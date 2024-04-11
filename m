Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB83143C76;
	Thu, 11 Apr 2024 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832110; cv=none; b=WFFD/kM80TQl5pKOTAp+RTGgr2Cz7DlEW031eXrd8kcDNmMqvlmLbiL/m0S3mjV/nNzKZUYMqguJxqfxb96exVQ26YM2kH++ys3HOcPictNDaGPvaMJ/YwCBxc0MeGguClk3rkMhbjw6VH7NTDjnvlk6sMV+hGD/YZyxb3HTKtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832110; c=relaxed/simple;
	bh=ROHqbR43eXWi0lrpmcHHybRzxbd+G8PnOBoH+YOKcd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKd+tH5TSPjnsGdRB4NjRtrQdXo+5oXr8xPfS/DOPA6lQdwYSj4fZP4rtjdUxnjPz9rKjBbER6AXpH5SM82LppMULRX3zyjTtqT+QZqpXBJPp5kh0s5BB7BEOt4D6IDc1QTvbN8i/1YLyacWuod9MTKYfbWD93QiDi454n3QG28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjh0Ig/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjh0Ig/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817B0C433F1;
	Thu, 11 Apr 2024 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832109;
	bh=ROHqbR43eXWi0lrpmcHHybRzxbd+G8PnOBoH+YOKcd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjh0Ig/OHhw6UiMEw/2m0ovFEzj2nE5yskKBoitFfoFXGzDpMGYHHslrwKKbdXJ3V
	 ddxwUKmqDtLDSi1zWpiVL6Bh25+0TUajI1XQ/4xlbNN1ssBJQg8iSTgPrjsURIPwtw
	 +VWFgWKoDURTpQzvgGkVNt33R0uN9RTQOA942w4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.10 193/294] netfilter: nf_tables: disallow timeout for anonymous sets
Date: Thu, 11 Apr 2024 11:55:56 +0200
Message-ID: <20240411095441.423480695@linuxfoundation.org>
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

commit e26d3009efda338f19016df4175f354a9bd0a4ab upstream.

Never used from userspace, disallow these parameters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Keerthana: code surrounding the patch is different
because nft_set_desc is not present in v4.19-v5.10]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4457,6 +4457,9 @@ static int nf_tables_newset(struct net *
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &timeout);
 		if (err)
 			return err;
@@ -4465,6 +4468,10 @@ static int nf_tables_newset(struct net *
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 


