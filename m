Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF9C14293;
	Tue,  2 Jul 2024 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940134; cv=none; b=GxsEb/XeqUpfbH8SHWRbUH2Kbv8Y4GTFecFaZBmiH8ZzzhoaRhy5TYZcYCdPNFMiNd4PAXJNLJyKBAc2oRlAYXlytsoox27mXg+BkB8CnL/PpYgElj3RnweEi5/rIognxD84RAK8jKdRS/EsQ42WDryN9fa3XwhkUr1GjnH1sqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940134; c=relaxed/simple;
	bh=pUqIs3zw9Mt/gqgFanzTqyZ5uCpieLJd1Ly23bWk/XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOOkuxWG5lzxWmDnoQFnirTbiL0Jdd6njaZmLyVd4KxmWFj1eni5xNVpqFiN0eZ+UUxZRuGQI7ZKg3JndQFoqn0OPx8JZhi9JSEhix55lFeGa9rXGgYphEWiV73mYGZUUI+/79jhcYIpM6mnHYQav9IJIcoN9KS91mi+rqOqmug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsM6/EVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsM6/EVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B915C116B1;
	Tue,  2 Jul 2024 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940133;
	bh=pUqIs3zw9Mt/gqgFanzTqyZ5uCpieLJd1Ly23bWk/XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsM6/EVhfQHCHvtQQER/yZ6Md4R0UpP9pem3oAO0jvkuYiuDMzrZcyhfzamPfIW49
	 hiWE7GgY+h0ZcqIHAH0qPfQiRcaWVuNkHZhlQCe65YtiqhKvHsl6JrsWOfFDtxtFfR
	 55NtSxg7F/WiuyCL0cxpMMKqsi7rpbKK9xKWGQlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 063/222] af_unix: Fix wrong ioctl(SIOCATMARK) when consumed OOB skb is at the head.
Date: Tue,  2 Jul 2024 19:01:41 +0200
Message-ID: <20240702170246.391011673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e400cfa38bb0419cf1313e5494ea2b7d114e86d7 ]

Even if OOB data is recv()ed, ioctl(SIOCATMARK) must return 1 when the
OOB skb is at the head of the receive queue and no new OOB data is queued.

Without fix:

  #  RUN           msg_oob.no_peek.oob ...
  # msg_oob.c:305:oob:Expected answ[0] (0) == oob_head (1)
  # oob: Test terminated by assertion
  #          FAIL  msg_oob.no_peek.oob
  not ok 2 msg_oob.no_peek.oob

With fix:

  #  RUN           msg_oob.no_peek.oob ...
  #            OK  msg_oob.no_peek.oob
  ok 2 msg_oob.no_peek.oob

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e0fea73317de8..24286ce0ef3ee 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3154,12 +3154,23 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	case SIOCATMARK:
 		{
+			struct unix_sock *u = unix_sk(sk);
 			struct sk_buff *skb;
 			int answ = 0;
 
+			mutex_lock(&u->iolock);
+
 			skb = skb_peek(&sk->sk_receive_queue);
-			if (skb && skb == READ_ONCE(unix_sk(sk)->oob_skb))
-				answ = 1;
+			if (skb) {
+				struct sk_buff *oob_skb = READ_ONCE(u->oob_skb);
+
+				if (skb == oob_skb ||
+				    (!oob_skb && !unix_skb_len(skb)))
+					answ = 1;
+			}
+
+			mutex_unlock(&u->iolock);
+
 			err = put_user(answ, (int __user *)arg);
 		}
 		break;
-- 
2.43.0



