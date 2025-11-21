Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AB1274FE3;
	Fri, 21 Nov 2025 13:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731150; cv=none; b=MbpPUOO0ZFkixHi7Sp5ZbRNFrYfDmU/lX1atsdxiyUIe+Z4o9O7Fw9hlGo7o8jo9RSAV26+wR5AHcdvAwzA70bluJnHXn/8aGkGE3hGfIfYddWbsPAqsHVmnqDJwY+JwO97UHcsw+GVsmQYqWcl0tBdE2YW2pbNR6hXKrlu1gnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731150; c=relaxed/simple;
	bh=o5d5O7Q1K1A6W1tcSX98hXurm9rJZvayEs5MTDg+w9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR47FRlOj6X4rtsqy0tgy8RE1J81oW5UNWSKNqDCGpwHlvqIje1nsq0rG4VCW/i2ZjXj0sTuZ1Oc7IJy6K6MFDYTetoJyRiJ2NiQqHAnm0DoPY/X2pa8eMQkd12O4wO6OFxnji5ze3pGhydGq9gii4cgJtulgYuTQD3B7txdjds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Su2HXTcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Su2HXTcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7757AC4CEF1;
	Fri, 21 Nov 2025 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731149;
	bh=o5d5O7Q1K1A6W1tcSX98hXurm9rJZvayEs5MTDg+w9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Su2HXTcTMuMQkr4dbItsU3EDu/UprBTeVJM9hgPisOyetCLtHcFYGIKKhQPEtOjfd
	 8yBBvx7+z8m64+hNjSw7NNzRMbbGEH/0LJ47RK+BqQb2EeQGdH4kZlDukv57wdSRv8
	 vWRwNKPwZJfisOXeZgeTD9l6MorqobJpbWusyoaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 107/247] NFS: Check the TLS certificate fields in nfs_match_client()
Date: Fri, 21 Nov 2025 14:10:54 +0100
Message-ID: <20251121130158.427552459@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit fb2cba0854a7f315c8100a807a6959b99d72479e ]

If the TLS security policy is of type RPC_XPRTSEC_TLS_X509, then the
cert_serial and privkey_serial fields need to match as well since they
define the client's identity, as presented to the server.

Fixes: 90c9550a8d65 ("NFS: support the kernel keyring for TLS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 4e3dcc157a83c..54699299d5b16 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -338,6 +338,14 @@ static struct nfs_client *nfs_match_client(const struct nfs_client_initdata *dat
 		/* Match the xprt security policy */
 		if (clp->cl_xprtsec.policy != data->xprtsec.policy)
 			continue;
+		if (clp->cl_xprtsec.policy == RPC_XPRTSEC_TLS_X509) {
+			if (clp->cl_xprtsec.cert_serial !=
+			    data->xprtsec.cert_serial)
+				continue;
+			if (clp->cl_xprtsec.privkey_serial !=
+			    data->xprtsec.privkey_serial)
+				continue;
+		}
 
 		refcount_inc(&clp->cl_count);
 		return clp;
-- 
2.51.0



