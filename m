Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210541;
	b=Fy+MVgNMWIIYelB1qaJ4zO2yWtpbJggdn1iImLlVzk2qcknfk28PoX5zDqcttgzB6+i+
	 kQTV5EMIulAwVFvh/guYm8e8aIOoWK0tFlEicDfe/YkW0hBpgJ+oMFiFsfRFOKFZVl9aB
	 +P4/7/nl1KBtMotPkQDlXt3IeynQ1otwuxHFZHsmzAA6d6XcaWB9sFBMx0I1BqsqrDWMC
	 ddJkGOykOblfK1/23R7vV/27Z5XoEybqoq0Pp730lFD/9JtkRnSdmVya44wF+FRVzDguf
	 EEfWOnSKLpBR9QI9OyH7cZy3Ylrd3W2IdmQRVBWmmsbNJiCHZUh89IX4qY9nPyiocGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FVWxFK0UTLhowLfw55QXG0gzfmqPu0C74/4qaSWxJYA=;
	b=l+mflrcNSlRrZ59fIpK4NmwmEUXqWoc8UQbC+mSi8qI09SfWOjWk1rTM696z3/M5J+5l
	 pQoqbfb2XVXDgKDdQeUPaa6/MedfX8vRk4HbN8XyLbG5iqVA49Y+vLeGurKUZV+4WRKMs
	 ors+pvIeJfhSMx0ku85zH7CLFyhT9/034ZHwaEwbGZxYmGcYckq4gSg+JuVnjsASGdkdb
	 v0Gzo0O+8CflDMIgLQk+CcD6T6sts/R2DbxqjfOOM9UzZl8J9KQZRLNVGXTJ/FQYa4A9l
	 q4DA1G/apFnw7I4xRYM8fnVaCGg3MGyuN4M51+9AeCOW6j+nHxz4WpzYueP2EDpn4rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a5hU/MPw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11C7606A31E;
	Wed, 28 Oct 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5hU/MPw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3071F01825;
	Wed, 28 Oct 2026 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210540;
	bh=FVWxFK0UTLhowLfw55QXG0gzfmqPu0C74/4qaSWxJYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5hU/MPwEnupZeP+2wMMtczNKhSIYXkFwTWJMQDSxi07KA7H+mX29CNZLzeLSpuRV
	 IlxspDV+xR1fH1e5dFNti7hi56w7xYQNfyGfj188CPv6CT3/0uVTc3dpSxNS1CHTAs
	 yi6aHpg/2x8yi0V1B699fxpo9veEaVMrlliLSd9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/571] smb: client: fix heap overflow in DACL owner/group rewrite
Date: Wed, 28 Oct 2026 17:53:02 +0100
Message-ID: <20261028170008.859034834@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit 0ee150794c75bcd0be0e24ff3394f433cbae18cc ]

When id_mode_to_cifs_acl rewrites an existing DACL, it allocates a
buffer sized according to the on-disk DACL length reported by
dacl_ptr->size. However, replace_sids_and_copy_aces may rewrite each
ACE with a new owner/group SID obtained from the cifs.idmap upcall.
Those SIDs can have up to SID_MAX_SUB_AUTHORITIES (15) sub-authorities,
making each ACE up to 76 bytes (sizeof(struct smb_ace)).

If the original DACL contains short SIDs (e.g., 1 sub-authority) while
the replacement SIDs are long, the rewritten ACEs overflow the
allocation.

Fix this by always budgeting for worst-case SID expansion: allocate
sizeof(struct smb_acl) plus num_aces * sizeof(struct smb_ace), which
covers the smb_acl header and room for every ACE at maximum SID size.
This replaces the previous split logic that used dacl_ptr->size for
cifsacl mounts but num_aces * sizeof(struct smb_ace) for mode_from_sid
mounts: both paths can trigger the same rewrite and need the same
headroom.

KASAN reports this as:
  BUG: KASAN: slab-out-of-bounds in build_sec_desc+0x1e8a/0x2680 [cifs]
  Write of size 4 at addr ffff8881a5e25374 by task chown/5298
  ...
  The buggy address is located 0 bytes to the right of
   allocated 884-byte region [ffff8881a5e25000, ffff8881a5e25374)

Cc: stable@vger.kernel.org
Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Assisted-by: Kiro:claude-opus-4.6
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Fixes: 5c3564852c58 ("cifs: Minimize the number of cifs_acl memory allocations")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ changed smb_acl/smb_ace to cifs_acl/cifs_ace and le16_to_cpu() to le32_to_cpu() for the branch’s 32-bit num_aces field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 19d2d68706ad0..3baafbc12f1a1 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1747,11 +1747,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 				cifs_put_tlink(tlink);
 				return rc;
 			}
-			if (mode_from_sid)
-				nsecdesclen +=
-					le32_to_cpu(dacl_ptr->num_aces) * sizeof(struct cifs_ace);
-			else /* cifsacl */
-				nsecdesclen += le16_to_cpu(dacl_ptr->size);
+			/*
+			 * Worst case: every ACE is rewritten with a new SID of
+			 * SID_MAX_SUB_AUTHORITIES sub-auths -> sizeof(cifs_ace) each,
+			 * plus the cifs_acl header replace_sids_and_copy_aces() emits.
+			 */
+			nsecdesclen += sizeof(struct cifs_acl) +
+				le32_to_cpu(dacl_ptr->num_aces) * sizeof(struct cifs_ace);
 		}
 	}
 
-- 
2.53.0



