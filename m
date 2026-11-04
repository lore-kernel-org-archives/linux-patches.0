Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827015;
	b=vxyVfgTG529x+EgA3nk/QHJkNR5okfvkBYRrJhusQMFIIxGO4GUaqHyDkYSwlfZY+9bQ
	 XyHODZxw1qKfxnz3ba9mYCgxWYbXfNhzj8JmN+jDXlfm6e4WXxIYzHNaxImqPf8NblZPG
	 bHxxWjjxhGUvTDkkEYKjORiqh3mIDoLITCvcEOzhpwSOwjmdJVyo7NCccx6IJxnoPSILo
	 xmt5/oGI7sbPVz6Q2IdX+1v+k/2fslqOvhgchh0npj70VeY59169jHJoSr59MvKI5JC4D
	 SGPdDu/S710iu4AsjQbu5MIJ2AbJZ5D2x1fhVvJRGd8sMX/we80dwfgvoboFUNk009A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EfGHCoIzxwg8MT7kW8mRT6JXxQsRcL2/MhU8X9P+Kd8=;
	b=izL3Klj+P7dW5SA1Xm+P7wJI4ZIMm5v2FL+55cAEQzpl+QEE2OWUdsFsRz3PaWrJQ/SB
	 WtAf8xulgm9A0NJ8+1R16A3aXnJXyKl5d6p3siEncEqb7m7ydLkWWfR+f3gAPzcmLWoOx
	 3L1dnK7C1IPS+V+FPT2yUSY0HUI3S0Dfb9XqQRbEO+6l8IN7IilbzRuNH/2jQVLy2jdrN
	 ypVzRl5OOg+L7ztAeYWCNKPzZwDLkt3hmRkcZUO1hYnvlLGjmmMRu3tOSyNLEfJPs4GJ3
	 BNiDGcnSJA8/pSyTgUlz8K2vJSgmvQE0A68vACjHbUdfLdgsjD6WwmyReb6RI4HLCIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btohrkoM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9222607493C;
	Wed,  4 Nov 2026 21:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btohrkoM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723B01F0093A;
	Wed,  4 Nov 2026 21:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827014;
	bh=EfGHCoIzxwg8MT7kW8mRT6JXxQsRcL2/MhU8X9P+Kd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btohrkoMpKCsSSNFneJajQEzXGbgcoWCNVlBbtpRJu2iqlqUMun1KY+CDvf5yDFxQ
	 6SMRIK+i7zJeRCeEopKx9NwOknYNG4zXnEU07akQDQwv7oGHOwLQpDAU9B1p0J4v6D
	 wQJ96RSgjW80abbQ5KrSibCj1wftYdZA0urFe/og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 136/547] ksmbd: validate security descriptor offsets before pointer arithmetic
Date: Wed,  4 Nov 2026 16:05:20 -0500
Message-ID: <20261104211042.039039900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 3474e1a304fbf9f7c996b24adcd519e031227a90 upstream.

parse_sec_desc() constructs SID and DACL pointers by adding untrusted
32-bit offsets to the security descriptor before checking their bounds.
The existing checks reject offsets into the descriptor header, but do
not reject offsets beyond the descriptor's length.

On a 32-bit kernel, a large offset can wrap the pointer before the
descriptor. The end-only checks in parse_sid() and parse_dacl() can then
accept it, allowing an authenticated SMB2 SET_INFO request to access
memory outside the security descriptor and fault the kernel.

Check each nonzero offset against acl_len before constructing its
pointer. Initialize the optional owner and group SID pointers to NULL
so an omitted SID remains absent when parsing the DACL.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reported-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -899,7 +899,7 @@ int parse_sec_desc(struct mnt_idmap *idm
 		   int acl_len, struct smb_fattr *fattr)
 {
 	int rc = 0;
-	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
+	struct smb_sid *owner_sid_ptr = NULL, *group_sid_ptr = NULL;
 	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
 	__u32 dacloffset;
@@ -911,12 +911,7 @@ int parse_sec_desc(struct mnt_idmap *idm
 	if (acl_len < sizeof(struct smb_ntsd))
 		return -EINVAL;
 
-	owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
-			le32_to_cpu(pntsd->osidoffset));
-	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-			le32_to_cpu(pntsd->gsidoffset));
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
-	dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 	ksmbd_debug(SMB,
 		    "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
 		    pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
@@ -932,9 +927,12 @@ int parse_sec_desc(struct mnt_idmap *idm
 	pntsd->type = cpu_to_le16(DACL_PRESENT);
 
 	if (pntsd->osidoffset) {
-		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd))
+		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd) ||
+		    le32_to_cpu(pntsd->osidoffset) >= acl_len)
 			return -EINVAL;
 
+		owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
+				le32_to_cpu(pntsd->osidoffset));
 		rc = parse_sid(owner_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d parsing Owner SID\n", __func__, rc);
@@ -950,9 +948,12 @@ int parse_sec_desc(struct mnt_idmap *idm
 	}
 
 	if (pntsd->gsidoffset) {
-		if (le32_to_cpu(pntsd->gsidoffset) < sizeof(struct smb_ntsd))
+		if (le32_to_cpu(pntsd->gsidoffset) < sizeof(struct smb_ntsd) ||
+		    le32_to_cpu(pntsd->gsidoffset) >= acl_len)
 			return -EINVAL;
 
+		group_sid_ptr = (struct smb_sid *)((char *)pntsd +
+				le32_to_cpu(pntsd->gsidoffset));
 		rc = parse_sid(group_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d mapping Owner SID to gid\n",
@@ -974,9 +975,10 @@ int parse_sec_desc(struct mnt_idmap *idm
 		pntsd->type |= cpu_to_le16(DACL_PROTECTED);
 
 	if (dacloffset) {
-		if (dacloffset < sizeof(struct smb_ntsd))
+		if (dacloffset < sizeof(struct smb_ntsd) || dacloffset >= acl_len)
 			return -EINVAL;
 
+		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 		rc = parse_dacl(idmap, dacl_ptr, end_of_acl,
 				owner_sid_ptr, group_sid_ptr, fattr);
 		if (rc)


