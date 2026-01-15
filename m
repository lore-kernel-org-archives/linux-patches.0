Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F68518AFD;
	Thu, 15 Jan 2026 17:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498695; cv=none; b=bMPrE2qPtvYIJi3ecKgw8JCDXs94XjAtLIinC7YfiBfeMzTwEcfaPxSJbP2r00Agwn15mrVkwm45x2PW3yIz6XXhSYej2SXRcHUvGvH+a0QLVZK4mTifittjEr7rjXm8jizcFu8Qhy+X5vYqyLitSGdR498jteWtrfcX6AHZ/lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498695; c=relaxed/simple;
	bh=RdgZacMSIDBNdynGtaFkEjLMoR36pQ5hnCngPwgf+pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NS2AUHTWBhq27GxnMC3MjHrReQ3hLJpGI0BuXM5o9RKw7QWOXI+A2ge9f6B7/FunGK2UNNW2ukP8++5mChjGaeY7uA0U+gKp50Ir2DAY1fpbG1ltPV1TGQvv1ZCSI4jh66KvA0zSHmuCHqfl1gwFrFcFhWfy2NEw2DN+XL3E8pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVK7rNck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVK7rNck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10A8C116D0;
	Thu, 15 Jan 2026 17:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498695;
	bh=RdgZacMSIDBNdynGtaFkEjLMoR36pQ5hnCngPwgf+pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVK7rNckQmTNk+kXS4gG+LXSjt8wSB4bP2+bhXzf/eypmzicyGKbXI3Zp4kuJ42bM
	 tivmbbg4lFpviQVK0GqL2SZhdwB6SmmAB860ulAzu0xOwPMXemsyDLhRk4b+bfcvh3
	 aHyB3JlgOGICGF2WpHlasf8Eq7H9y3DEWmugK8SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 520/554] NFS: Fix up the automount fs_context to use the correct cred
Date: Thu, 15 Jan 2026 17:49:46 +0100
Message-ID: <20260115164305.151452953@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit a2a8fc27dd668e7562b5326b5ed2f1604cb1e2e9 ]

When automounting, the fs_context should be fixed up to use the cred
from the parent filesystem, since the operation is just extending the
namespace. Authorisation to enter that namespace will already have been
provided by the preceding lookup.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 8fb570fd376a1..6367f067dd7be 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -170,6 +170,11 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	if (!ctx->clone_data.fattr)
 		goto out_fc;
 
+	if (fc->cred != server->cred) {
+		put_cred(fc->cred);
+		fc->cred = get_cred(server->cred);
+	}
+
 	if (fc->net_ns != client->cl_net) {
 		put_net(fc->net_ns);
 		fc->net_ns = get_net(client->cl_net);
-- 
2.51.0



