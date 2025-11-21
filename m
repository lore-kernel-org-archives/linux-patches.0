Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3AC3358B7;
	Fri, 21 Nov 2025 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733300; cv=none; b=U4cPwhFu7VlIzBaZSQa4PUtcPI0hz+fIEJneZXo4ZMRGHidzzgfiiz8r0G7+mudTXx/I8FsPid47BT5Fr77OzZrgLSbNMNrS9QmiBf/iHW664Z2NlRuFBSzYcQpoLAhd/YViL4HESIJQMEDftmbZIIlXJtspOncnwT70o4JQtDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733300; c=relaxed/simple;
	bh=guKnSdDZk4mBeTK3CkiTkGe5mSyIWVsp7c5Vg28Xhys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2xExcnTczTKp7f22IzLrp8UYSnXIVcRv2FuZqLUnHucLM60ZAONBe1HAVTNxnY1em8Sk6ckc0GnkPJmnT7w1I+MdJhadhYRcNaV467r4ej65FgHuUvQMkr4MXzmI/qlqQDQbJ7RaSvxTXaC762BNxbbax0b69PMbx5CJ+NDPd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9/dRv4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9/dRv4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2639EC4CEF1;
	Fri, 21 Nov 2025 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733298;
	bh=guKnSdDZk4mBeTK3CkiTkGe5mSyIWVsp7c5Vg28Xhys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9/dRv4BeoAFML+jN/uuSy4nYG2Q4rB7JOPQrGqqJMNGu9hum2a4JjYWTQzkyNnep
	 kXm2PDYKsLjVProGMYK5WtK4z40iDhJ4q43CyrHhH8XGKrhrst6jdGEswSTyEijqBs
	 +YjVZ7BQKoDXIWQD7x6fY1TvqwvcVuQku4/HelFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Watt <jpewhacker@gmail.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 387/529] NFS4: Fix state renewals missing after boot
Date: Fri, 21 Nov 2025 14:11:26 +0100
Message-ID: <20251121130244.792979828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index f6dc42de48f03..32b1147fcafc4 100644
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



