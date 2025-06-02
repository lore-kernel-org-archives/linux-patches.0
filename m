Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8305822ACEE;
	Mon,  2 Jun 2025 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874413; cv=none; b=HfzPC9hHJjK64Q38TbtRzR8Wslohi4S+Bza86617uraVaavFA8VkltI/n+F9rPW//wJN92pkwFCa3m9ajdwmPLQdjfqPqHQ/i0GL1payE08Ds7aNVhgsi6cxV9ds8n3jKNww1dZUkLtRIC7FOJNZJg3wofas9ztZ3DQLyK5TvEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874413; c=relaxed/simple;
	bh=vPWU+o6drO5Ybfvts/HZnAe0Cji3RZFVfzd3Wj2dvZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC8ljPA3dSprA17vSwZ3Tmc4/8ayn6hkw8N9ctcMuh1AiC2f9/jb9FT8sgxotEQc1Jc+9/nBdc9kdys8jqrYfgG8q/Di5ELKKTsM4BubFm5e+UBy9ykew9q+uWvzLIe8iUYPkIPslUD2oeJxThUk0mj7JJXY+76al2rYikfTdLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4aakhck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4aakhck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C38EC4CEEB;
	Mon,  2 Jun 2025 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874413;
	bh=vPWU+o6drO5Ybfvts/HZnAe0Cji3RZFVfzd3Wj2dvZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4aakhckaSwMJGXggSs5XVBC+LNPsiQsBnO+e7ZCEJEB+9YXrFXLKy2siSFA2htzX
	 2M8BLRU7Lt07FMyXgJuC3DZfMpmB3TGYBEuipkaVZnwCdZsOFgH4jOb2j4O5QHDhPc
	 WbeJPKA7t3mDI6/uj0xUNOfyuBkePD1W0EfR+m1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/204] lan743x: remove redundant initialization of variable current_head_index
Date: Mon,  2 Jun 2025 15:45:49 +0200
Message-ID: <20250602134256.131907208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit bb809a047eb5070e2fc76aa62d111fbbe656c532 ]

The variable current_head_index is being initialized with a value that
is never read and it is being updated later with a new value.  Replace
the initialization of -1 with the latter assignment.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2d52e2e38b85 ("net: lan743x: Fix memleak issue when GSO enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 6458dbd6c631a..5d539e4e942cc 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2004,14 +2004,13 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 {
 	struct skb_shared_hwtstamps *hwtstamps = NULL;
 	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
+	int current_head_index = *rx->head_cpu_ptr;
 	struct lan743x_rx_buffer_info *buffer_info;
 	struct lan743x_rx_descriptor *descriptor;
-	int current_head_index = -1;
 	int extension_index = -1;
 	int first_index = -1;
 	int last_index = -1;
 
-	current_head_index = *rx->head_cpu_ptr;
 	if (current_head_index < 0 || current_head_index >= rx->ring_size)
 		goto done;
 
-- 
2.39.5



