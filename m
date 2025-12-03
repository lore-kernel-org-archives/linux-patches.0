Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B88354AF5;
	Wed,  3 Dec 2025 16:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779162; cv=none; b=Ga7qc5B2s710XyQJpl3cEDjGfuwo/6nuqOPEONS5Kxc1xW/zs2Ds2cKiWzD8w96Gac2Dg72WG6CrkoQpXccDbTZTfmW5aIUBhp1JqZLH90xK/Jfg7qXOJmdcwXl/rWlZvISGzOMCVbawx8CFEkOzPnWwVwhwZiGnl5j7hTpKn3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779162; c=relaxed/simple;
	bh=MsdNdq/FpN4M5m9goM3sLbBXmM4Atrie0ZKIBPX8qN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xg3KGlNEGlXmJsvCtE0yTHpraRY6+G2hRKwuUlTIODsMlocuF+zThX288mw2qtao2QCMJDCPPf5FDnDp45CHSINKSJ8iylGntqZZJM438GztrkhiMsk5gcV45qiSrg5aanS+D97sJ9t56CJ/oAZYZWALk3McWx2JnosPIPt/f2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZF1a6In; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZF1a6In"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02723C4CEF5;
	Wed,  3 Dec 2025 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779162;
	bh=MsdNdq/FpN4M5m9goM3sLbBXmM4Atrie0ZKIBPX8qN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZF1a6Insx2ct5MTF8HnFm769rBA3l7WWhy//sBebBxZpuO/nh1JWJ6yt+Nzluykf
	 5x4fJbH+D2Xr6AzskNvA9Ka1IyYV87fu3pSxFal3LjPEJptHxejvoiCvz6xWkLxuv9
	 qogTewJQZxCI12KMZVoC6FM5UHAOg4aavT3dnWdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey McRae <geoffrey.mcrae@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/568] drm/amdkfd: return -ENOTTY for unsupported IOCTLs
Date: Wed,  3 Dec 2025 16:22:23 +0100
Message-ID: <20251203152445.892234297@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Geoffrey McRae <geoffrey.mcrae@amd.com>

[ Upstream commit 57af162bfc8c05332a28c4d458d246cc46d2746d ]

Some kfd ioctls may not be available depending on the kernel version the
user is running, as such we need to report -ENOTTY so userland can
determine the cause of the ioctl failure.

Signed-off-by: Geoffrey McRae <geoffrey.mcrae@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 773913a7d6e90..c1cb91a79b796 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2790,8 +2790,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	int retcode = -EINVAL;
 	bool ptrace_attached = false;
 
-	if (nr >= AMDKFD_CORE_IOCTL_COUNT)
+	if (nr >= AMDKFD_CORE_IOCTL_COUNT) {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	if ((nr >= AMDKFD_COMMAND_START) && (nr < AMDKFD_COMMAND_END)) {
 		u32 amdkfd_size;
@@ -2804,8 +2806,10 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			asize = amdkfd_size;
 
 		cmd = ioctl->cmd;
-	} else
+	} else {
+		retcode = -ENOTTY;
 		goto err_i1;
+	}
 
 	dev_dbg(kfd_device, "ioctl cmd 0x%x (#0x%x), arg 0x%lx\n", cmd, nr, arg);
 
-- 
2.51.0



