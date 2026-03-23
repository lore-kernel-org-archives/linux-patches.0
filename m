Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A48F3B8958;
	Mon, 23 Mar 2026 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282294; cv=none; b=cc3bn3J98HIP66paLB3hDJsgThWn6uC+IlRt6/nQfuIcjupT9EcoH+CVYQY3BW0Kcs6CClIFM+zCb/q5SYq5wx6GM+S7PGCBQGO9NkD8yE2wKg7SghJkExcK9oGwbKDlMC9FIhVcSJJua6WJyUcQ0VbuXD6ak8F+VQmf1BiTlgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282294; c=relaxed/simple;
	bh=3+bx01LyMaSlpavxsfAFKwQsEKTw8uJHDoCGyesAmvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFt6L7ES03TxoEt5dgixREVBXRMuVeNaU9VftDPu2OckdesoFbiSamSGikgGa95LpA2AqRDaaEQUrwMj5OgvN0BCsgcTVZX0jhos2JWTuzQGOWGGH2QfasT/H+9f0NbTVYStR2VnrUoGpjj0ocRJ/EJIcn0v2/bXUZIjjInKwNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmVySYTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmVySYTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2F7C4CEF7;
	Mon, 23 Mar 2026 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282294;
	bh=3+bx01LyMaSlpavxsfAFKwQsEKTw8uJHDoCGyesAmvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmVySYTa1GqBjlA0qHjcJc1VTGZ5qwvm2BsJY1eEu6yJuVxnZb0+uwXisxAF7Q2DN
	 AiHu8HHTjjC2iMQEgg1PyiRaPxvDPEIV+HjyVhnTYTuOGy/69ZsWPbYsLHcZM0NvN/
	 a81FfsswbuXSELCU1s1Vdlt2HSJFxgXLAKLIlL9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/481] dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler
Date: Mon, 23 Mar 2026 14:41:26 +0100
Message-ID: <20260323134527.821601359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 74badb9c20b1a9c02a95c735c6d3cd6121679c93 ]

Commit 31a7a0bbeb00 ("dpaa2-switch: add bounds check for if_id in IRQ
handler") introduces a range check for if_id to avoid an out-of-bounds
access. If an out-of-bounds if_id is detected, the interrupt status is
not cleared. This may result in an interrupt storm.

Clear the interrupt status after detecting an out-of-bounds if_id to avoid
the problem.

Found by an experimental AI code review agent at Google.

Fixes: 31a7a0bbeb00 ("dpaa2-switch: add bounds check for if_id in IRQ handler")
Cc: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260227055812.1777915-1-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index b29f49ec64049..510a018978d9a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1536,7 +1536,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	if_id = (status & 0xFFFF0000) >> 16;
 	if (if_id >= ethsw->sw_attr.num_ifs) {
 		dev_err(dev, "Invalid if_id %d in IRQ status\n", if_id);
-		goto out;
+		goto out_clear;
 	}
 	port_priv = ethsw->ports[if_id];
 
@@ -1559,6 +1559,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 		rtnl_unlock();
 	}
 
+out_clear:
 	err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    DPSW_IRQ_INDEX_IF, status);
 	if (err)
-- 
2.51.0



