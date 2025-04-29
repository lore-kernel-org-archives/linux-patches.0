Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5019919F424;
	Tue, 29 Apr 2025 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950306; cv=none; b=cWDy9AQMxMdgnrJTeYGwZWI/QpQAMmEcLWV548f/kBedk8zwOyCPIIj4cDsppxsgjQ6ZOyp/8rRng+OeaRrfyRN8yeXS7Sy4s76f2zj6rgwRgzsHHzAhPROMJT0x+l+701ULvNCInF8KLOCQh58CuOfHnV9g+i3RdNPOtrCxi48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950306; c=relaxed/simple;
	bh=o9errAEJx9bH020gWLhZsi4sK40Kt544MWc7lB1JjTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxbLKMwYPLg5AGN2rhLzFk5hdQy9oYdvOn2xa39vF8fg5u2fRUjBZAHeQecwCYK/pP5YPEj8Z3E91kDuGytGSVue0aqG1uNhKXDWbkz7Uq/QU0JOr342ymMiWJtWVwAlgRpCKNIiru0qxHxubjE9aISfOgvFW+XDEOPEEowZpc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2O9+aZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2O9+aZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B62C4CEE3;
	Tue, 29 Apr 2025 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950305;
	bh=o9errAEJx9bH020gWLhZsi4sK40Kt544MWc7lB1JjTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2O9+aZldp5GqaxbSXZT0U3uoowlQanS2j3HJN5isnW1Yynu5lSI1SMSNYPwb9j0z
	 kozEclt747Y7bdRpZ4hQjIA17Z9gvA4t9tobB8nIvyPekVoUXvQlVNrfnyv6AEgwVE
	 MKU5YHzH/yz63bLn3RQVYHFND2dZtI9NhcemxrPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Kovaleva <a.kovaleva@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/204] scsi: core: Clear flags for scsi_cmnd that did not complete
Date: Tue, 29 Apr 2025 18:42:21 +0200
Message-ID: <20250429161101.578800194@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasia Kovaleva <a.kovaleva@yadro.com>

[ Upstream commit 54bebe46871d4e56e05fcf55c1a37e7efa24e0a8 ]

Commands that have not been completed with scsi_done() do not clear the
SCMD_INITIALIZED flag and therefore will not be properly reinitialized.
Thus, the next time the scsi_cmnd structure is used, the command may
fail in scsi_cmd_runtime_exceeded() due to the old jiffies_at_alloc
value:

  kernel: sd 16:0:1:84: [sdts] tag#405 timing out command, waited 720s
  kernel: sd 16:0:1:84: [sdts] tag#405 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=66636s

Clear flags for commands that have not been completed by SCSI.

Fixes: 4abafdc4360d ("block: remove the initialize_rq_fn blk_mq_ops method")
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Link: https://lore.kernel.org/r/20250324084933.15932-2-a.kovaleva@yadro.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e6dc2c556fde9..bd75e3ebc14da 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1152,8 +1152,12 @@ EXPORT_SYMBOL_GPL(scsi_alloc_request);
  */
 static void scsi_cleanup_rq(struct request *rq)
 {
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+
+	cmd->flags = 0;
+
 	if (rq->rq_flags & RQF_DONTPREP) {
-		scsi_mq_uninit_cmd(blk_mq_rq_to_pdu(rq));
+		scsi_mq_uninit_cmd(cmd);
 		rq->rq_flags &= ~RQF_DONTPREP;
 	}
 }
-- 
2.39.5



