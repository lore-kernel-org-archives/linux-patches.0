Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C96B3B9D9D;
	Tue, 21 Jul 2026 22:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671763; cv=none; b=I1Y5gkLirV+ptDpIvi0uaJUP3/kJtft0zZRxHnpPSoyOTuYbV/2filNQueXItRf09OPnz6Md/9rsfR/XjQ+dWNpRc+cpWG3wKQMTwHDI5NCnjLULFVmNKYqo1fCj2NgVjQsZqAt6PQeZFmabvIFcnfv+Nf7yXp26uGSEoJstZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671763; c=relaxed/simple;
	bh=brZ9CxziyYc+HIUFv8bB1kv7uvLnIv9PCtpRyC/Rnas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIdpsyoPbNNxS7enl+fEXd/xLlnkgybC9SlYzr9FncxVabj9ur+oMFqjWRBZnRsd3SnWl3Mdo99WpJRji28lM+qCliVtCgT26PLzOFhAh8NhMyxxCMTjkM2/D8Nmhl3v6bgy3SvsnUjYd+4m8idVZiR5fxZ7RIxOsXt36LieC2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTX7fcVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTX7fcVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6821F000E9;
	Tue, 21 Jul 2026 22:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671762;
	bh=Gc2k8cWBoxgryTOxpanvElxE/crtyy30TsfqU6IBeeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTX7fcVOCW0w8A7FXx4ifrV2qRCMEJil68MkVWFGcfdVecp9nuhkIm6HX/tSdGpUe
	 QTqIxh1MvY00o5KGCvRIKYOf/GInvv0MoG5P9dyp1cV14//NYY2BDQ0gq0yVYLTbwJ
	 aVbLtu8wfYbhlVKnsuaLWqwfK3t5m0/nQICN5d1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 370/843] ksmbd: fix use-after-free in same_client_has_lease()
Date: Tue, 21 Jul 2026 17:20:05 +0200
Message-ID: <20260721152414.356563460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/oplock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 9fcdcea0e6bd84..84c4f656eedbd0 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -534,7 +534,12 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 
 		ret = compare_guid_key(opinfo, client_guid, lctx->lease_key);
 		if (ret) {
+			if (!atomic_inc_not_zero(&opinfo->refcount))
+				continue;
+			if (m_opinfo)
+				opinfo_put(m_opinfo);
 			m_opinfo = opinfo;
+
 			/* skip upgrading lease about breaking lease */
 			if (atomic_read(&opinfo->breaking_cnt)) {
 				read_lock(&ci->m_lock);
@@ -1237,6 +1242,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 			if (atomic_read(&m_opinfo->breaking_cnt))
 				opinfo->o_lease->flags =
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
+			opinfo_put(m_opinfo);
 			goto out;
 		}
 	}
-- 
2.53.0



