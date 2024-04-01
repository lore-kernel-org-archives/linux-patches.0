Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85056487BE;
	Mon,  1 Apr 2024 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991046; cv=none; b=njrvbcaMUQCDuls0z9GHTBKvs6Caz/8s8uwOZ811SgfY+mPZyfDChKQlJFvNj+Dv3Qr4qzb6gIl6SCRB2GH7dHBy2Ktl4PLkunCG/h0Qc+L9DmzxWWy05P+wtN0b1pe7fgnl7J2W5DCF9hCi8Dy+eVhObxBZmX7PlKRVHn93Abc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991046; c=relaxed/simple;
	bh=RE/EdN/mqQ2Cme8u0LE8eZ/4IdtHarU+vyRZLO4KNVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLtVOMx4ksvyTkCKTXIV//lqt6S6dy3dMrfvbfSkV0CP78EsShbdxZZSP9ucYwqvVCLr77ru3xHaBg0FHXj/+KqmB5xtfzrMyX03g2GSGN4Q0E9DXbVvq2Imt/mimppNUHfV47ar0XOJAi0Ivhu+6OTFynzhsIkBm3UmECv21JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMNG1wBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMNG1wBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8188C433F1;
	Mon,  1 Apr 2024 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991046;
	bh=RE/EdN/mqQ2Cme8u0LE8eZ/4IdtHarU+vyRZLO4KNVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMNG1wBorL3cTm+Qj3Sf/EXHN4GSuPWNU7fd++lK7AlB65Bo/qyOBj5CyLH8uohF4
	 tok1sxctgvxVVSoOKe1Yq34txaAIr25OojBUdBEJo6ixFlI6/UDL8CtZmfqCPWbzq8
	 s6iNitqIsQbKRxkpuDBoQbcFm3JZCQhQRXNtK6fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mgcho.minic@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 145/272] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
Date: Mon,  1 Apr 2024 17:45:35 +0200
Message-ID: <20240401152535.219616375@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5132,6 +5132,7 @@ static void nf_tables_unbind_set(const s
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);


