Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020836;
	b=eBH2xUL3+bpHd99NraMOL/d37M2BtSRhlVpW5aBNN+TNz4pkXezwLBEoLEtuk2COVb5w
	 +M0HzIA95rwV/pxJhDT2Pvp7zKPDpgcuzE1AnST8HE84pVuJSVQyqpchJ+p0dutbrCqlz
	 GrjkQgYZ7AtMyvpOHuzZ6qA4GH1lLhxA6JXTv508pORgf+nXFh9uPA8mclawNbai9cGU9
	 972TqhCmJLrUl7ioT+pPmzAYtRvALC/ZIKK/ppIHTbNGOEP+8C6Mkf6iBLc30dcyFgyPv
	 6nGGulGteG+USV68GAYpc/cZKH6gov/FMkN2JUZswDuBQLGcMfqGeH7PC5UfIvz3rhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4y9KUcexCzai5pxysNX1Wt2ZVKcqbWOt638JYSMAYs=;
	b=RMNMM9zRcFPK3jHSUYXUzwbjG4JjGyKl96EOC30KqDKKY+t9R7YRC4WndSxaUHhz49mI
	 IdjIt8kAB3QF+BSLCXkVSrXI3xfwvOrCtjFtiadftvu5h6k5CBSpBwhzIPobm2smCNrIH
	 nAknRap2x06lvieFwLpeDBC4Te9W4rcF03hJy6mPy2JEc3fBSJk8mRChGCxhk4AemvE2a
	 IbyPfMvggIAe9FCvvLLzSMjJsR4HM/i2c6yaZb1vVghmVA8/eUT4YvoEoqHIpvwZ8AMnB
	 Kyt2dFxg4lzHkb0CVY/KUGJom6/DCsjafhkO83X+ZBMr6lzie9QUc+yNW97bncJFXWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkszT6VZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39C660A2630;
	Wed, 18 Nov 2026 16:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkszT6VZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F351F000C4;
	Wed, 18 Nov 2026 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020836;
	bh=o4y9KUcexCzai5pxysNX1Wt2ZVKcqbWOt638JYSMAYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkszT6VZU+Je6YvJzbsqUbybnnJn0KM1VHJ8TlLcKXePWbl9EGoxbmBqXUhwHsdks
	 zj0wRb+1YpBNcVASKOopMkj6UUVjp+wn7EWS35uDZ9kaXezFsCNZgJdNjZKWNuFPvP
	 7PtrccvKVU65gdtBvcJpHuaN32VZSHBsCMJLhyIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2091/2651] bpf: Dont leak the inode when token creation fails
Date: Wed, 18 Nov 2026 15:55:31 +0100
Message-ID: <20261118150401.289590711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f52b699c88634d0161c97247e0f791a840eb868d ]

bpf_token_create() allocates a bpffs inode and hands it to
alloc_file_pseudo().  The inode reference only moves to the new file when
that call succeeds: alloc_file_pseudo() leaves the caller's reference alone
on failure, and FD_PREPARE() does not even evaluate the file expression
when it cannot get a descriptor.

Before the conversion to FD_PREPARE() the error path did iput(inode).  The
conversion dropped it, so each BPF_TOKEN_CREATE that fails with -EMFILE,
-ENFILE or -ENOMEM at this point leaks an inode.  A task that is allowed to
create tokens can hit this at will by lowering RLIMIT_NOFILE, and the
leaked inodes make umount of that bpffs instance complain about busy
inodes.

Put the inode again if no file was created.

Fixes: 981bec8f698b ("bpf: convert bpf_token_create() to FD_PREPARE()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-4-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/token.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/token.c b/kernel/bpf/token.c
index e85a179523f02..19660ef95ddbd 100644
--- a/kernel/bpf/token.c
+++ b/kernel/bpf/token.c
@@ -169,8 +169,11 @@ int bpf_token_create(union bpf_attr *attr)
 	FD_PREPARE(fdf, O_CLOEXEC,
 		   alloc_file_pseudo(inode, path.mnt, BPF_TOKEN_INODE_NAME,
 				     O_RDWR, &bpf_token_fops));
-	if (fdf.err)
+	if (fdf.err) {
+		/* no file took over the inode reference */
+		iput(inode);
 		return fdf.err;
+	}
 
 	token = kzalloc_obj(*token, GFP_USER);
 	if (!token)
-- 
2.53.0



