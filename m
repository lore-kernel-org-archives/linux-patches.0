Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BA813B29C;
	Tue, 27 Feb 2024 14:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043343; cv=none; b=bKyegI9W7scKtWlbLz4KqnRUIPZszNI5O6RHTu8Ll8H5jDLwdtZkDAvTh8zlYzWhTSz+e/yy3mKLqcFGWyqjmWB9y0poK87xTWdjD+qJy8yzQjqj8rwMjJhGOThpdUy2bUfj+WZvkdNZSwZiWGNBjC/PU3e1mVIQsGH8zK7VOW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043343; c=relaxed/simple;
	bh=WY4WOXCJ60fl8LMjdQYk5leR/weP487eyxGh3DtjkT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ky941qufJAHQ7V8LDapIdsiW6cbzSc5d8tzmLbuUetqY6b4i5bGBSeZOlnetPWWKEan7XvZYWUDieKUtBcDFSfdjYrS495eHC/3dQ2194mMAKXwuHtLh/g661oF8h9A1n2XRUnfTFoUTK2moMDRpp9BAGw08mesrR5nwTpMG5sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJ3uD9H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJ3uD9H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C61C433F1;
	Tue, 27 Feb 2024 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043343;
	bh=WY4WOXCJ60fl8LMjdQYk5leR/weP487eyxGh3DtjkT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJ3uD9H8pr+FHj0bYXf83t740vRq28qd8A5FeKpEXiQuP0+FBdJkgL8n83FePDVTK
	 tkJmu4QS3+fWPmEssDvb2GVxtZRgQXbdcnNWy7qY2752tUixpkw/zOB+Z/x5i23vmi
	 /0Br2q69GxMIO/Y8gsy88CqdDhTEB5YjmOHge0Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/195] nvmet-fc: release reference on target port
Date: Tue, 27 Feb 2024 14:25:06 +0100
Message-ID: <20240227131611.876069353@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit c691e6d7e13dab81ac8c7489c83b5dea972522a5 ]

In case we return early out of __nvmet_fc_finish_ls_req() we still have
to release the reference on the target port.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 1ab6601fdd5cf..0075d9636b065 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -359,7 +359,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 
 	if (!lsop->req_queued) {
 		spin_unlock_irqrestore(&tgtport->lock, flags);
-		return;
+		goto out_puttgtport;
 	}
 
 	list_del(&lsop->lsreq_list);
@@ -372,6 +372,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 				  (lsreq->rqstlen + lsreq->rsplen),
 				  DMA_BIDIRECTIONAL);
 
+out_puttgtport:
 	nvmet_fc_tgtport_put(tgtport);
 }
 
-- 
2.43.0



