Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DD68825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA060C4339C;
	Fri, 10 Mar 2023 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460317;
	bh=qwUBdG8xZboNESHoMBvDNXSqcCvEXTikOhggrdfOQ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijF4Ll1zyrv5dy/utC62ki0AxQR+a6HvWitQl7Zf82iBstBrFzlncXglSg/mobUP2
	 pCNOKZLaHnYk5gYp0fz2ziCtJVSrP/j6RHidl5wKNXk1jK7aYsQufZGyrQ7h66VDLC
	 V3l1foN4/01FJ6Oki1DmwFlgxn2PHsI+M2aWxtOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/529] inet: fix fast path in __inet_hash_connect()
Date: Fri, 10 Mar 2023 14:37:18 +0100
Message-Id: <20230310133818.640441343@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 21cbd90a6fab7123905386985e3e4a80236b8714 ]

__inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
equal to the sk parameter.
sk_head() returns the hlist_entry() with respect to the sk_node field.
However entries in the tb->owners list are inserted with respect to the
sk_bind_node field with sk_add_bind_node().
Thus the check would never pass and the fast path never execute.

This fast path has never been executed or tested as this bug seems
to be present since commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), thus
remove it to reduce code complexity.

Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2615b72118d1f..79bf550c9dfc5 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -760,17 +760,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	u32 index;
 
 	if (port) {
-		head = &hinfo->bhash[inet_bhashfn(net, port,
-						  hinfo->bhash_size)];
-		tb = inet_csk(sk)->icsk_bind_hash;
-		spin_lock_bh(&head->lock);
-		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL, NULL);
-			spin_unlock_bh(&head->lock);
-			return 0;
-		}
-		spin_unlock(&head->lock);
-		/* No definite answer... Walk to established hash table */
+		local_bh_disable();
 		ret = check_established(death_row, sk, port, NULL);
 		local_bh_enable();
 		return ret;
-- 
2.39.2



