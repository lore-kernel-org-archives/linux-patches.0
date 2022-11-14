Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549114C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3043C433D6;
	Mon, 14 Nov 2022 13:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431291;
	bh=gyd6MSVcaGqYhMtUQXg+Ec360Qdct/fzJ5nLR4bAHVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOXHSaEKlN8BK4aRVDwLurlJcToCq0Ffith75+5NXJ2KaxrBqEkznYO7J8xh5pJyl
	 m80oVT2uH+yp/abGLdDPfyFEOtrWeoFf6aL3kgE9WeEFB/+w/iJTP+gla84wfzbk/T
	 BwYt6P8yrbFyCqi4IN4jvWzv0FgpTAIZQ72vafI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Rajneesh Bhardwaj <Rajneesh.Bhardwaj@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Subject: [PATCH 6.0 142/190] drm/amdkfd: Fix error handling in criu_checkpoint
Date: Mon, 14 Nov 2022 13:46:06 +0100
Message-Id: <20221114124505.010383104@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Kuehling <Felix.Kuehling@amd.com>

commit b91c23e099f0b65d62159da13458c5eefa76083f upstream.

Checkpoint BOs last. That way we don't need to close dmabuf FDs if
something else fails later. This avoids problematic access to user mode
memory in the error handling code path.

criu_checkpoint_bos has its own error handling and cleanup that does not
depend on access to user memory.

In the private data, keep BOs before the remaining objects. This is
necessary to restore things in the correct order as restoring events
depends on the events-page BO being restored first.

Fixes: be072b06c739 ("drm/amdkfd: CRIU export BOs as prime dmabuf objects")
Reported-by: Jann Horn <jannh@google.com>
CC: Rajneesh Bhardwaj <Rajneesh.Bhardwaj@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-and-tested-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |   34 +++++++++++++------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1928,7 +1928,7 @@ static int criu_checkpoint(struct file *
 {
 	int ret;
 	uint32_t num_devices, num_bos, num_objects;
-	uint64_t priv_size, priv_offset = 0;
+	uint64_t priv_size, priv_offset = 0, bo_priv_offset;
 
 	if (!args->devices || !args->bos || !args->priv_data)
 		return -EINVAL;
@@ -1972,38 +1972,34 @@ static int criu_checkpoint(struct file *
 	if (ret)
 		goto exit_unlock;
 
-	ret = criu_checkpoint_bos(p, num_bos, (uint8_t __user *)args->bos,
-			    (uint8_t __user *)args->priv_data, &priv_offset);
-	if (ret)
-		goto exit_unlock;
+	/* Leave room for BOs in the private data. They need to be restored
+	 * before events, but we checkpoint them last to simplify the error
+	 * handling.
+	 */
+	bo_priv_offset = priv_offset;
+	priv_offset += num_bos * sizeof(struct kfd_criu_bo_priv_data);
 
 	if (num_objects) {
 		ret = kfd_criu_checkpoint_queues(p, (uint8_t __user *)args->priv_data,
 						 &priv_offset);
 		if (ret)
-			goto close_bo_fds;
+			goto exit_unlock;
 
 		ret = kfd_criu_checkpoint_events(p, (uint8_t __user *)args->priv_data,
 						 &priv_offset);
 		if (ret)
-			goto close_bo_fds;
+			goto exit_unlock;
 
 		ret = kfd_criu_checkpoint_svm(p, (uint8_t __user *)args->priv_data, &priv_offset);
 		if (ret)
-			goto close_bo_fds;
+			goto exit_unlock;
 	}
 
-close_bo_fds:
-	if (ret) {
-		/* If IOCTL returns err, user assumes all FDs opened in criu_dump_bos are closed */
-		uint32_t i;
-		struct kfd_criu_bo_bucket *bo_buckets = (struct kfd_criu_bo_bucket *) args->bos;
-
-		for (i = 0; i < num_bos; i++) {
-			if (bo_buckets[i].alloc_flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM)
-				close_fd(bo_buckets[i].dmabuf_fd);
-		}
-	}
+	/* This must be the last thing in this function that can fail.
+	 * Otherwise we leak dmabuf file descriptors.
+	 */
+	ret = criu_checkpoint_bos(p, num_bos, (uint8_t __user *)args->bos,
+			   (uint8_t __user *)args->priv_data, &bo_priv_offset);
 
 exit_unlock:
 	mutex_unlock(&p->mutex);


