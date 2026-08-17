Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5B3B42DC;
	Mon, 17 Aug 2026 14:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976774; cv=none; b=N99K9cGo5mILHuQI/oZCwVRebdcY433GL7J7+6xbPOS3cBd0NoNPf0HeZ0V8NChmReJD5Ga3sD28tzO5u52ZZRY7Cnu44JVsuopnQkrfH6LYvNhcJW9YZGDFJ+oZXsSLACsC5rPOl/hLcq4HUoLINbQ84gm2/fHP8WLRB6rWuSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976774; c=relaxed/simple;
	bh=cF90yDuHePYy3MlWEVaxIV61r12upMfAN4d2pTA1FfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaCXr7acDU0tInXtuZSKLDpx8hldRfUpBgw9tBxetOwyxm/Lk0A8rA/bk24g2/7hYIpXuS9BZ4UK6xpGAfYK48YM7KjNVAZcglFwHFKCTL9/fmrvPioiAD0cbM1931SgQMhgFJJ8g6RNbYRiSz5a4rBko5+3F4Uh4j+oA6TbTC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLyKgfXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLyKgfXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBF11F000E9;
	Mon, 17 Aug 2026 14:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976773;
	bh=oO69cysbIA/MBGo7BrnjU6AiBtpW1qFTDzTwwf6P4Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLyKgfXvNmOV1a0SP7jbxnQPoJsBiBoJdR+To2PMVbPb9NQuQtF4qdF2CUdOyKmCy
	 e/42mtS+3uFpqnAb1aAu2hllHXuGjIfVuKwABVAVOxEmOOdIHmwAx/y4PIVMCPUQ3y
	 3fXeGHcYbceXVHDMU7MWojqMBxhI66ZnGBFcXChM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/456] hwmon: occ: validate poll response sensor blocks
Date: Mon, 17 Aug 2026 15:28:07 +0200
Message-ID: <20260817132543.891703665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 70e76e700fc6c46afb4e17aec099a1ea089b4a22 ]

The OCC poll response parser walks a counted list of sensor data blocks.
It used the static backing-array capacity as the parse boundary, but a
transport response makes only data_length bytes current and valid. A
truncated response can therefore make the parser consume a block header or
block extent outside the current response.

Use data_length as the parent boundary, prove the fixed poll header and
each current block header before reading them, and prove the complete block
before advancing. Keep parsed sensor metadata local until the complete
response has passed validation, then publish it. Propagate
malformed-response errors before publishing the OCC as active.

Fixes: aa195fe49b03 ("hwmon (occ): Parse OCC poll response")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260720115826.14813-1-pengpeng@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index e0ab04b1d92ca5..86c54b36b7dbf8 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -1049,32 +1049,49 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 }
 
 /* only need to do this once at startup, as OCC won't change sensors on us */
-static void occ_parse_poll_response(struct occ *occ)
+static int occ_parse_poll_response(struct occ *occ)
 {
 	unsigned int i, old_offset, offset = 0, size = 0;
+	u16 data_length;
 	struct occ_sensor *sensor;
-	struct occ_sensors *sensors = &occ->sensors;
+	struct occ_sensors parsed = {};
+	struct occ_sensors *sensors = &parsed;
 	struct occ_response *resp = &occ->resp;
 	struct occ_poll_response *poll =
 		(struct occ_poll_response *)&resp->data[0];
 	struct occ_poll_response_header *header = &poll->header;
 	struct occ_sensor_data_block *block = &poll->block;
 
+	data_length = get_unaligned_be16(&resp->data_length);
+	if (data_length < sizeof(*header) || data_length > OCC_RESP_DATA_BYTES) {
+		dev_err(occ->bus_dev, "invalid OCC poll response length %u\n",
+			data_length);
+		return -EMSGSIZE;
+	}
+
 	dev_info(occ->bus_dev, "OCC found, code level: %.16s\n",
 		 header->occ_code_level);
 
 	for (i = 0; i < header->num_sensor_data_blocks; ++i) {
 		block = (struct occ_sensor_data_block *)((u8 *)block + offset);
+		if (size + sizeof(*header) + sizeof(block->header) >
+		    data_length) {
+			dev_err(occ->bus_dev,
+				"truncated OCC sensor block header\n");
+			return -EMSGSIZE;
+		}
+
 		old_offset = offset;
 		offset = (block->header.num_sensors *
 			  block->header.sensor_length) + sizeof(block->header);
-		size += offset;
 
 		/* validate all the length/size fields */
-		if ((size + sizeof(*header)) >= OCC_RESP_DATA_BYTES) {
-			dev_warn(occ->bus_dev, "exceeded response buffer\n");
-			return;
+		if (size + sizeof(*header) + offset > data_length) {
+			dev_err(occ->bus_dev,
+				"exceeded OCC poll response length\n");
+			return -EMSGSIZE;
 		}
+		size += offset;
 
 		dev_dbg(occ->bus_dev, " %04x..%04x: %.4s (%d sensors)\n",
 			old_offset, offset - 1, block->header.eye_catcher,
@@ -1104,6 +1121,9 @@ static void occ_parse_poll_response(struct occ *occ)
 
 	dev_dbg(occ->bus_dev, "Max resp size: %u+%zd=%zd\n", size,
 		sizeof(*header), size + sizeof(*header));
+	occ->sensors = parsed;
+
+	return 0;
 }
 
 int occ_active(struct occ *occ, bool active)
@@ -1130,10 +1150,12 @@ int occ_active(struct occ *occ, bool active)
 			goto unlock;
 		}
 
-		occ->active = true;
 		occ->next_update = jiffies + OCC_UPDATE_FREQUENCY;
-		occ_parse_poll_response(occ);
+		rc = occ_parse_poll_response(occ);
+		if (rc)
+			goto unlock;
 
+		occ->active = true;
 		rc = occ_setup_sensor_attrs(occ);
 		if (rc) {
 			dev_err(occ->bus_dev,
-- 
2.53.0



