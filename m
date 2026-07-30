Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D215844103A;
	Thu, 30 Jul 2026 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422472; cv=none; b=sBXZJ5zQEJaFgHD0BQQFtDRf/P+UItslEuzgJMz74stGjenLh0RuE8axKid9/AE0dXxV+yFBCZ/tO/gjeEXOpWxDijOpBYV60eR2I4aDrgOLQLwz4rlI8Z58aV25SHNWTjfrzb8ZAhN/sXirhtsbW4CosjXSovjoI9FA4thaio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422472; c=relaxed/simple;
	bh=XCb3f3Ku+LOkqGTaocr09yaKAnJDexztsKzHrUz9a0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnVva211alTH1kchHdCl8SHza+H6VjNBU99ZrZ4VE07EEDMIIPr1bfO2BJdgo5fmSqpntOX4kCfDm7W1I+JIKOxqZoC545J2cCYxqfgQ/3d/AWCv4anpd6+70tDszjeCLzMZ/mk4wKhwcGdRrq/7bV49vXwdEqm4m6sjJ1VzW/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAmGMjQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAmGMjQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375AA1F000E9;
	Thu, 30 Jul 2026 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422470;
	bh=0Yfntzcn9wqRJLtBona5k/niybN0QQorob55Pu7Rkdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAmGMjQBTDBA6ye5/+2HinwWWElaDbQRd5KSgESQcJArflKCFKUILI4JkfVU/UD24
	 f2RHPhj8n7rn3FqXTeLlwRfl0LY6xwXl4tmresHmFQioATLsomQygM94f5klP06gz8
	 jiUNuJqNv/BN44Wv7y9KkO4meCtJGPxrBef27wY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 413/744] drm/amdkfd: Use kvcalloc to allocate arrays
Date: Thu, 30 Jul 2026 16:11:26 +0200
Message-ID: <20260730141453.074498232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit 9c8b85f95c1d4736b967e17b8eb4a463c055bea3 upstream.

There were a few instances in kfd_chardev.c of kvzalloc being
used to allocate memory for an array.

Switch those to kvcalloc, which
- is the standard way of allocating a zero-initialized array
- does a check for the mul overflowing

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 60b048c93f7a3add39757ad65fe2bb6e58eeae23)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1837,13 +1837,13 @@ static int criu_checkpoint_devices(struc
 	struct kfd_criu_device_bucket *device_buckets = NULL;
 	int ret = 0, i;
 
-	device_buckets = kvzalloc(num_devices * sizeof(*device_buckets), GFP_KERNEL);
+	device_buckets = kvcalloc(num_devices, sizeof(*device_buckets), GFP_KERNEL);
 	if (!device_buckets) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	device_priv = kvzalloc(num_devices * sizeof(*device_priv), GFP_KERNEL);
+	device_priv = kvcalloc(num_devices, sizeof(*device_priv), GFP_KERNEL);
 	if (!device_priv) {
 		ret = -ENOMEM;
 		goto exit;
@@ -1963,17 +1963,17 @@ static int criu_checkpoint_bos(struct kf
 	int ret = 0, pdd_index, bo_index = 0, id;
 	void *mem;
 
-	bo_buckets = kvzalloc(num_bos * sizeof(*bo_buckets), GFP_KERNEL);
+	bo_buckets = kvcalloc(num_bos, sizeof(*bo_buckets), GFP_KERNEL);
 	if (!bo_buckets)
 		return -ENOMEM;
 
-	bo_privs = kvzalloc(num_bos * sizeof(*bo_privs), GFP_KERNEL);
+	bo_privs = kvcalloc(num_bos, sizeof(*bo_privs), GFP_KERNEL);
 	if (!bo_privs) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	files = kvzalloc(num_bos * sizeof(struct file *), GFP_KERNEL);
+	files = kvcalloc(num_bos, sizeof(struct file *), GFP_KERNEL);
 	if (!files) {
 		ret = -ENOMEM;
 		goto exit;
@@ -2510,7 +2510,7 @@ static int criu_restore_bos(struct kfd_p
 	if (!bo_buckets)
 		return -ENOMEM;
 
-	files = kvzalloc(args->num_bos * sizeof(struct file *), GFP_KERNEL);
+	files = kvcalloc(args->num_bos, sizeof(struct file *), GFP_KERNEL);
 	if (!files) {
 		ret = -ENOMEM;
 		goto exit;


