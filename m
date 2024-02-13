Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5F9A93C;
	Tue, 13 Feb 2024 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846027; cv=none; b=YOnZusRSVCmkrj+0ateec50CUbM5tYcHTQVny617JvLyn6FUUsSZmnaf4TsAU6751zYfF97fUrby21FfA1ses7zUtibULgURHjeyBRJwN/NJqsgooV66boJs47NBQ7nAklsJuxhYr04Wt1xmssiGQeqkz88wTa/geWmIKgsejkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846027; c=relaxed/simple;
	bh=xWdJaLPrKs9nhgJpjP/w3ReGlv5gpueNT1HxSYc0mQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfXz8wTwcld9xTM+DyqmfnrGfHTYQLVwyi4ziK0Fpt18azuoRPW7V8X3Ih4RrTP7fdvqeLVqYsy7Vg5mW90hkuMeBO+F8CjHT8Eq00UdMmpBDOhS8Dmh0wSHS44Fgkk6X4bqqagepl6a0RZb+blnSEYmXOTRf4p0pwhhTvgwWtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBbSc5+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBbSc5+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9B6C433C7;
	Tue, 13 Feb 2024 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846027;
	bh=xWdJaLPrKs9nhgJpjP/w3ReGlv5gpueNT1HxSYc0mQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBbSc5+8woLMw1CM+P3tgZvWe+pTc8reHY6m7dr5NttxC3d81laRW5blfqNR8wRox
	 5JWBl11VAzqcMBEDtRqHJEo3rTky8TsWdc0nrCsWhVBL2TN1ULawKEUWCQkv12rVne
	 2FNkVr1B9LoqAkQvQ4ZhrMF0MA9KBE3zG8mSTA/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 084/124] nvme-host: fix the updating of the firmware version
Date: Tue, 13 Feb 2024 18:21:46 +0100
Message-ID: <20240213171856.187716402@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit f0377ff97509f5a4921993d5d61da000361bd884 ]

The original code didn't update the firmware version if the
"next slot" of the AFI register isn't zero or if the
"current slot" field is zero; in those cases it assumed
that a reset was needed.

However, the NVMe specification doesn't exclude the possibility that
the "next slot" value is equal to the "current slot" value,
meaning that the same firmware slot will be activated after performing
a controller level reset; in this case a reset is clearly not
necessary and we can safely update the firmware version.

Modify the code so the kernel will report that a Controller Level Reset
is needed only in the following cases:

1) If the "current slot" field is zero. This is invalid and means that
   something is wrong, a reset is needed.

or

2) if the "next slot" field isn't zero AND it's not equal to the
   "current slot" value. This means that at the next reset a different
   firmware slot will be activated.

Fixes: 983a338b96c8 ("nvme: update firmware version after commit")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 60f14019f981..86149275ccb8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4107,6 +4107,7 @@ static bool nvme_ctrl_pp_status(struct nvme_ctrl *ctrl)
 static void nvme_get_fw_slot_info(struct nvme_ctrl *ctrl)
 {
 	struct nvme_fw_slot_info_log *log;
+	u8 next_fw_slot, cur_fw_slot;
 
 	log = kmalloc(sizeof(*log), GFP_KERNEL);
 	if (!log)
@@ -4118,13 +4119,15 @@ static void nvme_get_fw_slot_info(struct nvme_ctrl *ctrl)
 		goto out_free_log;
 	}
 
-	if (log->afi & 0x70 || !(log->afi & 0x7)) {
+	cur_fw_slot = log->afi & 0x7;
+	next_fw_slot = (log->afi & 0x70) >> 4;
+	if (!cur_fw_slot || (next_fw_slot && (cur_fw_slot != next_fw_slot))) {
 		dev_info(ctrl->device,
 			 "Firmware is activated after next Controller Level Reset\n");
 		goto out_free_log;
 	}
 
-	memcpy(ctrl->subsys->firmware_rev, &log->frs[(log->afi & 0x7) - 1],
+	memcpy(ctrl->subsys->firmware_rev, &log->frs[cur_fw_slot - 1],
 		sizeof(ctrl->subsys->firmware_rev));
 
 out_free_log:
-- 
2.43.0



