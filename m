Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C5338E121;
	Thu, 17 Sep 2026 19:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671628; cv=none; b=dgYJKIP5hemx1nz++/fojResON9IqBIuvLPZpzDpSuu+ZOW5iLt3EY7gO35wDk/ZTs4s81AcwCAlUBB4GEi/d6OvqaVMa/06BzXdz16J3LkNkKPa8P/g55rUuhAqo54KAxUfkqMnd8Io3tZ1DtAE4nj3451fDawb5YwBFCDIdGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671628; c=relaxed/simple;
	bh=xq2xxz3D0pZJ1oZu3QyljELHTM2pBDMcrfCAdBCHBuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baMK+hXQf/xki9E+M0XL5EJq3XDrfMEp9zmMAbOYdPCyPYJJQFh49ByvXaGEXdcgXpeuZeKgETXwyCXsR9VUigyduiDnidi+g6ADuKY01O4Uklc2nrHO0XN03VmgjkOpI/G0fjij/Oam/1PseR0i9LbEDmqnMMH33v2PDo2a8Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTNokes2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTNokes2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795601F000FF;
	Thu, 17 Sep 2026 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671627;
	bh=mYNX1MCCPvjpi80poSLuHBSbc1QHswaLi6R9NCKv7Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTNokes2wGlP6zsQDlWwjEhF92QW1hJbDzmSZ9SLAwo00uNgz/te/Pv2YiebmvHsw
	 9pqY1hCgQZLmBc1btQM/UgIAyJFBKxoUfLUDV1dd+caqpnvH6wwawxuGyTK4R+3sQq
	 Tx7B+TONZ+1cFgQaXHHPrTI46c+hp6MzxTnW8IBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XIAO WU <xiaowu.417@qq.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1037/1102] NFSD: Guard admin state-revocation walks with NFSD_NET_UP
Date: Thu, 17 Sep 2026 16:16:20 +0100
Message-ID: <20260917151606.820502230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -301,7 +301,7 @@ static ssize_t write_unlock_fs(struct fi
 	error = nlmsvc_unlock_all_by_sb(path.dentry->d_sb);
 	mutex_lock(&nfsd_mutex);
 	nn = net_generic(netns(file), nfsd_net_id);
-	if (nn->nfsd_serv)
+	if (nn->nfsd_net_up)
 		nfsd4_revoke_states(nn, path.dentry->d_sb);
 	else
 		error = -EINVAL;


