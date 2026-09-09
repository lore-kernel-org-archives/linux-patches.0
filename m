Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24587566C73;
	Wed,  9 Sep 2026 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964564; cv=none; b=B1L8F2LOFCOxeVJKIwNDi3vHSWiAXadTjsioukjsEYieMheHyAEGvcHidMRPIMWOqA5ozdQ8NiJgOhGzbTAyHMtT1vzt6aLvY//1ubk2QLd07j5mqtovmyQ6/MhSnIZHPD6W/JPMWPcoL0grc0gyUf3HobOtdfBe0JbSS1BlqQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964564; c=relaxed/simple;
	bh=EkkZ+znGD7ab1OqIhG5L+HvhPJc5XCg9vEO67gbPFlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8bWBKuwyZOO+bNlAISsSgVSHU+IWnEm8w6lViQKJDTCye3O01RFK1gvaaNIcKiRkVmJYgv3r1MIxpaDBBUf7qMkDgWcTnVXdt9EmBt84jHMM0rCN33wGEwTg+G+VF0hjPvKYWxbCI3dGmjwRuwT75vx1/f5S1SxOQPlWwAVyQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APyc79+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APyc79+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF201F00A3A;
	Wed,  9 Sep 2026 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964563;
	bh=tTPv5jWS5VllFY65lSnl3bLLIe8AaKkSlx4iUe40rOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APyc79+/c3IEITgj96VZpW36qMhCgBub7j7uXT/okDp3W/XnxQBalJ+8hRNeI+U4U
	 SwOUm6VtGLkDHzZz/njzXdw35ccTcgqrA870uh4+4EE0AtyadgxEB2uT9/JvYDxAil
	 ZZTL/HoMCi5yMnh+yCRmuoG1LG+ymQq/S4sCVUa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XIAO WU <xiaowu.417@qq.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 465/583] NFSD: Guard admin state-revocation walks with NFSD_NET_UP
Date: Wed,  9 Sep 2026 15:42:30 +0200
Message-ID: <20260909134254.006871355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 2f3e6638aebc0ab8afb8b4e9816ea9a1cad85378 ]

Writing to /proc/fs/nfsd/unlock_filesystem, or sending the
NFSD_CMD_UNLOCK_FILESYSTEM or NFSD_CMD_UNLOCK_EXPORT netlink command,
walks the NFSv4 client hash tables to revoke open state and cancel
async COPY operations.  All three handlers gate that walk on
nn->nfsd_serv, but a listener added via portlist or netlink
listener_set sets nn->nfsd_serv before any nfsd thread starts.
nfsd_startup_net() has not yet allocated nn->conf_id_hashtbl, so the
walkers dereference a NULL table.  A local administrator with
CAP_SYS_ADMIN can crash the kernel this way without ever starting the
server.

nn->nfsd_serv is set when the service is created, which precedes
table allocation.  NFSD_NET_UP instead brackets the window where the
tables are live: set at the end of nfsd_startup_net() and cleared in
nfsd_shutdown_net() after they are freed, both under nfsd_mutex.
Gating the three unlock paths on NFSD_NET_UP fixes the startup-time
NULL dereference while preserving the earlier post-shutdown
use-after-free fix.

Reported-by: XIAO WU <xiaowu.417@qq.com>
Fixes: 1ac3629bf012 ("nfsd: prepare for supporting admin-revocation of state")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260621162551.2469460-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ adapted NFSD_NET_UP flag check to the older nfsd_net_up boolean ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -298,7 +298,7 @@ static ssize_t write_unlock_fs(struct fi
 	error = nlmsvc_unlock_all_by_sb(path.dentry->d_sb);
 	mutex_lock(&nfsd_mutex);
 	nn = net_generic(netns(file), nfsd_net_id);
-	if (nn->nfsd_serv)
+	if (nn->nfsd_net_up)
 		nfsd4_revoke_states(nn, path.dentry->d_sb);
 	else
 		error = -EINVAL;


