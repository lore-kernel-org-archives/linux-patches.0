Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6036446AA64;
	Tue, 21 Jul 2026 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660023; cv=none; b=bAKruqNioKeu+JDD+LXlZa+F4U2De0jfztLcFIJW1Q3PdijNQFOsnTyWftdl9E0pIgtfy5sfSThij2xseW5n8vMyGEQMLCz7UiJ8mFSI09nKbgYZ3P1mg6HTw76+UN4LSo5QQ4qrmV8tN1/C+A4IPpCc2Z//zBgP3mYk/PLte0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660023; c=relaxed/simple;
	bh=a/YCiVS1KtTozw6XlxBIyCZklCuB7VQz7ZJtxhHcpf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDoKNC1mvsNs0KshwlNVY3AozmjbDTjdgjiu1oUVEShAskdYIqU+H+sbfmhrWs08kfLe4vsh38PGW+mnpdA354iMIQ7tKsjDVZCzrQVNiPGemA8D4xLuOEjwJ00e0KLiJgoAFPQXVCGv7mqjHCFaX6nBR9O9+VAGuoEmiuwz49M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmCM62GY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmCM62GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EB71F000E9;
	Tue, 21 Jul 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660022;
	bh=shzUMMILg/fcAzKjPSMNHR1n/ZJ5vhKLdUcQlYIuADM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmCM62GYblEXscv8kUDT65flpJHuPaR1r6auUnxGv/YeLcG7KR5CpAAEavJ244EuN
	 lrNUHO2T7G/G2/6/TICxCvttGcF7mzPeGY21cntSoWhraWuwnLaXGTYQX9pyi0eGUD
	 VWmewu3qeSgR4xyThS1NQI/ztcAYjR+w/o2qugOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0820/2077] ksmbd: fix use-after-free in same_client_has_lease()
Date: Tue, 21 Jul 2026 17:08:13 +0200
Message-ID: <20260721152612.131316604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index b193dde4810dca..60e7e821c2455d 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -528,7 +528,12 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 
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
@@ -1246,6 +1251,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 			if (atomic_read(&m_opinfo->breaking_cnt))
 				opinfo->o_lease->flags =
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
+			opinfo_put(m_opinfo);
 			goto out;
 		}
 	}
-- 
2.53.0



