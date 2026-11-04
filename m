Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829028;
	b=ik5c7X07ZkIYkau46+htBNGFJm1rFxATc7ye6UUB3mcQ4/cVd44eYKTqKI6SEuqBCuKQ
	 e5Ld6jJ+35ySNrS9UPHzznzrZTvxoKtBRbHNYM4N+0Pw5BNBdI0I8dCc5EhsosicxKGN0
	 VOTbwYRCa42ESk314wrjvDtPJlymJDQvhRpT9UE062t00yCEF+rdok9+ySaJARrHUx5+8
	 /KJfUCe+SwezmQV28acTjcRhLyKhbLmjHYRxwlZtzsyOHNOrQY1kU4g9XbgGzyTUPfQ98
	 ETtWDvSTXI4bImAsqWFGsxgDh6T4MnQV+EcfayzK8siGegWa9Gty52GbKWjui8rNsPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kLb0t1bU93cpmbh84sD9NXVlcEQdGgGLoqM59KoUN4s=;
	b=ohufHiR3nzS8LknCTGnWihM6i+FH0F94QpiYWtCmuwz9emc91gaOwG4qKNx0+DTXsD3U
	 Z3rvRlHBo3Em8lN3bNiJpZzf0ZVUUaM70aNucxBkdgJX6FmGdPYhgFriV6yn+2QOOZXE8
	 DxnK4aG59Ea3KcAqHmVS6WjbqPsyOIcFcaW8ELPRPmURW1j/Ls5NC3y9frwGdQvuKzQ8d
	 z2BlNTuoeYvLIWxd2KF1iSDLR7c/iam0cukkE2TbDiCxkgBV97Y6i7RcVDr3Zgu4RqJaH
	 1gdcvuvlAru4RBiDyohfxF7AiMVTQEfXf9/sHh4VXfvH/FSUTybPBU0mLJtKc08/3RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUszRDxI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1EE6070745;
	Wed,  4 Nov 2026 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUszRDxI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1A71F000C1;
	Wed,  4 Nov 2026 21:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829028;
	bh=kLb0t1bU93cpmbh84sD9NXVlcEQdGgGLoqM59KoUN4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUszRDxIUpkrtK4eo3rj2uu2J6rEkDO3whz4Qia/1E6LWIE+rB9Cz/LNlWw7DS/tM
	 nxekQ/fx1VQeZFgVXQTrgGMGGg80yLSOu3NN921CZyIEYAfEOdAvNCfplX1UiL306j
	 0BZG+JxwWkzv4tQl4cNVnCG79hCKuXtI1HezTPVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 7.3 399/547] NFSv4: Fix a regression in the handling of CB_RECALL_ANY
Date: Wed,  4 Nov 2026 16:09:43 -0500
Message-ID: <20261104211049.645424087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 25dde935988bc0cc2991cedbea90a2ce65066d54 upstream.

When the flag NFS_DELEGATION_RETURN was replaced by the
server->delegations_return list, the test in
nfs_mark_return_if_closed_delegation() was replaced by one that stops
all further marking of delegations for return when closed as soon as the
server->delegations_return list is non-empty, breaking CB_RECALL_ANY
behaviour.

While the intention at the time was probably to check if
delegation->entry was non-empty in order to emulate the effect of the
NFS_DELEGATION_RETURN test, that is no longer an option, since
delegation->entry is also used for the LRU list.

By just removing the offending check altogether, the patch can end up
moving delegations from the server->delegations_delayed list
prematurely, triggering an early retry. However that should be mostly
harmless behaviour.

Fixes: 0ebe655bd033 ("NFS: add a separate delegation return list")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/delegation.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -934,8 +934,7 @@ nfs_mark_return_if_closed_delegation(str
 {
 	struct inode *inode;
 
-	if (!list_empty_careful(&server->delegations_return) ||
-	    test_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags))
+	if (test_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags))
 		return;
 	spin_lock(&delegation->lock);
 	inode = delegation->inode;


