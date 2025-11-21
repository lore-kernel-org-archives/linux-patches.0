Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C533451A3;
	Fri, 21 Nov 2025 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731706; cv=none; b=lhmSHo/BP0lgaEjdoByPleJMVLbcAq+m7q/QrL+I44g5uQ3fd867OjF0X3ST4sfriZBRIwIL3UzIrWyrqk3U8I7F8HbDHur8PjWcFmamnpeuvmIdn3cp+oBzEqQjhQhTI68KKxsXedg0nR6GFEHQZKhgL92v+TdpA4X3aGnvZm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731706; c=relaxed/simple;
	bh=5aUlO81byvI7fNzIdP65RsUUUgEh/1a4yTKIfN5IdSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvSsCc5/KQeUzhFAw6HudmJs1+qkZC/wMYzZyql/AeWdL2tSvt3BiNUH6f+0Wy+LOUbL30qnoYGSq3Dd3Yz1QUW66B8VyLYgO194PI4VXjDx5mK1IVyxCIjjZaVppzxL52LTya8Cid0Z21yZ8P2Gt9GU4VCvzMdHbDinz6y7ONo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzzH5US4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzzH5US4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4425FC4CEF1;
	Fri, 21 Nov 2025 13:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731706;
	bh=5aUlO81byvI7fNzIdP65RsUUUgEh/1a4yTKIfN5IdSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzzH5US4Q2h5cEDcSaIdvhcO39c55bKSI9vXWyn2ItIHP22yi/sEGcM9VpjTX4dRH
	 jRgn/6/IJfwLC4t/eSCtHI94cHyeLnosmP/rvFiIUbH91EE9wPIMj/62TqTm0lHHtb
	 ipE646YlOygWvqB3H2CptznhEURGsd62MFa3VSQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Watt <jpewhacker@gmail.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/185] NFS4: Fix state renewals missing after boot
Date: Fri, 21 Nov 2025 14:10:46 +0100
Message-ID: <20251121130144.569365213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Joshua Watt <jpewhacker@gmail.com>

[ Upstream commit 9bb3baa9d1604cd20f49ae7dac9306b4037a0e7a ]

Since the last renewal time was initialized to 0 and jiffies start
counting at -5 minutes, any clients connected in the first 5 minutes
after a reboot would have their renewal timer set to a very long
interval. If the connection was idle, this would result in the client
state timing out on the server and the next call to the server would
return NFS4ERR_BADSESSION.

Fix this by initializing the last renewal time to the current jiffies
instead of 0.

Signed-off-by: Joshua Watt <jpewhacker@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 37c17f70cebe3..aaf723471228b 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -222,6 +222,7 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	clp->cl_state = 1 << NFS4CLNT_LEASE_EXPIRED;
 	clp->cl_mvops = nfs_v4_minor_ops[cl_init->minorversion];
 	clp->cl_mig_gen = 1;
+	clp->cl_last_renewal = jiffies;
 #if IS_ENABLED(CONFIG_NFS_V4_1)
 	init_waitqueue_head(&clp->cl_lock_waitq);
 #endif
-- 
2.51.0



