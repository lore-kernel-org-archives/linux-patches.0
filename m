Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9312D7393;
	Thu, 30 Jul 2026 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423254; cv=none; b=ta6YB9NuKNt1mQIRz+nSsyh48hT5emJOCYDAX0a2tQCZYkORyYLpYkSgfKCUivwEUuNk0GS1nLgfitWDEqCqahaK6b9yt+wtdZ7Cm5SM7v0qP3BniB4f42q/xqd+Ob3oyhHkJrghBg87blRA6mSohYBeaGySANWAZaGNBYSP6v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423254; c=relaxed/simple;
	bh=C8I2nH5Fx1WI/WpzPdS2FHdkOevlB87FxDWJ4XDJbOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8KroCdjzTFpf++zXAcX8r/ZjryDB1OTgF/Qs80TKANDx2DObfYp06A0k+7oyi22pbqhEqtslDT7WbM5sjtuFZDMjovLGLVEwzw22WdPzFBestNGu26royUb2BzuPsizFGiC9zbkA82LgTZLPhGrlQl8RgFUDT20mlLLciZwYb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs32yezG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs32yezG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ABB1F000E9;
	Thu, 30 Jul 2026 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423253;
	bh=Id4JNr/rLz8uqL+w34UInB5KzMBqZ8CNNP697c4KCqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bs32yezGVS7KA4vm0r5ENx45INWuHM1L7RbDqbzfbuuU4dS1wRVV9Z+Z9RqRMc1us
	 MBHgOrYwZ0BVNh7M05KoYtGsdWuaIK8xpSoL+ePRxMjYHXHfq4MIthyUak+VuR5Pt1
	 1PcM0YeibitVm3528588WZZCx5ddGg+uxxA2DJwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 720/744] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
Date: Thu, 30 Jul 2026 16:16:33 +0200
Message-ID: <20260730141459.584594830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haofeng Li <lihaofeng@kylinos.cn>

commit 47f0b34f6bc98ed85bfdc293e8f3e432ec24958d upstream.

set_ntacl_dacl() copies each ACE from the attacker-controlled stored
security descriptor verbatim into the response DACL without checking
sid.num_subauth. The ACE bytes (including an unchecked num_subauth)
originate from an authenticated SMB2_SET_INFO(SecInfo=DACL) that is
stored raw via ksmbd_vfs_set_sd_xattr(); parse_dacl() rejects a bad ACE
with `break` rather than an error, so parse_sec_desc() still returns
success and the malformed SD reaches the xattr intact.

On a subsequent SMB2_QUERY_INFO(SecInfo=DACL) for an inode carrying a
POSIX access ACL, build_sec_desc() -> set_ntacl_dacl() ->
set_posix_acl_entries_dacl() walks the copied ACEs and reads

    ntace->sid.sub_auth[ntace->sid.num_subauth - 1]

with num_subauth taken straight from the stored SD. Since sub_auth[]
is fixed at SID_MAX_SUB_AUTHORITIES (15), a crafted num_subauth (e.g.
255) drives an out-of-bounds heap read of ~1 KB with an offset fully
controlled by an authenticated client.

The sibling functions already gate this field:
  parse_dacl()    -- num_subauth == 0 || > SID_MAX_SUB_AUTHORITIES
  parse_sid()     -- num_subauth > SID_MAX_SUB_AUTHORITIES
  smb_copy_sid()  -- min_t(u8, num_subauth, SID_MAX_SUB_AUTHORITIES)
set_ntacl_dacl() is the lone inconsistent path that omits the check.

Add the same num_subauth validation in set_ntacl_dacl() before copying
the ACE, matching the gate already enforced by parse_dacl().

Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index fc9937cedb012b..9c59c8f73b6675 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -745,12 +745,18 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 			if (nt_ace_size > aces_size)
 				break;
 
+			if (ntace->sid.num_subauth == 0 ||
+			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+				goto next_ace;
+
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
 			if (check_add_overflow(size, nt_ace_size, &size))
 				break;
+			num_aces++;
+
+next_ace:
 			aces_size -= nt_ace_size;
 			ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
-			num_aces++;
 		}
 	}
 
-- 
2.53.0



