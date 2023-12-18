Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6601D12F;
	Mon, 18 Dec 2023 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OE3duLeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ACEC433C8;
	Mon, 18 Dec 2023 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908084;
	bh=ZswE+hlw4EXdcFcJSV7EuaY+GPMignWbuA1W9kLDfkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OE3duLeDkBx8++W606R47gdgIAMA3IeK7N1rdnWiQ5WZAyxRZTOFZo0/hnTB+Rp7e
	 wDUeCHhSw6YzNAOJt4HZLlqZNkrZUJWZCHe5/QufW+mgLBhU0dvC7CVkX2Vzj3nbys
	 lco6E6D8u/VezVbf6UBfCVR2RqBJ1t9ruwPwkE9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/166] net: ena: Fix XDP redirection error
Date: Mon, 18 Dec 2023 14:50:13 +0100
Message-ID: <20231218135107.118584207@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 4ab138ca0a340e6d6e7a6a9bd5004bd8f83127ca ]

When sending TX packets, the meta descriptor can be all zeroes
as no meta information is required (as in XDP).

This patch removes the validity check, as when
`disable_meta_caching` is enabled, such TX packets will be
dropped otherwise.

Fixes: 0e3a3f6dacf0 ("net: ena: support new LLQ acceleration mode")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Link: https://lore.kernel.org/r/20231211062801.27891-5-darinzon@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 3d6f0a466a9ed..f9f886289b970 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -328,9 +328,6 @@ static int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
 	 * compare it to the stored version, just create the meta
 	 */
 	if (io_sq->disable_meta_caching) {
-		if (unlikely(!ena_tx_ctx->meta_valid))
-			return -EINVAL;
-
 		*have_meta = true;
 		return ena_com_create_meta(io_sq, ena_meta);
 	}
-- 
2.43.0



