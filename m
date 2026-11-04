Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831775;
	b=oC3km+qUthpZRga54h8W5+5X/pZ3i9PWZr1z1RTHqPnKvThSXk5MqflCm0j+mqrdOJ9A
	 AtCiTtFECwVELnH6/MdStGs9cSHM1vAkRSL1vaAd/7uQgGOEQi2nn5UupC5Kfar51IVNc
	 HN7dJXC4iy9zjzLBDMNW0Yeo5P86FvpBDzIPrbpedON95d2oqaGU7KroRe0USLcNAENa5
	 SzYw7l4R8MBA0+b5offzY+sCrIfLCpVo1pAfb883pUxH0V1SKLO72KblE+catMCWYCX+E
	 AaNRmNraHzHiNY2wxnW4xc1grO78L72Jn1ZFEuedHT6NnM/RfkIN3YPJy1MB2kkvhAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ObCkWw8ZzuZ+KBJmjetzKMgz9TZGWuLliaoOueXYC/E=;
	b=Iqlg5DFA5opWbi+euImxcqU0VGKqWTHZPBbSbgp56krEbLaTn6mWb1Rdzo8HJsYoclKz
	 m/d+kwsrtEsjQxE05nIWjBUMwTRXQh3x54I5UE8k3rjp4cODYAlXrZN9Btm9HDMjxuZD2
	 edlpRvtddekIG0cJ7ETQAGw8rls3YilQGKPo3gT6rMs36moKnCnS/oi1OClLiWz1lymzF
	 9P9Wcxlji9UfE8WmnbGm+GI4NBpNEtKEd6mY/l+JRQ2EvB/xrjyRLvi5hEiSAod631FCH
	 0UYgIUIY/9KAAT56F4ndACTJ2o05A0p2rbnnKlQX30dyuM+Rt0nNXBgPXpzPzSPAC2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KiGBfr/y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6981A606A326;
	Wed,  4 Nov 2026 22:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiGBfr/y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DD11F000C1;
	Wed,  4 Nov 2026 22:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831775;
	bh=ObCkWw8ZzuZ+KBJmjetzKMgz9TZGWuLliaoOueXYC/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiGBfr/yMoUKzSnmJn6KF58nkhxMqnVZhYd/8aHMIcUZ4eYVCWNv90nNUGNWaA+n5
	 0yxiJAUxJDw0cRbLGAM5aeW01HzO5C4Sk8w7rSs97eN/1iWCaRFcP2XLdkKNlv9h+h
	 S0+D8pm+ZZvKTz0MsfWMN78IoPmghEDo3LqZeSu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0904/1005] NFSD: Set nn->cld_net before registering the cld pipe
Date: Wed,  4 Nov 2026 16:10:37 -0500
Message-ID: <20261104211108.508784175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 14996e662f3b734427e2d645cacffc27b779f7d1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -999,18 +999,24 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 	spin_lock_init(&cn->cn_lock);
 	INIT_LIST_HEAD(&cn->cn_list);
+#ifdef CONFIG_NFSD_LEGACY_CLIENT_TRACKING
+	cn->cn_has_legacy = false;
+#endif
+
+	/*
+	 * The pipe's methods reach @cn through nn->cld_net, so set
+	 * it before the pipe can be opened.
+	 */
+	nn->cld_net = cn;
 
 	ret = nfsd4_cld_register_net(net, cn->cn_pipe);
 	if (unlikely(ret))
 		goto err_destroy_data;
 
-#ifdef CONFIG_NFSD_LEGACY_CLIENT_TRACKING
-	cn->cn_has_legacy = false;
-#endif
-	nn->cld_net = cn;
 	return 0;
 
 err_destroy_data:
+	nn->cld_net = NULL;
 	rpc_destroy_pipe_data(cn->cn_pipe);
 err:
 	kfree(cn);


