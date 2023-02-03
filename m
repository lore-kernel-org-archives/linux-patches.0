Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578C61FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A81C433EF;
	Fri,  3 Feb 2023 10:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419764;
	bh=pt1rSltNBFBLCWdk1rNMYsruffAUqt+GJFUF7hugn80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hj83VhSkwKcE/jumWiQSphPLRj7FxUoPqKYJuhctOhgoyjCrAovXBBJnDO8Go1W5m
	 i+qlk8zHe6lnccAw5TZxRIl1cjDk1Nqs1l5zhBJwm9RnCcIx8/a/zdB3mGwigwYiPN
	 VtzlPy6veGtHG0NQQTgwaODWyc1JQ6GK87aXz2ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 28/28] net: mctp: purge receive queues on sk destruction
Date: Fri,  3 Feb 2023 11:13:16 +0100
Message-Id: <20230203101011.142443636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Kerr <jk@codeconstruct.com.au>

commit 60bd1d9008a50cc78c4033a16a6f5d78210d481c upstream.

We may have pending skbs in the receive queue when the sk is being
destroyed; add a destructor to purge the queue.

MCTP doesn't use the error queue, so only the receive_queue is purged.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230126064551.464468-1-jk@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -587,6 +587,11 @@ static void mctp_sk_unhash(struct sock *
 	del_timer_sync(&msk->key_expiry);
 }
 
+static void mctp_sk_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 static struct proto mctp_proto = {
 	.name		= "MCTP",
 	.owner		= THIS_MODULE,
@@ -623,6 +628,7 @@ static int mctp_pf_create(struct net *ne
 		return -ENOMEM;
 
 	sock_init_data(sock, sk);
+	sk->sk_destruct = mctp_sk_destruct;
 
 	rc = 0;
 	if (sk->sk_prot->init)


