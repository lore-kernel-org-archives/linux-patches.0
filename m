Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901A8318EC7;
	Thu, 17 Sep 2026 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659974; cv=none; b=AozPp919kbk3vsISpog2izxwSkRuVghZmRHk/Gkz+yADFOA2cBrbk44cmnn3XbucAkJGQy66yW6RiNeqIJeDJUs6tvo+rGeSIQbjIJ3Sud9FtN1G/anWJROa0Vc83S7OjVk3W5e1BYvwxepCqVzj3ilf4pD7VlBYuMlRdut7G48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659974; c=relaxed/simple;
	bh=86Aae8/fkHVam5uFXcrkDrpT2R90PGAe/p+hTocbwGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNwhtY/7VbW6xG7Ulvmi7MWEUmZoPHMN1Rhd7AoQZYKB1DQN+dtJCKeoufC3A7j7Ocusm3wN7sBX7UHTdjPfByGJBBCwQxEM8glqeaCYg7XGDI6f0CxU9gXAYVW8996d2sc0T92aes3UPEzF0WMmTfvEQvWa3sV0l6prYoe6NNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPLPKhz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPLPKhz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30941F000FF;
	Thu, 17 Sep 2026 15:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659967;
	bh=4IrV0kXJFkD6buK0YYmX7iEfmqfiZ+w29Msh7idbhKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPLPKhz89o8/ZbM8ekbOpUz7Rl9nLLK/8M3zeugReuV2buaRsfxXT6ZCyBP9d539E
	 SF4W/Meds1t0sOxll4M6kE78x+SejxgPnoejwDpLfxMV57f2yxX/p6OlstP6djy+6d
	 ImaejlFEmXwS1ttC8+tw6iRbVWsP4WJxoJek544g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Marsden <greg.marsden@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 434/733] net/rds: fix tcp stream corruption with large pages
Date: Thu, 17 Sep 2026 16:12:22 +0100
Message-ID: <20260917151402.664039567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7feb0eb6537db..9cbf045fe0031 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -405,7 +405,9 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
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



