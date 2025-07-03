Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F7E2F432B;
	Thu,  3 Jul 2025 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555703; cv=none; b=df2DEZIMQP+/26AaWvCmbJZAMgF/FobhzkCsx4LRy9xV7WzT8pDKgtrcVpOidxIRpJrAciaPXlGTJR7aQK0+wZoe2l4Ug+SEPoLXQ9Iob2eidIG7UwWKlG19xTBjxype5yJy0ntZ1wDBAO4Cr42R03PzRlvD4mB2rmFazb5Wkpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555703; c=relaxed/simple;
	bh=l0o0KcFHuNRsMzdc1/LOX65Rag424vkqTc3PlE0dJtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FARF/ZoBzN77dYe9lQ0wfHUAkHLk5XYvrHrsvW3tOs5cdcBo/1m+OA3YV2v+AmPHH47skFMTCUVZuWpNrF1YUpvcIi8UI5N+TDCEig2ivzoELeeKZu2K1IE6yq+mFt6xZM1tLE2yBiaJsMVczbPT+AryHyloMz2Rls2I+3uaWmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=empksDap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="empksDap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ECDC4CEE3;
	Thu,  3 Jul 2025 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555703;
	bh=l0o0KcFHuNRsMzdc1/LOX65Rag424vkqTc3PlE0dJtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=empksDapWp/34B3bgujjVRfhKEf0PR2zPx5VdpwYzr3QdcHUNSvgKz3Szc37ej5Xw
	 urcp4sxNF++ylVl4VAOywUjgREISL5hu8+fHakSu+HAb2m7d+tidwaKlM86+YlaI8F
	 P2aPrTGo+M6k5nuk9E4bF3/w1dYc6KGd2fKV0lbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/139] af_unix: Define locking order for U_LOCK_SECOND in unix_state_double_lock().
Date: Thu,  3 Jul 2025 16:42:10 +0200
Message-ID: <20250703143943.787222643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit ed99822817cb728eee8786c1c921c69c6be206fe ]

unix_dgram_connect() and unix_dgram_{send,recv}msg() lock the socket
and peer in ascending order of the socket address.

Let's define the order as unix_state_lock_cmp_fn() instead of using
unix_state_lock_nested().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 32ca245464e1 ("af_unix: Don't leave consecutive consumed OOB skbs.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4f839d687c1e4..a6f0cc635f4dd 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -133,6 +133,18 @@ static int unix_table_lock_cmp_fn(const struct lockdep_map *a,
 {
 	return cmp_ptr(a, b);
 }
+
+static int unix_state_lock_cmp_fn(const struct lockdep_map *_a,
+				  const struct lockdep_map *_b)
+{
+	const struct unix_sock *a, *b;
+
+	a = container_of(_a, struct unix_sock, lock.dep_map);
+	b = container_of(_b, struct unix_sock, lock.dep_map);
+
+	/* unix_state_double_lock(): ascending address order. */
+	return cmp_ptr(a, b);
+}
 #endif
 
 static unsigned int unix_unbound_hash(struct sock *sk)
@@ -992,6 +1004,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	u->path.dentry = NULL;
 	u->path.mnt = NULL;
 	spin_lock_init(&u->lock);
+	lock_set_cmp_fn(&u->lock, unix_state_lock_cmp_fn, NULL);
 	mutex_init(&u->iolock); /* single task reading lock */
 	mutex_init(&u->bindlock); /* single task binding lock */
 	init_waitqueue_head(&u->peer_wait);
@@ -1340,11 +1353,12 @@ static void unix_state_double_lock(struct sock *sk1, struct sock *sk2)
 		unix_state_lock(sk1);
 		return;
 	}
+
 	if (sk1 > sk2)
 		swap(sk1, sk2);
 
 	unix_state_lock(sk1);
-	unix_state_lock_nested(sk2, U_LOCK_SECOND);
+	unix_state_lock(sk2);
 }
 
 static void unix_state_double_unlock(struct sock *sk1, struct sock *sk2)
-- 
2.39.5



