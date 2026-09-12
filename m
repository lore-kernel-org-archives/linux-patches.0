Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAD42DC792;
	Sat, 12 Sep 2026 10:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207337; cv=none; b=Ckmf3LWF0i3SaJBlpCEWaMiNwNsGd7A6BeK7zajl6kccdSFjq8rWGIp64CCYs0Gy2WCYJpx3MBmuFQWorcy1p1Z+Cvy2NlDnheiv6onzmNqWQ9iQPj4qZcm5G4fq1/3MIcPu3uSQ5U4dKY+CYrpQyCnPdEVnBHPWVlmKVTATJ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207337; c=relaxed/simple;
	bh=tgDBVU2zaPQ8vPB/HUYCD0PzhhbohmkLuHA22PZt63c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqlUQ458SefJDysd39aB3H0NO+O2KztBScoyQI+FYR7XJ86gAvO8jYiG6IvnLvkONdHM7eNFehrz+3YGecOop83cWlbJiXYyNo5Be37Ne4mhNiBRu/Zs7Kysbm5AIn6gN3E3Es+mquwSeW/0muf3i7KdfVSRYS0ZOmEcUDLmIvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xqog87Lu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xqog87Lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AF61F00893;
	Sat, 12 Sep 2026 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207336;
	bh=HWvpx0pYwtPt6kh5/Dx5fvUPzzEGPD01kaGjxoEz3Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xqog87LudEimoKRfG/aZRQ4w8RJjWnaitAnjjw9y+C4SOVNcEPSlUEQjaFrpz+vvW
	 MjcBJFYoNES8B/SR8Ph6qHOqdeEesF68iKFoeNrrkRQvMAXDEbhUifdO1vnyLMbOJY
	 Bqa4SH+8umEZOXMQf5u68kSC+q3rPISqeYnumgFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0392/1518] cxl/features: Clamp Get Feature output size to the remaining buffer
Date: Sat, 12 Sep 2026 08:42:41 +0200
Message-ID: <20260912065632.325957931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 2aeb21fe557ef154f0cdf4f9745ebd8d5b31ca83 ]

cxl_get_feature() reads a feature in a loop but passes a fixed size_out
as the output capacity every iteration. On the last partial iteration
the buffer has less room left, so a device that returns more than asked
can overflow feat_out.

Use the per-iter size data_to_rd_size, which already tracks the
remaining room, as the output capacity.

Fixes: 5e5ac21f629d ("cxl/mbox: Add GET_FEATURE mailbox command")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260626104102.53892-4-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index c45b6dfcc2445..6e25223d3409b 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -225,7 +225,7 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 		       void *feat_out, size_t feat_out_size, u16 offset,
 		       u16 *return_code)
 {
-	size_t data_to_rd_size, size_out;
+	size_t data_to_rd_size;
 	struct cxl_mbox_get_feat_in pi;
 	struct cxl_mbox_cmd mbox_cmd;
 	size_t data_rcvd_size = 0;
@@ -237,7 +237,6 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 	if (!feat_out || !feat_out_size)
 		return 0;
 
-	size_out = min(feat_out_size, cxl_mbox->payload_size);
 	uuid_copy(&pi.uuid, feat_uuid);
 	pi.selection = selection;
 	do {
@@ -250,7 +249,7 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 			.opcode = CXL_MBOX_OP_GET_FEATURE,
 			.size_in = sizeof(pi),
 			.payload_in = &pi,
-			.size_out = size_out,
+			.size_out = data_to_rd_size,
 			.payload_out = feat_out + data_rcvd_size,
 			.min_out = data_to_rd_size,
 		};
-- 
2.53.0



