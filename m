Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5F51A618F;
	Tue, 30 Jul 2024 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356802; cv=none; b=PJsk/A7dXtyqFQgYLJ0CTQ2DzbDFgEQZsM6Fqds5qbdp8JjZe9HE9pbcv7o7ONwwGL4gg/h6FG2nNn5mngupTH5BwsfFiftZc112ynmdsS4YDFaAWaUFn4tVno9iF275qht7++HFEKQemaV5APgnJH/1uVBNE6vBMXAf8d+ExRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356802; c=relaxed/simple;
	bh=Lx5Lnege3qdfRs1J0pPDaZRw/7sIoLrmaSWLlAMCfmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUZUADqAWVs+Uy/V88yjVSnTd1SpOKtWNdgh5vHFNZ+DRuaeXnI4mzH5oTQwTxqg5xiZMA/kGXJmF0bIIQ29wJSkCgJjyV1FL3EglBPrJFwrLxqBjpYc6HKCi2W1ax4OJNe4W8bQ9ckKnIPauAFDoaAancC+bPlSnHype9YnfYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvs3igy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvs3igy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A87AC4AF0C;
	Tue, 30 Jul 2024 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356802;
	bh=Lx5Lnege3qdfRs1J0pPDaZRw/7sIoLrmaSWLlAMCfmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvs3igy5iFP8NWURmx3OOS9093ffrSqYWheJkAjrFLgCQaY8XSwbR2q6cnJw1QAHv
	 eRgsxsNOv6RV/5OEr1ZTgGyZmuyBFCGWwGGvORhXMlfOPwHhGYo6Gwa/n8Ls85VGzC
	 b+bBoipjE6J9w8s6yoRJQFeRSk41G/tCEa7h7/iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/440] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Tue, 30 Jul 2024 17:47:43 +0200
Message-ID: <20240730151624.841911295@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

[ Upstream commit 782161895eb4ac45cf7cfa8db375bd4766cb8299 ]

Delete expectation path is missing a call to the nf_expect_get_id()
helper function to calculate the expectation ID, otherwise LSB of the
expectation object address is leaked to userspace.

Fixes: 3c79107631db ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9ee8abd3e4b10..9672b0e00d6bf 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3415,7 +3415,8 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-			if (ntohl(id) != (u32)(unsigned long)exp) {
+
+			if (id != nf_expect_get_id(exp)) {
 				nf_ct_expect_put(exp);
 				return -ENOENT;
 			}
-- 
2.43.0



