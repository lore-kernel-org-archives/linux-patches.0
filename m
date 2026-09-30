Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF976463B8B;
	Wed, 30 Sep 2026 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785384; cv=none; b=sqDUmQ8lHk6yWFhJ36CETSfFHQO9mZQga96g6nxpXGMA0kJUbxEagxJf1Dtbv35tKrdmgIRq24NXxn6lo7PNm0lGtWqxVnLeZKu3fiMger3ZsmAqSIVs30NX0v8Nl4j6JKAz9sz9fq0v1AyNNpW9Tl3vcft2+uEf8dGqwjD5Cm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785384; c=relaxed/simple;
	bh=7HF5XwmrDLbaC/eupDOY+ZKa9uz8iy6hZoG+A85LMiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svuN/uJ8eb1bKpfUr8wskgmOExDwLu7mmMtMmUDDoTvtbj6mUQzrCSNsrUvQOn9h1bH5xnql6gd1/zLLma4el6DDWaYMRC3ZE3Ck489nO2A2LVflCLFU9XQ0af4L0Fcs8mBuQTM6UJrCkxp/ABP+CbV7P90qaVOciFhtGIe02qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/Cz8lXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/Cz8lXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B551F000FF;
	Wed, 30 Sep 2026 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785378;
	bh=61wXc4tXwPinBja+rvZjjhfATZXHFdgZ8cvxRQWR4oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/Cz8lXL+XmK16Fmc0LYVb4n68llTeewXjUrpqS/HdojL/44OEHv0s3SdAkRyeADB
	 OjB7v17LFO7f5pAtsQUGKG/FmwwFMB9aYSZzsm+l/XuZD5TUjbKaUbIE6RfUXIOwoO
	 SziM4ShQ7n+bHMw26RVyWMootGf+LsTay03GH1co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Marsden <greg.marsden@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 486/982] net/rds: fix tcp stream corruption with large pages
Date: Wed, 30 Sep 2026 17:20:22 +0200
Message-ID: <20260930152427.219982798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09ee4532376b1..26ff222abafc6 100644
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



