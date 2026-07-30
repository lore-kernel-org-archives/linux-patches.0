Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39894443A83;
	Thu, 30 Jul 2026 15:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423983; cv=none; b=q/DtQyli1oltfmBXBO7izIchPFXtL0UjjNFOMnIK2gOzKw6njbu8iYT9W0WH9UiCdnbO6Mrk0JXE7wA6kLpFdcaCFCVPhCSy2NvbbTb/z/N45X+9XAl4IVNLmZsE/bWq6v01nMMp/m5+BcWNEoIZ4QMMRkizRfjyddgySfm9Ejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423983; c=relaxed/simple;
	bh=gpYwytn+w1JdMfY0X20XJ2hEu/RpCtC2L9fqTHxejVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNOXtZaM6JU0QlhRInch5ctgL6HwWJwaCr/TMWgvsz8s472KHmTJVMUeJ9sgsZRtW/jIb/ulfPnXipeHkQm+gI+YW5wAOO/S5g9vYbXXXG1eOriY7ekTmrSuyF3bnI6O3ZafVd6hQ97gN4qHSzU+39sCBqheNyMLKhs/V+UHeYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWVXZxMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWVXZxMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AD31F000E9;
	Thu, 30 Jul 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423982;
	bh=RslPiTITpji4GdUaYbZl6Fe7azc29cM41mMj3lA1RSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWVXZxMzkvcUatCiYCYc1NjckLoNICxFL3swfaCcWKjq/EhWhUaRS7wIcw/xyQgyU
	 YvuaFCx2ha2LDGntV3/52u8ogvkV3Cby4KBjyyuh1kWVsVj4WXyiLAGIpMqtebCTrP
	 yMW+Juzb37zZGzKrXesactopsdEzb6jlzZR/A19Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/675] soreuseport: Clear sk_reuseport_cb before failure in sk_clone().
Date: Thu, 30 Jul 2026 16:09:25 +0200
Message-ID: <20260730141450.130899629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 98da8ce87dd561f08fbe44f75865edc5d9b2ba5f ]

When sk_clone() fails, sk_destruct() is called for the new socket.

If the parent socket has sk->sk_reuseport_cb, the child will call
reuseport_detach_sock() for the reuseport group.

Let's clear sk->sk_reuseport_cb before any failure path in sk_clone().

Note that this was not a problem before the cited commit because
reuseport_detach_sock() did nothing if the socket was not found in
the reuseport array.

Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260709032007.9E4D61F000E9@smtp.kernel.org/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260709183315.965751-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index c52cec0bf942c0..9803926942c559 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2525,6 +2525,8 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 	cgroup_sk_clone(&newsk->sk_cgrp_data);
 
+	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
+
 	rcu_read_lock();
 	filter = rcu_dereference(sk->sk_filter);
 	if (filter != NULL)
@@ -2547,8 +2549,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		goto free;
 	}
 
-	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
-
 	if (bpf_sk_storage_clone(sk, newsk))
 		goto free;
 
-- 
2.53.0



