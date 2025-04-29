Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59282459EA;
	Tue, 29 Apr 2025 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947669; cv=none; b=MZy9iEUvZvyuah2XoL7C8OrzEIbwGhk7FBUpjyd069idGdVwVJ0CtWWZrp4cg6BBg56vLxmVG3VTAo/bVTOpGXWVXlH6UGmbC227H98jzvvTciIJLOiJgqZD23QAEYdOn28VuyxAvKIHlfJ51+T77hCZU0GoI7pLBdYCeqNFXYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947669; c=relaxed/simple;
	bh=66vtz+YKf/LRzi6A4WJ/9ouaWV/RyQKYIY1LXmjZ5VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFOP3HPSoOO4xZbaFoABd/5TI6y2+VDYPTCkM0BKr5PMvuyY72kWTsn4133V6rqKOJc1FvNBQ7ZsAccT/LXmi1I1La+HrgjTL3MsZ97Bles+W+9rq25KKVQw2nLwrrtwS5mhYnblegu4oLt4wY3jquwnLsSDlICwGGR0SivsdWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK5b/anT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK5b/anT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58054C4CEE3;
	Tue, 29 Apr 2025 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947669;
	bh=66vtz+YKf/LRzi6A4WJ/9ouaWV/RyQKYIY1LXmjZ5VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK5b/anTE677NSntnz65QHukgvkxlHSIqgWUw777HK62oNyPQkSk+FSRcgVNxFUd8
	 8cNyGnsF/nEJy6KR4P3KGRgGxnidOVn3hLFYiBrfTDBzrIiN/tIEPduYg4wN5fIqyI
	 fBu2J23mdmTWeANuOg/EHFQ26wfyPT89U4qEPY3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Kovaleva <a.kovaleva@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/280] scsi: core: Clear flags for scsi_cmnd that did not complete
Date: Tue, 29 Apr 2025 18:40:09 +0200
Message-ID: <20250429161117.893206243@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3023b07dc483b..ce4b428b63f83 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1237,8 +1237,12 @@ EXPORT_SYMBOL_GPL(scsi_alloc_request);
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



