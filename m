Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D8F4FD27A;
	Thu, 17 Sep 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666166; cv=none; b=dxg8HkV6r7f4Gt2GKIrf2z+tkzhqnF/NBBDzTDYZO1ABBuPf9SYmP9dGCHZqNVwCUE/OLcA/JM43c2RjU9orM7DAgU2Kswroyn9uBfsgs06k5fFycpDo1h/L6YXmctGJasJlPbcYWafwMnl324Mr5FUrTJFldXrfRxdzsVVGQog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666166; c=relaxed/simple;
	bh=C0q2pQXfpfznYDJ4e9dqPdY2oUCvyQpXUmePYPPFyuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJ3MUkgYEboIPNGemU5VN1thwAncc8/XUL9rcJelsftfRhPpUX3vlTxu/EgcCs3cE+V9VVayay3p9mU0Frhj6YljW/IMZMVLkM2P+dsXPx0WpP/p05Ci+5aw09VAZQeJtqxmIjd/alo6xPve5ECBlCic1MIK3Q81tI5OyVvJ1iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDulx0xa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDulx0xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432E41F000FF;
	Thu, 17 Sep 2026 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666164;
	bh=N5EIE+OvdEloOQAZmmn2z6zawp/zFsqFaGpQNzTeMAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDulx0xaXt2a0BvDb5uczyDVHEmfvjcLIW357iWPCWC6t/ks0Lgb8FDBEuf8oe9aE
	 /72JagJ+mj5kvqyRqKSMWgdabnS33MHslS1Xl+trvvdB3rWjVPWRwhY1F6eUaSeaiA
	 hKUm/kC0Ng/AH4Q2pg246ZyuqeXb4Wcy7SE5QXRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Marsden <greg.marsden@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0939/1250] net/rds: fix tcp stream corruption with large pages
Date: Thu, 17 Sep 2026 16:12:14 +0100
Message-ID: <20260917151617.468625401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Marsden <greg.marsden@oracle.com>

[ Upstream commit 2ac09b5353fe6858411fdc8c6efa60d832e20f13 ]

rds_message_map_pages() assigns PAGE_SIZE bytes to every
scatterlist entry, even when total_len ends in a partial page. The RDS
congestion map is defined as 8192 bytes, so on systems with PAGE_SIZE
greater than 8192 the scatterlist maps bytes beyond the end of the
congestion map.  RDS-TCP transmits the SG contents according to those
lengths, so the extra bytes become part of the TCP RDS stream and are
interpreted as subsequent RDS message headers, corrupting the stream.

Limit the final scatterlist mapping to the number of bytes remaining.
This has no effect on systems with a 4K page size and allows RDS-TCP to
be used on systems with 16K and larger page sizes.

The RDS selftest, which previously hung on 16K pages, now passes.

Fixes: 7875e18e0996 ("RDS: Message parsing")
Signed-off-by: Greg Marsden <greg.marsden@oracle.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/apxJjxvStibPI0AS@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 064e507f0ccf2..19202aa33f6f4 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -365,7 +365,9 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	for (i = 0; i < rm->data.op_nents; ++i) {
 		sg_set_page(&rm->data.op_sg[i],
 				virt_to_page((void *)page_addrs[i]),
-				PAGE_SIZE, 0);
+				i == rm->data.op_nents - 1
+					? total_len - (i * PAGE_SIZE)
+					: PAGE_SIZE, 0);
 	}
 
 	return rm;
-- 
2.53.0



