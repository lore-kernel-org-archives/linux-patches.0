Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F5267B05;
	Sat, 30 May 2026 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162969; cv=none; b=VlY+bQrcZuQtiDNQSOAdAFVsWOHiP3PUV8v9/kZLLk+sjnG5HQ2xtPH/REPj206BvR4vWNz8WStDZ/4Cd3TNoVMuIuzu0NF1eu5CaRIycGod4aOCDtSnGFwO51ZvpHjq+bvy4JjZsIE3VbmRGyWPZI/s/73qc/LqvAYykj3zN/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162969; c=relaxed/simple;
	bh=Zuvyz0b051/JGITUuktKNJrHoBd70AHGRmHltcLHmHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3T/p5WlInbCRBvQBzGln6wsfMeTv5DOXJZ2Pz9dt7bmgPr0zc3dnbXT4b2KH481Wzv0amKoln/iBv2U8e7JTgscVNznrli3Xvcw5zVWR5EUYGJtM6FEfRBOsTS1IH5bC4oBYmY2jf4tYCpurnH6HyUxoUhTsOFHcV77OaT+kyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dhp3ILeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dhp3ILeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617981F00893;
	Sat, 30 May 2026 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162968;
	bh=WBGDMnghGEeL2Rco00Sg6pKfM6jqejczIqBy901UPXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dhp3ILeG3NP9cSKIm4lwLybW67x96Y7QupesAVWF3QBS/hkyEkQIEnRKEeS3wUtCQ
	 C3fMzLxIP+07NjrxTo5s5oNRYr37iEi5Ohga0xVfU5/lVrWn+7mrLOca4RhBAtDV88
	 2i65yJHBx4i8KuNA3/bXBPv986CHiuVIr0D1M62I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaskaran Singh <jsingh@cloudlinux.com>
Subject: [PATCH 5.15 118/776] Revert "nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()"
Date: Sat, 30 May 2026 17:57:12 +0200
Message-ID: <20260530160243.420308948@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaskaran Singh <jsingh@cloudlinux.com>

This reverts commit 60ba31330faf5677e2eebef7eac62ea9e42a200d.

The backport of upstream commit 0a2c5495b6d1 was incorrectly applied.
The cancel_work_sync() call for ->ioerr_work was added to
nvme_fc_reset_ctrl_work() instead of nvme_fc_delete_ctrl().

Revert this commit so the correct fix can be applied.

Signed-off-by: Jaskaran Singh <jsingh@cloudlinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3263,6 +3263,7 @@ nvme_fc_delete_ctrl(struct nvme_ctrl *nc
 {
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 
+	cancel_work_sync(&ctrl->ioerr_work);
 	cancel_delayed_work_sync(&ctrl->connect_work);
 	/*
 	 * kill the association on the link side.  this will block
@@ -3333,7 +3334,6 @@ nvme_fc_reset_ctrl_work(struct work_stru
 
 	/* will block will waiting for io to terminate */
 	nvme_fc_delete_association(ctrl);
-	cancel_work_sync(&ctrl->ioerr_work);
 
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING))
 		dev_err(ctrl->ctrl.device,


