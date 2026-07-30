Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69897417D7E;
	Thu, 30 Jul 2026 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425104; cv=none; b=awfeMv22MvjQIa0KPf5qNNsfDogvmKKiSuR9+u2tOghGmpEGy22KhielQJdsZAxQbhZxovXSFQXybEB2SpqxeOChVrKs2Vsns/V83lfrRzDXpsg8aaWKTSSyAf2K5XEmpyN2z0vUQCXhqc2vqP1kYRNe4/lEAhZBjPTgxRRr2sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425104; c=relaxed/simple;
	bh=EK1wz2woO93O+zjqMABXguMzsq3H6x3/FSnz/IGns8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9neSZAtniixogizwO9D/tbgfh5YrEjjLAB2baitqPxPIXVGayBGtWSJNSOBigDSbSZc/yk3TqRQDz7cN7RB1CPMaaJZS5LXlRPpGljXgJ0M/JEpL1zvp0Njj1WkxvnNZiR07vhzp7rLBVOQDJg1rbLtw3llY+yTDKN20jjFeo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RACmDe/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RACmDe/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6471F000E9;
	Thu, 30 Jul 2026 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425103;
	bh=D+9g4/Ij9LzD9MDTovq0Lq7OuNraF6+oSJXVD38lBD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RACmDe/AEZFRTGGxlwfg41uMpgvWwCe1c/nge6DBtfhNpfIGk9jpUrIMmC4QRerck
	 2qYXzfjXbtZSrgXQoWTLwf82BX0wTpKpoBXUOObpCIEiVQQeKGqnkYB4u8ReG8Oxev
	 IoQqEBe0um66+Qi5pauvi5msT124fTgV3F/BYNZA=
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
Subject: [PATCH 6.18 599/675] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
Date: Thu, 30 Jul 2026 16:15:29 +0200
Message-ID: <20260730141457.848973733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index b09bc8d9389a2a..173469d112f101 100644
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



