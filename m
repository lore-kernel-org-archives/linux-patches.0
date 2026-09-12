Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70C0345EB5;
	Sat, 12 Sep 2026 19:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242689; cv=none; b=Xo4szFyJV3/k3SpZdrd+3wknsfAYgsGhS8mYzykhys1+CmO6H+VfjJKcXPo5moIIe6yi9a0BnOEeo41vm2pOnQnQW6Lgt379V7dKOfpob2i1iWmRbZZtaYPPS8+qzNC5ORgYKlpSe8x9u/BR+Ko84qnl4yB1glgYJMEsbNU9PBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242689; c=relaxed/simple;
	bh=FaPH72cB4+hl8MXbDeje1js3tw4/b86pBJTVo49nCLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGAarNoLW/yjZw7UvJHDg/ob0iMCq+19OuWCpp9GMjr0srW0A3HuTK+8xBMeu//Kbk9L/Lm08WbznvIxBtiPQmZCWasWqfE1zuOBW4GW8srN9nEIQtr251eo8oy48DXm+dkBnLbYaMJIh97815ZBWIv9ENa5LDzfIUOvWfNbt3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2GaWoZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2GaWoZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8761F000FF;
	Sat, 12 Sep 2026 19:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242688;
	bh=Y9PUHgHMfqzULvHNtkH3kxRzyk6X59feYhU6oIODKN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2GaWoZWSg3cSMjY6k31kGqjIhywUeHlhMxG1ym8UX/LEmB3tlkpneZ9DvNRquQkK
	 N3AbsdsesLpkQ4jWa1jyVnTpqI6WpdV2ynLbRmTa6ZwpAIlP2QrHo+s1brcnOtCWns
	 qZV6FnPs+2UDptg0tG0sJedaifUHAHQnYrts9MWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 492/798] scsi: target: srpt: Convert to new submission API
Date: Sat, 12 Sep 2026 09:02:00 +0200
Message-ID: <20260912065528.416408498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 50ab9c47f51dbe3419e414ac6880273f58ac2849 ]

target_submit_cmd_map_sgls() is being removed, so convert srpt to the new
submission API.

srpt uses target_stop_session() to sync session shutdown with LIO core, so
we use target_init_cmd()/target_submit_prep()/target_submit(), because
target_init_cmd() will detect the target_stop_session() call and return an
error.

Link: https://lore.kernel.org/r/20210227170006.5077-6-michael.christie@oracle.com
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ef63cc441703 ("RDMA/srpt: Pass the mapped task attribute to target_init_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d2cf5b9590fac..73256300f3ffc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1542,16 +1542,19 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
-	rc = target_submit_cmd_map_sgls(cmd, ch->sess, srp_cmd->cdb,
-			       &send_ioctx->sense_data[0],
-			       scsilun_to_int(&srp_cmd->lun), data_len,
-			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF,
-			       sg, sg_cnt, NULL, 0, NULL, 0);
+	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+			     scsilun_to_int(&srp_cmd->lun), data_len,
+			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
 		goto busy;
 	}
+
+	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(cmd);
 	return;
 
 busy:
-- 
2.53.0



