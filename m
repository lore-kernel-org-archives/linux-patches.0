Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038CC1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1BFC433EF;
	Wed, 28 Dec 2022 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239437;
	bh=7E/0zQB8juoHyZTbd+Q/WRk6Bxaew8qu7g/BSd4k+WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbyPzcOGIyBHfF794qTvVa02SjNgqQl/kbvy95yMGLoNAh1OdsLfRE7kSCkTSDpLG
	 t4Cs7NGMv1GMRmQ7nOWXMt+iZSfBxIwwuk+bwuIPrDfWLqCPJ7b4huzFNIyF+OMOeJ
	 gBwyZErRF0htr2V/NebYV07XlnzAh243+ddzNNFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/731] drm/amdgpu: fix pci device refcount leak
Date: Wed, 28 Dec 2022 15:35:32 +0100
Message-Id: <20221228144303.083488128@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 36cc89f56cea..0d998bc830c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4902,6 +4902,8 @@ static void amdgpu_device_resume_display_audio(struct amdgpu_device *adev)
 		pm_runtime_enable(&(p->dev));
 		pm_runtime_resume(&(p->dev));
 	}
+
+	pci_dev_put(p);
 }
 
 static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
@@ -4940,6 +4942,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 		if (expires < ktime_get_mono_fast_ns()) {
 			dev_warn(adev->dev, "failed to suspend display audio\n");
+			pci_dev_put(p);
 			/* TODO: abort the succeeding gpu reset? */
 			return -ETIMEDOUT;
 		}
@@ -4947,6 +4950,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 	pm_runtime_disable(&(p->dev));
 
+	pci_dev_put(p);
 	return 0;
 }
 
-- 
2.35.1



