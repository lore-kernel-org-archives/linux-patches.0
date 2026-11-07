Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064625;
	b=DDkrs+Fq+9MTOlZ/bqWALukhWQh3PxLY67jyupCQOgv0rsybcRqQmo9ZmdKYDuIUs3zS
	 Z/1T4BHejE0bVQXD4naAcXNv1AHvuOUzP6PLxnCsk511d8LmYh6XUER/dm2BjAUbIjyqb
	 BHrC2BUbZsmMs52+m+rn+9nOWRQ/9zIPRdavBRemA3Pxxjt3hJxu/W+LKjDziwKohkzPE
	 z9NqY0cZOP8e2uld50pe4QVB3kSKNNU2XXNgi116gwNEnM+rBNYt5ZtfqI8VO1tyy1pxD
	 8pINhYOhQF1fVbxC4Yk7BZm2xDwtCp69wSPoUpmOYv+dfrLn9J4X8poTsb68YsIBS8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClnY2YjkhvpCJjXF+Me6soxnttz9zf81pBGR+vXCbBA=;
	b=MVZ7nM2Zx+ChyUXS5BFLGXIk5DbRFqnY6AQRjtd1I82d8aF1BzlxNUvVlecWbrX0MC8g
	 LfKgQ3ZhYlTIh2nEBfeVeVrwqfUtiedt0IDRg97gCpF73/3JKSnUZExXE+CtNdET7gvAO
	 CccEDTubgtwSDPDKnLOzF1a+nQf1joYoRRSOojwNmvia1BZ9zNzd8gGW6efVRExKetnhc
	 qFEOQnKG7bUMMmzdsoQZcFM7lHYuN1sgJjPrVRiLGDYQhByXBPjjvbFZtM4ePuOUf1kpu
	 xa/gAG2qTUwbJWGisCaa3hSN7AaeF0Rh9BadmA0f+oHV4j/Lg//gNM45f0ybOiEwlDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9JSXy5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3B4606C007;
	Sat,  7 Nov 2026 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9JSXy5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5D41F0089F;
	Sat,  7 Nov 2026 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064624;
	bh=ClnY2YjkhvpCJjXF+Me6soxnttz9zf81pBGR+vXCbBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9JSXy5JMIE0RQo+PjTi86Oq65n2A3losJj8D3SJqobfsZpvolbbFgiTsKCD5v7xe
	 eUJw0c7BG6aY8vbw5Qn9oXuSXTtRblkTS0TZlE5gkA528Xuvr0UAxhSDVKjXRkEgx8
	 iDQIql4yDJTh5BBFL0/rhjyG1i4eFYTk/xv2jRVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0634/1257] mailbox: mtk-cmdq: Fix runtime PM leak in cmdq_mbox_flush()
Date: Sat,  7 Nov 2026 08:48:50 -0500
Message-ID: <20261107134956.796543172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 18e3e979826795b62e8916743bec4de660e7cb22 ]

pm_runtime_get_sync() leaves the runtime PM usage counter incremented
even when it fails, but cmdq_mbox_flush() returns the error without
dropping it.  The same happens when the GCE thread does not drain in
time and the function bails out with -EFAULT.

Undo the reference on both error paths.

Fixes: b0524f7c9635 ("mailbox: mediatek: implement flush function")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index e523c84b48088..96462ca844715 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -565,8 +565,10 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 	int ret;
 
 	ret = pm_runtime_get_sync(cmdq->mbox.dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(cmdq->mbox.dev);
 		return ret;
+	}
 
 	spin_lock_irqsave(&thread->chan->lock, flags);
 	if (list_empty(&thread->task_busy_list))
@@ -603,6 +605,9 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 		dev_err(cmdq->mbox.dev, "Fail to wait GCE thread 0x%x done\n",
 			(u32)(thread->base - cmdq->base));
 
+		pm_runtime_mark_last_busy(cmdq->mbox.dev);
+		pm_runtime_put_autosuspend(cmdq->mbox.dev);
+
 		return -EFAULT;
 	}
 	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-- 
2.53.0



