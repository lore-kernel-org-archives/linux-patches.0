Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EB149D587;
	Thu, 17 Sep 2026 18:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670855; cv=none; b=dseV46ZA0HCELhF72KE7juLie9vhiudjOpcWXcis8MNFiHZXTtu7AmxcBV13K1X+lbWXS2y/ejN6VrJd4A9BmIO3ljEQcm/ugLQxvpow1DldY5tLEvdcSj0JIrxorvIzvha/9+VLEIFDGz7JozFMKHc6yK4bIHjeJHv969i7OnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670855; c=relaxed/simple;
	bh=hTwzZdD122Dvjr5eNXQoKkXImJ3GOLbJV1hWjQ+Lhy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoJv9PWj3HouqjBy1J6/DtxoEkyhWGk7u+7wguZ/GqStgypXz6sIMsXX9eBJaIVkpgejiO4hAE/CW9dBQaxL6hC+yqENBmPHqpzH3HzszbnQGdHN3CRT2491tZhtP7nPUmRt35YY9q7gTg39iz/7SSHmjRJ8hpER0aMGCI3IWrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iX9A6ziE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iX9A6ziE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0341F000FF;
	Thu, 17 Sep 2026 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670854;
	bh=j3IM7e4b5+CKlzRD6GIWtiyq1/W6wKcZiOZ2DN5Jg4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iX9A6ziED+7ckLtbAb/tp2aaktHoS50YwSdWauQKIHztE0uOr8FVKoZZsPqTdvEeT
	 dMg03GiPqoMY5X9dzznYWGGKRyXhmRYvWrklGxGEaxxITjzO8jsS1UmKkdXkYNQ6K6
	 ZzTRofRJuBQKyA9sIWW41wVuufDreCQx520EGo/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Marsden <greg.marsden@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0790/1102] net/rds: fix tcp stream corruption with large pages
Date: Thu, 17 Sep 2026 16:12:13 +0100
Message-ID: <20260917151600.301627322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9824e79e057f4..5d9286da53c9a 100644
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



