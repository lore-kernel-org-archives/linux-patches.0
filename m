Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBF1882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35168C433D2;
	Fri, 10 Mar 2023 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461037;
	bh=vmyrriZKIPiF32jWDTlv9+FDAVwY5GW2RjMbTOKSEDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NN+mSCnXjklZrs1Ytszh0KgP6PoxxlK4dw8UmtMERatzWfy38j5FE6nCil09pC7NA
	 SQGmbzLhGosA7Sfc4RpFMrh+qGqMe5r5KXvJwQAA2UdlGFYaeoBS5wimGTR7a/a5dY
	 g4KsCeLV89iN2UaLnVOuYvwkpWS0fCgtrz3csYcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 513/529] net: tls: avoid hanging tasks on the tx_lock
Date: Fri, 10 Mar 2023 14:40:56 +0100
Message-Id: <20230310133828.594655875@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit f3221361dc85d4de22586ce8441ec2c67b454f5d upstream.

syzbot sent a hung task report and Eric explains that adversarial
receiver may keep RWIN at 0 for a long time, so we are not guaranteed
to make forward progress. Thread which took tx_lock and went to sleep
may not release tx_lock for hours. Use interruptible sleep where
possible and reschedule the work if it can't take the lock.

Testing: existing selftest passes

Reported-by: syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com
Fixes: 79ffe6087e91 ("net/tls: add a TX lock")
Link: https://lore.kernel.org/all/000000000000e412e905f5b46201@google.com/
Cc: stable@vger.kernel.org # wait 4 weeks
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230301002857.2101894-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -949,7 +949,9 @@ int tls_sw_sendmsg(struct sock *sk, stru
 			       MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1283,7 +1285,9 @@ int tls_sw_sendpage(struct sock *sk, str
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2266,11 +2270,19 @@ static void tx_work_handler(struct work_
 
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
-	mutex_lock(&tls_ctx->tx_lock);
-	lock_sock(sk);
-	tls_tx_records(sk, -1);
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
+
+	if (mutex_trylock(&tls_ctx->tx_lock)) {
+		lock_sock(sk);
+		tls_tx_records(sk, -1);
+		release_sock(sk);
+		mutex_unlock(&tls_ctx->tx_lock);
+	} else if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		/* Someone is holding the tx_lock, they will likely run Tx
+		 * and cancel the work on their way out of the lock section.
+		 * Schedule a long delay just in case.
+		 */
+		schedule_delayed_work(&ctx->tx_work.work, msecs_to_jiffies(10));
+	}
 }
 
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)


