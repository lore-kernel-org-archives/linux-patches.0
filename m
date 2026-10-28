Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210463;
	b=T9JNO7Kn7HIWLQeGo7NsclmmfSkYNASAtpdfa5qu2RPC1QkKB9lC4VDjARDrvPlR5OYo
	 zLpTE38FEPmb6rq/jF3rcFMFpdIXlcLSsabDTzdHGIgaxa+pwx2n8jTww48YJo94ecb00
	 2Matw/KFRuUWTsDAcAdBBjiDF60gtgUq13ZMU2/Cc+fF8KV1nf+DPJ8bN150LQFwQlRc7
	 HwdHJJOIiVpLCXiVg+OWm8HsAWNW2fjVeIhq5KPS9SMAmDXcauOH0kxkJPO2d94DwaozP
	 v/2nUT78o1mF41jU4DTosnU3S/n+CqU8XmZkMf3o6I4ELiFRdrhmrzQEjH79rs9Ugnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TraaxEPp4UogtuZcMACPTXLJ8cmg91XA0i4Mr82TM7Y=;
	b=NzQv5+p+HByXZae7LU3kZnkxsQm+2FVAAya09AwjavrfolfpZWZlNhLDazrXnfGoFqNz
	 6KSuXRtCZ2bPp8P8yzZ8eVBzRzSgtXXYQ/HlATLFcyW2aa9BGaowUnpMQt6lp+CBBq2r6
	 BmZmp153cYXeZ738yO2HBGbW2noIpGrQwyAy8d+UX9Q0jRjwHvCqJm1IKd8wf1q9/4xbj
	 I7TeKLh0aZhlPX5DX/3lwKjQ6v2PdCjXrHWaTaLwKjClKbj3QOru257dOs632JlxTjvV5
	 vncNglCth2bj7W/mW9NSzAqAF7F9mL8u7QIHmWAWJn1Gn5VDdSPdqou8pVy0bEChYqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3rwWSYH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74154606A31C;
	Wed, 28 Oct 2026 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3rwWSYH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FA61F01825;
	Wed, 28 Oct 2026 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210463;
	bh=TraaxEPp4UogtuZcMACPTXLJ8cmg91XA0i4Mr82TM7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3rwWSYHR7XAHIPeqBIwTqTEwJxwabOnDy+vQB5CbhBVIN/be6CWpZP9bk4oAArNK
	 n2wR0JeYNeK1QY5+RiLAegKSSeVx4aQovpPvNNW2elmlwCaZTVSp5qbrKJZaZAB8ga
	 s3VkmF19esBTpiokGEODhwovz2fRGumkYLZGWjcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/571] ceph: bound copied dentry name length in NFS export get_name
Date: Wed, 28 Oct 2026 17:52:33 +0100
Message-ID: <20261028170008.170023306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit eff8013c5a8916613c742ae5a2cc341cb605c0ae ]

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
[ adapted the bounds check to the older ceph_get_name() flow without encrypted-name handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/export.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 466af8e0cbce1..ba2b918a5dfe6 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -422,6 +422,16 @@ static struct dentry *ceph_fh_to_parent(struct super_block *sb,
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
@@ -487,9 +497,8 @@ static int __get_snap_name(struct dentry *parent, char *name,
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
@@ -551,8 +560,12 @@ static int ceph_get_name(struct dentry *parent, char *name,
 
 	if (!err) {
 		struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
-		memcpy(name, rinfo->dname, rinfo->dname_len);
-		name[rinfo->dname_len] = 0;
+
+		err = ceph_export_copy_name(name, rinfo->dname,
+					    rinfo->dname_len);
+	}
+
+	if (!err) {
 		dout("get_name %p ino %llx.%llx name %s\n",
 		     child, ceph_vinop(inode), name);
 	} else {
-- 
2.53.0



