Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F822391E77;
	Thu, 17 Sep 2026 19:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671631; cv=none; b=ul7kqDdVf1MWPrwtSu5O2/F1jIb0R2qDwLv8JQnVnFwXWh5C+HIfHmyNck2P8C1lo7gYSjmMYgBZiFMSJp7rNFE7BKpQwQ3f9zwRMoGObCNVydGqQonJmjEm3DDJGm1LH5gsZ4vyr++oQtesLSZxoP41NEj1Bbxl/Rd36uNdmMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671631; c=relaxed/simple;
	bh=v8alhOw8VZkPWEkWIVJMrS9vpsitUpECyVV5342CqHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDnJeNG/kuEbrHoGC6lmSzYSzF0DeHlVm3aNgy6JLar6xfC34D+GaAfpbMqsk4x7SzxyLKYZ5Wdm75s/jQgbwVDQuFNuBoWpxqrGbtnEvzW0+7RJAbHAcic4Jk3OtVbMAab2yWcNn4Au0Bon+pCk6qWt1MG+RYbWwZmWRc4d5rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=161fZJB/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="161fZJB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B831F000FF;
	Thu, 17 Sep 2026 19:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671630;
	bh=LTL1miwvZg+WldOKSPKbC3eBVKHqlK/HKbm04u2+bKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=161fZJB/T70Xt4RtCltXxSiiRU5TJrxxbAhFmNK06qqS6PcvtOuNT6z33Vp6iw8gk
	 twg0zlLxAkcBNyi4yfJNKksGDy5cxdoG3hd46Hp8tuZ6rrfG7UyL+rbo6SfmMUoeSO
	 Pz9+L0C6WZ1XZf+BTDZ/bSFf4OqMSWlXdb5nFFgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1038/1102] ceph: properly decrypt filenames in vmalloc() buffers
Date: Thu, 17 Sep 2026 16:16:21 +0100
Message-ID: <20260917151606.846107582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit e939fc6a7bd969a58a150b7f188c1047138403e3 ]

The fscrypt subsystem uses the scatterlist crypto API, inheriting its
requirement that any buffers are in the linear mapping region. However,
the messenger client uses kvmalloc() to create buffers for messages,
which will occasionally place those buffers in the vmalloc() region when
physical memory fragmentation doesn't permit a large enough kmalloc().
The various callers of ceph_fname_to_usr() directly pass (slices of) raw
messages from the MDS without considering that the messages may be in
vmalloc() buffers, resulting in oopses especially on non-x86 platforms
(see 'Closes:' for more details and a reproducer).

Make ceph_fname_to_usr() explicitly tolerant of vmalloc()-allocated
fname->ctext, fname->name, and/or oname->name buffers, using `tname`
(which, when non-null, must be a linear address; when null, is briefly
allocated as necessary) as a bounce buffer to avoid passing any
inappropriate addresses to fscrypt_fname_disk_to_usr().

Additionally change parse_reply_info_readdir() -- the only function to
supply its own `tname` -- to follow the new "tname must never come from
vmalloc()" rule by passing NULL when the message is not in the linear
region. Though this causes a per-dentry kmalloc()+kfree(), this overhead
exists only when processing the minority of messages that spill into
vmalloc(). My (crude) testing puts this at only about 1 in 8,000 readdir
messages. Still, if the overhead proves unreasonable in the future, it
is easy enough to mitigate: a future change could allocate a bounce
buffer in parse_reply_info_readdir() and use that as `tname` instead.

Cc: stable@vger.kernel.org # 888d33b208bd: ceph: pass fscrypt `tname` buffers directly
Cc: stable@vger.kernel.org
Fixes: 457117f077c6 ("ceph: add helpers for converting names for userland presentation")
Closes: https://lore.kernel.org/ceph-devel/20260415034020.11530-1-CFSworks@gmail.com/
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ adapted raw tname buffer accesses to the legacy tname->name interface ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/crypto.c     |   46 +++++++++++++++++++++++++++++++++++++---------
 fs/ceph/mds_client.c |    8 ++++++--
 2 files changed, 43 insertions(+), 11 deletions(-)

