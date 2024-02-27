Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFB613B7AB;
	Tue, 27 Feb 2024 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041761; cv=none; b=ntvG9KnFlYv1BrZYNBYeW3M6VGv8WJdXcUXbhoZ53oCAeXQQh8bzbnO2PHbbevBp2Vkf9asMV0R7mmkBj4MRpQhgDWvcuYE7rSEcvblHbue6OGPOK3/wEZcTRV43MxCKeOoV/fuBI88ctAhmHnOEBSWhSawSDuJhsWFqzLOlqVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041761; c=relaxed/simple;
	bh=7ezRUtE0AhN5lyKKCMYE41XRxRZCvTo7qD7nJqRSjG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kewe315q/sWOzr31BxVMH6/bT71jK9UHVl10wf1cHqCEuBRvI/o+rt2UK/FiyaL12fbviA05jV8PpJ6aUoVsQtRlA0Pp3yOQzBXfGHI5C5+C5mbu3BxinhMgb5Y3cWO+94MchCyvPHYz1Uxtg+zxv9eyW3Sxyk28bl8ATCRENKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=it78x/Vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="it78x/Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950E4C433F1;
	Tue, 27 Feb 2024 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041761;
	bh=7ezRUtE0AhN5lyKKCMYE41XRxRZCvTo7qD7nJqRSjG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=it78x/VvDwbCp3Zja9Z2Q6zymz6nRedsdCUHIwIcbFRMXxSzFKycNjJb0sksRLwQg
	 egTaiRBEDTQdQBPd5WvVi6PBp9Pxi0/OlOrXJOWGpr3MNVpVJHPd/n4rvk7TA8ZZ+8
	 fsUvVUSFufzmlVIG8B3k8sNtgbnnxOtgtJV9CoSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/299] nvmet-fcloop: swap the list_add_tail arguments
Date: Tue, 27 Feb 2024 14:22:50 +0100
Message-ID: <20240227131627.857622723@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit dcfad4ab4d6733f2861cd241d8532a0004fc835a ]

The first argument of list_add_tail function is the new element which
should be added to the list which is the second argument. Swap the
arguments to allow processing more than one element at a time.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index c65a73433c05f..e6d4226827b52 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -358,7 +358,7 @@ fcloop_h2t_ls_req(struct nvme_fc_local_port *localport,
 	if (!rport->targetport) {
 		tls_req->status = -ECONNREFUSED;
 		spin_lock(&rport->lock);
-		list_add_tail(&rport->ls_list, &tls_req->ls_list);
+		list_add_tail(&tls_req->ls_list, &rport->ls_list);
 		spin_unlock(&rport->lock);
 		queue_work(nvmet_wq, &rport->ls_work);
 		return ret;
@@ -391,7 +391,7 @@ fcloop_h2t_xmt_ls_rsp(struct nvmet_fc_target_port *targetport,
 	if (remoteport) {
 		rport = remoteport->private;
 		spin_lock(&rport->lock);
-		list_add_tail(&rport->ls_list, &tls_req->ls_list);
+		list_add_tail(&tls_req->ls_list, &rport->ls_list);
 		spin_unlock(&rport->lock);
 		queue_work(nvmet_wq, &rport->ls_work);
 	}
@@ -446,7 +446,7 @@ fcloop_t2h_ls_req(struct nvmet_fc_target_port *targetport, void *hosthandle,
 	if (!tport->remoteport) {
 		tls_req->status = -ECONNREFUSED;
 		spin_lock(&tport->lock);
-		list_add_tail(&tport->ls_list, &tls_req->ls_list);
+		list_add_tail(&tls_req->ls_list, &tport->ls_list);
 		spin_unlock(&tport->lock);
 		queue_work(nvmet_wq, &tport->ls_work);
 		return ret;
-- 
2.43.0



