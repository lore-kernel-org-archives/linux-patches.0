Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214941;
	b=Moc2P08dq8vcQNI4DJ/DaWWXHcrZ5LGS/84kFreDTpTiRMvarZ2nJlxOVnyDI7SjxAg9
	 kepQiiNHhXVkjHN6FpAT/QuB5rphJjYFaeVMLpeUFqAAJ/a+tUiqxqBpWGjFBgYYtqMQr
	 FjJWVWcv+dSnXBi37yXdKAZvFomGeMf9C5zHWcybpZukCwF/nGbHzlPtjaicFZ7doTEd4
	 VoQbDWHtInP+ldjsxMjvp6IQE+QQPD7bOx66i07COiyMGq+CITFAjWDR7jPA6F7ITlVsp
	 jAJ/JsJCNgo613FgvENaeuziKngqK4UHSEPH8FTqz2/JSAqoRI7tOUbYkh0abSJuHFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Y7/Os4Q7ZWM+QlsA4yBHD70V+b+KkAUzgOBlnyCjJg=;
	b=k+tl0meaZc8FCab5ADDuPjgv+jxMxeTbr2MA7NjacC462GUtDuefYCPJs/7Svg5allLj
	 3muUk7vMDvqTsf8kGFQtAZWxfIzjHMeLC33L8aHblK+Ghmgt/bhcYntuQNerz28vq7cXc
	 zQagx6GSFtTGY5suVudnLtdJG1waXeiLknrbPfViVtLJ546tFsdHCaTgMOFenQYp1hhLU
	 MXcY2Gkby+icqU2MCaylyAzexXDUPJh838Kuj2f7xwNdZEKO2kA4mpjHcukQh9DeIg8H4
	 BfQFPDyVk0sfCVCjNzdhXEwyfzxLNNWPWZWpraNYZoIgpYf3MNuUnCi+Zhff85xAxrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrvVEwXG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD45606A320;
	Wed, 28 Oct 2026 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrvVEwXG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386D81F01825;
	Wed, 28 Oct 2026 19:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214940;
	bh=/Y7/Os4Q7ZWM+QlsA4yBHD70V+b+KkAUzgOBlnyCjJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrvVEwXGiF1xsgXufPru++G+mVYwgTroUUVsmTl6qUzzLZckjxv9FClaRnH2ptfof
	 QuR39gHH6VibwqIN/1cZCFOZfrug64RaHWxnIlzHE5AOcPDTl8rxmWSS28TwyRmnqT
	 ETFEXLtaR30QCS32uPv4mkJfyH2c/HhWfwKM3nQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1034/1887] ext4: delete redundant calculations in ext4_mb_get_buddy_page_lock()
Date: Wed, 28 Oct 2026 17:52:10 +0100
Message-ID: <20261028170522.942578280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit f2fec3e99a32d7c14dbf63c824f8286ebc94b18d ]

'blocks_per_page' is always 1 after 'if (blocks_per_page >= 2)',
'pnum' and 'block' are equal in this case.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231024035215.29474-1-gouhao@uniontech.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: bdc56a9c46b2 ("ext4: fix e4b bitmap inconsistency reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1968918366ee..3b9a345b94140 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1385,9 +1385,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 		return 0;
 	}
 
-	block++;
-	pnum = block / blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, gfp);
+	/* blocks_per_page == 1, hence we need another page for the buddy */
+	page = find_or_create_page(inode->i_mapping, block + 1, gfp);
 	if (!page)
 		return -ENOMEM;
 	BUG_ON(page->mapping != inode->i_mapping);
-- 
2.53.0



