Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621174;
	b=X2efnzeVetcKnmzV+863YgYBg4oKKPl8an2J9lTiPXNbA0lEYvaAgqrt2P/f2AdwiBJC
	 W4qaW7YVzS9FLMyLbcrNLXCMIkgY0nm5X59bW4bSPzryBiwplBx9bbLmoTaIin12qP7M5
	 r4VaagDm91knoE1GSuRrTJPX4UyiLrvLWoJ+hY5erOFOpT5wEBcS4Q65PYAYEE7mLtVM0
	 IufrsnP3fQSYjDDbwrvuzVm/PkIRAR+GvwXGZfP/dxi/Z+Mhyz6FXT4An32ZoNOPqX6zK
	 1XswAIkuj33KrHPQPh2ccxOYNQZsSt8FucvHT02J3Wxmn4XE5Z5lY2ODABTSOGQ6zIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFReEKzmr8EU+fzUJj8TLgF42a6lnhc7p/c1MLTDM8k=;
	b=Jlmx1+vQQ30IhLTwrVX8gHlVejomMDV4aPrVr5hZs4ENeSYSzMCPC7k0fvTL3Bc9Zc14
	 /42qL1EGnkVkNRK75VDDqkGCVg2Sh6c1yBL52kuwdvzUQgIay+/ZaYTDhJe6M7EwrxGWx
	 riGMQbUm8m9pdhN725ChcODIbQEi5HsXg4ujemrKybYblM7NcNaBT+yHXESrg7BdiLTlR
	 KcLeYHrcuen5dL8Xjh3sFo6FCbdoKVFYj9gZF+pPQAZaZSpBe9gUJVb9TQrZOryHDLkHC
	 bjK0XiEhlmqIPHSf61ixPaTXLLbYQSPTG7qDPye/YuMf13+i11lrzCSnyHXdRw3aQdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h41ZIOar;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC3F606A33E;
	Wed, 25 Nov 2026 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h41ZIOar
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3FE1F000D4;
	Wed, 25 Nov 2026 15:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621174;
	bh=eFReEKzmr8EU+fzUJj8TLgF42a6lnhc7p/c1MLTDM8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h41ZIOareXnLM9OPKpod4OxZKzY0YCPeSXJ0edvzbtAzDAduOcX4AGgVHZ3SyIHsb
	 lNu3q8JAlG4WPdkiVXi5MrZMgdupoUCi72rqUBqwgm464buud2wNAqnm17xk3tCtOx
	 1m8ViO28v0tUgsJI678O0EUHmS3q3hlJDG5DR+qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/990] net: lan966x: dont free XDP buffers in fdma tx clear with budget 0
Date: Wed, 25 Nov 2026 15:25:11 +0100
Message-ID: <20261125143825.457805290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 263a5514cb9535380734b5e300b298f82570eb57 ]

lan966x_fdma_tx_clear_buf() runs from the NAPI poll and frees the
buffers of completed tx DCBs with napi_consume_skb(),
page_pool_recycle_direct() and xdp_return_frame_bulk().

netpoll calls the NAPI poll with a budget of 0 and hardirqs disabled.
With a budget of 0, a driver cannot call any XDP or page pool API.

Before this patch, the XDP_TX pages and ndo_xdp_xmit frames are freed
regardless of the budget. With netconsole on the port that owns the
FDMA NAPI, such a buffer is freed with hardirqs disabled, and
__page_pool_put_page() warns via lockdep_assert_no_hardirq().

Leave the XDP buffers of completed DCBs in place when the budget is 0,
and free them in the next NAPI poll. napi_consume_skb() already handles
a budget of 0, so skbs are still freed.

Found by an AI code review agent. Reproduced on a lan9668 board with a
modified kernel that runs the NAPI poll with a budget of 0 and hardirqs
disabled. With the fix the warning is gone.

Fixes: 19c6f534f636 ("net: lan966x: Add support for XDP_TX")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261029-lan966x-fdma-tx-clear-budget-v1-1-38c52d7aab8c@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 11a341fc45779..6dad3c019f01c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -354,6 +354,12 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 		if (!fdma_db_is_done(db))
 			continue;
 
+		/* XDP and page pool APIs can't be used with a budget of 0.
+		 * Leave these buffers for the next NAPI poll.
+		 */
+		if (!weight && !dcb_buf->use_skb)
+			continue;
+
 		dcb_buf->dev->stats.tx_packets++;
 		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
 
-- 
2.53.0



