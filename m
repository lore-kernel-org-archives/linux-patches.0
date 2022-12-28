Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F531863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B820C433D2;
	Wed, 28 Dec 2022 15:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242531;
	bh=jrcC32pe8Kolx3MaVTPjSS7wyKA9V9nxMWJ6XbOIkaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOP8oNABDkOkuHl7TqDjhnRybnow6I+lCPJeIvmxiMAMSuSxwg/XvuuYf8TuVrEwL
	 6vnUU2sp+PJYa2euyRdzpuLN958HQwxR5D9P0EJdYCSpeOEbLNcDqyBhuwkTY4qZrx
	 dPb4fLnZnsienubeVF+hx0ACdlQdsu8GOgL1UCh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0380/1146] drm/amdgpu: fix pci device refcount leak
Date: Wed, 28 Dec 2022 15:31:59 +0100
Message-Id: <20221228144340.488228515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b85e285e3d6352b02947fc1b72303673dfacb0aa ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put().

So before returning from amdgpu_device_resume|suspend_display_audio(),
pci_dev_put() is called to avoid refcount leak.

Fixes: 3f12acc8d6d4 ("drm/amdgpu: put the audio codec into suspend state before gpu reset V3")
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index f1e9663b4051..2cf72cfa2e60 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5027,6 +5027,8 @@ static void amdgpu_device_resume_display_audio(struct amdgpu_device *adev)
 		pm_runtime_enable(&(p->dev));
 		pm_runtime_resume(&(p->dev));
 	}
+
+	pci_dev_put(p);
 }
 
 static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
@@ -5065,6 +5067,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 		if (expires < ktime_get_mono_fast_ns()) {
 			dev_warn(adev->dev, "failed to suspend display audio\n");
+			pci_dev_put(p);
 			/* TODO: abort the succeeding gpu reset? */
 			return -ETIMEDOUT;
 		}
@@ -5072,6 +5075,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 	pm_runtime_disable(&(p->dev));
 
+	pci_dev_put(p);
 	return 0;
 }
 
-- 
2.35.1



