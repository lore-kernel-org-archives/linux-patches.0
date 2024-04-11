Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175421474CA;
	Thu, 11 Apr 2024 10:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831765; cv=none; b=dWg2S6X06le8AZWd/3+O92pBshQPgpBR1UZI1oHr3w7Q/9u6U4lhwmjKacohY25sBiUgMWUUSWRDvVzxGSsob3EXe2WbWB0dJqWb7mrS7WRbuw8QV++n1Y03WC5US417IA9bkzeCvvX8n2ykgbgwghTZJi34V+kHHLLKMVgjcbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831765; c=relaxed/simple;
	bh=HtEFblNrTDDNVXAFYDQQX8Gh9dWI8vHg9k8+MBmYC4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSVFbHC7ckEnmqW8Jw8kcJi1bcgA36AMSoxWq1ZbVePTErLdxs+CqQD2XjoUDXbhc+2EL35+IDGnE3nus27sQozvRXhPfAYgfHH0Vk/dqDdqmvCkKw0/5/RvSQJwtRNt0avgLKijysvcS0QtgRVLqxWYqj6jWYhYOGadRcJq5Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbDuCbA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbDuCbA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9D6C433F1;
	Thu, 11 Apr 2024 10:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831765;
	bh=HtEFblNrTDDNVXAFYDQQX8Gh9dWI8vHg9k8+MBmYC4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbDuCbA1ZIuLdCQZYVp8/NnOddGZyKTg+ryuFmDQR05zucfYHwWwBKdwOEFLYHvSv
	 vHI4Y9s7jVPQqU5ShWd/dbkyjtHSHqYwrPE5W3DGibyccdSA36vxZDYnl2LwPOqKE1
	 4UHiwbUwHQuFobbeXKl/IdooQ/YByFlf0RICL3/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mgcho.minic@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 119/294] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
Date: Thu, 11 Apr 2024 11:54:42 +0200
Message-ID: <20240411095439.250166967@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 552705a3650bbf46a22b1adedc1b04181490fc36 upstream.

While the rhashtable set gc runs asynchronously, a race allows it to
collect elements from anonymous sets with timeouts while it is being
released from the commit path.

Mingi Cho originally reported this issue in a different path in 6.1.x
with a pipapo set with low timeouts which is not possible upstream since
7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
element timeout").

Fix this by setting on the dead flag for anonymous sets to skip async gc
in this case.

According to 08e4c8c5919f ("netfilter: nf_tables: mark newset as dead on
transaction abort"), Florian plans to accelerate abort path by releasing
objects via workqueue, therefore, this sets on the dead flag for abort
path too.

Cc: stable@vger.kernel.org
Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Mingi Cho <mgcho.minic@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4754,6 +4754,7 @@ static void nf_tables_unbind_set(const s
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);


