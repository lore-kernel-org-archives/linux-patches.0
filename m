Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3933B3BE7;
	Thu, 17 Sep 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665413; cv=none; b=kQFNGR2pbWvXrFUMK1Pkzyid/83svk6mYxgtOMwWTsPbApmXy34LZxDwfaEH3fmVT/QfljJuXHSHfyMFwNS3xtelXkRPDV/12QrA15Hrs64Dg7eA3wTOowVh4ctq7gphj+JjSd0DauaqcluziLJmDlMNUFFW0Khqk4C2tABBc8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665413; c=relaxed/simple;
	bh=d53NTdgP8Vgvy+Zh2AB0b1ZPjdNQZr+y9KeYsbIeUDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7Y/e3Vf/EpjcA7iX2G5NA3NUy5XwxTOl6TXWsA0AICSRfhS4Ty2vLVDaDoX9tOcDKPYbQeMaxO+kygU38BZ1e0QWNsoAgckTB5D/yb36ugfDV06Sy7O5yqehuwwTNPniFtnrB34J90L7/RSJOX63UFweMrFhUXvPaE8AwN8Y5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDoHA4x0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDoHA4x0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2511F000FF;
	Thu, 17 Sep 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665412;
	bh=L0CR9Q+/DXgaCThwjePr5TFMkt8V2V3DahhYa4E8uH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDoHA4x0tDvQV84HaWHexJm4PpTOrFPGMFraM8mEHkE1yRetwfNKZJFlRKknqPfBE
	 PA02NXT86TJaERnE98pfdtOYWj8PiMRR4QAoPO/brPqB0Aia08miGcNjxgDdVktwV+
	 keg21xcC3OgB5J+ABur0evqgpnBov57gC5Vr93wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0647/1250] cachefiles: Fix potential UAF/KASAN warning
Date: Thu, 17 Sep 2026 16:07:22 +0100
Message-ID: <20260917151609.432398905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit a67632c8c2688d6e0091529bcefe54bc5ee80e9b ]

Currently, trace_cachefiles_coherency() is being passed a pointer to a
__be64 lain over the coherency data in struct cachefiles_xattr so that it
can display the first 8 bytes.  However, the data is of variable length and
could even be 0 bytes.  This could lead to a UAF or KASAN warning.

Fix this by making sure the buffer has room for at least 8 bytes and that
those 8 bytes are pre-cleared.

Further, those bytes are not 8-byte aligned, so fix the tracepoint to
extract the data as four 2-byte words (they are 2-byte aligned) and
reassemble the __be64.  The compiler will convert this into a single 8-byte
load where the CPU supports it.

Fixes: 229105e5cfd9 ("cachefiles: Add auxiliary data trace")
Link: https://sashiko.dev/#/patchset/20260810144746.574036-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-11-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/xattr.c             | 16 ++++++++--------
 include/trace/events/cachefiles.h | 19 +++++++++++++++++--
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 52383b1d0ba63..6214331821583 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -13,6 +13,7 @@
 #include <linux/quotaops.h>
 #include <linux/xattr.h>
 #include <linux/slab.h>
+#include <linux/unaligned.h>
 #include "internal.h"
 
 #define CACHEFILES_COOKIE_TYPE_DATA 1
@@ -50,7 +51,7 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 
 	_enter("%x,#%d", object->debug_id, len);
 
-	buf = kmalloc(sizeof(struct cachefiles_xattr) + len, GFP_KERNEL);
+	buf = kmalloc(sizeof(struct cachefiles_xattr) + max(len, sizeof(__be64)), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -60,6 +61,7 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 	buf->content		= object->content_info;
 	if (test_bit(FSCACHE_COOKIE_LOCAL_WRITE, &object->cookie->flags))
 		buf->content	= CACHEFILES_CONTENT_DIRTY;
+	put_unaligned_be64(0, (__be64 *)buf->data);
 	if (len > 0)
 		memcpy(buf->data, fscache_get_aux(object->cookie), len);
 
@@ -77,8 +79,7 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 		trace_cachefiles_vfs_error(object, file_inode(file), ret,
 					   cachefiles_trace_setxattr_error);
 		trace_cachefiles_coherency(object, file_inode(file)->i_ino,
-					   be64_to_cpup((__be64 *)buf->data),
-					   buf->content,
+					   buf->data, buf->content,
 					   cachefiles_coherency_set_fail);
 		if (ret != -ENOMEM)
 			cachefiles_io_error_obj(
@@ -86,8 +87,7 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 				"Failed to set xattr with error %d", ret);
 	} else {
 		trace_cachefiles_coherency(object, file_inode(file)->i_ino,
-					   be64_to_cpup((__be64 *)buf->data),
-					   buf->content,
+					   buf->data, buf->content,
 					   cachefiles_coherency_set_ok);
 	}
 
@@ -110,9 +110,10 @@ int cachefiles_check_auxdata(struct cachefiles_object *object, struct file *file
 	int ret = -ESTALE;
 
 	tlen = sizeof(struct cachefiles_xattr) + len;
-	buf = kmalloc(tlen, GFP_KERNEL);
+	buf = kmalloc(sizeof(struct cachefiles_xattr) + max(len, sizeof(__be64)), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
+	put_unaligned_be64(0, (__be64 *)buf->data);
 
 	xlen = cachefiles_inject_read_error();
 	if (xlen == 0)
@@ -148,8 +149,7 @@ int cachefiles_check_auxdata(struct cachefiles_object *object, struct file *file
 
 out:
 	trace_cachefiles_coherency(object, file_inode(file)->i_ino,
-				   be64_to_cpup((__be64 *)buf->data),
-				   buf->content, why);
+				   buf->data, buf->content, why);
 	kfree(buf);
 	return ret;
 }
diff --git a/include/trace/events/cachefiles.h b/include/trace/events/cachefiles.h
index a743b2a35ea70..3ca9be3a21c56 100644
--- a/include/trace/events/cachefiles.h
+++ b/include/trace/events/cachefiles.h
@@ -380,7 +380,7 @@ TRACE_EVENT(cachefiles_rename,
 TRACE_EVENT(cachefiles_coherency,
 	    TP_PROTO(struct cachefiles_object *obj,
 		     ino_t ino,
-		     u64 disk_aux,
+		     const void *disk_aux,
 		     enum cachefiles_content content,
 		     enum cachefiles_coherency_trace why),
 
@@ -397,12 +397,27 @@ TRACE_EVENT(cachefiles_coherency,
 			     ),
 
 	    TP_fast_assign(
+		    union {
+			    __be16 s[4];
+			    __be64 ll;
+		    } x;
+
 		    __entry->obj	= obj->debug_id;
 		    __entry->why	= why;
 		    __entry->content	= content;
 		    __entry->ino	= ino;
 		    __entry->aux	= be64_to_cpup((__be64 *)obj->cookie->inline_aux);
-		    __entry->disk_aux	= disk_aux;
+
+		    /* cachefiles_xattr::data is 2-byte aligned but not 8-byte aligned. */
+		    if (disk_aux) {
+			    x.s[0] = ((__be16 *)disk_aux)[0];
+			    x.s[1] = ((__be16 *)disk_aux)[1];
+			    x.s[2] = ((__be16 *)disk_aux)[2];
+			    x.s[3] = ((__be16 *)disk_aux)[3];
+			    __entry->disk_aux = be64_to_cpu(x.ll);
+		    } else {
+			    __entry->disk_aux = 0;
+		    }
 			   ),
 
 	    TP_printk("o=%08x %s B=%llx c=%u aux=%llx dsk=%llx",
-- 
2.53.0



