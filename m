Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0929F145353;
	Thu, 11 Apr 2024 10:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830677; cv=none; b=fTGgv074kl184GEsgXldW6kPlpKeifxbdXt7+qPg6DcQQa3B4M3Do/jOcNvriiB8BKfdiehxWtkVy1C8Z9sV63cDOps54yByz/fG3J/9XuW7uFX/QwbPBJRlsTUiWTxdpBgCRnZbR/rjakCN/KGWViB8Xo2pG7rMFSAkEmbeE6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830677; c=relaxed/simple;
	bh=ZMV+WfiSRZhmJbotcMQzjSBrZVDB7QgfE5Yi3d46UMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH49snEoodxEYBpJ6JL96NO96Ee9fLatYwxZHJ5nLyxhK6gYraCFaq+232Yhyfn3vMhv1cnMB81dg8RdWL058Bx+H5FyQRogxAGkB5FdtjkSIa596bNip8nzwJo0XuMMihNe/Gb2FSv3QOwohcyftkYycSHSJmjC2dbjbyYoEu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NSFMw8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NSFMw8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34129C433F1;
	Thu, 11 Apr 2024 10:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830676;
	bh=ZMV+WfiSRZhmJbotcMQzjSBrZVDB7QgfE5Yi3d46UMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NSFMw8JmYMEphmvaJQ2EuxExT/pM2m/hWNGBcmJlzGs8lcW4QVbktf+iM/YZVV06
	 YlN71b7WU0b3rrCE5TtLyLD6muQJnI9KJP5k30Tk3gaCEW2qtmb4nF6GXb0lGM/FBq
	 MLcy44egQlw945H8/h3YdYpXXVtziK9VaP0auPB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mgcho.minic@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 081/215] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
Date: Thu, 11 Apr 2024 11:54:50 +0200
Message-ID: <20240411095427.343293180@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4073,6 +4073,7 @@ static void nf_tables_unbind_set(const s
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);


