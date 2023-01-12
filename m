Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556BD749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4C8C433D2;
	Thu, 12 Jan 2023 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532540;
	bh=Mp1/T7PmqxzoioPX2+0xKJyLik9zZb3UDcFWWdSOBAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7nR2Ait1q5cLdk9zQk3lPJs96KaP/aFd77wud1P0Dzp0soAPOWhJL762GV6kgxQr
	 F/8PLurMWFtOhzfUCs5qgC6yPPQQvHte8Assw0pxrjI839/qA4tVtf/AKvmk3UV9TO
	 /im+b+xbeWpv/PGNVUXgW9ldhsEZ/HjoD1BV+JGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/783] drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
Date: Thu, 12 Jan 2023 14:48:31 +0100
Message-Id: <20230112135533.351757501@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit ca54639c7752edf1304d92ff4d0c049d4efc9ba0 ]

As comment of pci_get_class() says, it returns a pci_device with its
refcount increased and decreased the refcount for the input parameter
@from if it is not NULL.

If we break the loop in amdgpu_atrm_get_bios() with 'pdev' not NULL, we
need to call pci_dev_put() to decrease the refcount. Add the missing
pci_dev_put() to avoid refcount leak.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 6333cada1e09..4b568ee93243 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -313,6 +313,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	adev->bios = kmalloc(size, GFP_KERNEL);
 	if (!adev->bios) {
-- 
2.35.1



