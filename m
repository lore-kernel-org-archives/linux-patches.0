Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A7117B50B;
	Sun,  1 Sep 2024 16:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209554; cv=none; b=U3EqzIedBelwwRD2ZsGgoo9U0xfo4tMq+T0j0LjgfP63Jqpq0moRNwTnD1giZCWxajgsk80SRgSVYCk6JY9PjmHTJJ2bix0J2SlZpRrZlKMINoGcVfd8zBROwFBTuxdoFgOddzpj2d3EnLp7xXoknzK4bcq9UL5NjkjF6o5IVRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209554; c=relaxed/simple;
	bh=K1WGFec9DvEtFCgavRSNrQ7QEmDbUnHsXAu0du0vtWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv3j9GjpD0Ym9wzxLjAEG+IMTicIijyLHpphrcv4WedjAv9g1WrvcRoScqng/LPZZtnH7Jaj4soZPhaQJ8GOrVqM1vrrGf++5hxqfGwSOT7taKO29TqD2OpjgKdDAjF+IUNvQBZ8Vf17Uq9kQkwL9vL9Ca9bDE1JdYxxCNUgdMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYqY3Gkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYqY3Gkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE57C4CEC3;
	Sun,  1 Sep 2024 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209554;
	bh=K1WGFec9DvEtFCgavRSNrQ7QEmDbUnHsXAu0du0vtWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYqY3GkwFPXuMOOsukP2x6+z0ig+QydyBAiaB9BKckEijaOeJtSLWn00cPrp6RNL4
	 1lU2tS9oIgmaEfc91B4AaR93oay83ji4qeHhUlPKsMSztVmrRmy6cXGNcRTuap1gkr
	 7ybFmdHLu2LgmNx2H/hNAPa7CNOpItdMmFScgQbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/151] NFS: avoid infinite loop in pnfs_update_layout.
Date: Sun,  1 Sep 2024 18:17:13 +0200
Message-ID: <20240901160816.861201174@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 2fdbc20036acda9e5694db74a032d3c605323005 ]

If pnfsd_update_layout() is called on a file for which recovery has
failed it will enter a tight infinite loop.

NFS_LAYOUT_INVALID_STID will be set, nfs4_select_rw_stateid() will
return -EIO, and nfs4_schedule_stateid_recovery() will do nothing, so
nfs4_client_recover_expired_lease() will not wait.  So the code will
loop indefinitely.

Break the loop by testing the validity of the open stateid at the top of
the loop.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index ed6a3ed83755d..f2da20ce68754 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2000,6 +2000,14 @@ pnfs_update_layout(struct inode *ino,
 	}
 
 lookup_again:
+	if (!nfs4_valid_open_stateid(ctx->state)) {
+		trace_pnfs_update_layout(ino, pos, count,
+					 iomode, lo, lseg,
+					 PNFS_UPDATE_LAYOUT_INVALID_OPEN);
+		lseg = ERR_PTR(-EIO);
+		goto out;
+	}
+
 	lseg = ERR_PTR(nfs4_client_recover_expired_lease(clp));
 	if (IS_ERR(lseg))
 		goto out;
-- 
2.43.0



