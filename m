Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEAC30C160;
	Fri,  4 Sep 2026 05:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498954; cv=none; b=M/oI6pMbz7StAhPru0YbpCnaZutxsAxRitBf9Gso68gIj8LWHAoYjtInCb3Okbh83XpujiJKkq4+3OCcYpZDYcZ0FuOqN1zwULeLa7V7smVzpEbr26oxd1Ko6NtG54Nmm01Zej7peN/FO2SmuKiKQ+m2oJk/yV26VDBJL69KFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498954; c=relaxed/simple;
	bh=dhFegBsyj+u68QT75JrYp4DEMj00+hjcvwyt6bblK90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIcDNe0qu8F145Yt2ongvQQdoVp9gxPudJP/UoDNDr0o/0v2vMhfX9MN1VnVAz/6ybWJEYR1pZrpGUdBWDCcqQfhzNChgcAnT0kHJb9EGWz5L0RaHozCQZUU+DP1RabV/SJbBpPcix9GCtB+Z2bBxahdrGGdj3DTBUFXZjynkgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPip1lu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPip1lu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248AB1F00A3D;
	Fri,  4 Sep 2026 05:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498953;
	bh=uSxTPbpw0K5N716327HiIvUX/r2ULA/DfiHJVOcR7jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPip1lu+NxJKxvGL62mOOf8pkGR5JZYUUY95Yw6OLOzHF61cAE+bwM6LM4l5a2YZf
	 2pX+BEMF8RA7y9i/o8oS1RkZZj6YS1ZJ92H8TG+iOsb/m4TcEq0TehdiYZdcuT9ck0
	 vYaNty3yhd6n4kGxcYqLFFqeAMIB/uHJl3P8xuDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.2 219/713] ceph: bound copied dentry name length in NFS export get_name
Date: Fri,  4 Sep 2026 06:53:07 +0200
Message-ID: <20260904045808.727256032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit eff8013c5a8916613c742ae5a2cc341cb605c0ae upstream.

ceph_get_name() copies the MDS-supplied name into the caller's
NAME_MAX-sized buffer with memcpy(name, rinfo->dname, rinfo->dname_len)
and then writes name[rinfo->dname_len] = 0, without checking dname_len
against NAME_MAX. A malicious or buggy MDS that returns a LOOKUPNAME reply
with dname_len > NAME_MAX overflows the buffer. __get_snap_name() copies
rde->name / rde->name_len the same unchecked way.

Impact: a malicious or compromised Ceph MDS overflows the NAME_MAX name
buffer in a client's NFS-export get_name path, a slab out-of-bounds write
reported by KASAN. Reachable when a CephFS mount is re-exported over NFS.

Add ceph_export_copy_name(), which rejects lengths above NAME_MAX with
-ENAMETOOLONG before the copy, and use it in both ceph_get_name() and
__get_snap_name().

Cc: stable@vger.kernel.org
Fixes: 19913b4eac4a ("ceph: add get_name() NFS export callback")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/export.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -442,6 +442,16 @@ static struct dentry *ceph_fh_to_parent(
 	return dentry;
 }
 
+static int ceph_export_copy_name(char *name, const char *src, u32 len)
+{
+	if (len > NAME_MAX)
+		return -ENAMETOOLONG;
+
+	memcpy(name, src, len);
+	name[len] = '\0';
+	return 0;
+}
+
 static int __get_snap_name(struct dentry *parent, char *name,
 			   struct dentry *child)
 {
@@ -513,9 +523,8 @@ static int __get_snap_name(struct dentry
 			BUG_ON(!rde->inode.in);
 			if (ceph_snap(inode) ==
 			    le64_to_cpu(rde->inode.in->snapid)) {
-				memcpy(name, rde->name, rde->name_len);
-				name[rde->name_len] = '\0';
-				err = 0;
+				err = ceph_export_copy_name(name, rde->name,
+							    rde->name_len);
 				goto out;
 			}
 		}
@@ -580,8 +589,8 @@ static int ceph_get_name(struct dentry *
 
 	rinfo = &req->r_reply_info;
 	if (!IS_ENCRYPTED(dir)) {
-		memcpy(name, rinfo->dname, rinfo->dname_len);
-		name[rinfo->dname_len] = 0;
+		err = ceph_export_copy_name(name, rinfo->dname,
+					    rinfo->dname_len);
 	} else {
 		struct fscrypt_str oname = FSTR_INIT(NULL, 0);
 		struct ceph_fname fname = { .dir	= dir,
@@ -595,10 +604,9 @@ static int ceph_get_name(struct dentry *
 			goto out;
 
 		err = ceph_fname_to_usr(&fname, NULL, &oname, NULL);
-		if (!err) {
-			memcpy(name, oname.name, oname.len);
-			name[oname.len] = 0;
-		}
+		if (!err)
+			err = ceph_export_copy_name(name, oname.name,
+						    oname.len);
 		ceph_fname_free_buffer(dir, &oname);
 	}
 out:


