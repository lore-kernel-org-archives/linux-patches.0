Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739F24E0B7C;
	Thu, 17 Sep 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668866; cv=none; b=jNLwpkhrR4DT+ZWjcsCHAhQbhvEkQGK9ry5ApDFJyj9RNTykww2hwCM1DYDWUVIH5VkdLDB9oagAi/I5+pbNbS07PWu9KBsytZWuKnGLv0DZKtyPW1H7pivpsOcT4qagWZ+3Wz4jxPoaSnV+y6BG5kIpMYP4onjThtSBDl7er+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668866; c=relaxed/simple;
	bh=+Fvh/AlhF1p33efMyETzg3L55i7CTbB9Oh/J8ogzMSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiQNWwrSZ3tUPM3WQv9jK2UZgiKMRQtfCMWaU8BOKeZ+oRP4U1JnpFLFVndaZUMLXP3JZ27KWQUK5JRZdM9I2+8XYE6RExcg9jpE58SYHsAskoyapfVpcbX8HqvlKg/k0i8KrnqmU8hsy3zuJVKqsm+QQbIG9Jv32+l6swgeCkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMOY6DbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMOY6DbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24971F000FF;
	Thu, 17 Sep 2026 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668865;
	bh=3/yjcyJh/CcXPinpNw3GNYFiW9x1PowIGAnWpzVoLEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMOY6DbTO+hxF7deJ2rHj7LH6xRpH0E962Qr3EB+gzQrTAd2lL/hiBDh34ojOmrdP
	 VhPj+GX/eFhNB5XNbYx5L8uiDGDOL085howQtxlH+y24J81XFGxiwB3xAihOMhbnZa
	 BvYk+2V/yQnQEvfW1xp9UKKA1Ya8BFsCRKBbxIi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0567/1102] net: ethernet: oa_tc6: Disable tx queues on fatal error
Date: Thu, 17 Sep 2026 16:08:30 +0100
Message-ID: <20260917151554.137894584@linuxfoundation.org>
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

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit 349c366365876b7f67120827a0deb44899f59303 ]

Previously, TX queue interface was stopped when
disable_traffic flag was set, which would indicate fatal
error. It is more appropriate to disable the queue as,
unless driver is unloaded and reloaded, there is no recovery
after disable_traffic is set.

Queues may be re-enabled inadvertently by other layers.
Intention of disable_traffic is only to stop the traffic
from flowing on fatal error.

Fixes: b542d13fab0f ("net: ethernet: oa_tc6: Interrupt is active low, level triggered.")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260824-fix-race-condition-and-crash-v7-3-4323279b18f2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index aca771674347a..e4949a310af2f 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -718,6 +718,10 @@ static void oa_tc6_disable_traffic(struct oa_tc6 *tc6)
 	skb = oa_tc6_detach_waiting_tx_skb(tc6);
 	spin_unlock_bh(&tc6->tx_skb_lock);
 
+	/* disable_traffic, when set, is a point of no return to
+	 * working state. Keeping the TX queues disabled.
+	 */
+	netif_tx_disable(tc6->netdev);
 	oa_tc6_drop_tx_skb(tc6, skb);
 	oa_tc6_free_ongoing_skbs(tc6);
 	oa_tc6_write_register(tc6, OA_TC6_REG_INT_MASK0, regval);
-- 
2.53.0



