Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61004126C18;
	Wed,  5 Feb 2025 13:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763296; cv=none; b=eGdXY7XGw8Xw6lMnQJpsNNQPaB7kCSa13yM7wANDvZYjqdXXZHwnv5V0pYWYFmjNKRJbgcnFb/GTRzd/s3XRAuZxB1mXXSIRrlypxmHi0Kwr1P0ffVW1o6O6KrVhJyO3g0NXTYsxRUcxj3ojDvcedMfebHuGkqP7kZts/YtawJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763296; c=relaxed/simple;
	bh=UQFZH9VlcLRlNPKq9UlrIKpKRIO9Wf1w0/+WaFy15sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKTKiXmqSVYUB5bXgByIXMcoLJXPNgfnInzeiSUHPfvSjoqT1pdfBlCIt+MVfOVm5qbsG3xgWuodYU8zIq6Q2cN3PtuM7Ex5yzP5XaPG8vgFwMvYNsmwbr1QTQeurNLWv7sfIEECtvo6ws5Bkivdc4w3EOUWSnaKp+IrMxd0P4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcyKfQQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcyKfQQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6182DC4CED1;
	Wed,  5 Feb 2025 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763295;
	bh=UQFZH9VlcLRlNPKq9UlrIKpKRIO9Wf1w0/+WaFy15sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcyKfQQNOfMM0yfr05yQC6EMNZ+DVFK6ML0xDiyQMAdpUg+Cb3wM6N+8KnX2kDMGh
	 2so83D33od10Ja+y04NGxxbwunRGU1a/xd5ImXcAz84t5pPe61pv5Xtx4m8/ClQ0ph
	 mBSzqzqNj79bOKubbtckzV/+7o5vMKLb0QLciXOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/393] nvme: fix bogus kzalloc() return check in nvme_init_effects_log()
Date: Wed,  5 Feb 2025 14:38:54 +0100
Message-ID: <20250205134420.878130288@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 170e086ad3997f816d1f551f178a03a626a130b7 ]

nvme_init_effects_log() returns failure when kzalloc() is successful,
which is obviously wrong and causes failures to boot. Correct the
check.

Fixes: d4a95adeabc6 ("nvme: Add error path for xa_store in nvme_init_effects")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 75ea4795188f2..26e3f1896dc39 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2951,7 +2951,7 @@ static int nvme_init_effects_log(struct nvme_ctrl *ctrl,
 	struct nvme_effects_log *effects, *old;
 
 	effects = kzalloc(sizeof(*effects), GFP_KERNEL);
-	if (effects)
+	if (!effects)
 		return -ENOMEM;
 
 	old = xa_store(&ctrl->cels, csi, effects, GFP_KERNEL);
-- 
2.39.5



