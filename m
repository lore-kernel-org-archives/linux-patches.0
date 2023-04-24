Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57BF2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581DDC433D2;
	Mon, 24 Apr 2023 13:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343439;
	bh=lZ2IgiWGP47Z0fvYY4pBpYGxeg5uxIr1PXN6VuawWx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LrYZxlY3mEPFDs58LTyfn1Fx2oEdL4SN0CX6E5IcOKbKv0xWZgPHvwv4HwEHdYi3
	 gayI2S4m5g7mRuCZe3DZSZXnsObAOmy2OG6DUiEiWZz9b6zgpgKphd93RQsGSrqJuR
	 VxOoh1DS7TR8af67J7tOLtl6tz3v+y1cjcXAFVn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 4.14 25/28] sctp: Call inet6_destroy_sock() via sk->sk_destruct().
Date: Mon, 24 Apr 2023 15:18:46 +0200
Message-Id: <20230424131122.176943849@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 6431b0f6ff1633ae598667e4cdd93830074a03e8 upstream.

After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
sk->sk_destruct() by setting inet6_sock_destruct() to it to make
sure we do not leak inet6-specific resources.

SCTP sets its own sk->sk_destruct() in the sctp_init_sock(), and
SCTPv6 socket reuses it as the init function.

To call inet6_sock_destruct() from SCTPv6 sk->sk_destruct(), we
set sctp_v6_destruct_sock() in a new init function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4497,13 +4497,17 @@ static void sctp_destroy_sock(struct soc
 }
 
 /* Triggered when there are no references on the socket anymore */
-static void sctp_destruct_sock(struct sock *sk)
+static void sctp_destruct_common(struct sock *sk)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	/* Free up the HMAC transform. */
 	crypto_free_shash(sp->hmac);
+}
 
+static void sctp_destruct_sock(struct sock *sk)
+{
+	sctp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
 
@@ -8134,7 +8138,7 @@ void sctp_copy_sock(struct sock *newsk,
 	newsk->sk_reuse = sk->sk_reuse;
 
 	newsk->sk_shutdown = sk->sk_shutdown;
-	newsk->sk_destruct = sctp_destruct_sock;
+	newsk->sk_destruct = sk->sk_destruct;
 	newsk->sk_family = sk->sk_family;
 	newsk->sk_protocol = IPPROTO_SCTP;
 	newsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
@@ -8351,11 +8355,20 @@ struct proto sctp_prot = {
 
 #if IS_ENABLED(CONFIG_IPV6)
 
-#include <net/transp_v6.h>
-static void sctp_v6_destroy_sock(struct sock *sk)
+static void sctp_v6_destruct_sock(struct sock *sk)
+{
+	sctp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
+static int sctp_v6_init_sock(struct sock *sk)
 {
-	sctp_destroy_sock(sk);
-	inet6_destroy_sock(sk);
+	int ret = sctp_init_sock(sk);
+
+	if (!ret)
+		sk->sk_destruct = sctp_v6_destruct_sock;
+
+	return ret;
 }
 
 struct proto sctpv6_prot = {
@@ -8365,8 +8378,8 @@ struct proto sctpv6_prot = {
 	.disconnect	= sctp_disconnect,
 	.accept		= sctp_accept,
 	.ioctl		= sctp_ioctl,
-	.init		= sctp_init_sock,
-	.destroy	= sctp_v6_destroy_sock,
+	.init		= sctp_v6_init_sock,
+	.destroy	= sctp_destroy_sock,
 	.shutdown	= sctp_shutdown,
 	.setsockopt	= sctp_setsockopt,
 	.getsockopt	= sctp_getsockopt,


