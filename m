Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E391F3FFE;
	Tue, 21 Jan 2025 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482895; cv=none; b=GPj/1Yz/UkyFumBOkaUVlA84BLA6lDprW9CXxJ5jgFpPTrflmeCxBdU8NYYxC0KotkS03PFTCbHEvaeo1nQISVDq+VIRp6vUhN+S8M2rvutedQL5I5uqN4D9yjmcYchQaoZpA1ePQE+cFPPTgcdwsPnq9hDbe3EwdFVwtMGjstA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482895; c=relaxed/simple;
	bh=J4c9Fo9njWVUH2diVprDkh4r8AyZmC7Vf553DYX+ljY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xhx/aGA7WBvDUG8hio/bTM79yJaZ8soeDSdFEhmzywOtUmDpTcR2VLzs8v8W4m/CKIZQbVVAZUKrjWErDFYBjLg/nQmEH03kC5mv34G9AV6Uyw/sFySAVk4TZpBrLnacIDmBbdzCniFgcbcJCGZU8Z0Yw8INOxbpk1v9C926R7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjrwxa19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjrwxa19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15FBC4CEDF;
	Tue, 21 Jan 2025 18:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482895;
	bh=J4c9Fo9njWVUH2diVprDkh4r8AyZmC7Vf553DYX+ljY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjrwxa198tpuEZFPNbsDcz76uSfVit5YC4/GMnRU94gNrYem4jlWnSsGGRAddDffw
	 i1XiDXCIDM2VFVC8zZ7pMJKaaMBZrE66wCMD8Vq++VG6LAGy1GLWMftkhHoxY4hZqY
	 UFfTBhV1hGK02mp/MJwrKEB7s7PDmgTOo37hnMSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Li Huafei <lihuafei1@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 046/127] topology: Keep the cpumask unchanged when printing cpumap
Date: Tue, 21 Jan 2025 18:51:58 +0100
Message-ID: <20250121174531.450853675@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Huafei <lihuafei1@huawei.com>

commit cbd399f78e23ad4492c174fc5e6b3676dba74a52 upstream.

During fuzz testing, the following warning was discovered:

 different return values (15 and 11) from vsnprintf("%*pbl
 ", ...)

 test:keyward is WARNING in kvasprintf
 WARNING: CPU: 55 PID: 1168477 at lib/kasprintf.c:30 kvasprintf+0x121/0x130
 Call Trace:
  kvasprintf+0x121/0x130
  kasprintf+0xa6/0xe0
  bitmap_print_to_buf+0x89/0x100
  core_siblings_list_read+0x7e/0xb0
  kernfs_file_read_iter+0x15b/0x270
  new_sync_read+0x153/0x260
  vfs_read+0x215/0x290
  ksys_read+0xb9/0x160
  do_syscall_64+0x56/0x100
  entry_SYSCALL_64_after_hwframe+0x78/0xe2

The call trace shows that kvasprintf() reported this warning during the
printing of core_siblings_list. kvasprintf() has several steps:

 (1) First, calculate the length of the resulting formatted string.

 (2) Allocate a buffer based on the returned length.

 (3) Then, perform the actual string formatting.

 (4) Check whether the lengths of the formatted strings returned in
     steps (1) and (2) are consistent.

If the core_cpumask is modified between steps (1) and (3), the lengths
obtained in these two steps may not match. Indeed our test includes cpu
hotplugging, which should modify core_cpumask while printing.

To fix this issue, cache the cpumask into a temporary variable before
calling cpumap_print_{list, cpumask}_to_buf(), to keep it unchanged
during the printing process.

Fixes: bb9ec13d156e ("topology: use bin_attribute to break the size limitation of cpumap ABI")
Cc: stable <stable@kernel.org>
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20241114110141.94725-1-lihuafei1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/topology.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -27,9 +27,17 @@ static ssize_t name##_read(struct file *
 			   loff_t off, size_t count)				\
 {										\
 	struct device *dev = kobj_to_dev(kobj);                                 \
+	cpumask_var_t mask;							\
+	ssize_t n;								\
 										\
-	return cpumap_print_bitmask_to_buf(buf, topology_##mask(dev->id),	\
-					   off, count);                         \
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))				\
+		return -ENOMEM;							\
+										\
+	cpumask_copy(mask, topology_##mask(dev->id));				\
+	n = cpumap_print_bitmask_to_buf(buf, mask, off, count);			\
+	free_cpumask_var(mask);							\
+										\
+	return n;								\
 }										\
 										\
 static ssize_t name##_list_read(struct file *file, struct kobject *kobj,	\
@@ -37,9 +45,17 @@ static ssize_t name##_list_read(struct f
 				loff_t off, size_t count)			\
 {										\
 	struct device *dev = kobj_to_dev(kobj);					\
+	cpumask_var_t mask;							\
+	ssize_t n;								\
+										\
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))				\
+		return -ENOMEM;							\
+										\
+	cpumask_copy(mask, topology_##mask(dev->id));				\
+	n = cpumap_print_list_to_buf(buf, mask, off, count);			\
+	free_cpumask_var(mask);							\
 										\
-	return cpumap_print_list_to_buf(buf, topology_##mask(dev->id),		\
-					off, count);				\
+	return n;								\
 }
 
 define_id_show_func(physical_package_id);


