Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D543D64CF0;
	Tue, 23 Jan 2024 01:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975073; cv=none; b=prUfJNla3ZUCmSRHdr+2U54QXv68VydKB3HJb9XmCZ7Yr1dO+WnZUIMTzkXB4AjVOMj6463sKOvgxOv8fm10q3Kj4Ac0nnY4KpaT4ZBeRs2F5aVwr7/TUEvV0WUAxr04MXxVh/hPrTt119mVcfhVSk9GdOmVbG2v6sAV5tJYH3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975073; c=relaxed/simple;
	bh=e+sgVka6kUs0mHxJJMoAhfATTeuTZQxrD8z/vZxiu/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXqgMK+R+ADDJmROEYv6nkahLSK0hYGwVTRB9NJJm4z5Br8hOgYBQODzSb884xKTKJI/le15R0KLSbuEvbPh25jnhxc6P1qlFgcSvjcox+pMjzXQW5RJAXSq63MOTMg8/I+jrwkKp6gk7LO9/o3MHT2USXz19Cgt+js8enwz8xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkHWCQU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkHWCQU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996D5C433C7;
	Tue, 23 Jan 2024 01:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975073;
	bh=e+sgVka6kUs0mHxJJMoAhfATTeuTZQxrD8z/vZxiu/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkHWCQU2yqwRLY+CeN45oNKsjGFT4uQrHsz1TwyJIOWUNjBG9jTyvdrQVd7up8E3E
	 TxZ8uodLhfFDr9jM50FAvxaM3RXCu6Q9h/J6hpcgK1Yl/SjsQzeM6KrAFHvNy/QzmJ
	 YnkFSOvMjRo2Wr2uoOdAi86ApjpA+PeqRSqEwtIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/374] netfilter: nf_tables: reject NFT_SET_CONCAT with not field length description
Date: Mon, 22 Jan 2024 16:00:10 -0800
Message-ID: <20240122235757.253342281@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 967ad439e6b3..e2e3ccbb635f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4703,8 +4703,12 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
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



