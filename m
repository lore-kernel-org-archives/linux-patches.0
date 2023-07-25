Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BDC1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3CC433C7;
	Tue, 25 Jul 2023 11:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285437;
	bh=hlSLYnyHE2PYsIS1TTQrcdNBUBX6wvATSShZmvwchk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYdiUK9yWeFoaML+5aY+QqZqXDMU9AWYMjRZM+4eQegP191+6Qdmmq19gTbcEN1Ru
	 XOjCUvxqew7kltp7wqlPblYAGbKc4uL9wKV80m2EFICJIDYHnIUdAKjZ1NbPGnVfDB
	 6sjmNJX6Z0cpTLfP+DYRrNCxzCXYqgkHRSpQPZlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 187/313] netfilter: nf_tables: unbind non-anonymous set if rule construction fails
Date: Tue, 25 Jul 2023 12:45:40 +0200
Message-ID: <20230725104529.052399107@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 3e70489721b6c870252c9082c496703677240f53 ]

Otherwise a dangling reference to a rule object that is gone remains
in the set binding list.

Fixes: 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3987,6 +3987,8 @@ void nf_tables_deactivate_set(const stru
 		nft_set_trans_unbind(ctx, set);
 		if (nft_set_is_anonymous(set))
 			nft_deactivate_next(ctx->net, set);
+		else
+			list_del_rcu(&binding->list);
 
 		set->use--;
 		break;


