Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA951E909B;
	Wed,  6 Nov 2024 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897007; cv=none; b=m5frbaZMhLFZdLiMnQNBY44Pv24fpPrrNm6ofGx7doQSZm1/CJqFZJwc160HnOjSD/uTqA/FjqZUITxe9d3QYC8TAJdKIa2fqw3KZZIFGkAEt/+3sWcscudxj54AFoUncVmtunk2B+ahCIxxwEf+wBPzAiD6gYuYHS+mFh5U5Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897007; c=relaxed/simple;
	bh=fTdNdLUKtvyJUG9nKbmIPUghjs1Q8Zzp9j+CrkL1N50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APFKhVy5aA+c58sQ9ot4jZCV1qCHDWL19UH3QEm3NEeKw1Jea5Z0FIhj2OC16r5ZbDMymlRh14xhVSEroWpU0T2CAK6e2QSOrS0jJNUOiORWiqLZxP0vTD7OOZ0Yi6bCDTq+kdODIDV6bwFQK5revhClU1dQp1+ZSsngQArmBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j19miaAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j19miaAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A27C4CECD;
	Wed,  6 Nov 2024 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897007;
	bh=fTdNdLUKtvyJUG9nKbmIPUghjs1Q8Zzp9j+CrkL1N50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j19miaAJhklrW9k6lJpMW4RakNtg3yzSt7+fE+Z17FOo5lDd9IR/LpQv//rcj0AdH
	 RenWMw9//a02fN+Y8Hl78p5MH0xS62aD2jQfDQdPE0WZ9r/Zu5RIUal3t5LRiCrvwV
	 /w8glIa7JkvqQ1PVuFeulrUquD0gsv1OrfNjY8kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Jiri Olsa <jolsa@kernel.org>,
	Liu Shixin <liushixin2@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/126] fs/proc/kcore: convert read_kcore() to read_kcore_iter()
Date: Wed,  6 Nov 2024 13:03:27 +0100
Message-ID: <20241106120306.235846553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 46c0d6d0904a10785faabee53fe53ee1aa718fea ]

For the time being we still use a bounce buffer for vread(), however in
the next patch we will convert this to interact directly with the iterator
and eliminate the bounce buffer altogether.

Link: https://lkml.kernel.org/r/ebe12c8d70eebd71f487d80095605f3ad0d1489c.1679511146.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/kcore.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 786e5e90f670c..2aff567abe1e3 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -25,7 +25,7 @@
 #include <linux/memblock.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <asm/io.h>
 #include <linux/list.h>
 #include <linux/ioport.h>
@@ -309,9 +309,12 @@ static void append_kcore_note(char *notes, size_t *i, const char *name,
 }
 
 static ssize_t
-read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
+read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
+	struct file *file = iocb->ki_filp;
 	char *buf = file->private_data;
+	loff_t *fpos = &iocb->ki_pos;
+
 	size_t phdrs_offset, notes_offset, data_offset;
 	size_t page_offline_frozen = 1;
 	size_t phdrs_len, notes_len;
@@ -319,6 +322,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 	size_t tsz;
 	int nphdr;
 	unsigned long start;
+	size_t buflen = iov_iter_count(iter);
 	size_t orig_buflen = buflen;
 	int ret = 0;
 
@@ -357,12 +361,11 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		};
 
 		tsz = min_t(size_t, buflen, sizeof(struct elfhdr) - *fpos);
-		if (copy_to_user(buffer, (char *)&ehdr + *fpos, tsz)) {
+		if (copy_to_iter((char *)&ehdr + *fpos, tsz, iter) != tsz) {
 			ret = -EFAULT;
 			goto out;
 		}
 
-		buffer += tsz;
 		buflen -= tsz;
 		*fpos += tsz;
 	}
@@ -399,15 +402,14 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		}
 
 		tsz = min_t(size_t, buflen, phdrs_offset + phdrs_len - *fpos);
-		if (copy_to_user(buffer, (char *)phdrs + *fpos - phdrs_offset,
-				 tsz)) {
+		if (copy_to_iter((char *)phdrs + *fpos - phdrs_offset, tsz,
+				 iter) != tsz) {
 			kfree(phdrs);
 			ret = -EFAULT;
 			goto out;
 		}
 		kfree(phdrs);
 
-		buffer += tsz;
 		buflen -= tsz;
 		*fpos += tsz;
 	}
@@ -449,14 +451,13 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 				  min(vmcoreinfo_size, notes_len - i));
 
 		tsz = min_t(size_t, buflen, notes_offset + notes_len - *fpos);
-		if (copy_to_user(buffer, notes + *fpos - notes_offset, tsz)) {
+		if (copy_to_iter(notes + *fpos - notes_offset, tsz, iter) != tsz) {
 			kfree(notes);
 			ret = -EFAULT;
 			goto out;
 		}
 		kfree(notes);
 
-		buffer += tsz;
 		buflen -= tsz;
 		*fpos += tsz;
 	}
@@ -498,7 +499,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		}
 
 		if (!m) {
-			if (clear_user(buffer, tsz)) {
+			if (iov_iter_zero(tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
@@ -509,14 +510,14 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		case KCORE_VMALLOC:
 			vread(buf, (char *)start, tsz);
 			/* we have to zero-fill user buffer even if no read */
-			if (copy_to_user(buffer, buf, tsz)) {
+			if (copy_to_iter(buf, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
 			break;
 		case KCORE_USER:
 			/* User page is handled prior to normal kernel page: */
-			if (copy_to_user(buffer, (char *)start, tsz)) {
+			if (copy_to_iter((char *)start, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
@@ -532,7 +533,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 			 */
 			if (!page || PageOffline(page) ||
 			    is_page_hwpoison(page) || !pfn_is_ram(pfn)) {
-				if (clear_user(buffer, tsz)) {
+				if (iov_iter_zero(tsz, iter) != tsz) {
 					ret = -EFAULT;
 					goto out;
 				}
@@ -542,17 +543,17 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
 			/*
-			 * We use _copy_to_user() to bypass usermode hardening
+			 * We use _copy_to_iter() to bypass usermode hardening
 			 * which would otherwise prevent this operation.
 			 */
-			if (_copy_to_user(buffer, (char *)start, tsz)) {
+			if (_copy_to_iter((char *)start, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
 			break;
 		default:
 			pr_warn_once("Unhandled KCORE type: %d\n", m->type);
-			if (clear_user(buffer, tsz)) {
+			if (iov_iter_zero(tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
@@ -560,7 +561,6 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 skip:
 		buflen -= tsz;
 		*fpos += tsz;
-		buffer += tsz;
 		start += tsz;
 		tsz = (buflen > PAGE_SIZE ? PAGE_SIZE : buflen);
 	}
@@ -604,7 +604,7 @@ static int release_kcore(struct inode *inode, struct file *file)
 }
 
 static const struct proc_ops kcore_proc_ops = {
-	.proc_read	= read_kcore,
+	.proc_read_iter	= read_kcore_iter,
 	.proc_open	= open_kcore,
 	.proc_release	= release_kcore,
 	.proc_lseek	= default_llseek,
-- 
2.43.0



