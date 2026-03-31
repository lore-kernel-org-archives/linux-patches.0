Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB223E92A5;
	Tue, 31 Mar 2026 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974441; cv=none; b=dV3qLBF5ub+tX1MzAmxkXudijyY8F2svN0Xe9l1yOjRKIRp5cDFWRiMhCS+YlXDvTAa0GiSwSNCu58VIHuebB44J/XERDLXeG+o1f+/3v9CwFUfWIsKlmGXqhNzAd9fgd8ri/D1TthguKrXUOv0/M0spGSp+aluSElVQxfBNOLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974441; c=relaxed/simple;
	bh=0yZnLFGBphip3i05T49U8nFDpwbWU2j6hodo1gKofqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOaJDq+k6rWjjwgeg8LXlAQTdFoBdf/UrnuhUFlRRlzQfZSVxUoxusyA0IHxGWsNPVEiWmmUnPSm5QG46IFDyWTCsq5R3L+UJZtc12ZjZfSFgQVU/tFYgJJFRnDcNUY18vd9W8E5kwHOAhtr1zUQ4V8A3zLM0SYPlVPGxEskRfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvQhCsIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvQhCsIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126DEC19423;
	Tue, 31 Mar 2026 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974441;
	bh=0yZnLFGBphip3i05T49U8nFDpwbWU2j6hodo1gKofqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvQhCsIKvZKZ1pC+mpuIrzwxndftZ87ZoxAdn3uJRgC4cn+nxSl3W/mLpkEpBn8uA
	 fprQQcqrrCIu1QgkHXK14ZLQLoOPw8MPuMTgkggjPGXILBHvoVKYoxOW/ydPQgMU8K
	 UDFvWv7krg+5MNz7K7oQLn3Q57qO2/0Af5kdAn00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Kees Cook <keescook@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/175] PM: hibernate: Dont ignore return from set_memory_ro()
Date: Tue, 31 Mar 2026 18:21:11 +0200
Message-ID: <20260331161732.967725777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit f4311756a83fb01c28a9bf841cbb7eb2b318eebf ]

set_memory_ro() and set_memory_rw() can fail, leaving memory
unprotected.

Take the returned value into account and abort in case of
failure.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 734eba62cd32 ("PM: hibernate: Drain trailing zero pages on userspace restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/power.h    |  2 +-
 kernel/power/snapshot.c | 25 ++++++++++++++++---------
 kernel/power/swap.c     |  8 ++++----
 kernel/power/user.c     |  4 +++-
 4 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 62a7cb452a4be..3ea663f1ad1e2 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -152,7 +152,7 @@ extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
 extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
-extern void snapshot_write_finalize(struct snapshot_handle *handle);
+int snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
 extern bool hibernate_acquire(void);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 50a15408c3fca..ea52417375a4e 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -58,22 +58,24 @@ static inline void hibernate_restore_protection_end(void)
 	hibernate_restore_protection_active = false;
 }
 
-static inline void hibernate_restore_protect_page(void *page_address)
+static inline int __must_check hibernate_restore_protect_page(void *page_address)
 {
 	if (hibernate_restore_protection_active)
-		set_memory_ro((unsigned long)page_address, 1);
+		return set_memory_ro((unsigned long)page_address, 1);
+	return 0;
 }
 
-static inline void hibernate_restore_unprotect_page(void *page_address)
+static inline int hibernate_restore_unprotect_page(void *page_address)
 {
 	if (hibernate_restore_protection_active)
-		set_memory_rw((unsigned long)page_address, 1);
+		return set_memory_rw((unsigned long)page_address, 1);
+	return 0;
 }
 #else
 static inline void hibernate_restore_protection_begin(void) {}
 static inline void hibernate_restore_protection_end(void) {}
-static inline void hibernate_restore_protect_page(void *page_address) {}
-static inline void hibernate_restore_unprotect_page(void *page_address) {}
+static inline int __must_check hibernate_restore_protect_page(void *page_address) {return 0; }
+static inline int hibernate_restore_unprotect_page(void *page_address) {return 0; }
 #endif /* CONFIG_STRICT_KERNEL_RWX  && CONFIG_ARCH_HAS_SET_MEMORY */
 
 
@@ -2832,7 +2834,9 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		}
 	} else {
 		copy_last_highmem_page();
-		hibernate_restore_protect_page(handle->buffer);
+		error = hibernate_restore_protect_page(handle->buffer);
+		if (error)
+			return error;
 		handle->buffer = get_buffer(&orig_bm, &ca);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
@@ -2858,15 +2862,18 @@ int snapshot_write_next(struct snapshot_handle *handle)
  * stored in highmem.  Additionally, it recycles bitmap memory that's not
  * necessary any more.
  */
-void snapshot_write_finalize(struct snapshot_handle *handle)
+int snapshot_write_finalize(struct snapshot_handle *handle)
 {
+	int error;
+
 	copy_last_highmem_page();
-	hibernate_restore_protect_page(handle->buffer);
+	error = hibernate_restore_protect_page(handle->buffer);
 	/* Do that only if we have loaded the image entirely */
 	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages + nr_zero_pages) {
 		memory_bm_recycle(&orig_bm);
 		free_highmem_data();
 	}
+	return error;
 }
 
 int snapshot_image_loaded(struct snapshot_handle *handle)
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index d71c590550d28..8c162e18e1645 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1099,8 +1099,8 @@ static int load_image(struct swap_map_handle *handle,
 		ret = err2;
 	if (!ret) {
 		pr_info("Image loading done\n");
-		snapshot_write_finalize(snapshot);
-		if (!snapshot_image_loaded(snapshot))
+		ret = snapshot_write_finalize(snapshot);
+		if (!ret && !snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
 	}
 	swsusp_show_speed(start, stop, nr_to_read, "Read");
@@ -1440,8 +1440,8 @@ static int load_image_lzo(struct swap_map_handle *handle,
 	stop = ktime_get();
 	if (!ret) {
 		pr_info("Image loading done\n");
-		snapshot_write_finalize(snapshot);
-		if (!snapshot_image_loaded(snapshot))
+		ret = snapshot_write_finalize(snapshot);
+		if (!ret && !snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
 		if (!ret) {
 			if (swsusp_header->flags & SF_CRC32_MODE) {
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 3a4e70366f354..3aa41ba22129d 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -317,7 +317,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_ATOMIC_RESTORE:
-		snapshot_write_finalize(&data->handle);
+		error = snapshot_write_finalize(&data->handle);
+		if (error)
+			break;
 		if (data->mode != O_WRONLY || !data->frozen ||
 		    !snapshot_image_loaded(&data->handle)) {
 			error = -EPERM;
-- 
2.53.0



