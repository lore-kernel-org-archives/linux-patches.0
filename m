Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EB66773D;
	Tue, 23 Jan 2024 02:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975283; cv=none; b=TIBiKYjBsVK/6DA/ZDXj2LlkG/rOKurmy9fksiZS6ODo6A5Korx4twMwH710FjTltnOI6fYMNrcKpuJcI3tPZhYwtVigP3TzbeS56Oh2mylcdFN7HLEUhQZyIlILFxMPC3T99ph8ABUlBXXB9XDGohB6z6TOyX1xLekrSsg9/mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975283; c=relaxed/simple;
	bh=n9lScoswzZ7BtDUgZG5yDZDTlAI8ZxCvGIWFyuWnpBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWopRGlFWTLoDGimmoayFVtUOLdBvK9gscGm3mXmrQOuAv9FtS+89kpK0CxFYaYT5T2WyM/2nmDqaPOeFLocAQd30WGBOow4MQxunKgw4Ryuc07bYI/yUQJaoBR/qit3CurI2UuhvEznCA8P1qb4oMoWQAnmMCHX15PKnLs1aak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvBvqXCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvBvqXCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEA5C43390;
	Tue, 23 Jan 2024 02:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975283;
	bh=n9lScoswzZ7BtDUgZG5yDZDTlAI8ZxCvGIWFyuWnpBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvBvqXCeCDc4VfbkasAQgfykrOGS1VTPgL9j9N1n/Rf44zaBUkozVZEvCMN3J21y8
	 MSQto7aVNtegRzmbNX9FhlHIIbq/YU14PNZpx5mRFKXPsugVd0Fy5QvyfEy0AQYp66
	 Nhe1bsDzIoMLVF7WQzcMjvcwbmOTxSi2aj6BqT5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 373/374] netfilter: nft_last: copy content when cloning expression
Date: Mon, 22 Jan 2024 16:00:29 -0800
Message-ID: <20240122235757.958990409@linuxfoundation.org>
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

commit 860e874290fb3be08e966c9c8ffc510c5b0f2bd8 upstream.

If the ruleset contains last timestamps, restore them accordingly.
Otherwise, listing after restoration shows never used items.

Fixes: 33a24de37e81 ("netfilter: nft_last: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_last.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -104,11 +104,15 @@ static void nft_last_destroy(const struc
 static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
+	struct nft_last_priv *priv_src = nft_expr_priv(src);
 
 	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
 	if (!priv_dst->last)
 		return -ENOMEM;
 
+	priv_dst->last->set = priv_src->last->set;
+	priv_dst->last->jiffies = priv_src->last->jiffies;
+
 	return 0;
 }
 


