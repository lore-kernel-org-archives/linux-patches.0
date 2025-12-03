Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575AC30F7E4;
	Wed,  3 Dec 2025 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776521; cv=none; b=SpdEyohHOP8wrWFXB90efDHw/XLM3EPTaYdFPdMNiytSGos/hdLotYvl1ArhYblbnKBIPLzmQbLFdwPQubcNPkksLDLwCeyeEXihH+9YYy2qWnDdgz2anIC20Q9bEMb172Wjw0TGmxGQmuiL899QSbrS/YJ3kQ8WBHelDR43mjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776521; c=relaxed/simple;
	bh=JBEyMXp8DEdLg51aWBN7TkjPqr4Avhn7aVQ+cbr2hlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS/Ul+CqI55pPya0IsaypQa5Rkk3XRVBX1c/VOd8HOXDIq7t7LowOGsr3et3TsA4bXbd9h5nQYKfuiSv5vcz/UW/+EnKakKtrbMQWC1e6K2BTrVK+MZlaKigbZqYYGyFv8klO/HxjO8OTqmb/jgdItPrDbc+Bya6uS+xJqYBdVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3qtGzUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3qtGzUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F56C4CEF5;
	Wed,  3 Dec 2025 15:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776521;
	bh=JBEyMXp8DEdLg51aWBN7TkjPqr4Avhn7aVQ+cbr2hlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3qtGzUsMQCBaHqF8p7Nsv9fG/JQw3PrBVD+iWTVFNd5zWrKK9H1ABL36K0Sr6jc9
	 7dvQLIlUl1AbtNDjHSDy6EnAhsEGHMMkjXzZ324bccoLsAcLHk4MpmyPFhpVQj7I6B
	 c1R5tgeWmCJzgnOMncTmM2TP8b12nx4HnLV2Lw38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Watt <jpewhacker@gmail.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/300] NFS4: Fix state renewals missing after boot
Date: Wed,  3 Dec 2025 16:26:19 +0100
Message-ID: <20251203152407.109136515@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 89835457b7fda..5fd63df2db8b1 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -221,6 +221,7 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	clp->cl_state = 1 << NFS4CLNT_LEASE_EXPIRED;
 	clp->cl_mvops = nfs_v4_minor_ops[cl_init->minorversion];
 	clp->cl_mig_gen = 1;
+	clp->cl_last_renewal = jiffies;
 #if IS_ENABLED(CONFIG_NFS_V4_1)
 	init_waitqueue_head(&clp->cl_lock_waitq);
 #endif
-- 
2.51.0



