Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590C81FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1839C433D2;
	Fri,  3 Feb 2023 10:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419876;
	bh=2EkidmGYR9Fi14vrQ/xIDvANimnqugpun2Vo+Jh5rfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsFEG5ab/nAdTlBKZFAd0B2mhBbCv62JNKwS1QnEpjX40QH4l2OVeMhh5GFhnz2Ps
	 wvmU+QaZP/l26o/rlVmZzDhr3SDVwzgo2jVMDVBWXejMNCaM8vnolP+UaPwjUr9IP+
	 htIiZSXUiA+2vJD7hGtoJtOEClABvX1jmRJ21vUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 20/20] net: mctp: purge receive queues on sk destruction
Date: Fri,  3 Feb 2023 11:13:47 +0100
Message-Id: <20230203101008.845565463@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
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
@@ -294,6 +294,11 @@ static void mctp_sk_unhash(struct sock *
 	synchronize_rcu();
 }
 
+static void mctp_sk_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 static struct proto mctp_proto = {
 	.name		= "MCTP",
 	.owner		= THIS_MODULE,
@@ -330,6 +335,7 @@ static int mctp_pf_create(struct net *ne
 		return -ENOMEM;
 
 	sock_init_data(sock, sk);
+	sk->sk_destruct = mctp_sk_destruct;
 
 	rc = 0;
 	if (sk->sk_prot->init)


