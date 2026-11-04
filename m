Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831717;
	b=4wbzaAA15RDd86eQJHDs1PTHZS00iJotj0KKfP/P+h+9EG8PRCgTcSJqkrfyM705721/
	 b5hf+gngOiawhJrzrcdEm6IiouTCqduzDY3AsrrQ59+wFUiBbvpbM12Xemt2hnTSkdPyG
	 oRLIr8W4vH8jAQ703YdppbHJAovHtZEytqUBqIy6/FoYmhaW/C9VMv0u90e61eZKSwznE
	 bFA/msXoukjBl/9ikzc5Lkk1yoBcVi1El1G7abpjya+DRgIMBcwirZaHZ/0h3I6aKXA7m
	 kRJHa8iGRMXKFCh6oj2NuM3+Ij3G5wICmazA817uJsUg3qgFInnYfB2KPuJK0Q5Hxnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85bsCY0citZ8kHmEcgZn18anMSXvgBnexa4UyoKrlr8=;
	b=atEeQrfQAWyVla1Xj1+YQDnlkmdm8qEI1WFOm1APy9uWkoS9B6GUspEljg44jXca5WiC
	 ixQqRg6mA7G++KXY8AtzIDMqPpmCmDq25UyhS06hCd4YiBPlvjWpy9iSJfLbotZOS7DMx
	 nG7XenQ+a1la2UfVg1ItBlFuAVlFzdNy2IBOvq/+RMPXU/DswJe3Y3r59b8dvT8bjPOYd
	 yclWVDL4JKvBdhZ+VUQ/YVxqbIQlyjR2RKqClx6+VBnTeihwKoSeVJQpMcArri3Rkt42y
	 EBptUMmMxleidfk4dUVABKpZcENDByK/ktzdK81Mhqul78/nyxlxMzcMpPtW1j7tpbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeobbkov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320A4606A846;
	Wed,  4 Nov 2026 22:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeobbkov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F6B1F000C1;
	Wed,  4 Nov 2026 22:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831717;
	bh=85bsCY0citZ8kHmEcgZn18anMSXvgBnexa4UyoKrlr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeobbkovEZYDBnctKxLCGype31hj2nSayjKgj8kIndRdYiTVIkttwI5IpI+OOBf2h
	 S89fh2oRV9/70Jsp5YV79aQjD69CZOuVVOZz9wBHS4VUA0/Hw93EJMdVxnf/CPD2ik
	 WGeKtQma1uQZXJY60EVYU1f7Yhb9ZzEiwCDj3oCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 0870/1005] smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()
Date: Wed,  4 Nov 2026 16:10:03 -0500
Message-ID: <20261104211107.634535002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1772,12 +1772,15 @@ id_mode_to_cifs_acl(struct inode *inode,
 
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


