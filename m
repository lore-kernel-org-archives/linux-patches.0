Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5075C41DED0;
	Thu, 30 Jul 2026 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423917; cv=none; b=VdmTWxZ66IuewDntIRuRr3HIOv7aDqIR/V+qI4yhmX4MaRzlATRFG0Sob1ghUugTqOIcy7LmKETD4dniCErNDbGuOJeze9h2uN1T/dwUjhKO+/FiXrLs979Nba9X3OXbhZ4ujSRBD9zKVlbKStw9cEJ+oKUo5u07jb/4+cTm5XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423917; c=relaxed/simple;
	bh=CtopFwG4Zi5fxmEIjeh0D0ku9Iny42/o/9y+wkDy+7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfwpOUeCwW61joDXv2Cz6bwtUMVzQkeMroMQ1bn9gyLcYV3IeD4C5mYo3NvhmOFsiFuTlv7+BA8xagNXt+DdkwAD5rrFWx8yLVhRjCiYwr7xMwf/q28x71LMOTK7K2KWWa3FfpI/HntuFc6USmURZ+IVamQyz+7D8dJe1jzpTM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPIQjjn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPIQjjn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A714C1F000E9;
	Thu, 30 Jul 2026 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423916;
	bh=ajSSBUj4BOwJp9Qrm1VkoZvrtdORqt+oAOZiHTqmfko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPIQjjn5BXOsfSRTiCdMKS4ys9Rno5auu+Bfp8Ejf6NH1qV/IYWgXE7+Tn7Iul45i
	 Ixom2AvPqhQbe+8WwPJDVApdBjkJFQYnMO/sTBE3lZtiUgEs3CpCybZqzUfn7Rm/Os
	 CeU8+CxK2U3FAsLqvrC/Gy8eoH+CRwpUUm04AJN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/675] hwmon: occ: validate poll response sensor blocks
Date: Thu, 30 Jul 2026 16:08:59 +0200
Message-ID: <20260730141449.584881706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e18e80e832fd3f..175208d712b06e 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -1052,32 +1052,49 @@ static int occ_setup_sensor_attrs(struct occ *occ)
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
@@ -1107,6 +1124,9 @@ static void occ_parse_poll_response(struct occ *occ)
 
 	dev_dbg(occ->bus_dev, "Max resp size: %u+%zd=%zd\n", size,
 		sizeof(*header), size + sizeof(*header));
+	occ->sensors = parsed;
+
+	return 0;
 }
 
 int occ_active(struct occ *occ, bool active)
@@ -1138,10 +1158,12 @@ int occ_active(struct occ *occ, bool active)
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



