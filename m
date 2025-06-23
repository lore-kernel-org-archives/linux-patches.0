Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2277EB676;
	Mon, 23 Jun 2025 22:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717102; cv=none; b=pHw0mm/3dqViXGRKCAOzA8NvnXctS3m7i6/aUIyMaZjHDGO6NhB0X5KemOVQfKOICTEtyCmsRmEF0nTIU915Qz9EsI8I6DKlHNvU/BtnCuoz2M2wEMbziicWUFMyiCb1a08cr3wiR+g5QAzxK7d8GsA+lAs3rYCcnh87e6o8aHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717102; c=relaxed/simple;
	bh=mPbGkts0HU0oO7PiakOePRzaY+yMjAlGLhTDhwIU08I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCvxW3nGa2Fi1hQOwViAGucPMeQvwrlswAM32cwzNbQSOWenl4EKcpFJqFYrdaUDcURMsk7B9uoHvZQQxkvuncJPgY6niGAd6M1wQ3MRFSlMFjfWqGt+mYofvTN0XkxmhnK8SStZ4Oi/kO/KANk/PjDwKIqPbH0SJaubdjjM4tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwg+cyz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwg+cyz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E95BC4CEEA;
	Mon, 23 Jun 2025 22:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717102;
	bh=mPbGkts0HU0oO7PiakOePRzaY+yMjAlGLhTDhwIU08I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwg+cyz5jYppcvY/kELHPszFtEPIf4dZmgTIM9bhQ3lgEMHrFg+/5wMEf9EMlMPg+
	 jf3Hi4qdjJQi00f4O9FYT0GEEMj6Ft2ZpRksP2cSzVh62qgQVXTtRg0NnUBgNPyOcD
	 qmZ9uPu6P8vEEYn4WWFmdGy44tMtsZrFXd43luI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 324/414] atm: Revert atm_account_tx() if copy_from_iter_full() fails.
Date: Mon, 23 Jun 2025 15:07:41 +0200
Message-ID: <20250623130650.094539144@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 7851263998d4269125fd6cb3fdbfc7c6db853859 upstream.

In vcc_sendmsg(), we account skb->truesize to sk->sk_wmem_alloc by
atm_account_tx().

It is expected to be reverted by atm_pop_raw() later called by
vcc->dev->ops->send(vcc, skb).

However, vcc_sendmsg() misses the same revert when copy_from_iter_full()
fails, and then we will leak a socket.

Let's factorise the revert part as atm_return_tx() and call it in
the failure path.

Note that the corresponding sk_wmem_alloc operation can be found in
alloc_tx() as of the blamed commit.

  $ git blame -L:alloc_tx net/atm/common.c c55fa3cccbc2c~

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Simon Horman <horms@kernel.org>
Closes: https://lore.kernel.org/netdev/20250614161959.GR414686@horms.kernel.org/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250616182147.963333-3-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/atmdev.h |    6 ++++++
 net/atm/common.c       |    1 +
 net/atm/raw.c          |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -249,6 +249,12 @@ static inline void atm_account_tx(struct
 	ATM_SKB(skb)->atm_options = vcc->atm_options;
 }
 
+static inline void atm_return_tx(struct atm_vcc *vcc, struct sk_buff *skb)
+{
+	WARN_ON_ONCE(refcount_sub_and_test(ATM_SKB(skb)->acct_truesize,
+					   &sk_atm(vcc)->sk_wmem_alloc));
+}
+
 static inline void atm_force_charge(struct atm_vcc *vcc,int truesize)
 {
 	atomic_add(truesize, &sk_atm(vcc)->sk_rmem_alloc);
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -635,6 +635,7 @@ int vcc_sendmsg(struct socket *sock, str
 
 	skb->dev = NULL; /* for paths shared with net_device interfaces */
 	if (!copy_from_iter_full(skb_put(skb, size), size, &m->msg_iter)) {
+		atm_return_tx(vcc, skb);
 		kfree_skb(skb);
 		error = -EFAULT;
 		goto out;
--- a/net/atm/raw.c
+++ b/net/atm/raw.c
@@ -36,7 +36,7 @@ static void atm_pop_raw(struct atm_vcc *
 
 	pr_debug("(%d) %d -= %d\n",
 		 vcc->vci, sk_wmem_alloc_get(sk), ATM_SKB(skb)->acct_truesize);
-	WARN_ON(refcount_sub_and_test(ATM_SKB(skb)->acct_truesize, &sk->sk_wmem_alloc));
+	atm_return_tx(vcc, skb);
 	dev_kfree_skb_any(skb);
 	sk->sk_write_space(sk);
 }


