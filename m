Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E083F227599;
	Tue, 26 Aug 2025 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207528; cv=none; b=Kv6LIQQ/LoLcmF5rZ+EzgtjGavv+o3+uaHyW+7LoLFCNq7mDt1WTd3oLlEQKvGPmZwbzg8mAr5lSyU4XVYcaKdLYqxmMZLFF41/ajEahsPGzluye5kWPJNjHbrk+gfSrqT61ZCwuzC+9tVXTI+rBLgENJenoSu6/4XrjS5rhNug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207528; c=relaxed/simple;
	bh=FPl7iX8UEoOpdMF3zVDtD+Qpos/CN5o/Fhy+IJpJApQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ0FPkE1p8zCfOSD7L43zCX+jSsqdP64f8sgMYzteVIRV4r4kp86hTwvTrlYPTkZr4zaKH8tZgTXU3BAABT2N+jP6c6eePIp7PynmLaTZ83RQxRr5+F+8s65QD9t7joMvqs9PWQt3s+iFEychmhFBEClKO9FrU8DqWpqZFff9WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvu1wuBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvu1wuBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780EFC4CEF1;
	Tue, 26 Aug 2025 11:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207527;
	bh=FPl7iX8UEoOpdMF3zVDtD+Qpos/CN5o/Fhy+IJpJApQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvu1wuBgaX5IASL69juwAVkdHUYx4/89dLD2lFgBG4uUkknchBt81O5EiVzLpFepe
	 UYPZcO4soa/75ZriyF+MyNP0mPnjO+Tn9bEwPpw3fVm8HYMDa8qTTBe7wfsaWcEWMe
	 MzyB8WubOptBdXGVuCHGZtmOjZBYf36w3dN/a92w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 185/457] drm/amdkfd: Destroy KFD debugfs after destroy KFD wq
Date: Tue, 26 Aug 2025 13:07:49 +0200
Message-ID: <20250826110941.944675879@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amber Lin <Amber.Lin@amd.com>

commit 2e58401a24e7b2d4ec619104e1a76590c1284a4c upstream.

Since KFD proc content was moved to kernel debugfs, we can't destroy KFD
debugfs before kfd_process_destroy_wq. Move kfd_process_destroy_wq prior
to kfd_debugfs_fini to fix a kernel NULL pointer problem. It happens
when /sys/kernel/debug/kfd was already destroyed in kfd_debugfs_fini but
kfd_process_destroy_wq calls kfd_debugfs_remove_process. This line
    debugfs_remove_recursive(entry->proc_dentry);
tries to remove /sys/kernel/debug/kfd/proc/<pid> while
/sys/kernel/debug/kfd is already gone. It hangs the kernel by kernel
NULL pointer.

Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Reviewed-by: Eric Huang <jinhuieric.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0333052d90683d88531558dcfdbf2525cc37c233)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
@@ -78,8 +78,8 @@ err_ioctl:
 static void kfd_exit(void)
 {
 	kfd_cleanup_processes();
-	kfd_debugfs_fini();
 	kfd_process_destroy_wq();
+	kfd_debugfs_fini();
 	kfd_procfs_shutdown();
 	kfd_topology_shutdown();
 	kfd_chardev_exit();


