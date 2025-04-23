Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6F3175BF;
	Wed, 23 Apr 2025 14:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420071; cv=none; b=k/twwD+Ml1yFwIuE7z0PmGv8uWPdmRQWeq8XRZs+wFYMe5/LszG7HJ5VEjMEqjQwxsYIINT3vgTqf7USViiRzHJEr2vZty+8BnD/E8/SWitQq9Hwae7WJUNJaRqQOjjKgbihC1lAlUe3IjiCfQnYzBnVhhX18YUAeATE0VnyK9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420071; c=relaxed/simple;
	bh=zu2VGz1rcJtPXoXXLZlaMCaFjZO4ly2M2heWvx6n2eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJr/mu+LL4uI+ySHGw3Lae3LJjdSasms0XFlIA5uCn/MxThmqgzXZCqQr0V8olGirUsVke7I3thUiGYE4DD+nNcPknIJJL7WhWZGK5/rFUtSY/6GEGCjfWcgYFeTpVdZXldfpajeLpb2lf0AOiy/nue89srVFW9QpK6RjDUfqII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuxxxUvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuxxxUvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DC8C4CEE2;
	Wed, 23 Apr 2025 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420071;
	bh=zu2VGz1rcJtPXoXXLZlaMCaFjZO4ly2M2heWvx6n2eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuxxxUvEq8daG9rHCl5azPFwhdykxJ++g7ni1/irHTEpOpHMtP63XpdTGbp6cnTP9
	 uLtcTSoTh2S7767nYPQVrjA7yXOPYtq6yig3j7SRTbLz6AFb2SFDQr7Md7eEhqepsm
	 krxEPtEr5/9uTNFG/q6l7L5gODU0uO5bSYLdgJak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/223] dma-buf/sw_sync: Decrement refcount on error in sw_sync_ioctl_get_deadline()
Date: Wed, 23 Apr 2025 16:42:49 +0200
Message-ID: <20250423142621.067945029@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c353029789cf1..1290886f065e3 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -444,15 +444,17 @@ static int sw_sync_ioctl_get_deadline(struct sync_timeline *obj, unsigned long a
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
@@ -464,6 +466,13 @@ static int sw_sync_ioctl_get_deadline(struct sync_timeline *obj, unsigned long a
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



