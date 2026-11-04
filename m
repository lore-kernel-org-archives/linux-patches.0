Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827196;
	b=lo3sj6cVLL4UCx0q1ZBEACef74VtYMMs66urgBGL7XrvyqDQAgXE91PkI+v90o/zuCLQ
	 PPZmh0qvG5BiwzkA/9YcRMWY14jfxJPUPIe0d6bgIg5XTaPzOyDJNqs9JOYiNJETCxpDI
	 +HqGEe9rICoSRFAzvtrQLToGNdK8fgQ6Irptq8uSd2WTgQSRB1ht3woZlhK5VJalUpAwA
	 XipELVOrMK8xXRfhZdkhb9JW2ja9FvIcE3fCG5CIVr/pSmNmo19gdBMH1UsMuhg5gOtW4
	 u193qLLdivmo5je3t68XYGgjqkRVEi5FfP8mNT6woScG7QwAJ3aVO//4/duNmffi5cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T9ApCYWHBVDrqzvYCMis/TDfgoQvwLZTbugwLvvBtI8=;
	b=dQHNPzVPAyHhwfI+tsgHIg6zlml/6MhYLG1X4OKw168Ein5jjB+0M0ZtKvhQtAOUsn3K
	 wN0Cj4quFnJuCxmgRPRaoUf/amVeHRoxUTHz33pIJLKqeDThS9rVYE4Df0obLDZENjCa8
	 4XakSy5uYvjq2dIk+4lv3xMbZKUsWLNhtibgWdWwy1KQXCAXHsOapxGuiI6ja6bBvCxK5
	 E6ianXJPEVNQQ3shsFjidyqT6QYn/ExMSCVW54YDo/BZyxWt4Ln4U1QA3exmzbbCqPsKO
	 qf+wJX/mKcD6hfsnED2XjHZsi7X/2zL5XsOXIt4OSLqTZ5jqnP7vyoqtTafLZg4yayA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZfkuaMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82582606B387;
	Wed,  4 Nov 2026 21:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZfkuaMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2C21F00919;
	Wed,  4 Nov 2026 21:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827196;
	bh=T9ApCYWHBVDrqzvYCMis/TDfgoQvwLZTbugwLvvBtI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZfkuaMVX8yLcvxKkFjzq6udytcizUfY4BiojxM1gMO4+gL8qhr/jdRTk2c1XMicl
	 9i6I56JOBYliOmZIs4uwaVdLcSlHjIabzg1APRpNk7mKjvwYhX3kG24rEip10bfswm
	 B1CUychIAgbEw45IYAlGx85WGeG51aCnSBSBvKXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Ankit Agrawal <ankita@nvidia.com>
Subject: [PATCH 7.3 251/547] vfio/nvgrace-gpu: Use a core-only open_device in fallback mode
Date: Wed,  4 Nov 2026 16:07:15 -0500
Message-ID: <20261104211045.308222840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit 9c48b994b66d7b585698f9aaee8ff559a7755c0a upstream.

When the ACPI memory properties are missing or the C2C link is down, the
device is exposed through nvgrace_gpu_pci_core_ops.  That table opens
through nvgrace_gpu_open_device() but closes through
vfio_pci_core_close_device(), so open and close are not symmetric.

nvgrace_gpu_open_device() registers nvdev->usemem for poison handling
unconditionally.  In fallback mode usemem.memlength is zero, and
register_pfn_address_space() inserts a node covering [0, ULONG_MAX].
Nothing removes it: a second open fails with -EBUSY, and once the device
is unbound the node outlives the nvdev that contains it.  The next open
after a rebind reports:

  BUG: KASAN: slab-use-after-free in interval_tree_iter_first+0x209/0x310
  Read of size 8 at addr ffff88800894aa30 by task nvgrace_repro/203
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   print_report+0x153/0x4c6
   kasan_report+0xe4/0x1a0
   interval_tree_iter_first+0x209/0x310
   register_pfn_address_space+0x97/0x100
   nvgrace_gpu_open_device+0x21c/0x730
   vfio_df_open+0x213/0x520
   vfio_df_ioctl_bind_iommufd+0x3e8/0x6e0
   vfio_device_fops_unl_ioctl+0x782/0x1570
   __x64_sys_ioctl+0x13c/0x1c0
   do_syscall_64+0x106/0x630
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  Allocated by task 188:
   ...
   _vfio_alloc_device+0x3a/0x500
   nvgrace_gpu_probe+0xcb/0x660
   local_pci_probe+0xcf/0x170
   ...

  Freed by task 188:
   ...
   kfree+0x20d/0x600
   device_release+0xcf/0x250
   kobject_put+0x152/0x2f0
   pci_device_remove+0xb0/0x1c0
   device_release_driver_internal+0x38d/0x540
   unbind_store+0xde/0x100
   ...

Give the fallback table its own open_device that only calls
vfio_pci_core_enable() and vfio_pci_core_finish_enable(), the
counterpart of vfio_pci_core_close_device().  Fallback mode then never
touches the nvgrace memory regions, as Alex suggested.

This should be safe because the fallback table uses the vfio-pci core
read, write and mmap handlers, so nothing there uses the state
nvgrace_gpu_open_device() sets up.  The one visible difference is that a
fallback open no longer fails when BAR0 cannot be mapped, which matches
vfio-pci.

Fixes: e5f19b619fa0 ("vfio/nvgrace-gpu: register device memory for poison handling")
Cc: stable@vger.kernel.org
Suggested-by: Alex Williamson <alex@shazbot.org>
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>
Link: https://lore.kernel.org/r/20261015081937.405320-2-parri.andrea@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/nvgrace-gpu/main.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -1083,6 +1083,21 @@ static const struct vfio_device_ops nvgr
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 };
 
+static int nvgrace_gpu_core_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
+}
+
 static const struct vfio_pci_device_ops nvgrace_gpu_pci_dev_core_ops = {
 	.get_dmabuf_phys = vfio_pci_core_get_dmabuf_phys,
 };
@@ -1091,7 +1106,7 @@ static const struct vfio_device_ops nvgr
 	.name		= "nvgrace-gpu-vfio-pci-core",
 	.init		= vfio_pci_core_init_dev,
 	.release	= vfio_pci_core_release_dev,
-	.open_device	= nvgrace_gpu_open_device,
+	.open_device	= nvgrace_gpu_core_open_device,
 	.close_device	= vfio_pci_core_close_device,
 	.ioctl		= vfio_pci_core_ioctl,
 	.get_region_info_caps = vfio_pci_ioctl_get_region_info,


