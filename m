Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F8C3B71C0;
	Tue, 13 Oct 2026 12:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895398; cv=none; b=kCKSIxg9Pku/xAjM1oJGECyczGVcUzvmpw0zFfsf7OUZxz3YvZLxd9fZhi4hmEw2k4SkMBQMt7wAaYAPBiq/Cdvkdfb2dpw9lDQEqdIRw5nn4ccm+BahTaQiAlXqnUCWyB2qytmtXCRNG34eNjhZUSXEmpb4/UBb0zdRam8CSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895398; c=relaxed/simple;
	bh=Otq5usbpjA3dcFwhUixJtpvgPUgkDugwL3ai482AtU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMKIZ6OXpF4C+Rs6N6FwB4AhzHNLPP/67dwgtZOHTKIff0ewZ2eYHsyI+V+Kvxh2pNJ4A3v0et+8WQUMKDzrgT7gqgWPaWzYhknbw9eoHKkvHQjAZq7Gv7UFn2WN9kE7uhtw9iayO82bjngKIbiJR+zGHfV4qDSw95kdoU6lZlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuVIGVI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuVIGVI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695351F000FF;
	Tue, 13 Oct 2026 12:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895397;
	bh=zd6Fr6nt+DvUAVC9MHQdi/yvRtnyCFMn5fBMdMVcCC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuVIGVI3M/bjigd+UWfeVHWxjGCMT64GjskzPDqIySrz4HO32pTenrmsT+QugtSyj
	 tYHaAphOrk6Q05eDcnlBCHYTPX+OdeXk4b6IVR4kSocf+iNSLPah75q9ZAtrH7xDNm
	 glb+AuH0B4bQSQCKlJFaSWG4IM24IOKyr7Id+d4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/497] tty/vt: use guard()s
Date: Tue, 13 Oct 2026 13:37:07 +0200
Message-ID: <20261013112914.061793232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit e730c373b6ff16a177e132859bf6ea4dbb15105f ]

Having all the new guards, use them in the vt code. This improves
readability, makes error handling easier, and marks locked portions of
code explicit.

A local free_page_ptr __free guard is introduced for
__get_free_page/free_page (with proper casts). This could be made public
in include/. But I am not sure if there are more possible users, so
keeping completely private here.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250814072456.182853-16-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Use scope-based console locking and buffer cleanup in vcs_write() so
error paths can return directly while releasing both resources.

Limit the conversion to the function needed by the follow-up console
pointer reload fix. Omit the other guard conversions, including the
selection changes whose context assumes bracketed-paste support.

Allocate the page-sized copy buffer with kmalloc() and reuse the existing
kfree cleanup guard instead of introducing a new cleanup helper. Declare
the buffer before the console guard so the console is unlocked before
the buffer is freed, preserving the original cleanup order.

[ sashal: REDUCED BACKPORT of e730c373b6ff: carries 29/414 upstream
  changed lines; not carried:
  drivers/tty/vt/consolemap.c:con_set_trans_old(),
  drivers/tty/vt/consolemap.c:con_get_trans_old(),
  drivers/tty/vt/consolemap.c:con_set_trans_new(),
  drivers/tty/vt/consolemap.c:con_get_trans_new(),
  drivers/tty/vt/consolemap.c:con_clear_unimap(),
  drivers/tty/vt/selection.c:sel_loadlut(),
  drivers/tty/vt/selection.c:set_selection_kernel(),
  drivers/tty/vt/selection.c:paste_selection(), +28 more ]

Stable-dep-of: 226bd5603371 ("vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 2536635153552..a59d2006b1a99 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -591,7 +591,6 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct inode *inode = file_inode(file);
 	struct vc_data *vc;
-	char *con_buf;
 	u16 *org0, *org;
 	unsigned int written;
 	int size;
@@ -602,7 +601,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	con_buf = (char *) __get_free_page(GFP_KERNEL);
+	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -611,22 +610,18 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	/* Select the proper current console and verify
 	 * sanity of the situation under the console lock.
 	 */
-	console_lock();
+	guard(console_lock)();
 
 	attr = use_attributes(inode);
-	ret = -ENXIO;
 	vc = vcs_vc(inode, &viewed);
 	if (!vc)
-		goto unlock_out;
+		return -ENXIO;
 
 	size = vcs_size(vc, attr, false);
-	if (size < 0) {
-		ret = size;
-		goto unlock_out;
-	}
-	ret = -EINVAL;
+	if (size < 0)
+		return size;
 	if (pos < 0 || pos > size)
-		goto unlock_out;
+		return -EINVAL;
 	if (count > size - pos)
 		count = size - pos;
 	written = 0;
@@ -651,8 +646,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 				 */
 				if (written)
 					break;
-				ret = -EFAULT;
-				goto unlock_out;
+				return -EFAULT;
 			}
 		}
 
@@ -664,15 +658,13 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 		if (!vc) {
 			if (written)
 				break;
-			ret = -ENXIO;
-			goto unlock_out;
+			return -ENXIO;
 		}
 		size = vcs_size(vc, attr, false);
 		if (size < 0) {
 			if (written)
 				break;
-			ret = size;
-			goto unlock_out;
+			return size;
 		}
 		if (pos >= size)
 			break;
@@ -702,9 +694,6 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (written && vc)
 		vcs_scr_updated(vc);
 
-unlock_out:
-	console_unlock();
-	free_page((unsigned long) con_buf);
 	return ret;
 }
 
-- 
2.53.0



