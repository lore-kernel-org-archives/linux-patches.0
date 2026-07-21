Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C3A3B8950;
	Tue, 21 Jul 2026 21:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668615; cv=none; b=tAryps4tlMqvAtLZZKbLmeuxKKPve8JDJQSbo5ZpWozXrANSzTpKZLtFVv0QBiZQwxnIjHjD7065WIIdi/z2DCwPH8ybJkhAhpbTiPHxTJ6/VvgmtCJO56n72JNsU4zbOPiFoLivDd3XRbPwjNTNhO70p8PI6Mn0igKri28hk6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668615; c=relaxed/simple;
	bh=TP5VHKOT7/g0P3Hp9J3GPThtKbnypGAaAB7k27P6ME8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUExMESnARUX8/xXRx53sizakTclXsRhHceFWBTl1gyFrd6HBt9d4RbkYcg3BDVURyZme1XPFqh8dZcNpmLW+KDfnpIahcrylgQ0wDUrE6SBU0AEBsMDYZj0JdZyajvxlfXilLVO/a4XENhfRAJVmn9451EeSXq/18uG7W96Mdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaGXcXn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaGXcXn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4176A1F000E9;
	Tue, 21 Jul 2026 21:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668612;
	bh=Unlf2LD08foS3GPPnBdwIQ7UvYMmU2KWqrumEHWnVkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yaGXcXn3TDmf9qD0vZu3ULgq0qfX3S/kdqRwrGEr50trFw5oV+LcZTNbNoN0lQ25f
	 ae1UcKjNCG9d3spGl0rVgOZ6ORw54AWXUfm8xnwpseoL0W323/IVuddGi8ed0CS4Q9
	 1yl109pmKVn9XT2d13z0Nu+veFQbSy/NBsSMAnag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anisse Astier <an.astier@criteo.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0198/1067] efivarfs: expose used and total size
Date: Tue, 21 Jul 2026 17:13:19 +0200
Message-ID: <20260721152429.021691037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Anisse Astier <an.astier@criteo.com>

[ Upstream commit d86ff3333cb1d5f42d8898fb5fdb304e143c0237 ]

When writing EFI variables, one might get errors with no other message
on why it fails. Being able to see how much is used by EFI variables
helps analyzing such issues.

Since this is not a conventional filesystem, block size is intentionally
set to 1 instead of PAGE_SIZE.

x86 quirks of reserved size are taken into account; so that available
and free size can be different, further helping debugging space issues.

With this patch, one can see the remaining space in EFI variable storage
via efivarfs, like this:

   $ df -h /sys/firmware/efi/efivars/
   Filesystem      Size  Used Avail Use% Mounted on
   efivarfs        176K  106K   66K  62% /sys/firmware/efi/efivars

Signed-off-by: Anisse Astier <an.astier@criteo.com>
[ardb: - rename efi_reserved_space() to efivar_reserved_space()
       - whitespace/coding style tweaks]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Adjusted for headers in linux-6.1.y
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/quirks.c |  8 +++++++
 drivers/firmware/efi/efi.c     |  1 +
 drivers/firmware/efi/vars.c    | 12 +++++++++++
 fs/efivarfs/super.c            | 39 +++++++++++++++++++++++++++++++++-
 include/linux/efi.h            | 11 ++++++++++
 5 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index b0d0376940ba8b..a29efaf6fe411e 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -114,6 +114,14 @@ void efi_delete_dummy_variable(void)
 				     EFI_VARIABLE_RUNTIME_ACCESS, 0, NULL);
 }
 
