Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB3D377563;
	Thu, 17 Sep 2026 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659072; cv=none; b=axWYY5G+YzZatI6oLOiGuEoAmdQ/X+ZtK5lk9Hok9vrNvSOgUZjDwEoBbq2k/fPrUVi6y/23EO6cpwG3SDPqou5xwRzj29vxRjnVVjRta9HPlAeUy5XkWTibi+5HGd5Ov+iBnQORo19ogLkRahSSJUig414rpuadjORe6Y4XQ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659072; c=relaxed/simple;
	bh=hbSADkeQcUvihcU9hVYkbRyrwHyr1Rgo4+ryIaYXxV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qY2m/DgAa6t1kthNYtGt5vmi65whp4W36KpMOhEUIbdrjIedy2lW8OpLcBqb/z5rBnjW2b6lKGXYi8ZBt5vcMPEdNZv/UhfLSV+ycQBJv1V5Xl0TeZ4wZZAKTqHwj3eZv9mGyV2golim5b60C1SSJYolwfYge5yilsD6Y6JtaH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpP4dvYr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpP4dvYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F3B1F000FF;
	Thu, 17 Sep 2026 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659061;
	bh=1tl0rujdYwVEWB6EnCWHe/HpR1Lc11hF0xqgOZYUZzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpP4dvYrSZwJYK7UxgCp63bLkyJQysP7eUVjL6bikAMOhYeC8g9lUgAQc3RKlO7ui
	 n8xL3VWE+8KRZtRQv634MFqVcDB+j4SC6anbv7/EtMeY10D1RgFenviBiZqZM9Zq3T
	 HAu4O/EwPEJwWGUMGgug11OpwF7Cf8uR9MmnMOdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 131/733] net: ethernet: oa_tc6: Disable tx queues on fatal error
Date: Thu, 17 Sep 2026 16:07:19 +0100
Message-ID: <20260917151354.286571832@linuxfoundation.org>
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
index c60e0f37b7c5e..bc468cd86a140 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -717,6 +717,10 @@ static void oa_tc6_disable_traffic(struct oa_tc6 *tc6)
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



