Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A1513EFEC;
	Tue, 27 Feb 2024 14:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044192; cv=none; b=n6ODbp4wzJKa8xD6rpUh/1YhKr7P1m2l/JAqxnQrAgGt4juD0AmgW4JXwaQu3577gJz3bJGKTpayRHJGxaNrYY5ODgd/Dl/8WNa/oxyzy4M/IdoRGzMhqdPcoPowfGvvV0wqz3fcYGr3qYr2i5u40kC8DVPQbn8ctQo6ScRLsok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044192; c=relaxed/simple;
	bh=/Q9OUfQ4SJAn40kbI48VLV5MEfPbXTqtrntsjwT19eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDP+u4bwQqxQitnzpIRE7hGDaa9ulUPyqtmyYHEGDw2AgkKIqU4Nef6hXDs8qmjcwMkE5EVSK/btYnsMrZdsWCafSaSNUIcoKtbfSPUdFSUblQcmQ+XI7NSHXH6h4I/wbxf2Dr28WGWb7yTYztczQFApJKSMLXnOKW5nMp9KpG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMK/UfuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMK/UfuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7392C433C7;
	Tue, 27 Feb 2024 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044192;
	bh=/Q9OUfQ4SJAn40kbI48VLV5MEfPbXTqtrntsjwT19eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMK/UfuH3+sRfMwQH+n8CW4t38aGB5+8diI0mbyqsdEeMbmAojCsdACr8ftbc28LA
	 7QNmuRQLcUANmruOB/eyguhUgEi266cfBNS9IvPuMyi9ZtM7gPNMKp+zKsDJFrO1q5
	 X9UWNnOpLKwTXEjW9MbKcbBFrTq1Rdgy+Ya0mUvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 095/122] mptcp: fix lockless access in subflow ULP diag
Date: Tue, 27 Feb 2024 14:27:36 +0100
Message-ID: <20240227131601.812174675@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit b8adb69a7d29c2d33eb327bca66476fb6066516b upstream.

Since the introduction of the subflow ULP diag interface, the
dump callback accessed all the subflow data with lockless.

We need either to annotate all the read and write operation accordingly,
or acquire the subflow socket lock. Let's do latter, even if slower, to
avoid a diffstat havoc.

Fixes: 5147dfb50832 ("mptcp: allow dumping subflow context to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h  |    2 +-
 net/mptcp/diag.c   |    6 +++++-
 net/tls/tls_main.c |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2224,7 +2224,7 @@ struct tcp_ulp_ops {
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
 	/* diagnostic */
-	int (*get_info)(const struct sock *sk, struct sk_buff *skb);
+	int (*get_info)(struct sock *sk, struct sk_buff *skb);
 	size_t (*get_info_size)(const struct sock *sk);
 	/* clone ulp */
 	void (*clone)(const struct request_sock *req, struct sock *newsk,
--- a/net/mptcp/diag.c
+++ b/net/mptcp/diag.c
@@ -13,17 +13,19 @@
 #include <uapi/linux/mptcp.h>
 #include "protocol.h"
 
-static int subflow_get_info(const struct sock *sk, struct sk_buff *skb)
+static int subflow_get_info(struct sock *sk, struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *sf;
 	struct nlattr *start;
 	u32 flags = 0;
+	bool slow;
 	int err;
 
 	start = nla_nest_start_noflag(skb, INET_ULP_INFO_MPTCP);
 	if (!start)
 		return -EMSGSIZE;
 
+	slow = lock_sock_fast(sk);
 	rcu_read_lock();
 	sf = rcu_dereference(inet_csk(sk)->icsk_ulp_data);
 	if (!sf) {
@@ -69,11 +71,13 @@ static int subflow_get_info(const struct
 	}
 
 	rcu_read_unlock();
+	unlock_sock_fast(sk, slow);
 	nla_nest_end(skb, start);
 	return 0;
 
 nla_failure:
 	rcu_read_unlock();
+	unlock_sock_fast(sk, slow);
 	nla_nest_cancel(skb, start);
 	return err;
 }
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -800,7 +800,7 @@ static void tls_update(struct sock *sk,
 	}
 }
 
-static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
+static int tls_get_info(struct sock *sk, struct sk_buff *skb)
 {
 	u16 version, cipher_type;
 	struct tls_context *ctx;


