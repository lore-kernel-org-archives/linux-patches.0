Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035371;
	b=1pmmBqGQPquvTwyRsId11kTF3EFt7HxVsDWj1vo3EjI8JSxtjjr7PYcvHRHyD2mX7FnF
	 hkK3mt71TjYg/bRet1Af3nHr1UySCEBUFA6tnlC803zts+Omg0bJncTlKL2gFM4J38YUb
	 GyNadhUT8KuJ46eixK92V07ET0xmOVX062qPagFSEup1IksMd8ssiyJoZ+UZryx/BP8aD
	 i3iQlhrPBEK2iYytLJZfRD3+bv4NoFj0vJin7X/piDG+I+WDDcF/Dp71Eg1NNodGPnZw8
	 5Px3QSo58W58GUN4vptBMgkhh++w53hPvMz8cItR6p+OZZ+aLMkl0LLLrhouHz+mzBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iMMVuPnsntkE2aBzlQSLeIlhG/PBPCzcxg8JAf60jes=;
	b=DWkh1n4IKEFcS+dvSkNpfZB4/9+qXbU+8eJFjZCfmnPzMn96ystiZNNlXBHNzSn6M/VP
	 FkIEjjOZOpBeGutRyy8xlh6awFGFr+N9l2cAAnR436cSVtLNM5/tkSyk2OkRU4drS8hJy
	 JhjwsFxhwZOs7W0PgGwFndz0g7BwD2/pUX/5zLqQKNAEGQMMSZWhtbWRcSscGn3X6VP/m
	 /Rha/a6iuBJ4y+ZQXoazVXUSlnt6VMizGF2pUmyE4uutmGMHPZ+Ao9Q9py3YfQj3KZuqf
	 kOwKXyTloXcO2v/A6IebsO5FDary0ZGkkUF8v0t4fL+q9SZSmqic9nC3nnx4R/W39fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoW4Q5zb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E41606A31C;
	Wed, 18 Nov 2026 20:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoW4Q5zb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555A21F000C4;
	Wed, 18 Nov 2026 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035370;
	bh=iMMVuPnsntkE2aBzlQSLeIlhG/PBPCzcxg8JAf60jes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoW4Q5zbwc/lVUakx4xJbarDj8Qpog98zz+81Jfwz22qajtV/EF2vTPTnFASKyq3r
	 dK35eMQorDadBj8/16LgTZwoQVx9BdcSKPoX72znprRoWJyz4jiUsC/3Rt3uTuSWPx
	 7JMueGJmEwdIH4tehOW28KDE1xleJvCPHeIFY1Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0679/3318] smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()
Date: Wed, 18 Nov 2026 15:21:41 +0100
Message-ID: <20261118150338.552695878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Maier <dmnk@google.com>

commit a377a3645c7d0246af0bc4ef24db94bb2670bdde upstream.

In id_mode_to_cifs_acl(), while the chown branch reserves
sizeof(struct smb_ntsd) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_acl) and the worst-case ACE space after
commit 0ee150794c75 ("smb: client: fix heap overflow in DACL owner/group
rewrite")), the chmod branch only adds 2 * sizeof(struct smb_ace) or
5 * sizeof(struct smb_ace) to secdesclen (or 1 * sizeof(struct smb_ace)
on posix).

However, the chmod branch also invokes build_sec_desc() ->
copy_sec_desc(), which unconditionally writes the Owner SID at
pnntsd + sidsoffset and the Group SID at
pnntsd + sidsoffset + sizeof(struct smb_sid) (2 * 68 = 136 bytes total),
and set_chmod_dacl() always writes a struct smb_acl header (8 bytes)
even when the source descriptor has dacloffset == 0. When a security
descriptor has compact or overlapping Owner/Group SIDs (or
dacloffset == 0), calling chmod() under-allocates pnntsd and writes past
the end of the slab buffer.

Reserve sizeof(struct smb_acl) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_ntsd) on the posix path) in the chmod branch of
id_mode_to_cifs_acl().

Fixes: 7ee0b4c635c0 ("cifs: fix hardcoded default security descriptor length")
Fixes: f5065508897a ("cifs: Retain old ACEs when converting between mode bits and ACL.")
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1767,12 +1767,15 @@ id_mode_to_cifs_acl(struct inode *inode,
 
 	/* Potentially, five new ACEs can be added to the ACL for U,G,O mapping */
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
+		nsecdesclen = sizeof(struct smb_acl) +
+			2 * sizeof(struct smb_sid);
 		if (posix)
-			nsecdesclen = 1 * sizeof(struct smb_ace);
+			nsecdesclen += sizeof(struct smb_ntsd) +
+				       sizeof(struct smb_ace);
 		else if (mode_from_sid)
-			nsecdesclen = secdesclen + (2 * sizeof(struct smb_ace));
+			nsecdesclen += secdesclen + 2 * sizeof(struct smb_ace);
 		else /* cifsacl */
-			nsecdesclen = secdesclen + (5 * sizeof(struct smb_ace));
+			nsecdesclen += secdesclen + 5 * sizeof(struct smb_ace);
 	} else { /* chown */
 		/* When ownership changes, changes new owner sid length could be different */
 		nsecdesclen = sizeof(struct smb_ntsd) + (sizeof(struct smb_sid) * 2);


