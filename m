Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B8335DA40;
	Tue, 21 Jul 2026 19:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662324; cv=none; b=jB7mO2tXEXpmudK3XZLZHAeRxW8S40Y1oG4xrRUVePpiUr9mQ4Ed3NfAyAuSkObK4fBZdXjCIRsAxeCPwsdKzUO/9685Ua4JPGzhm0mPGFjlb+KH9sqTE8/XPdtLGwSM7IIPrBjCbsGa2ZNYrzahwR6zpJp6dDeuRI8o+FWXXuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662324; c=relaxed/simple;
	bh=fipaEdOHmJFOdYtX4r8Jl36FmkTd+bAvieDWrrpAVZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/Ik4ws+QDq+oqza+Wuajupj3mb4L1lIxtvZvNQqQA4/wqdlbcXU2dySvCJgED/O0YZIbf7jPqv0BlbcWjIzAoJlTJad6Pncdn2JVnJf5GAbh46qnb47ofhPh/jv4xJyt5BIdXSpXIZ/DLR3ZU8AjtdHJh9ZU9F1TebS1NziEEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cw7XAfdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cw7XAfdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF841F000E9;
	Tue, 21 Jul 2026 19:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662322;
	bh=f6RoGbACEYLv8sSpY8X8txCq3PLpjB4d3Gn4mO2Hwks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cw7XAfdXUwEB4pwyA7SOvO8GuR5t2CdmzpdgiHXcQwulwdNYviP+222I9hA3LkM3C
	 Pf9aNdyB3RmVy5yajiXOBjPFujAjJ2UjUTo9c9G6BS+XyA20FMTChlPImHamUmYzJu
	 zu4mUF8gs0jljEZ37hUZvFSsnMACKdiXiiN7Y52Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0400/1276] ksmbd: fix use-after-free in same_client_has_lease()
Date: Tue, 21 Jul 2026 17:14:03 +0200
Message-ID: <20260721152455.051602920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 65b655f65c3ca1ab5d598d3832bb0ff531725858 ]

same_client_has_lease() returns an opinfo pointer from ci->m_op_list
after dropping ci->m_lock without taking a reference.

smb_grant_oplock() then dereferences that pointer in copy_lease() and
when checking breaking_cnt. A concurrent close can remove the old lease
from ci->m_op_list and drop the last reference before the caller uses
the returned pointer, leading to a use-after-free.

Take a reference when same_client_has_lease() selects an existing lease,
drop any previous match while scanning, and release the returned
reference in smb_grant_oplock() after copying the lease state.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 6454c7a4baa450..fc2ee00cfd8100 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -531,7 +531,12 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 
 		ret = compare_guid_key(opinfo, client_guid, lctx->lease_key);
 		if (ret) {
+			if (!atomic_inc_not_zero(&opinfo->refcount))
+				continue;
+			if (m_opinfo)
+				opinfo_put(m_opinfo);
 			m_opinfo = opinfo;
+
 			/* skip upgrading lease about breaking lease */
 			if (atomic_read(&opinfo->breaking_cnt))
 				continue;
@@ -1249,6 +1254,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 			if (atomic_read(&m_opinfo->breaking_cnt))
 				opinfo->o_lease->flags =
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
+			opinfo_put(m_opinfo);
 			goto out;
 		}
 	}
-- 
2.53.0



