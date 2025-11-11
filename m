Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E381F24113D;
	Tue, 11 Nov 2025 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822279; cv=none; b=dnv26puqTF87bLYVXbK/uy104OHyoB1O65XChvaDJVkStl23gXnuoQHg80xwelzj8X9ZHCKfI6f0WnTexPw2kx4dkO8X9SY+Rz5bUFSv/Z5E8FedCQOiaUxqkSuyjW20Jip/dVJypyRV8Yjinn/AbRtBA1X5Hhu8Y3/+GuL5vv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822279; c=relaxed/simple;
	bh=+sA1XdXATBqSb/zLOPWTyXzFeohExVX3G8HS7t6VdQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdNiWnT9dRFkMJmKXJzntWdb726eiRdb1gfwQ0Dt9l7QJRHLrM4n3hx52ky3dkX4He/Wn1W2PXXJogT/uyK5tTgfo5TxGL1ADHPmm6IEazoRfenfzGIvWTeOPo576VguOVLk8T+oWFzo8xmrOixK2FjOqGrIhftOZARcfVvn7HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmhI1R4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmhI1R4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C358C16AAE;
	Tue, 11 Nov 2025 00:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822278;
	bh=+sA1XdXATBqSb/zLOPWTyXzFeohExVX3G8HS7t6VdQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmhI1R4XUsz0DLErxEytn4RnaI2/b/hSSm8Abl6nJkLLrTPUl59MxEpwp1Jcbvoqs
	 XKe4wtbec34c+WKmHsv9Cc1jTDcC/9klflosTOWSOgvvrY2UeB6yUVJsfqG29QcXag
	 x8irndTFvbiic/E2qq0DUf52bA8oMkUSipg+hfRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 017/565] smb: client: fix potential cfid UAF in smb2_query_info_compound
Date: Tue, 11 Nov 2025 09:37:53 +0900
Message-ID: <20251111004527.256519475@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 5c76f9961c170552c1d07c830b5e145475151600 upstream.

When smb2_query_info_compound() retries, a previously allocated cfid may
have been freed in the first attempt.
Because cfid wasn't reset on replay, later cleanup could act on a stale
pointer, leading to a potential use-after-free.

Reinitialize cfid to NULL under the replay label.

Example trace (trimmed):

refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 11224 at ../lib/refcount.c:28 refcount_warn_saturate+0x9c/0x110
[...]
RIP: 0010:refcount_warn_saturate+0x9c/0x110
[...]
Call Trace:
 <TASK>
 smb2_query_info_compound+0x29c/0x5c0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 ? step_into+0x10d/0x690
 ? __legitimize_path+0x28/0x60
 smb2_queryfs+0x6a/0xf0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 smb311_queryfs+0x12d/0x140 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 ? kmem_cache_alloc+0x18a/0x340
 ? getname_flags+0x46/0x1e0
 cifs_statfs+0x9f/0x2b0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 statfs_by_dentry+0x67/0x90
 vfs_statfs+0x16/0xd0
 user_statfs+0x54/0xa0
 __do_sys_statfs+0x20/0x50
 do_syscall_64+0x58/0x80

Cc: stable@kernel.org
Fixes: 4f1fffa237692 ("cifs: commands that are retried should have replay flag set")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Acked-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2725,11 +2725,12 @@ smb2_query_info_compound(const unsigned
 	struct cifs_fid fid;
 	int rc;
 	__le16 *utf16_path;
-	struct cached_fid *cfid = NULL;
+	struct cached_fid *cfid;
 	int retries = 0, cur_sleep = 1;
 
 replay_again:
 	/* reinitialize for possible replay */
+	cfid = NULL;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);


