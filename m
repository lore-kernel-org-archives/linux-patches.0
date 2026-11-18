Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045951;
	b=gWbJVAcSZ32jqcaFkSPvG9leYWKKklwSsPwXCe/z1Wwk/0VGG+9Azan0xZaTXO7iyowI
	 JqLAEEDRW8FVqDIqJ4AaAx3Kq7UjVOUIokfsIHjgwOT3KoUlz0huNSTx4B7VqzKvmEU/n
	 8JZ/A4Uf5F2CApbbdiVfL8wZVE2Q2aMT2mdj2aYfT+0eCD9/cws+t1oRxMT6A9n8uVv3y
	 TnkkXh62eyQBh3jIyrlx9j+01k0TYbqEjUy7sTNWK2vHfXzKVVSfIyKqk4dUt7A4VJrHL
	 XR3+h/QYT0YpdalYkzYaRxtAHWPrqqVva1QlK/um3qtoX2DDwwuJcd+uaV0ZjWmFQKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5WWhqUNm433OdyOoFVAjLRdOE0q63KKkx6kRZ4ct9o4=;
	b=FvB9EBPhLv6NFjAM84J24wM1nYBnE5J3uJohQCTaPDRq7xKq3IVbmc2YKqbodG4ePepY
	 COIOwzp9VnJnmLfkSG0xaeRraWZaksSeCqI5fw/HKvPKHMVhGo4ThDfEXG4JVX/0hHDlC
	 DUMH6s4XVHcalk0bgH6dzFM9y90mma9NeTV+LIiudNusbSrTL8/zezVWTG125nmHXxrhE
	 rm6z4ToKK9n4Am2g6f2PhWaiTi2NND5jODeE3BF0A60R7K/wdk9ojQQyCgGiujakvEhJ9
	 8ksUyIOMCbITBF7LMSnBl4p1un0AXlJuLzUagdk4VlbJDOdcBuc+LdsrWzG1+4zfEQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=huvryaMG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE1D606A32C;
	Wed, 18 Nov 2026 23:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=huvryaMG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C651F000C4;
	Wed, 18 Nov 2026 23:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045951;
	bh=5WWhqUNm433OdyOoFVAjLRdOE0q63KKkx6kRZ4ct9o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=huvryaMGF2d2krYswobM6K74y40LYQy0WsWl/46R6KC+8YIU5aOUsJ5bHc7YYJ9kS
	 mmZPyQVDSEmgIVt95pvcSJmpgz5URx+5P0NBuj6u75ZOudkr6dj98geX87KKEzEoP1
	 1C7+cD+TnsP6zjWyrICMOL11GVq7LiNG6HmP8fLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1106/2857] NFSD: Set nn->cld_net before registering the cld pipe
Date: Wed, 18 Nov 2026 15:35:40 +0100
Message-ID: <20261118150241.457289157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 14996e662f3b734427e2d645cacffc27b779f7d1 ]

rpc_mkpipe_dentry() instantiates the pipe's dentry before it returns,
so the cld pipe can be opened as soon as nfsd4_cld_register_net() has
run. __nfsd4_init_cld_pipe() does not store the new cld_net in
nn->cld_net until after that call. cld_pipe_downcall() reaches the
cld_net only through that pointer and takes cn_lock without checking
it, so a write() that lands in the window oopses.

Store nn->cld_net once @cn is fully initialized and before the pipe is
registered, and clear it again when registration fails.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-6-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ sashal: Omitted the CONFIG_NFSD_LEGACY_CLIENT_TRACKING guard around cn_has_legacy initialization. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 2eebde725f71e..d91b912fb7d0b 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -1020,6 +1020,13 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 	spin_lock_init(&cn->cn_lock);
 	INIT_LIST_HEAD(&cn->cn_list);
+	cn->cn_has_legacy = false;
+
+	/*
+	 * The pipe's methods reach @cn through nn->cld_net, so set
+	 * it before the pipe can be opened.
+	 */
+	nn->cld_net = cn;
 
 	dentry = nfsd4_cld_register_net(net, cn->cn_pipe);
 	if (IS_ERR(dentry)) {
@@ -1028,11 +1035,10 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 
 	cn->cn_pipe->dentry = dentry;
-	cn->cn_has_legacy = false;
-	nn->cld_net = cn;
 	return 0;
 
 err_destroy_data:
+	nn->cld_net = NULL;
 	rpc_destroy_pipe_data(cn->cn_pipe);
 err:
 	kfree(cn);
-- 
2.53.0



