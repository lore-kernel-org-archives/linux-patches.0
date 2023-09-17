Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B96A6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF577C433C7;
	Sun, 17 Sep 2023 20:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982023;
	bh=3/9DWdZuXhmRbxbukpCJjjWzB203sUAzyLsJex0tJSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieP/R7yroodM9pAPYQrh2IBGfRpkDoTpauuDjaH7bqw+I8x3HHQknATUDEH4+Up4k
	 xp+on5Ru1oM8eAQrRtQPZzCGZLR+oBrg/NRaEMuiAcBSVw2Hysq5k/5DUuchBL6g8s
	 d0p8cZButtyS0pQagnfJpkEwfHHL2WpmhOkkmE5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/511] drm/amdgpu: avoid integer overflow warning in amdgpu_device_resize_fb_bar()
Date: Sun, 17 Sep 2023 21:09:27 +0200
Message-ID: <20230917191117.241450136@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 822130b5e8834ab30ad410cf19a582e5014b9a85 ]

On 32-bit architectures comparing a resource against a value larger than
U32_MAX can cause a warning:

drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:1344:18: error: result of comparison of constant 4294967296 with expression of type 'resource_size_t' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
                    res->start > 0x100000000ull)
                    ~~~~~~~~~~ ^ ~~~~~~~~~~~~~~

As gcc does not warn about this in dead code, add an IS_ENABLED() check at
the start of the function. This will always return success but not actually resize
the BAR on 32-bit architectures without high memory, which is exactly what
we want here, as the driver can fall back to bank switching the VRAM
access.

Fixes: 31b8adab3247 ("drm/amdgpu: require a root bus window above 4GB for BAR resize")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 2b5766d3789b2..8b6b47fd9b880 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1195,6 +1195,9 @@ int amdgpu_device_resize_fb_bar(struct amdgpu_device *adev)
 	u16 cmd;
 	int r;
 
+	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
+		return 0;
+
 	/* Bypass for VF */
 	if (amdgpu_sriov_vf(adev))
 		return 0;
-- 
2.40.1



