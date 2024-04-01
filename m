Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1510F4AED1;
	Mon,  1 Apr 2024 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990446; cv=none; b=guYWtLmhWZFY3jQrlp1y89FetV7L7oo5Swxo3HObeAftiSYY0GrhIub6xwL4oWxLLAMrN/CK4Cbfo9ovzoVJyj2u5hd8y2DYitYbjJ8j5XhaZ3H+iVlRXAcTGuAGwFluJyVTvJihUJphVfyHRuGV1muzFW0kRSTdbCsNY2hlLPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990446; c=relaxed/simple;
	bh=zZLLpoh3Mp5DBSP21QAuhsu3xvCTL9DifPlXi3omk/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxPrRGX9br5zCA6f2ET5pjyHdYwtBuqMKm6To615kOKW+FCyTx4H7TfJbfIvoxP2PKVU//6D4idjAywDTmj3f35nHiLNwNnMlQoGHWgocZtjESLOYyWmozkS5MTzXEB0SKJBBLzG3EEoUwqbnC2Fn7lpbJ39hb0g2Taqur5DuVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXWej3qP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXWej3qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAE3C433C7;
	Mon,  1 Apr 2024 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990446;
	bh=zZLLpoh3Mp5DBSP21QAuhsu3xvCTL9DifPlXi3omk/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXWej3qPNKWVqZHXJdEMjsGYVmLoKc6IK9oV4/oKX7HOJrTNQFTOYIJ99FIFvEiwe
	 aErBi+w+ZC02GnA+jprwLuQCJki522qh6u6TDeZEyCukyDE4nDouAV4lG3rP4BeR7M
	 ORzbCOfokISxNMYajCHtmuuzHGJf0lVNLBs+TE2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 355/396] vfio/pds: Make sure migration file isnt accessed after reset
Date: Mon,  1 Apr 2024 17:46:44 +0200
Message-ID: <20240401152558.507154528@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 457f7308254756b6e4b8fc3876cb770dcf0e7cc7 ]

It's possible the migration file is accessed after reset when it has
been cleaned up, especially when it's initiated by the device. This is
because the driver doesn't rip out the filep when cleaning up it only
frees the related page structures and sets its local struct
pds_vfio_lm_file pointer to NULL. This can cause a NULL pointer
dereference, which is shown in the example below during a restore after
a device initiated reset:

BUG: kernel NULL pointer dereference, address: 000000000000000c
PF: supervisor read access in kernel mode
PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:pds_vfio_get_file_page+0x5d/0xf0 [pds_vfio_pci]
[...]
Call Trace:
 <TASK>
 pds_vfio_restore_write+0xf6/0x160 [pds_vfio_pci]
 vfs_write+0xc9/0x3f0
 ? __fget_light+0xc9/0x110
 ksys_write+0xb5/0xf0
 __x64_sys_write+0x1a/0x20
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
[...]

Add a disabled flag to the driver's struct pds_vfio_lm_file that gets
set during cleanup. Then make sure to check the flag when the migration
file is accessed via its file_operations. By default this flag will be
false as the memory for struct pds_vfio_lm_file is kzalloc'd, which means
the struct pds_vfio_lm_file is enabled and accessible. Also, since the
file_operations and driver's migration file cleanup happen under the
protection of the same pds_vfio_lm_file.lock, using this flag is thread
safe.

Fixes: 8512ed256334 ("vfio/pds: Always clear the save/restore FDs on reset")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Link: https://lore.kernel.org/r/20240308182149.22036-2-brett.creeley@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/lm.c | 13 +++++++++++++
 drivers/vfio/pci/pds/lm.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index 79fe2e66bb498..6b94cc0bf45b4 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -92,8 +92,10 @@ static void pds_vfio_put_lm_file(struct pds_vfio_lm_file *lm_file)
 {
 	mutex_lock(&lm_file->lock);
 
+	lm_file->disabled = true;
 	lm_file->size = 0;
 	lm_file->alloc_size = 0;
+	lm_file->filep->f_pos = 0;
 
 	/* Free scatter list of file pages */
 	sg_free_table(&lm_file->sg_table);
@@ -183,6 +185,12 @@ static ssize_t pds_vfio_save_read(struct file *filp, char __user *buf,
 	pos = &filp->f_pos;
 
 	mutex_lock(&lm_file->lock);
+
+	if (lm_file->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (*pos > lm_file->size) {
 		done = -EINVAL;
 		goto out_unlock;
@@ -283,6 +291,11 @@ static ssize_t pds_vfio_restore_write(struct file *filp, const char __user *buf,
 
 	mutex_lock(&lm_file->lock);
 
+	if (lm_file->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
 	while (len) {
 		size_t page_offset;
 		struct page *page;
diff --git a/drivers/vfio/pci/pds/lm.h b/drivers/vfio/pci/pds/lm.h
index 13be893198b74..9511b1afc6a11 100644
--- a/drivers/vfio/pci/pds/lm.h
+++ b/drivers/vfio/pci/pds/lm.h
@@ -27,6 +27,7 @@ struct pds_vfio_lm_file {
 	struct scatterlist *last_offset_sg;	/* Iterator */
 	unsigned int sg_last_entry;
 	unsigned long last_offset;
+	bool disabled;
 };
 
 struct pds_vfio_pci_device;
-- 
2.43.0



