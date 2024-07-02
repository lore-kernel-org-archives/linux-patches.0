Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC24178381;
	Tue,  2 Jul 2024 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940124; cv=none; b=uvcXrF/Qygm73HfhFXfNbhqoW4t+pxFta0Ia/urxfwyRtS2CsfB+JXL8hFw4sbv9p0767Dz961nlizAJvgY5Kw7Frz0vARsj6eYM9uJW1Y5UJTcQI8m9OwnnAivMdl2s1m0VTgKXwo/r0nubLTRS1ypGObeU6Fnp0be7wk03H5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940124; c=relaxed/simple;
	bh=Xot3gHy9fmtgqX8EP8LCbsvUPhvakJGTnsw1RvFrA70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snQufm/Gcql9lmI98YxhaDCJs/5gJa6iUIFMzNkJ5z6hxBdWhgglICdGadUyo0fIMrP1CzheYs48WrXoNShp/iG6ovSoUtX39ppi44E5hhzz/mGLO3vtBn2x7alrwNTMrW/sQOZkrmfs2iaNzLaotRG10Iywj2BgevOE40+Azfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6GmeCGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6GmeCGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E95C116B1;
	Tue,  2 Jul 2024 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940124;
	bh=Xot3gHy9fmtgqX8EP8LCbsvUPhvakJGTnsw1RvFrA70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6GmeCGtQkHrw+YWHDJXwqGd7H9TFb8yeO+aOaEDYtxDvSFLiY0q3gXwwC8znzWBT
	 d2/KFip++IjWXx5uoqcYcUxHgNYatreeL8RNapmrscKr6h5REVTYPyyqsWdFNNTWH7
	 vwC1lrdL+MDQi6gNGv4GW+J7OmgQv7NF5RSGxd4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 060/222] af_unix: Stop recv(MSG_PEEK) at consumed OOB skb.
Date: Tue,  2 Jul 2024 19:01:38 +0200
Message-ID: <20240702170246.277960903@linuxfoundation.org>
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

[ Upstream commit b94038d841a91d0e3f59cfe4d073e210910366ee ]

After consuming OOB data, recv() reading the preceding data must break at
the OOB skb regardless of MSG_PEEK.

Currently, MSG_PEEK does not stop recv() for AF_UNIX, and the behaviour is
not compliant with TCP.

  >>> from socket import *
  >>> c1, c2 = socketpair(AF_UNIX)
  >>> c1.send(b'hello', MSG_OOB)
  5
  >>> c1.send(b'world')
  5
  >>> c2.recv(1, MSG_OOB)
  b'o'
  >>> c2.recv(9, MSG_PEEK)  # This should return b'hell'
  b'hellworld'              # even with enough buffer.

Let's fix it by returning NULL for consumed skb and unlinking it only if
MSG_PEEK is not specified.

This patch also adds test cases that add recv(MSG_PEEK) before each recv().

Without fix:

  #  RUN           msg_oob.peek.oob_ahead_break ...
  # msg_oob.c:134:oob_ahead_break:AF_UNIX :hellworld
  # msg_oob.c:135:oob_ahead_break:Expected:hell
  # msg_oob.c:137:oob_ahead_break:Expected ret[0] (9) == expected_len (4)
  # oob_ahead_break: Test terminated by assertion
  #          FAIL  msg_oob.peek.oob_ahead_break
  not ok 13 msg_oob.peek.oob_ahead_break

With fix:

  #  RUN           msg_oob.peek.oob_ahead_break ...
  #            OK  msg_oob.peek.oob_ahead_break
  ok 13 msg_oob.peek.oob_ahead_break

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 68a58bc07cf23..d687670e84990 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2660,9 +2660,12 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 {
 	struct unix_sock *u = unix_sk(sk);
 
-	if (!unix_skb_len(skb) && !(flags & MSG_PEEK)) {
-		skb_unlink(skb, &sk->sk_receive_queue);
-		consume_skb(skb);
+	if (!unix_skb_len(skb)) {
+		if (!(flags & MSG_PEEK)) {
+			skb_unlink(skb, &sk->sk_receive_queue);
+			consume_skb(skb);
+		}
+
 		skb = NULL;
 	} else {
 		struct sk_buff *unlinked_skb = NULL;
-- 
2.43.0



