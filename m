Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B945381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09F7C433C8;
	Mon, 19 Jun 2023 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171620;
	bh=EtghdKTmX7hI7Lsgk6W6tp2CjApi7H5GgSjAmKeCgL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9Elid2pMy88rETTsGLGNC1pVnp0dFvIU66/WG3OdiLqicAdL2JNl1cKusOjG3OM8
	 C8kiY73afdf6Woo6FAHak0HmdU6j9vlTelWXhKveSj2AJlG8w/CJMOCakaXWpttBuV
	 atspKOxgD1kMGa2pXbgBerE0umT8WXDJmOYQ74yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/166] netfilter: nfnetlink: skip error delivery on batch in case of ENOMEM
Date: Mon, 19 Jun 2023 12:29:34 +0200
Message-ID: <20230619102159.497690997@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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

[ Upstream commit a1a64a151dae8ac3581c1cbde44b672045cb658b ]

If caller reports ENOMEM, then stop iterating over the batch and send a
single netlink message to userspace to report OOM.

Fixes: cbb8125eb40b ("netfilter: nfnetlink: deliver netlink errors on batch completion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index ae7146475d17a..c9fbe0f707b5f 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -533,7 +533,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 * processed, this avoids that the same error is
 			 * reported several times when replaying the batch.
 			 */
-			if (nfnl_err_add(&err_list, nlh, err, &extack) < 0) {
+			if (err == -ENOMEM ||
+			    nfnl_err_add(&err_list, nlh, err, &extack) < 0) {
 				/* We failed to enqueue an error, reset the
 				 * list of errors and send OOM to userspace
 				 * pointing to the batch header.
-- 
2.39.2



