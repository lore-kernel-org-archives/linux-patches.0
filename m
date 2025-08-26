Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8A414B950;
	Tue, 26 Aug 2025 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214964; cv=none; b=F7YMgm+9buQy+KdEVTWQo8lIPqg5NEknn7g/BCp9QNnvihr9JuZC+ZteNuGmJenlvPXzne3reoJ5ZRCQbw7xFQN4S1XkjIqX4vHwkafrhadNSsm+aKFaV1bl5NnuQGD9Djy3ltXrsBARgfJQ/lUUV/j16zOGrEdPyr6x7elEIFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214964; c=relaxed/simple;
	bh=om4111jzoXro2ajr8Dub5TLNVCLPmoaKPANUkU2zMCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akKquwITjizMdcTgaVB8fuhfK7UD4kIi+34/kPsNY29BtMmrPi+C+YYWV2qCkEomiLQdccFW9xbPOrCcWZAl/DDB/kfIZHSOQhHWa0MlkR+/x42UIqWS6IILtIFMZPn2BuWlACtyt5314rbD8vERX0v8cS231e08SB7+4lZfclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3NskA+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3NskA+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05276C4CEF1;
	Tue, 26 Aug 2025 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214964;
	bh=om4111jzoXro2ajr8Dub5TLNVCLPmoaKPANUkU2zMCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3NskA+w8vl0jynDQf+gwL1AWEkc0g90p33Rfh0SrHk8hbABlqMRmf1xYSQqvHHyG
	 821J3ykFbqZz9pkh9tiwD6cAJ5lhbp3mxMqygyi7k/UIXqrXNaSnj7PRy15KvfCcWi
	 19rGTm1BlxWfY2O8FFIRrF1oQ7VmTTeWAMSNVpKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 336/482] drm/amdkfd: Destroy KFD debugfs after destroy KFD wq
Date: Tue, 26 Aug 2025 13:09:49 +0200
Message-ID: <20250826110939.127157607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