+u64 efivar_reserved_space(void)
+{
+	if (efi_no_storage_paranoia)
+		return 0;
+	return EFI_MIN_RESERVE;
+}
+EXPORT_SYMBOL_GPL(efivar_reserved_space);
+
 /*
  * In the nonblocking case we do not attempt to perform garbage
  * collection if we do not have enough free space. Rather, we do the
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9786dfff9f840f..83b63dd2de9be3 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -211,6 +211,7 @@ static int generic_ops_register(void)
 	generic_ops.get_variable = efi.get_variable;
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_store = efi_query_variable_store;
+	generic_ops.query_variable_info = efi.query_variable_info;
 
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE)) {
 		generic_ops.set_variable = efi.set_variable;
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 4ca256bcd69715..d22160e7c7851b 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -250,3 +250,15 @@ efi_status_t efivar_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 	return status;
 }
 EXPORT_SYMBOL_NS_GPL(efivar_set_variable, EFIVAR);
+
+efi_status_t efivar_query_variable_info(u32 attr,
+					u64 *storage_space,
+					u64 *remaining_space,
+					u64 *max_variable_size)
+{
+	if (!__efivars->ops->query_variable_info)
+		return EFI_UNSUPPORTED;
+	return __efivars->ops->query_variable_info(attr, storage_space,
+			remaining_space, max_variable_size);
+}
+EXPORT_SYMBOL_NS_GPL(efivar_query_variable_info, EFIVAR);
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 9025430cf2ad35..3fbced52fc6bb8 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/magic.h>
 #include <linux/printk.h>
+#include <linux/statfs.h>
 
 #include "internal.h"
 
@@ -24,8 +25,44 @@ static void efivarfs_evict_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
+static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS;
+	u64 storage_space, remaining_space, max_variable_size;
+	efi_status_t status;
+
+	status = efivar_query_variable_info(attr, &storage_space, &remaining_space,
+					    &max_variable_size);
+	if (status != EFI_SUCCESS)
+		return efi_status_to_err(status);
+
+	/*
+	 * This is not a normal filesystem, so no point in pretending it has a block
+	 * size; we declare f_bsize to 1, so that we can then report the exact value
+	 * sent by EFI QueryVariableInfo in f_blocks and f_bfree
+	 */
+	buf->f_bsize	= 1;
+	buf->f_namelen	= NAME_MAX;
+	buf->f_blocks	= storage_space;
+	buf->f_bfree	= remaining_space;
+	buf->f_type	= dentry->d_sb->s_magic;
+
+	/*
+	 * In f_bavail we declare the free space that the kernel will allow writing
+	 * when the storage_paranoia x86 quirk is active. To use more, users
+	 * should boot the kernel with efi_no_storage_paranoia.
+	 */
+	if (remaining_space > efivar_reserved_space())
+		buf->f_bavail = remaining_space - efivar_reserved_space();
+	else
+		buf->f_bavail = 0;
+
+	return 0;
+}
 static const struct super_operations efivarfs_ops = {
-	.statfs = simple_statfs,
+	.statfs = efivarfs_statfs,
 	.drop_inode = generic_delete_inode,
 	.evict_inode = efivarfs_evict_inode,
 };
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1d73c77051c09b..5868c4b2933261 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1039,6 +1039,7 @@ struct efivar_operations {
 	efi_set_variable_t *set_variable;
 	efi_set_variable_t *set_variable_nonblocking;
 	efi_query_variable_store_t *query_variable_store;
+	efi_query_variable_info_t *query_variable_info;
 };
 
 struct efivars {
@@ -1047,6 +1048,12 @@ struct efivars {
 	const struct efivar_operations *ops;
 };
 
+#ifdef CONFIG_X86
+u64 __attribute_const__ efivar_reserved_space(void);
+#else
+static inline u64 efivar_reserved_space(void) { return 0; }
+#endif
+
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -1081,6 +1088,10 @@ efi_status_t efivar_set_variable_locked(efi_char16_t *name, efi_guid_t *vendor,
 efi_status_t efivar_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 				 u32 attr, unsigned long data_size, void *data);
 
+efi_status_t efivar_query_variable_info(u32 attr, u64 *storage_space,
+					u64 *remaining_space,
+					u64 *max_variable_size);
+
 #if IS_ENABLED(CONFIG_EFI_CAPSULE_LOADER)
 extern bool efi_capsule_pending(int *reset_type);
 
-- 
2.53.0



