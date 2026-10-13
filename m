Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE024EDCD6;
	Tue, 13 Oct 2026 12:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894149; cv=none; b=RsbJgbexPEBpW9pVdq62Q5oPwmJ9XmEExjBvaRAwwMGeH3dedgXkqUOH5u8eZEQ7yhwEZe72uc628c7hoOePc7qPba4GriwICoIzrtdh89X6KJYh4YUczci7MOn08/kAHFLHH1Ma3isX2M4uKYqrk9J8R57tiJVJbgyHIu77Ttw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894149; c=relaxed/simple;
	bh=wpQu978wDPg6DEXVlmHho6S9rrdZtH3y/Yxv4TWwg30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6mPt98Id0lHERJGN5VVLNOj+/KaTqFtEcn/LN0ynIJAYo7rGGpSAfD6a7QUIfFReg4hastpxMsO/7cAus/4pMb4fiIWhluQIAyX5zX/rnnAJngiDE5J/QulwOAUM1+bjmLVUseRq+Cxngv4c/SIkdVHxZ4sseWM4yk6Chv8XKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ee8ApIYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ee8ApIYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ABB1F000FF;
	Tue, 13 Oct 2026 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894148;
	bh=G+/vNdD9WRAgNT/gFVFhvD97yethH8krlzxLyihhvyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ee8ApIYhG9zrjbaIxrkBiyrq+U/ePKE0RYdxdni/Y8tihd5I3xNTqjrambzFChedD
	 n3B4IhKUqfnieRZ2Zhf9zdDSqCZmBw075y7DMahmm6v94WZZRO6DOmiUmwKvR3A9lW
	 ckUAmrTBKGlkISXrf8c3j6c9oAX5JXz96+eKUoMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 463/621] nvmet: fix return status of RMI log page on allocation failure
Date: Tue, 13 Oct 2026 13:37:38 +0200
Message-ID: <20261013112931.819946575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 581d8bb556dd3e5567bcf322aa5e3e4b6a200c08 ]

nvmet_execute_get_log_page_rmi() leaves 'status' holding NVME_SC_SUCCESS
(set by the successful nvmet_req_find_ns() call) when the kzalloc() for
the log buffer fails. It then jumps to the out label and completes the
request with a success status, so the host is told the command succeeded
while no data was transferred.

Initialize 'status' to NVME_SC_INTERNAL, matching the smart log handler,
so an allocation failure is reported as an internal error.

Fixes: 5fd075cdaf36 ("nvmet: implement rotational media information log")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 4b4811f06982e..fa9920787a8ff 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -309,8 +309,10 @@ static void nvmet_execute_get_log_page_rmi(struct nvmet_req *req)
 	}
 
 	log = kzalloc(sizeof(*log), GFP_KERNEL);
-	if (!log)
+	if (!log) {
+		status = NVME_SC_INTERNAL;
 		goto out;
+	}
 
 	log->endgid = req->cmd->get_log_page.lsi;
 	disk = req->ns->bdev->bd_disk;
-- 
2.53.0



