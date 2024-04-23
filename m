Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35519143897;
	Tue, 23 Apr 2024 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908556; cv=none; b=t/JuXifax0Lwq0iNX4Q4B8tUJExJ3dFPNIZoHc2Gkm+ZWqWY8Z0H9ZFUF5su4j+OOozWcvfn2Dqx46+Rp0cgbCOojYGBMVIm2tw1JK3XXa1LzGZSn5jfQ3DovqIduFpnI1r8EVhzoGUZ+Jt6p8DMQZzSgcWTIEgPykj472XRP0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908556; c=relaxed/simple;
	bh=nWAxosUidR6hAEWsRgDnwX+YzURzW+RwjaagbdfJr9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRHz6Cq1sSHM2ghYBFqCVOvj8E9/Tf7r4Aal+qXFNnO0+uHXZuwlTXqAUIra0U5Bd1zNKwjNSxpBIvbLCD2/dH55YmNH6Y+1rdsf/PtpJ7Siy0XSXNGBMXtuehJVY8xdNXF0j5WhLWifnH1Q++9jpozscxsJ+kNiGyUtAgkpO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5lq2up2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5lq2up2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083ABC32782;
	Tue, 23 Apr 2024 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908556;
	bh=nWAxosUidR6hAEWsRgDnwX+YzURzW+RwjaagbdfJr9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5lq2up2lZxNpI2o/sf5y4EGboQix6vMAK5yF4JuprgrT/8JpBHyXeNe5yayBTGJW
	 LXgdEyR6af0jhJvJvIVAlqURJicFHjJCjGBrpc5IksK33LGXKVubMjEU7GWp+LwMnO
	 TPGDmui1hXPmay1FHz4w8pK6JlH18tGjut/FY8ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Harish Kasiviswanthan <Harish.Kasiviswanthan@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 141/158] drm/amdkfd: Fix memory leak in create_process failure
Date: Tue, 23 Apr 2024 14:39:23 -0700
Message-ID: <20240423213900.447387875@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

commit 18921b205012568b45760753ad3146ddb9e2d4e2 upstream.

Fix memory leak due to a leaked mmget reference on an error handling
code path that is triggered when attempting to create KFD processes
while a GPU reset is in progress.

Fixes: 0ab2d7532b05 ("drm/amdkfd: prepare per-process debug enable and disable")
CC: Xiaogang Chen <xiaogang.chen@amd.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Tested-by: Harish Kasiviswanthan <Harish.Kasiviswanthan@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -819,9 +819,9 @@ struct kfd_process *kfd_create_process(s
 	mutex_lock(&kfd_processes_mutex);
 
 	if (kfd_is_locked()) {
-		mutex_unlock(&kfd_processes_mutex);
 		pr_debug("KFD is locked! Cannot create process");
-		return ERR_PTR(-EINVAL);
+		process = ERR_PTR(-EINVAL);
+		goto out;
 	}
 
 	/* A prior open of /dev/kfd could have already created the process. */


