Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07613770B;
	Tue, 21 Jul 2026 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666317; cv=none; b=HMCH7xXneh2beTeM84dTRBlWo+ZPPT9hYVv9H2fIn37Yt8teyDENzFiFKG3YjoQctbtxKzldat2bzoI5xDDLVF/ARTlftG4lhKjWapIC8pWbGQGNCiYaocIawEwWzlsbu8p2VeUVEgAapyXEmZMOqT9Kv5to1HXPHuUpujg+C0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666317; c=relaxed/simple;
	bh=felRFW/vQ5gl1Tq8lqm2XTcYQCX8bhtZzZn0vjq6NNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/R0k6QqAfMZKacOnrfjd9jnWlEyilm5/gcyNtunN0UCNhdZbcYxE8e/h21/0hzH0p77B/JrDSSghXwxdd8ToDBS2DgGV9aDrgWq8bZ3ULtw1qa5vuxgqVXF9T88fQTVpPztH1GOV2OCXQyzHBopd0xyUoS/BXvXWDr9soOlvq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9o8CZFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9o8CZFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210771F000E9;
	Tue, 21 Jul 2026 20:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666316;
	bh=LEHZRpVs+RnBETElb+Cf9XVwomLMZpcKx7x8hPZyuUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9o8CZFWrQmIBgXpLisqFtbfg1MbL3KyZuMQLOmtEcSj+nm5JJ1HDoeNqSOkoEFvJ
	 okU4np76aXIqipRNXQ9PMot+yY3Meh1QeBxMFJoMvS0P/ySAnvWpQd+WveNRhQxcKs
	 LqYHVcKHULuhFJXW5JvcVEMsNEbU7RZolOYqBji8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0600/1266] ksmbd: fix use-after-free in same_client_has_lease()
Date: Tue, 21 Jul 2026 17:17:17 +0200
Message-ID: <20260721152455.290031998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index bba17ea84023e2..1d2e06e34a9a35 100644
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



