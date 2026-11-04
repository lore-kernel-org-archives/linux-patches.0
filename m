Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829006;
	b=1h0Heswss6JAtB6qfBM604VOBdSxqPbJb7IpEKgxZ8m93HgoB6QwiQPs6TrDSjR0/fKu
	 2JrxlgDi0z8Ykea8xdVWSCVQkDk1toOslcS3WvafoDZBK+MoEXsjV483e3bMRibfsBOES
	 OxQaS+NinDBBxT04XakwI40Wo+/ujhglpF2wjsOCigM/ICt7Tvok1i5wiVX1UIWUOz79a
	 VrhREvAV7km7WM7/OxSDiX7NnNgXjkrsgRuUDFfyJ2vmfYFSgMM+oM7NAvGKjC2wTiE7z
	 8ywbrRrCXeW50d4CF6QUFZARinLxNbBVl/1aabE3cCZ7Oj4Kan1xdXFeV0B22LuLBAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ygZVR9lE789/skBl1Yso6avLYGY8ewKmdOBt43ZZZrI=;
	b=KYt34VHKHrrfaHjPXL8hv6aG8MTRZCXALfGGiom+hUpAB839bodCOHcHRQwSM2sLGpv2
	 S4DWnzaoZhbEGO1NpZDbT/7F9aU0WA/6MtEDGQE3oJW8Nfd56JLedCk+MKLQRzXmO+jpe
	 Xw6feON6cuXIt6Vtnqyf1BNN9VzPP14JjeTHVBRYgcYj8gqUqfcohw930PU1ksimiYh/u
	 buBB7s+58R1TZBYhnN2/iG84/vM0ExR+jgWFQCVNgmpo11Ishy5EOcko0okPryfR7ThJO
	 6nZjujjFAWEIUWF1QIyHXhpuncEcSJyifRR/5l6DoPJAoUPCYv7sUhF1jRkUrVf6vNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU4kVQeo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B306070747;
	Wed,  4 Nov 2026 21:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU4kVQeo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842051F000C1;
	Wed,  4 Nov 2026 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829005;
	bh=ygZVR9lE789/skBl1Yso6avLYGY8ewKmdOBt43ZZZrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gU4kVQeok+zSWcwxEur8esGIQIRBlyi3ibQwq59t/O8I/U+Oanah+gxtvMG27wmmB
	 X9Ow5pvPvl4NLTu8/ggWRMQv1nbTu7t/MJNKdruU5LqhXVxoOi6R2weULGvsNwxEX4
	 dR3iIxqY8fm6d2pPVKz8CNFFnqWU31u7j3Aopkdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 383/547] smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()
Date: Wed,  4 Nov 2026 16:09:27 -0500
Message-ID: <20261104211049.179281969@linuxfoundation.org>
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
@@ -1826,12 +1826,15 @@ id_mode_to_cifs_acl(struct inode *inode,
 
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


