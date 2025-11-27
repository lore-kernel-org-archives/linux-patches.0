Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A22B273816;
	Thu, 27 Nov 2025 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254865; cv=none; b=ZmA+bGqR/t7gpYurxxLGHWDYi45D6s84GM/Y/sHeItqUsHqZpMvXf/UICcM3Xrg7KM+8YVOohcsW2L1YKqbFKvjJA3FdTzLDYWiyV924Tmfam0/EGFzK26BCdDLf086o7eNtbaQIBbP9YHanoHGQ+v+KcwPHcfW4JJLSTmehTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254865; c=relaxed/simple;
	bh=ROz2PM8+rGXDAzImK6NtdVXVFhpqEGnhl04yGhIMvfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Owp2pIOueL76BHBcRiBkwIuWgStdxKGUTIrCQnZULnPBcalKF/eFsd49fLApgYskC4WislJkfszEYwQf3nkRzmrLBDdOdoOevNxGIVXQNrIDacUH+jKvPdhOQ4P+hADO32FgR17TEQ4DysOtlxR25F6c6HpDHtoQEev+iFX16OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiiXFEj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiiXFEj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE2AC4CEF8;
	Thu, 27 Nov 2025 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254864;
	bh=ROz2PM8+rGXDAzImK6NtdVXVFhpqEGnhl04yGhIMvfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiiXFEj/fpPGJGmmltSqAMIOMlbLxZyq4jJX0wewG/Kp219Zoq04MhLJm+vFqkbmT
	 WN6BrQOq6ZPDNxfehgsgATWFX+Z/v7qcDaZbUDKLzbTVSbjw82QIJRxfZtueKbQFjO
	 fLBRszWj5bNny9T5PK5d27fo7Y7mQBKeSgBD+dzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 13/86] be2net: pass wrb_params in case of OS2BMC
Date: Thu, 27 Nov 2025 15:45:29 +0100
Message-ID: <20251127144028.302863626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

commit 7d277a7a58578dd62fd546ddaef459ec24ccae36 upstream.

be_insert_vlan_in_pkt() is called with the wrb_params argument being NULL
at be_send_pkt_to_bmc() call site.  This may lead to dereferencing a NULL
pointer when processing a workaround for specific packet, as commit
bc0c3405abbb ("be2net: fix a Tx stall bug caused by a specific ipv6
packet") states.

The correct way would be to pass the wrb_params from be_xmit().

Fixes: 760c295e0e8d ("be2net: Support for OS2BMC.")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://patch.msgid.link/20251119105015.194501-1-a.vatoropin@crpt.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1296,7 +1296,8 @@ static void be_xmit_flush(struct be_adap
 		(adapter->bmc_filt_mask & BMC_FILT_MULTICAST)
 
 static bool be_send_pkt_to_bmc(struct be_adapter *adapter,
-			       struct sk_buff **skb)
+			       struct sk_buff **skb,
+			       struct be_wrb_params *wrb_params)
 {
 	struct ethhdr *eh = (struct ethhdr *)(*skb)->data;
 	bool os2bmc = false;
@@ -1360,7 +1361,7 @@ done:
 	 * to BMC, asic expects the vlan to be inline in the packet.
 	 */
 	if (os2bmc)
-		*skb = be_insert_vlan_in_pkt(adapter, *skb, NULL);
+		*skb = be_insert_vlan_in_pkt(adapter, *skb, wrb_params);
 
 	return os2bmc;
 }
@@ -1387,7 +1388,7 @@ static netdev_tx_t be_xmit(struct sk_buf
 	/* if os2bmc is enabled and if the pkt is destined to bmc,
 	 * enqueue the pkt a 2nd time with mgmt bit set.
 	 */
-	if (be_send_pkt_to_bmc(adapter, &skb)) {
+	if (be_send_pkt_to_bmc(adapter, &skb, &wrb_params)) {
 		BE_WRB_F_SET(wrb_params.features, OS2BMC, 1);
 		wrb_cnt = be_xmit_enqueue(adapter, txo, skb, &wrb_params);
 		if (unlikely(!wrb_cnt))


