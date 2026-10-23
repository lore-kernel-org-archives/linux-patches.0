Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774914;
	b=jGezJjZfSAvfrcF7jbeA/tbJ4IqceomJenewmH6x04xt48zDKjeeC5S2lZqzA72QaJKh
	 n3d6ejsStWCt1vZh3EcUbMz2sNSdwrS139zqqtz6qZu3ezTUYbxmsK0UzbO4ZMkKhRaR8
	 Ext3n1WH8lqUZsvXWmvEI+wdbtrCRKXoUOLz75azy/hGXR2dBa30ol5+ldZXjYHzZIUU9
	 euCPaIwctLvRu7aNLhG8dIpK0qBQjt6cHDH5vp1lPMaKNsyU1pcgtpBOFNJWJPtPvTLtv
	 ZzX0UBWyUax0jntjY4ZP9PIvWuopyaPfMWJW63uqezSpwrcrLq28j9WsWKSD+OpoO+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pcwv8+I1FI4huOxLtAuvO6A0vczI+BrqcHVW8Qw62lk=;
	b=ec0TcgQyNLx+HO3ysK35yhKEUOsrbMi2Icj7O6d5r7hrxDHQlzToTcw/bDwukEPjuyzo
	 6JJE3gifafQqjI7zhxf8jvgmEf/kvO4nCJYDCltkeKwiXcC3vrnCoP9tp3TXg5b5PWAeU
	 WY9JloAHc7EB8F5wU86elK/gHvTtLNHO5pkMk30JgT55J0p7u/fR6pSiIPdbn/rw60LVg
	 UWEYVRfZJptgs7+GoKKdI997B6zHSacoVqEDzph1JcZDVnUVRTmE73fesVCE+pG9ZK7Md
	 ctnekHgjfeZEy6C/5un+8SFJ+GjpRjS2TMsB9W9tvpLWkiGQ82wbB0P2Y7+is7feOcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RA8hSdlu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CCD606A31D;
	Fri, 23 Oct 2026 17:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RA8hSdlu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F521F01825;
	Fri, 23 Oct 2026 17:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774914;
	bh=pcwv8+I1FI4huOxLtAuvO6A0vczI+BrqcHVW8Qw62lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RA8hSdluULbcDNffzJ7oRlo71ULg6BTEsH/av1VvMUjqMssdIFd2HybGXaD0aHOp3
	 MPgxEb00+Rppzji2DSqcC6qaIAAlxfSwj42DwXw3DhGhioSj12evlit8ZWoekk2Xk2
	 UChsxjhOPOlQJbavr+L6xtugYVLdWn8D+1eAONHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.2 199/242] selinux: fix BPF token permission checks
Date: Fri, 23 Oct 2026 18:40:41 +0200
Message-ID: <20261023163718.499146990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <paul@paul-moore.com>

commit 77d499e61d36e883a6ad1f10afe05f556aa7e0cc upstream.

Avoid multiple lookups of the bpffs creator SID using the token's file
descriptor when the same information can be found via the resolved
path/dentry (in selinux_bpf_token_create()) or the token itself (in
selinux_bpf_map_create() and selinux_bpf_prog_load()).  Not only does
this simplify the code, it avoids potential TOCTOU issues if the user
changes the token file descriptor passed into the kernel.

Cc: stable@vger.kernel.org
Fixes: 5473a722f782 ("selinux: add support for BPF token access control")
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7382,24 +7382,6 @@ static int selinux_bpf_prog(struct bpf_p
 			    BPF__PROG_RUN, NULL);
 }
 
-static u32 selinux_bpffs_creator_sid(u32 fd)
-{
-	struct path path;
-	struct super_block *sb;
-	struct superblock_security_struct *sbsec;
-
-	CLASS(fd, f)(fd);
-
-	if (fd_empty(f))
-		return SECSID_NULL;
-
-	path = fd_file(f)->f_path;
-	sb = path.dentry->d_sb;
-	sbsec = selinux_superblock(sb);
-
-	return sbsec->creator_sid;
-}
-
 static int selinux_bpf_map_create(struct bpf_map *map, union bpf_attr *attr,
 				  struct bpf_token *token, bool kernel)
 {
@@ -7412,7 +7394,7 @@ static int selinux_bpf_map_create(struct
 	if (!token)
 		ssid = bpfsec->sid;
 	else
-		ssid = selinux_bpffs_creator_sid(attr->map_token_fd);
+		ssid = selinux_bpf_token_security(token)->grantor_sid;
 
 	return avc_has_perm(ssid, bpfsec->sid, SECCLASS_BPF, BPF__MAP_CREATE,
 			    NULL);
@@ -7430,7 +7412,7 @@ static int selinux_bpf_prog_load(struct
 	if (!token)
 		ssid = bpfsec->sid;
 	else
-		ssid = selinux_bpffs_creator_sid(attr->prog_token_fd);
+		ssid = selinux_bpf_token_security(token)->grantor_sid;
 
 	return avc_has_perm(ssid, bpfsec->sid, SECCLASS_BPF, BPF__PROG_LOAD,
 			    NULL);
@@ -7444,12 +7426,14 @@ static int selinux_bpf_token_create(stru
 				    const struct path *path)
 {
 	struct bpf_security_struct *bpfsec;
-	u32 sid = selinux_bpffs_creator_sid(attr->token_create.bpffs_fd);
+	struct superblock_security_struct *sbsec;
 	int err;
 
+	sbsec = selinux_superblock(path->dentry->d_sb);
+
 	bpfsec = selinux_bpf_token_security(token);
 	bpfsec->sid = current_sid();
-	bpfsec->grantor_sid = sid;
+	bpfsec->grantor_sid = sbsec->creator_sid;
 
 	bpfsec->perms = 0;
 	/**
@@ -7458,15 +7442,15 @@ static int selinux_bpf_token_create(stru
 	 * in the allowed_cmds bitmap.
 	 */
 	if (bpf_token_cmd(token, BPF_MAP_CREATE)) {
-		err = avc_has_perm(bpfsec->sid, sid, SECCLASS_BPF,
-				   BPF__MAP_CREATE_AS, NULL);
+		err = avc_has_perm(bpfsec->sid, bpfsec->grantor_sid,
+				   SECCLASS_BPF, BPF__MAP_CREATE_AS, NULL);
 		if (err)
 			return err;
 		bpfsec->perms |= BPF__MAP_CREATE;
 	}
 	if (bpf_token_cmd(token, BPF_PROG_LOAD)) {
-		err = avc_has_perm(bpfsec->sid, sid, SECCLASS_BPF,
-				   BPF__PROG_LOAD_AS, NULL);
+		err = avc_has_perm(bpfsec->sid, bpfsec->grantor_sid,
+				   SECCLASS_BPF, BPF__PROG_LOAD_AS, NULL);
 		if (err)
 			return err;
 		bpfsec->perms |= BPF__PROG_LOAD;


