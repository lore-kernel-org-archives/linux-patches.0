Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A4A3BED78;
	Sat, 12 Sep 2026 20:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243578; cv=none; b=icpp0Zf9DYCVzDosN8+RjPgX/Rm8hzjXcdzjLKbFWPdUOKIEGkTuencYS3yZfvYaGQ8t4aZc5fh5Cyzg3tOv2z9hgyhWBp8Zjoo3dgP4NtZubDB3mpR0idZWt1Rf1SBsndLP8Rtom0WqpnAPQqvpK3j050ygcImYxdMcY58QwZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243578; c=relaxed/simple;
	bh=9lDxR1DYBfeYqSNefLP8dTLMWMt+bkwiWRJldcJiwqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g51iCthwWm44VU01IJyem2NLs83cN8dOH7W168zT/RxCeO8ED5KX2o4bdMP11W0UiMcswpm2IpaCWxZ9KZQyYPZsHSDVEWCV4QQEj79M/kfuIkAJRkI5gHc5HLNXmLmEIg90CFIC8h65WFOu/T97Y/+6d7VhCbMoAGhFOL7etT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUQGsjxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUQGsjxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610981F00893;
	Sat, 12 Sep 2026 20:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243574;
	bh=sNJt8gMVnkrx+s5yrAv4J2h2IYpNqknF+bPpJ7vbw4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUQGsjxCh94JL1tm4zONlXOOYRa/ZDE0hHua12ZUgN+xKKO/1n3JdD+ev4y5Ty8m7
	 /cNWaRFZ97OUE/Ou7piB6M3h9BVR9IPdxIb8wtHG5tVAo6PIUUc/JiPbbOJMIgZgl/
	 WPh7Rv5jTzOcgu7cvNHJXnhbDdqbOD0azQG0BZkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 793/798] scsi: qla2xxx: Fix memory leak in __qlt_24xx_handle_abts()
Date: Sat, 12 Sep 2026 09:07:01 +0200
Message-ID: <20260912065535.236270167@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 601be20fc6a1b762044d2398befffd6bf236cebf ]

Commit 8f394da36a36 ("scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG")
made the __qlt_24xx_handle_abts() function return early if
tcm_qla2xxx_find_cmd_by_tag() didn't find a command, but it missed to clean
up the allocated memory for the management command.

Link: https://lore.kernel.org/r/20220914024924.695604-1-rafaelmendsr@gmail.com
Fixes: 8f394da36a36 ("scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e89a907a07d4a..e15a1921f411f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2125,8 +2125,10 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 
 	abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
 				le32_to_cpu(abts->exchange_addr_to_abort));
-	if (!abort_cmd)
+	if (!abort_cmd) {
+		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
 		return -EIO;
+	}
 	mcmd->unpacked_lun = abort_cmd->se_cmd.orig_fe_lun;
 
 	if (abort_cmd->qpair) {
-- 
2.53.0



