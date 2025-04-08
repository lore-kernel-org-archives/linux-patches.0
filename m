Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2637526656B;
	Tue,  8 Apr 2025 11:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110791; cv=none; b=az21d4MnyYAp0Q0n0MB6gOaC40m+xI8EuYIa76uj16497ywUYohGIOewgWyspszAzwv4WHmaN0EK/8u7WRP2A28xXU19/0fYH3R3c2d7VS6uhtvio3Mdlf67l6QYslAyH/x8PqL7BgbDU0Du5yztQpHgO/h3Kr+d3geLVPRJx80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110791; c=relaxed/simple;
	bh=dNz4NYiSkoEvrBiLLtInIUoD5B1ufAsxdilD4tFly4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnI2QZ4DbiFDWxGUy06hNMVXlGw0DOH7+S2FGju1xNsjr6K8XAdy2u6JxJLRM3Ft96KK/GlflGZ2DN82e3rctPAA1NOqbXdomQIwXH7pnRultqUVrK+XAvuKGEC8CMezPBNsC3fltF0ccUq93cdqzb/QsC+FwZfJ3aED7oMbN+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eftI0oqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eftI0oqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC83C4CEE5;
	Tue,  8 Apr 2025 11:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110791;
	bh=dNz4NYiSkoEvrBiLLtInIUoD5B1ufAsxdilD4tFly4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eftI0oqJtpU7NZpQ0LpKh/yUho2KZCL2Ngx2SCljx5Z8F81hlUC1FvwT1pbKImGpf
	 8JZxipOOGg3exZAtDNO1KTCvgmtvU5Qtq9cSTwWZDmkMlb/rCAzJUEqys4C7BxHFn+
	 ctfY2UtfUzQC+lD06NHbsv1fQAH2s2lgQbQoHXBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 195/731] scsi: target: tcm_loop: Fix wrong abort tag
Date: Tue,  8 Apr 2025 12:41:32 +0200
Message-ID: <20250408104918.817166195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 1909b643034ef741af9f24a57ab735440c4b5d1a ]

When the tcm_loop_nr_hw_queues is set to a value greater than 1, the
tags of requests in the block layer are no longer unique. This may lead
to erroneous aborting of commands with the same tag. The issue can be
resolved by using blk_mq_unique_tag to generate globally unique
identifiers by combining the hardware queue index and per-queue tags.

Fixes: 6375f8908255 ("tcm_loop: Fixup tag handling")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250313014728.105849-1-kanie@linux.alibaba.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/loopback/tcm_loop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 761c511aea07c..c7b7da6297418 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -176,7 +176,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
-	tl_cmd->sc_cmd_tag = scsi_cmd_to_rq(sc)->tag;
+	tl_cmd->sc_cmd_tag = blk_mq_unique_tag(scsi_cmd_to_rq(sc));
 
 	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
@@ -242,7 +242,8 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
-				 scsi_cmd_to_rq(sc)->tag, TMR_ABORT_TASK);
+				 blk_mq_unique_tag(scsi_cmd_to_rq(sc)),
+				 TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
-- 
2.39.5



