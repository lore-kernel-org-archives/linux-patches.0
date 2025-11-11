Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBE14C97;
	Tue, 11 Nov 2025 00:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822254; cv=none; b=d5ocINU/Xxu7AJcvdkr8f3QaAqE8pTPzYse3Autylk0IzSGFtqXt7YE+qZvaYUVogp37D87HzjngmDi+OV+HNIP0bFZp4TEVBGzKA77GUXjVO8lrRHGY+21fDbviAhLRKkgdhwOTI+y+QwwJsJ6m72A0Et5sDm2ccLqTv6NzX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822254; c=relaxed/simple;
	bh=2MnJYnUpESVE9t2XRuaSN79O+7PVpWTBiei3RBBPLPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYE7ocZz9WMmqQ7wjb6P68fHPxlIYaYBSD+X9GUAsqE21N1qYhNprOdYQdzuCkCb0qoy6ELOY3AUWkHZtmvp5roP3Jh8LBa+zdO05JA7P1I9oaXq/sapkJc7VRK5MOsn7a3YMwZKYXEeQzpka457uo2bV7mTafilbsqgwCDcTBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkdctji7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkdctji7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380BDC116B1;
	Tue, 11 Nov 2025 00:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822254;
	bh=2MnJYnUpESVE9t2XRuaSN79O+7PVpWTBiei3RBBPLPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkdctji7+hnpCxFhRyFm/2sW9wDVb/VNV5EfiPGOpBvh8ZA3HBvvLL0srIqLq6JFN
	 ifMbRVdi47KnVCLQjvoscl659DXTsByDx7OHQauXmRlByIvEDHOVjXz2UMqoWs1AOt
	 t+Ufub2jfgQHLOrKyZLZPyHETZn1ZAEpa2hrg8fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 067/849] drm/msm: Ensure vm is created in VM_BIND ioctl
Date: Tue, 11 Nov 2025 09:33:57 +0900
Message-ID: <20251111004538.048432075@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 00d5f09719aa6c37545be5c05d25a1eaf8f3da7e ]

Since the vm is lazily created, to allow userspace to opt-in to a
VM_BIND context, we can't assume it is already created.

Fixes: 2e6a8a1fe2b2 ("drm/msm: Add VM_BIND ioctl")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/682939/
Message-ID: <20251022222039.9937-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_vma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_vma.c b/drivers/gpu/drm/msm/msm_gem_vma.c
index 381a0853c05ba..b6248f86a5ab1 100644
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -1401,7 +1401,7 @@ msm_ioctl_vm_bind(struct drm_device *dev, void *data, struct drm_file *file)
 	 * Maybe we could allow just UNMAP ops?  OTOH userspace should just
 	 * immediately close the device file and all will be torn down.
 	 */
-	if (to_msm_vm(ctx->vm)->unusable)
+	if (to_msm_vm(msm_context_vm(dev, ctx))->unusable)
 		return UERR(EPIPE, dev, "context is unusable");
 
 	/*
-- 
2.51.0



