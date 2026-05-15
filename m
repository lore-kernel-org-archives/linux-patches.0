Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A813F9299;
	Fri, 15 May 2026 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862074; cv=none; b=KzUuUcsnEm8N/g2THF1ex/8Z21wzNR2/K9RS5MFxHCZ0ZSIIKewSHaAns94uNHwvFezFVK4zmtqJX7MvDHphxuvxOGurbuWwptrBGQzoZO+W7tcWNrUdxrHavuI67HyZ8EzDFYZwIPGZlGlQn/Q7jMQvOwggWOlegrncbqonszQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862074; c=relaxed/simple;
	bh=roI1bj0ec+fQ8jq1fw/PqXYNeTO4ULlCzLIWtpeff64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhzk6cZSI4cMNy6uhKM8FQFVMWUA6Jxrn5OUMqJGBX/BwXhzNj3uhL44yMEjuYZfXe/HO6rmOuPyPOpoIBJ6sagDgCkd/L309R6iuPWST/U//XDihPc5y8AMQi4gJhBchbb9EnqFFg711q38rYVpqayC4OOtfMrB3wQGI75CylQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbaoWRVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbaoWRVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AEAC2BCB3;
	Fri, 15 May 2026 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862074;
	bh=roI1bj0ec+fQ8jq1fw/PqXYNeTO4ULlCzLIWtpeff64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbaoWRVstOMyAlwPQbxCbnMR8CBKKNmd1RCVJyb2zBDheLNaJRxTp16M97DOMHawa
	 lqIe3gznC7sMhrvvI4UmMi9pQxHX+td8W6Jt5Ns1ErZou+KIyrGOmlxscjRX/Pubz0
	 vgk4qa7u/Fv8Otdex7AX52SwNk62l7gE/vaQM8zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 097/188] drm/msm/gem: fix error handling in msm_ioctl_gem_info_get_metadata()
Date: Fri, 15 May 2026 17:48:34 +0200
Message-ID: <20260515154659.433998538@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasuaki Torimaru <yasuakitorimaru@gmail.com>

commit 47cbfe2608314b833ad61a65827d8fb363bc2d2d upstream.

msm_ioctl_gem_info_get_metadata() always returns 0 regardless of
errors. When copy_to_user() fails or the user buffer is too small,
the error code stored in ret is ignored because the function
unconditionally returns 0. This causes userspace to believe the
ioctl succeeded when it did not.

Additionally, kmemdup() can return NULL on allocation failure, but
the return value is not checked. This leads to a NULL pointer
dereference in the subsequent copy_to_user() call.

Add the missing NULL check for kmemdup() and return ret instead of 0.

Note that the SET counterpart (msm_ioctl_gem_info_set_metadata)
correctly returns ret.

Fixes: 9902cb999e4e ("drm/msm/gem: Add metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Yasuaki Torimaru <yasuakitorimaru@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/714478/
Message-ID: <20260325114635.383241-1-yasuakitorimaru@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -536,6 +536,11 @@ static int msm_ioctl_gem_info_get_metada
 	len = msm_obj->metadata_size;
 	buf = kmemdup(msm_obj->metadata, len, GFP_KERNEL);
 
+	if (!buf) {
+		msm_gem_unlock(obj);
+		return -ENOMEM;
+	}
+
 	msm_gem_unlock(obj);
 
 	if (*metadata_size < len) {
@@ -548,7 +553,7 @@ static int msm_ioctl_gem_info_get_metada
 
 	kfree(buf);
 
-	return 0;
+	return ret;
 }
 
 static int msm_ioctl_gem_info(struct drm_device *dev, void *data,