--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -370,6 +370,11 @@ int ceph_encode_encrypted_fname(struct i
  * Otherwise, base64 decode the string, and then ask fscrypt to format it
  * for userland presentation.
  *
+ * Though the fscrypt/crypto subsystems broadly expect all buffers to be in the
+ * linear-mapped region, this function slightly relaxes those requirements:
+ * fname->ctext, fname->name, and oname->name may be vmalloc(), but not
+ * tname->name.
+ *
  * Returns 0 on success or negative error code on error.
  */
 int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
@@ -377,11 +382,15 @@ int ceph_fname_to_usr(const struct ceph_
 {
 	struct inode *dir = fname->dir;
 	struct fscrypt_str _tname = FSTR_INIT(NULL, 0);
+	struct fscrypt_str _oname;
 	struct fscrypt_str iname;
 	char *name = fname->name;
 	int name_len = fname->name_len;
 	int ret;
 
+	if (WARN_ON_ONCE(tname && is_vmalloc_addr(tname->name)))
+		return -EIO;
+
 	/* Sanity check that the resulting name will fit in the buffer */
 	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
 		return -EIO;
@@ -422,16 +431,19 @@ int ceph_fname_to_usr(const struct ceph_
 		goto out_inode;
 	}
 
+	if ((!tname || !tname->name) &&
+	    (fname->ctext_len == 0 ||
+	     unlikely(is_vmalloc_addr(fname->ctext)) ||
+	     unlikely(is_vmalloc_addr(oname->name)))) {
+		ret = fscrypt_fname_alloc_buffer(NAME_MAX, &_tname);
+		if (ret)
+			goto out_inode;
+		tname = &_tname;
+	}
+
 	if (fname->ctext_len == 0) {
 		int declen;
 
-		if (!tname) {
-			ret = fscrypt_fname_alloc_buffer(NAME_MAX, &_tname);
-			if (ret)
-				goto out_inode;
-			tname = &_tname;
-		}
-
 		declen = ceph_base64_decode(name, name_len, tname->name);
 		if (declen <= 0) {
 			ret = -EIO;
@@ -439,13 +451,29 @@ int ceph_fname_to_usr(const struct ceph_
 		}
 		iname.name = tname->name;
 		iname.len = declen;
+	} else if (unlikely(is_vmalloc_addr(fname->ctext))) {
+		memcpy(tname->name, fname->ctext, fname->ctext_len);
+
+		iname.name = tname->name;
+		iname.len = fname->ctext_len;
 	} else {
 		iname.name = fname->ctext;
 		iname.len = fname->ctext_len;
 	}
 
-	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
-	if (!ret && (dir != fname->dir)) {
+	_oname.name = unlikely(is_vmalloc_addr(oname->name)) ?
+			tname->name : oname->name;
+	_oname.len = oname->len;
+
+	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, &_oname);
+	if (ret)
+		goto out;
+
+	if (unlikely(is_vmalloc_addr(oname->name)))
+		memcpy(oname->name, _oname.name, _oname.len);
+	oname->len = _oname.len;
+
+	if (dir != fname->dir) {
 		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
 
 		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -496,9 +496,13 @@ static int parse_reply_info_readdir(void
 			 * to do the base64_decode in-place. It's
 			 * safe because the decoded string should
 			 * always be shorter, which is 3/4 of origin
-			 * string.
+			 * string. If this message was allocated with
+			 * vmalloc() (happens, but rarely), leave it
+			 * NULL and let ceph_fname_to_usr() allocate
+			 * suitable temporary working space instead.
 			 */
-			tname.name = _name;
+			if (likely(!is_vmalloc_addr(_name)))
+				tname.name = _name;
 
 			/*
 			 * Set oname to _name too, and this will be


