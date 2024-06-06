Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BD819925A;
	Thu,  6 Jun 2024 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682992; cv=none; b=LX148MfMVRXfAcEF5Ki3G0U6XsatbbobHGZIOVjqNx+MykIVIEle5RT4TTejQNg7Z3DXeqXGEtThTvIKWW6JrJXubkwMAbd1CC1dkwJ3xOAXUj31eygsSEPBgdmhaTTW1oh2ypImYVAQ65LKqn5lHRF15WX+FD0aCRuqiOqdWXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682992; c=relaxed/simple;
	bh=LTk0e6f8jXx9Rhnpfi/XBFMvVwTAv0bUkz0ydOZf7SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iABViQ5NmgC7XbeNXhDtpmAhyCjhFXAqQKguCOdZ50yQ+HwmBJLUno0SC5NDIZOlrf168HusKKUFyDC4RZX1bNETFXsVr5jkVe+LNWUrlVxoTL1m+aSn32QuFT4w9JlPOhSVMmB8ngcRUJOa2YGRD9m0OklXhHuq2KOb396iqvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4F+bBjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4F+bBjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36995C32782;
	Thu,  6 Jun 2024 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682992;
	bh=LTk0e6f8jXx9Rhnpfi/XBFMvVwTAv0bUkz0ydOZf7SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4F+bBjcYxRxRo//3BH0cwemrYZ1m+HxheNdKgJBVNv0PzHmItIJGFpJ83AFFQqTP
	 +bqIPePlUCWfzUa7d0ZISXmuT7kiRLJl28BrpUBF+XzcyuSszbo8YY7Sulj+B+IcPO
	 ZD1jFuSfEddZjXIzIQMY3L5cawTFDWSvz3dEJb2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 144/374] mailbox: mtk-cmdq: Fix pm_runtime_get_sync() warning in mbox shutdown
Date: Thu,  6 Jun 2024 16:02:03 +0200
Message-ID: <20240606131656.735851181@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 747a69a119c469121385543f21c2d08562968ccc ]

The return value of pm_runtime_get_sync() in cmdq_mbox_shutdown()
will return 1 when pm runtime state is active, and we don't want to
get the warning message in this case.

So we change the return value < 0 for WARN_ON().

Fixes: 8afe816b0c99 ("mailbox: mtk-cmdq-mailbox: Implement Runtime PM with autosuspend")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index ead2200f39ba0..033aff11f87cf 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -465,7 +465,7 @@ static void cmdq_mbox_shutdown(struct mbox_chan *chan)
 	struct cmdq_task *task, *tmp;
 	unsigned long flags;
 
-	WARN_ON(pm_runtime_get_sync(cmdq->mbox.dev));
+	WARN_ON(pm_runtime_get_sync(cmdq->mbox.dev) < 0);
 
 	spin_lock_irqsave(&thread->chan->lock, flags);
 	if (list_empty(&thread->task_busy_list))
-- 
2.43.0



