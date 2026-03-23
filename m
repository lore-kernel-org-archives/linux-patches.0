Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8533BD62F;
	Mon, 23 Mar 2026 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283060; cv=none; b=ALyy8xuuBKkzRfzHTSSHtkSNgm8oKRnZCe+4lS8ITJD2aJWrU50ye8zxC1YAnYS53Sb9n2ZP/uYDg4lk0+t3QoNKfQe2rgrEaJ8MP/791yko71hmXb5aJ5rz0jlIXlGtrwW45XSdjgb5/d7bnuXS5HQVqvnyjBe1AwBvznHYocI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283060; c=relaxed/simple;
	bh=SK7tLH+n57lGiuDiqPp0Zg+xV8s+LFm8aGnqJetXs4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jvt4FLHFzPt3eD4d/HTNiS2UjqGlT505P1jnN/j8+WOs/ynFczunNcaSubFL4Iecu5EEqwcFLe4/JV9uLpSeJlYU+lzpnzLBzf70avRnP26eYPxg6/EsWbzulWGfMJfUbMCpjThng1c29jKqvZnnvGDRum+VBI7YxVZY5eZLxcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amPBwGAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amPBwGAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21505C2BC9E;
	Mon, 23 Mar 2026 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283060;
	bh=SK7tLH+n57lGiuDiqPp0Zg+xV8s+LFm8aGnqJetXs4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amPBwGAu4xA1Wk/NhtSTWUB/c/Mb8GkavghY+zGwti1b3Llo2Jg3Teh6t+QC94MxZ
	 TitUuKkbPFs0K3WvHHsfTG5K4miGzLBXfxVDyFYlA5gajq89cLijammTngZpS6Qx33
	 ht+nlUqhyBMgJnc5cQoCBlC4a0Q5hijXgwXoLe6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 6.1 388/481] drm/exynos: vidi: fix to avoid directly dereferencing user pointer
Date: Mon, 23 Mar 2026 14:46:10 +0100
Message-ID: <20260323134534.604035907@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit d4c98c077c7fb2dfdece7d605e694b5ea2665085 upstream.

In vidi_connection_ioctl(), vidi->edid(user pointer) is directly
dereferenced in the kernel.

This allows arbitrary kernel memory access from the user space, so instead
of directly accessing the user pointer in the kernel, we should modify it
to copy edid to kernel memory using copy_from_user() and use it.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -252,19 +252,26 @@ int vidi_connection_ioctl(struct drm_dev
 
 	if (vidi->connection) {
 		struct edid *raw_edid;
+		struct edid edid_buf;
+		void *edid_userptr = u64_to_user_ptr(vidi->edid);
 
-		raw_edid = (struct edid *)(unsigned long)vidi->edid;
-		if (!drm_edid_is_valid(raw_edid)) {
+		if (copy_from_user(&edid_buf, edid_userptr, sizeof(struct edid)))
+			return -EFAULT;
+
+		if (!drm_edid_is_valid(&edid_buf)) {
 			DRM_DEV_DEBUG_KMS(ctx->dev,
 					  "edid data is invalid.\n");
 			return -EINVAL;
 		}
-		ctx->raw_edid = drm_edid_duplicate(raw_edid);
-		if (!ctx->raw_edid) {
+
+		raw_edid = drm_edid_duplicate(&edid_buf);
+
+		if (!raw_edid) {
 			DRM_DEV_DEBUG_KMS(ctx->dev,
 					  "failed to allocate raw_edid.\n");
 			return -ENOMEM;
 		}
+		ctx->raw_edid = raw_edid;
 	} else {
 		/*
 		 * with connection = 0, free raw_edid


