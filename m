Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3443C8EB;
	Wed, 23 Apr 2025 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420720; cv=none; b=lIbt9fFNHYZto9wexLjs1ybe0B9rmOmX3VkVjsx+Uez4/dMZGhH+W0nvmVryfuCWQMa+zL1gTeJs+G+0QukKcnweFrZXSj2uNwBglG43WXn4wy0IMzJLlwBOoC55qXmwiJtHEvbKiEVUB9Ipml6UNzvC2OR70bpVWyjI70O6jMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420720; c=relaxed/simple;
	bh=ow1Ze8xBmK7TJz0+kZRbh2WO0pfQ/gPB7np4xzZCM20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PtUuk8kOkIzlvvVCH7WKPsoFEPCQFQ0NHOLttaziQz35jfYbjlsJPdpbQLMfJg7Q2l+pOlp5beoV83XQ/2ByMmgoGXo/mU7SYp3zqcEkoluBGrktuxqX3VjJQ8TXjJs2XzYRBQMqQwU5qovPYqYWJ8K1GntsrWZwfUS35QHca/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YakV61/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YakV61/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8DAC4CEE2;
	Wed, 23 Apr 2025 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420719;
	bh=ow1Ze8xBmK7TJz0+kZRbh2WO0pfQ/gPB7np4xzZCM20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YakV61/m7SsR2wqhlWLGCwelmDtfZohtyMp4eBZeTSemc46ZGm8FQ71538jMeuQU
	 NVi4hcmPsm2AfMp/fyEnmmUflInCrq5h27T1z8aVCBG1h3UBfElfb5wPnVxiivH9YZ
	 Dd7GaLyKSDqCc2fvpB3w/+BuJbAn3qekycCiX/28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 116/241] dma-buf/sw_sync: Decrement refcount on error in sw_sync_ioctl_get_deadline()
Date: Wed, 23 Apr 2025 16:43:00 +0200
Message-ID: <20250423142625.323196748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d27326a9999286fa45ad063f760e63329254f130 ]

Call dma_fence_put(fence) before returning an error if
dma_fence_to_sync_pt() fails.  Use an unwind ladder at the
end of the function to do the cleanup.

Fixes: 70e67aaec2f4 ("dma-buf/sw_sync: Add fence deadline support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/a010a1ac-107b-4fc0-a052-9fd3706ad690@stanley.mountain
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/sw_sync.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index f5905d67dedbb..22a808995f106 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -438,15 +438,17 @@ static int sw_sync_ioctl_get_deadline(struct sync_timeline *obj, unsigned long a
 		return -EINVAL;
 
 	pt = dma_fence_to_sync_pt(fence);
-	if (!pt)
-		return -EINVAL;
+	if (!pt) {
+		ret = -EINVAL;
+		goto put_fence;
+	}
 
 	spin_lock_irqsave(fence->lock, flags);
-	if (test_bit(SW_SYNC_HAS_DEADLINE_BIT, &fence->flags)) {
-		data.deadline_ns = ktime_to_ns(pt->deadline);
-	} else {
+	if (!test_bit(SW_SYNC_HAS_DEADLINE_BIT, &fence->flags)) {
 		ret = -ENOENT;
+		goto unlock;
 	}
+	data.deadline_ns = ktime_to_ns(pt->deadline);
 	spin_unlock_irqrestore(fence->lock, flags);
 
 	dma_fence_put(fence);
@@ -458,6 +460,13 @@ static int sw_sync_ioctl_get_deadline(struct sync_timeline *obj, unsigned long a
 		return -EFAULT;
 
 	return 0;
+
+unlock:
+	spin_unlock_irqrestore(fence->lock, flags);
+put_fence:
+	dma_fence_put(fence);
+
+	return ret;
 }
 
 static long sw_sync_ioctl(struct file *file, unsigned int cmd,
-- 
2.39.5



