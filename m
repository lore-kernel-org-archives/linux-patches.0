Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B5833438C;
	Fri, 21 Nov 2025 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732131; cv=none; b=gbZHFlBuVMwIZMNM9TnqgZeLWNO/JeHzD9/y+oMMfmIEMS/wsNxcK18IwNUNg1bOJmwZ+kcMoJuLtrrzbn66NuMPIE0c0t55Aq6F2MjmwnKli+bx1cQK7Kk3+0Wcgfx+XxsYmtgMKFz3eaA4ulYOtpf0IQtdFUFX29TFowsD5rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732131; c=relaxed/simple;
	bh=pwdUMFHWVNDMMH49HmVuds/ajTX0F5MgMKr3BBx0nfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F57WEBKVc5pJs9Ow8QS+ClA/U3ZNYahN0uL7qNC0E5q3bHwQt8ELYT7oRa9wgwO1zRsu0/U67/nHpg+q52OG4p0qbxgXsn2qBNRZ21NMwrv5rA8GBL1oljTK6/e0+l96LI7oU50XkRG00AKkdPKyIZ+HuhPOQ5ZI74kVqPndk58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxKP8pvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxKP8pvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FD1C4CEFB;
	Fri, 21 Nov 2025 13:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732131;
	bh=pwdUMFHWVNDMMH49HmVuds/ajTX0F5MgMKr3BBx0nfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxKP8pvTwaefZZUU5T+mfExSZWw8MoF/rk6w5+h598WY/wnRa9J/f9mykiKoxG6w6
	 /+z7gmkw/asvid/VDeoVtJSFusCVzATiAoQZD0SFbJiT365o35Rvn2Q7uinOGu+DRr
	 GV7JrvkFY+xjVD1556SCIVy8erAoRMWfakOKtLcM=
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
Subject: [PATCH 6.6 015/529] smb: client: fix potential cfid UAF in smb2_query_info_compound
Date: Fri, 21 Nov 2025 14:05:14 +0100
Message-ID: <20251121130231.545148258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2663,11 +2663,12 @@ smb2_query_info_compound(const unsigned
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


