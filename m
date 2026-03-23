Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602B3BFE5D;
	Mon, 23 Mar 2026 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283350; cv=none; b=qGYKOhk0M98H/D5o4G0dlTeAtcaKVFIry3DRAEZrNa6sk9oKBwwPpZMNGabDY5HlBI9n1u6zz+7tzClIQl0nR2u/xeIPMGdold+ME6tN+Bw74JI0nhgug6LOKmr8Zxk7gyoyRvlma7GDlYyS+5COftzAFnFpYBeXMTfgOS/8phM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283350; c=relaxed/simple;
	bh=MR6jGQTiuMbiM6FFFaZHGmvaWmB7EBgqk1BpGZhLozY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIBx34Ps3qpqwT2Bizdr29dZQWZVm9v66mFW7oIt3BuHrlaRdrz5FbtGUo+/uJhEYQcHiMqEm1qHJWvvgJMCElxToy0epdPECMx1T+PEXkBn7R4hHM1QdGzJZ/mQXJydpHvGv1qE9djftQ2wzrNMMs3Jyo7XqjFdk2n+tmTHEz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrxVAtJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrxVAtJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E20C4CEF7;
	Mon, 23 Mar 2026 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283350;
	bh=MR6jGQTiuMbiM6FFFaZHGmvaWmB7EBgqk1BpGZhLozY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrxVAtJ9BAa88LOIljZ3RxLlScXiDH0M5Lfp1CF2u0Y8F3ic4DkneKpQo9W7wwK8C
	 3bb/C6ReVL/yKdaKGHhqjf0fHqirGoP8ZkoTpl1yO61dKdAoHauek7/TV4vLJ88N1D
	 kEcrWbm7olIsYRtsyA0MvIDqrpZ3km8Yjd6rIzf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaskaran Singh <jsingh@cloudlinux.com>
Subject: [PATCH 6.1 479/481] Revert "nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()"
Date: Mon, 23 Mar 2026 14:47:41 +0100
Message-ID: <20260323134536.898413634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaskaran Singh <jsingh@cloudlinux.com>

This reverts commit 3d81beae4753db3b3dc5b70dc300d4036e0d9cb8.

The backport of upstream commit 0a2c5495b6d1 was incorrectly applied.
The cancel_work_sync() call for ->ioerr_work was added to
nvme_fc_reset_ctrl_work() instead of nvme_fc_delete_ctrl().

Signed-off-by: Jaskaran Singh <jsingh@cloudlinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3264,6 +3264,7 @@ nvme_fc_delete_ctrl(struct nvme_ctrl *nc
 {
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 
+	cancel_work_sync(&ctrl->ioerr_work);
 	cancel_delayed_work_sync(&ctrl->connect_work);
 	/*
 	 * kill the association on the link side.  this will block
@@ -3334,7 +3335,6 @@ nvme_fc_reset_ctrl_work(struct work_stru
 
 	/* will block will waiting for io to terminate */
 	nvme_fc_delete_association(ctrl);
-	cancel_work_sync(&ctrl->ioerr_work);
 
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING))
 		dev_err(ctrl->ctrl.device,


