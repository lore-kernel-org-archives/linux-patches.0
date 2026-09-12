Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17B1427A04;
	Sat, 12 Sep 2026 10:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208543; cv=none; b=diLPggKD7PlgLnBRspjTUu0WwQOGGipVglsmDVMOisSnafzCD+x2yeAfRt3u1Sl3GFXyIt3y8IJZCoYyc0NDg/J++CMZyUWkZYWQNb1xVKHsbQgW1OMsyNMdHXNEP3+xK6uRsPiX6SAPqCfxvFBotOSCE5q4+dkt5HSaxQfl3BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208543; c=relaxed/simple;
	bh=9lfRFKLhLEV8dGtLk3rVm7nPR2jg+XsYwoVepKm4LNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrZaU71GeRiRHNvNoHybvFg+GSHJjtDkwZ9EFsZhDTu8U6Vg8V8H8eyimWhwN4mtHf9Qn25dtPhji7/2YhldzZDCylY5RPnHFJUH6OKt8C3Lm2pkhZdC7vq3URUHCrdqXDfmWwUv9yfRZrVIwOmktsC+IlWeCsW0uPbyeZVFZrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWL0nmiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWL0nmiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1531F00893;
	Sat, 12 Sep 2026 10:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208534;
	bh=FP40s4eXx+qBKzQohhjl0tXf2XIqB43NxFRg/xKy06g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWL0nmiCUwNEtoO9ORKeIAmS8npKIuROoqtPI8dcNRODStyRZLF9nhCZsqdys3NWd
	 ApuYjm+Yqo7uVgh+YC1reBnmtyXWkqUEQh2UP4aFmAPtskX7fuWZZbQa1sQKP3M7tt
	 excH3669asrjTbP2A9MDwZJTgecAUyzSAZ2fNM3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0636/1518] drm/msm: remove objects from evit list after pinning them
Date: Sat, 12 Sep 2026 08:46:45 +0200
Message-ID: <20260912065637.817918956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

[ Upstream commit 83723f32cb3de23d45c1ac09241b5e0cfb32cc9b ]

Once objects are pinned they should not be kept in the evict list as
that will cause drm_gpuvm_validate to keep ieterating a growing list of
objects needlessly.

Once an object is pinned remove it from the list.

Fixes: 2e6a8a1fe2b2 ("drm/msm: Add VM_BIND ioctl")
Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/742166/
Message-ID: <20260723-evict_list_fix-v2-1-bd0725e56253@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_vma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_vma.c b/drivers/gpu/drm/msm/msm_gem_vma.c
index 9016ef978be5e..701fe4a0b73c9 100644
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -452,6 +452,8 @@ msm_gem_vm_bo_validate(struct drm_gpuvm_bo *vm_bo, struct drm_exec *exec)
 			return ret;
 	}
 
+	drm_gpuvm_bo_evict(vm_bo, false);
+
 	return 0;
 }
 
-- 
2.53.0



