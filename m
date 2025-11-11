Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E811FDA92;
	Tue, 11 Nov 2025 00:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822125; cv=none; b=FfS9kt3EHhnDcGsdAGgmQ4GpA7nw0WwziQfXxmfUGZzHQv8toTty7IbO7bZ+l942Sj3l2iLxG6z9+rvK9EaWeG5kFtEwRKoDuiXmo222f/8nPbc6jSMjc1RDOUr+WQbPVWIphwb/Az3sAirZMq1MAjtVR9McNdietpMDXskpDmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822125; c=relaxed/simple;
	bh=526cT+dzwezkRoIimD9natHVEOw/s7SRloZMsFPQcdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgRaHa7IFceObfSjsxbLm+tbnX/Kk+p9LxgApFVKNeXVy8ELLR3hsZV7v578Z7TLWlAObL/Kk9YRi9OWuS6lyytsfeoLmp0fHJZIAXRhN64df5evtVtJkXXLaWAmvq+4/do11wc2i+E2s/ibLSdsnxIq3fAtOq/DM2gH2CmaiE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6oMsF2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6oMsF2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C84C4AF0B;
	Tue, 11 Nov 2025 00:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822124;
	bh=526cT+dzwezkRoIimD9natHVEOw/s7SRloZMsFPQcdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6oMsF2RyDxVAdbh3G43iIAWw+9poNgPnXzmCZzINSqOCDCcndDtzwtzxmujkAdA0
	 gsMCvRFEgIQdX3gMO8oMFM/P2qZv7zs7rQLwzMcoAYvV3+tlpm0FAqzpBVitLnXFeN
	 bjQht9ugp5J6KX6A5X20PXQTZ4esRQAfx327Wo+I=
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
Subject: [PATCH 6.17 025/849] smb: client: fix potential cfid UAF in smb2_query_info_compound
Date: Tue, 11 Nov 2025 09:33:15 +0900
Message-ID: <20251111004537.059130826@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2716,11 +2716,12 @@ smb2_query_info_compound(const unsigned
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


