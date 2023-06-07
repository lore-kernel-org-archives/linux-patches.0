Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A70F37325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2959C433D2;
	Wed,  7 Jun 2023 20:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170821;
	bh=NWh9iomevTyAz+Wgof1LH6MiHyLp1oRY6rLLI3mDTgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eD/7zASH3AiASMFkYPGD5iIQskhy0DYgbZO7Faf/4oPZpToNWL6Fi6CHkY/P+Vk7p
	 K0vfzR67ARKGz3tB1YhYpD8mYdA1tEeBsjg/e82k8RbfkEw0lClsh/gXsdY8fqyhIQ
	 tQQeFm9E9RyQ2WioNI89l55Qlmsz7Ic231IqENDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shai Amiram <samiram@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 220/225] tls: rx: strp: dont use GFP_KERNEL in softirq context
Date: Wed,  7 Jun 2023 22:16:53 +0200
Message-ID: <20230607200921.563449284@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
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

commit 74836ec828fe17b63f2006fdbf53311d691396bf upstream.

When receive buffer is small, or the TCP rx queue looks too
complicated to bother using it directly - we allocate a new
skb and copy data into it.

We already use sk->sk_allocation... but nothing actually
sets it to GFP_ATOMIC on the ->sk_data_ready() path.

Users of HW offload are far more likely to experience problems
due to scheduling while atomic. "Copy mode" is very rarely
triggered with SW crypto.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2289,8 +2289,12 @@ static void tls_data_ready(struct sock *
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct sk_psock *psock;
+	gfp_t alloc_save;
 
+	alloc_save = sk->sk_allocation;
+	sk->sk_allocation = GFP_ATOMIC;
 	tls_strp_data_ready(&ctx->strp);
+	sk->sk_allocation = alloc_save;
 
 	psock = sk_psock_get(sk);
 	if (psock) {


