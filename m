Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B2146AF14;
	Tue, 16 Jun 2026 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627107; cv=none; b=Knt3FdId18i72krCwWqHYtpQFMGvNHM2+MqS4x5eTtHqk4y55hZuiVFuv9TfP2I/A0u9rc2E0d/B7uXQ8d52YXypYTV6cHeR7GRMAB19pFfvr1O/nlD6kUmuv9FLCCKOzogD7siPbcYllKQ2B9kOhWBmHgWdgFHwQ6DrVUeFbNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627107; c=relaxed/simple;
	bh=uSqWB07I/yVd0s0IwXFb5tmmEtb6M/Q48H8nG6WDGo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0B14wiyaolS8fxqCGmIwOret//KDWccMMWeUzGA4DrmFmumhBFECFGcv+UKhMb8+cLxZggdnZk82DoDUvbzxYa5PCN7UBZetA85MOz6fGyL5Ib+9CRJNvBrUb+X1ZhBLmIEmpau9T5t2i0wO9pDKGyOKVC7sJA3jme0D6aWsuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cI++N0fw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cI++N0fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6BB1F000E9;
	Tue, 16 Jun 2026 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627105;
	bh=uzSO8i2yHqbP1FFF37eL9VgZvdms1hODCIsgaHFKSeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cI++N0fwQsP79E6zPWcsPB8ZXze3TmanFevj3i4x84L+G72bPXwDPoSG8h4mtxfJS
	 XO7dMpKm0+UNah92XzRijzjbhQd6fakWEucNipB1aa5RLhOf9xG71Bvo2b5F8ygHrR
	 m7Ay23zf8yc09VzvLLNhXR/iBSrWahf9A7uP2eZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.12 121/261] tee: shm: fix shm leak in register_shm_helper()
Date: Tue, 16 Jun 2026 20:29:19 +0530
Message-ID: <20260616145050.656377265@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgiy Osokin <g.osokin@auroraos.dev>

commit 26682f5efc276e3ad96d102019472bfbf03833b2 upstream.

register_shm_helper() allocates shm before calling
iov_iter_npages(). If iov_iter_npages() returns 0, the function
jumps to err_ctx_put and leaks shm.

This can be triggered by TEE_IOC_SHM_REGISTER with
struct tee_ioctl_shm_register_data where length is 0.

Jump to err_free_shm instead.

Fixes: 7bdee4157591 ("tee: Use iov_iter to better support shared buffer registration")
Cc: stable@vger.kernel.org
Cc: lvc-project@linuxtesting.org
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -307,7 +307,7 @@ register_shm_helper(struct tee_context *
 	num_pages = iov_iter_npages(iter, INT_MAX);
 	if (!num_pages) {
 		ret = ERR_PTR(-ENOMEM);
-		goto err_ctx_put;
+		goto err_free_shm;
 	}
 
 	shm->pages = kcalloc(num_pages, sizeof(*shm->pages), GFP_KERNEL);


