Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56053BF687;
	Mon, 23 Mar 2026 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283331; cv=none; b=F8V0fubDMQ662IiZfPTcp82yTJ6Rvi+0AO3WtbkdPMqtcqtGjwfvmxZKeQ71zxp1nqROBImC62X2mdyT9JGCXCiLYhvolR454zrWcinCCq8xuAMlkMX2rDbI0RG1oNUR4D4aNcdq9TGOOvUFhSxLA9hcgsaoltfgVFyHxyxRC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283331; c=relaxed/simple;
	bh=HaniH7fwZzGT99ACVVWyyiaaaeRg4pBNiS8RYJU7k3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8KupkrJgbFZNFCj9madmH4i8SEB5Sulr1AjmFenTXT8Qw8PkUizStQAronOnIiKCncrvY1zs7YlgQah6505vCuM/k3yS40cJOlgUed5nrUua+c8crWhw3LTj/8FaZZljLafBL0A3K+DSN0e1mGYkXNAr0+GnWvWSfRW+5i2m5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VD9p3Crr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VD9p3Crr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B66CC4CEF7;
	Mon, 23 Mar 2026 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283331;
	bh=HaniH7fwZzGT99ACVVWyyiaaaeRg4pBNiS8RYJU7k3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VD9p3CrrWVGF+Q5QJW9GB+zyF3jacbW5PTT8wcq/o0Gj+0afB+nYbyIxBQ9Opro9Z
	 x8ETVcE2ViAxirBKaVzKNR2uCLySXa8a5qE5AiymHYsD4t3PEhoyLTc6PoykW+fmhv
	 O0zE9+ezY4QDEi1GMdNpY+/KD/2cPQzq6p1T56Ec=
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
Subject: [PATCH 6.1 427/481] igc: fix missing update of skb->tail in igc_xmit_frame()
Date: Mon, 23 Mar 2026 14:46:49 +0100
Message-ID: <20260323134535.609720948@linuxfoundation.org>
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
index 5bcdb1b7da29a..8f8312a250c83 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1667,11 +1667,8 @@ static netdev_tx_t igc_xmit_frame(struct sk_buff *skb,
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



