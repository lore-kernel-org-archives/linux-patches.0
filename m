Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D0033CF2;
	Fri, 24 Nov 2023 19:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KutqCUIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C943C433C8;
	Fri, 24 Nov 2023 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853366;
	bh=sAXA8unYC6Do4FUUPsU1/XGBnIoOPOjQ5dMgYhx8T4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KutqCUIO89HAkPhmNa6Vt7VmeNCHMZbXshWHX5XWqdq8a5zV4Gz5qDR6/JpB3VEk/
	 Wc8j6TQ8m5CqnTmLpZJlsUzcEmtOKRHVLi9oRzB1HPDidsd3l1LgyCbSFZUPGlHBwQ
	 JeJ6VkCgnF+KxatyDJAclzw00LiLA8AzTJTl02tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	Serge Semin <fancer.lancer@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/297] net: stmmac: fix rx budget limit check
Date: Fri, 24 Nov 2023 17:52:47 +0000
Message-ID: <20231124172004.682737598@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit fa02de9e75889915b554eda1964a631fd019973b ]

The while loop condition verifies 'count < limit'. Neither value change
before the 'count >= limit' check. As is this check is dead code. But
code inspection reveals a code path that modifies 'count' and then goto
'drain_data' and back to 'read_again'. So there is a need to verify
count value sanity after 'read_again'.

Move 'read_again' up to fix the count limit check.

Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/d9486296c3b6b12ab3a0515fcd47d56447a07bfc.1699897370.git.baruch@tkos.co.il
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a43628dd1f4c2..2b4c30a5ffcd9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5165,10 +5165,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		buf2_len = 0;
 		entry = next_entry;
-- 
2.42.0



