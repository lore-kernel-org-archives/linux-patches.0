Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ECE43D4E9;
	Tue, 16 Jun 2026 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631408; cv=none; b=Jk/ToHA5YO8akioLCEfYYirdP/hma4pb1sDqLroJprbYsft9Vh25vZIC4AqOpMjnhl8my8n2q1A08VWHS9bC+vvG7fs6zdxFBRoBmVGitU/Yy4jnA4iwPCORyk31auLIOqHFPXYpUJ2oNjW4JVZNiF7YBwnJVo4NVmL9dkYv2PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631408; c=relaxed/simple;
	bh=XktSxX0Cs0h0qigjb7tCv72GGNOjgMF6nXiVXY+lYC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT/u3qW6W04Ad6vXWF0fHtn69YzdTij0p5rkZBO9qbkkJH3/g2JCNTJB5DBWlUw2ZnJNqU6U56xsTr06I7m+iyRLXAVEGBUFnZSrG3rdY+8gO1pfbYliFIrBtnksz4kmT2QOzfeHA5FXcXuX+1UjpUWJUYDzFInxU9dq56Q4esA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0bG47g2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0bG47g2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191091F000E9;
	Tue, 16 Jun 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631407;
	bh=h5DemRsgbSmajC8yuXgycV2Xf/u54AOobFV1ZFcS9KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0bG47g2Yp28FWb/yO+TxEBcSSVRB9OQTEtDPihmaj6hq3hSylpa9CmMBUlUuynAp
	 BuVQaIL92lnw2ZzJvbf3IEhbaWAdwh93pZ731eULNkPfz21ijryyuQscLTQZJEMzEo
	 CvsmYaQTCS8YCaEmSCSb8logEzZeM9Tduf6Uuqis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/522] net: Annotate sk->sk_write_space() for UDP SOCKMAP.
Date: Tue, 16 Jun 2026 20:25:55 +0530
Message-ID: <20260616145135.793184452@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit b748765019fe9e9234660327090fc1a9665cdbdd ]

UDP TX skb->destructor() is sock_wfree(), and UDP holds lock_sock()
only for UDP_CORK / MSG_MORE sendmsg().

Otherwise, sk->sk_write_space() may be read locklessly while SOCKMAP
rewrites sk->sk_write_space().

Let's use WRITE_ONCE() and READ_ONCE() for sk->sk_write_space().

Note that the write side is annotated by commit 2ef2b20cf4e0
("net: annotate data-races around sk->sk_{data_ready,write_space}").

Fixes: 7b98cd42b049 ("bpf: sockmap: Add UDP support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://patch.msgid.link/20260529193941.3897256-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6c178b47426669..62411c8870e855 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2433,8 +2433,12 @@ void sock_wfree(struct sk_buff *skb)
 	bool free;
 
 	if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE)) {
+		void (*sk_write_space)(struct sock *sk);
+
+		sk_write_space = READ_ONCE(sk->sk_write_space);
+
 		if (sock_flag(sk, SOCK_RCU_FREE) &&
-		    sk->sk_write_space == sock_def_write_space) {
+		    sk_write_space == sock_def_write_space) {
 			rcu_read_lock();
 			free = refcount_sub_and_test(len, &sk->sk_wmem_alloc);
 			sock_def_write_space_wfree(sk);
@@ -2449,7 +2453,7 @@ void sock_wfree(struct sk_buff *skb)
 		 * after sk_write_space() call
 		 */
 		WARN_ON(refcount_sub_and_test(len - 1, &sk->sk_wmem_alloc));
-		sk->sk_write_space(sk);
+		sk_write_space(sk);
 		len = 1;
 	}
 	/*
-- 
2.53.0



