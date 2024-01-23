Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFF123CA;
	Tue, 23 Jan 2024 02:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975787; cv=none; b=iAq7SPPYvQFaQBpoHRl5q39JbR8KtUKo6bqO/esIsdyCaOoaCvUmsIWtyC+nP11EQ29QjcIKa6BzREjyEDW/CZPZwGdi5gBLQCpeyKfCAQoiB14yOY+JpjqA4+uosWnv2XYSHnpU3CVyKI0HS8Z3auuWKghMzxWgBOJrwSdrk64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975787; c=relaxed/simple;
	bh=0dYFj5Po7uGix2WNxcQh6wou5Cswi+rWJvO7gW66pUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8WlhpdBZ1HRxhp5Sez2BiTfzs+H2+j7Rhp2OlkDJ4zPnVLhAiMcFxONdp7MQ1UYdM8MlMKjJnm1lxJsiMZNVy017y6o2Q7vg0nxMmjx6t84TPFPGjibM0eqkiBuTca2Gq7OKNqCTdFx0znayuqCUlFa0fqaFiDrLS/hJ7gdG0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iULpLytM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iULpLytM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08680C433F1;
	Tue, 23 Jan 2024 02:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975787;
	bh=0dYFj5Po7uGix2WNxcQh6wou5Cswi+rWJvO7gW66pUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iULpLytMSpS2WcZOyRmXNWaA25lSG1pHQFvXyFkWnvgdGciqRXQgFn/xiEy/Obp1G
	 KQGlxUug3V14MHgysv3asOFfsED2zEtzW7Z6HNpbxiTDpoNUb1w7c6fuOro+iWAgGa
	 JkuvB7SqoBdqnzA4ZNXoX3eWm5Oiz2+U9Oh8kW0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 568/583] netfilter: nf_tables: reject NFT_SET_CONCAT with not field length description
Date: Mon, 22 Jan 2024 16:00:19 -0800
Message-ID: <20240122235829.551571094@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 113661e07460a6604aacc8ae1b23695a89e7d4b3 ]

It is still possible to set on the NFT_SET_CONCAT flag by specifying a
set size and no field description, report EINVAL in such case.

Fixes: 1b6345d4160e ("netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1f6d5ffbe34a..b28fbcb86e94 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5010,8 +5010,12 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
-		if (desc.field_count > 1 && !(flags & NFT_SET_CONCAT))
+		if (desc.field_count > 1) {
+			if (!(flags & NFT_SET_CONCAT))
+				return -EINVAL;
+		} else if (flags & NFT_SET_CONCAT) {
 			return -EINVAL;
+		}
 	} else if (flags & NFT_SET_CONCAT) {
 		return -EINVAL;
 	}
-- 
2.43.0



