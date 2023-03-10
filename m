Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2551848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCEAC433D2;
	Fri, 10 Mar 2023 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458574;
	bh=0pJXg31ozyxLoPC1QoiKcU4hFs3FWEaOY0WNCKmc650=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNwa0NiEl5bYscFwiU4Erw2VCX4+/96u4j3PpslnORp2jenDHEEYK0DMXb8Kup3JW
	 J3TIRwjTai2Co3qRNOgVSur3sKXZHTfXfPUW7AJHkm06LLs/jhAjp2QWhqORg6IjgC
	 UWyDjilS2OOI6VJcP1K1YDrP2fdAcef5GvO0fiOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliangtang@gmail.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/357] mptcp: add sk_stop_timer_sync helper
Date: Fri, 10 Mar 2023 14:36:01 +0100
Message-Id: <20230310133737.147331526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit 08b81d873126b413cda511b1ea1cbb0e99938bbd ]

This patch added a new helper sk_stop_timer_sync, it deactivates a timer
like sk_stop_timer, but waits for the handler to finish.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 584f3742890e ("net: add sock_init_data_uid()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 976433438c6f2..c65baac40548a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2185,6 +2185,8 @@ void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 
 void sk_stop_timer(struct sock *sk, struct timer_list *timer);
 
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer);
+
 int __sk_queue_drop_skb(struct sock *sk, struct sk_buff_head *sk_queue,
 			struct sk_buff *skb, unsigned int flags,
 			void (*destructor)(struct sock *sk,
diff --git a/net/core/sock.c b/net/core/sock.c
index a2b12a5cf42bc..6cca1ebf904ae 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2882,6 +2882,13 @@ void sk_stop_timer(struct sock *sk, struct timer_list* timer)
 }
 EXPORT_SYMBOL(sk_stop_timer);
 
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
+{
+	if (del_timer_sync(timer))
+		__sock_put(sk);
+}
+EXPORT_SYMBOL(sk_stop_timer_sync);
+
 void sock_init_data(struct socket *sock, struct sock *sk)
 {
 	sk_init_common(sk);
-- 
2.39.2



