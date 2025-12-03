Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84931352FBB;
	Wed,  3 Dec 2025 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779722; cv=none; b=J4WXllM15d8yv1WJ/fHCiQZryQNtQug3LoyTrvpD9TfBLVKsDHLPh9r5/e65mx6SZ1qcIbWdNLK4NGswf2Y8NZHG6MI4Pk/qppBGym/Ydj4rDG8KKQty/WAgV7MMjyidVS6lajkOyf2ENFU0vy9Ewb/YRE+Ol3rQ4xReEGRa6S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779722; c=relaxed/simple;
	bh=BbevHUn2fCDgvPtPXTZPw1xw6ftRt4NcgHqRHAnB8Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObB3M4PROLbBrbRb9fASOheVXVse6XU9n7C/bBr7BhnGSekPqs0VfIRGA02CMp8PSFhc4CxHX6P80fV3WKfEwQZ/cPtjYoWI1Yv14Nf2TjTd5CxYnoMChd6mmvaoYx1B6ZLjL+nFrd8nhcIA6vA9tKIiotwxs+jGHAg8zFdPIyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTGGkNPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTGGkNPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BEFC4CEF5;
	Wed,  3 Dec 2025 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779722;
	bh=BbevHUn2fCDgvPtPXTZPw1xw6ftRt4NcgHqRHAnB8Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTGGkNPljQrEor/fFM2eOxo9/aIlDGuVlT/eIXj5zEHNGXlzJoJLvKlcImc96C/KS
	 6YHxsk6iYsY26pt3qqlykokYa01+bjSVMEFY6Zn91S8UFyanhLE2s9GaqLKj3IBjyT
	 sfVllVVOo+5yKuUMhRfUdSt5NqeEVJ7YnFcj/TrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Watt <jpewhacker@gmail.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 341/568] NFS4: Fix state renewals missing after boot
Date: Wed,  3 Dec 2025 16:25:43 +0100
Message-ID: <20251203152453.196173498@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b14e4af25d37..4cb405e343b83 100644
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



