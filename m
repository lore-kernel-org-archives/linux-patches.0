Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FD33B52E2;
	Mon, 23 Mar 2026 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279275; cv=none; b=BrQkrlJixmcP8Ln2E/1Au/8R1TvDxkBoX9MQm5eAds8vrf5H5mY+hseA1C2Y6IhH3cI2kouQ8N2OrGnsOB72X/dXxu2vPSK+n57hn8rRv0keaQ/QjDbCIpUi2r0I5V1ipR2V5lQ/UQkQxR+aVV07k6LUUbeQAHGatiGASasTPP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279275; c=relaxed/simple;
	bh=vlmvF6TzT4g/EQDOrX4qQ7d5aRE4DDVhZ7JAcE/SWQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNKNitixNYoFeNtSqOjVdqqrRUX391kLIVdcFr7KgRPjp4hd1CJwtTm6T2JWa5WuxuCPwn0Uea3Splx6UlI3Z2fkeiE7A+RvGJmv/+eepbmmWJuxCcGLRCGYzCo8DPF1P/dGP1Py/uGgcflpiy+FpKGUhYb5LUqYGlkLajU9b8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nz4ZVTUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nz4ZVTUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B775C4CEF7;
	Mon, 23 Mar 2026 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279275;
	bh=vlmvF6TzT4g/EQDOrX4qQ7d5aRE4DDVhZ7JAcE/SWQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nz4ZVTUziyAiZ+2bL1WXp2u00qn6AWddgq59aJ5J0V0WUyiiuRdZHshPk+b4TB/rS
	 eYNATwhB0Gg/33Jxld4BWdJD/fqIblMZE4i9Few7kdoYgjSVDb1zQYsSG8I8YrtZZD
	 IR6FgEdbDCAK8WcbKg+dkMry+UknJ5p6ZSgaKPA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 532/567] igc: fix missing update of skb->tail in igc_xmit_frame()
Date: Mon, 23 Mar 2026 14:47:32 +0100
Message-ID: <20260323134547.160574654@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit 0ffba246652faf4a36aedc66059c2f94e4c83ea5 ]

igc_xmit_frame() misses updating skb->tail when the packet size is
shorter than the minimum one.
Use skb_put_padto() in alignment with other Intel Ethernet drivers.

Fixes: 0507ef8a0372 ("igc: Add transmit and receive fastpath and interrupt handlers")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3e1408e1c1fcf..13c41facfc976 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1700,11 +1700,8 @@ static netdev_tx_t igc_xmit_frame(struct sk_buff *skb,
 	/* The minimum packet size with TCTL.PSP set is 17 so pad the skb
 	 * in order to meet this minimum size requirement.
 	 */
-	if (skb->len < 17) {
-		if (skb_padto(skb, 17))
-			return NETDEV_TX_OK;
-		skb->len = 17;
-	}
+	if (skb_put_padto(skb, 17))
+		return NETDEV_TX_OK;
 
 	return igc_xmit_frame_ring(skb, igc_tx_queue_mapping(adapter, skb));
 }
-- 
2.51.0



