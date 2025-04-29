Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082BC21A43D;
	Tue, 29 Apr 2025 17:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946041; cv=none; b=k04TvGDUroXCDAeoYI9eYI9pKebSy45/qGitW85eNWK61XjPmuyF3iMEmdTHHZ4fUJqpa4r5jmDkxm3cDewKl6JMp5j7dZae5XeO/3WC0LlSFYZuvW2L3oCeH0qoomiPTQfrzCKUCy0dGavptLP8xYQggyhIiWPIsdnDK0ZFHtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946041; c=relaxed/simple;
	bh=Hg52meg4sgG0qfTQ4/l6hsqrjWPCylf9aFmzXfFcPUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEd5z4mcE+NHwxyw1+L+YjeHlaZp6bZKsQNzXz1SdQ03FeJAJ+fMKQijv4tCKnupv/Re6W9X8rCyBMHs2t64GUSgUBciBl/7T+5zLTtCLSO33lw6HgPZ69G3xp/R88FfzSrnZnJAqTbX1ppy015c+qJDZUb+IBfsRoRsEuGLz0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeyevQXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeyevQXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75679C4CEE3;
	Tue, 29 Apr 2025 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946040;
	bh=Hg52meg4sgG0qfTQ4/l6hsqrjWPCylf9aFmzXfFcPUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeyevQXLgNmWRZUzSSxutxB/qZukTkLSNKkgZ87OX77lG7CMtyJ/LOPhf9U8b9Qrq
	 ZwloEsLSRocPXuEiRvicE1QqW59nia4OF1wYqug8mJXiAl1KeMqW6yx0OBlBwuwCaK
	 EpG+K3wDm6NgglwGZzFLOYYlMSNZPcF7lqjjYsR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.14 117/311] scsi: mpi3mr: Fix pending I/O counter
Date: Tue, 29 Apr 2025 18:39:14 +0200
Message-ID: <20250429161125.833681721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

commit cdd445258db9919e9dde497a6d5c3477ea7faf4d upstream.

Commit 199510e33dea ("scsi: mpi3mr: Update consumer index of reply
queues after every 100 replies") introduced a regression with the
per-reply queue pending I/O counter which was erroneously decremented,
leading to the counter going negative.

Drop the incorrect atomic decrement for the pending I/O counter.

Fixes: 199510e33dea ("scsi: mpi3mr: Update consumer index of reply queues after every 100 replies")
Cc: stable@vger.kernel.org
Co-developed-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250411111419.135485-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -563,7 +563,7 @@ int mpi3mr_process_op_reply_q(struct mpi
 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));
 		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
 		    reply_qidx);
-		atomic_dec(&op_reply_q->pend_ios);
+
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_op_reply++;


