Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF4E335BBB;
	Fri,  4 Sep 2026 05:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500729; cv=none; b=p+9/3jxTRkucRrqYTp3r7HdXCpzkwZ1E7WtybXhGzmgsJD1TMn5Zx6j+fZYKhWXQJ6cAzETnzzzFj1BXBgPalo0RV5E2E7E1kGhzB1OtGbU2r6awsdc4tnG1g6zbTiCqOyiWJCG57aN2r5yJXhOWptU+L6EXLI25gwpKyW2Bfag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500729; c=relaxed/simple;
	bh=sE71V9QessT5Op4d0aab86ftz3QHNl/YSqiVaCp+wPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HD6I+cjWiCrb75UrEOXqEfck32HLZD0+vEX9vda8OfoJDHtHMH4FbnQuKtfYFxJQZzCafA/VZYdmssX0wH/ownNS9TC0HkJJ/UhL/ZR0+eZKua9EphZTnDKA7oxhpM32x6lnakRmRbuGGzppuPn3wt139gpXaAa4ptMVUn8pmSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmKx2ATs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmKx2ATs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C6A1F00A3D;
	Fri,  4 Sep 2026 05:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500728;
	bh=CxnxxndNMl1aOmoFw3QT8Z86ooG0+qD7C4vYAhtd34M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmKx2ATs4VKs9i35gMatulr35UerIg4yV82mnoQ17qbFb2axLAaDJwt0FJq5XOUaT
	 qCdNfcRQVMoX0tyjBrZaq5x/+fDGsSrG2Tey1wvUdQWfN9Vbqu9B1DCCYXSDWp12Sf
	 j7AisyIMoRZlzBsrbKjx6/+HmJJAuIl7zg3Hj4rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 157/552] ceph: bound copied dentry name length in NFS export get_name
Date: Fri,  4 Sep 2026 06:55:14 +0200
Message-ID: <20260904045752.438898929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


