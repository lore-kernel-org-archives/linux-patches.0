Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909D4F4754;
	Wed, 30 Sep 2026 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783104; cv=none; b=ktvIe4VelQJOMdBqMRN4p9hJriWi9ENMI3eoqgfYUaN9u+rvfHrQ980i2dfzkvkxQA+i3hjxEqykp9TE6hVY4tKGnftbhltImY9sZGEcOuwN9D51N5fXRw8225TWhm2k6vmXgT3kpapOnmQUQxcq5JpQBkBus4V6UiQpnN4Ab6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783104; c=relaxed/simple;
	bh=K5AArzu7ipZpaphpquxn+aRmHIVjKOOq5wEfZdYB+Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtY9JBwU6g7MaLHvxU6eCxS9Lw+SAAl5H3lIGLLkiKAUpcfUY0MUr0XOhOJRgNWOOnpy0uivW8P/UlXBgo6CEB1gEwUDVHyiOD6RK7MZEgBlwV1U3T0CjaIFDwCyQsxd6i4frJG1dBNTQ1Izp8nZktCUFio4kNIAT93mxeffKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xySB97tZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xySB97tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7CF1F00899;
	Wed, 30 Sep 2026 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783100;
	bh=r7nuuNIVMX9BqakJEpYyV8APsrgQW+JuXh63SUhmDt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xySB97tZQX8t9S9aPqd5BuyvwNFq4jM9hxpKBFJjWpkTDY3YJn4paxF+ne+LTnA3h
	 tDaxpqz1MjldVxlOkG5t71waAlpGReB8e6o6iGkDMT4HxlGk3zGABzkxqKNKC5iSUs
	 pKlsnFj+k4Ic7X7YtFMMvDNWLuBJxtQT2sBVLGQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Marsden <greg.marsden@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/595] net/rds: fix tcp stream corruption with large pages
Date: Wed, 30 Sep 2026 17:22:53 +0200
Message-ID: <20260930152353.725885559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cd13f0c4de540..7444594a02e11 100644
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



