Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970D9768EA;
	Mon,  8 Apr 2024 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582550; cv=none; b=FhhHliC/sWUOvburgOfNbyg/YtR197IvmEDC8FHeufcNkfBiI/RW+gP2KqOUQr3ANplc0bJRNCVcB+9YmVbx8YgNjthC6SVxAq+MA9o6NiLk26JpZUS2h9aiDY2mVLhgt+pTZu3IqVwHhpmdRdEaw3jRoaz7VgprmLpVp0Fyan4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582550; c=relaxed/simple;
	bh=NBnrXbNauukYCGSxgKdM1vkJaWy/pj8MWyMiz0JGSNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prQiz5A1NEsmRfBrXjRX0QvXyhfGFeYtH9apEUVyVx2VqgOsoz1+YtAsDYFY1QdzoAhdV61oaoW9erFDcEA5wBL3VlnWlXGPQ7wtHTw3J1ol3aVQvBkdOO7FDck5xr+tLS/3Z0sG+L3iPrb7szf9hm1jEhxvgFsttKoVu0ANupY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITspUhEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITspUhEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20873C433F1;
	Mon,  8 Apr 2024 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582550;
	bh=NBnrXbNauukYCGSxgKdM1vkJaWy/pj8MWyMiz0JGSNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITspUhEMNN1dCpluxlHCH/eKomq1MCau5KvVrwA8jhlZHnyXZHFp2DlwCarRR89Lv
	 Tz0g/D+JUYnJ+3n6a9SQFb2wizdbmCsmyhsAmI2IiEdhDiObC0lsbW3NiY3JUOTBDi
	 vZp/YcAhIBYFQbvHGA5OERDdSyNxiQOuys4hsYdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 085/273] net: mana: Fix Rx DMA datasize and skb_over_panic
Date: Mon,  8 Apr 2024 14:56:00 +0200
Message-ID: <20240408125311.939291166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit c0de6ab920aafb56feab56058e46b688e694a246 upstream.

mana_get_rxbuf_cfg() aligns the RX buffer's DMA datasize to be
multiple of 64. So a packet slightly bigger than mtu+14, say 1536,
can be received and cause skb_over_panic.

Sample dmesg:
[ 5325.237162] skbuff: skb_over_panic: text:ffffffffc043277a len:1536 put:1536 head:ff1100018b517000 data:ff1100018b517100 tail:0x700 end:0x6ea dev:<NULL>
[ 5325.243689] ------------[ cut here ]------------
[ 5325.245748] kernel BUG at net/core/skbuff.c:192!
[ 5325.247838] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[ 5325.258374] RIP: 0010:skb_panic+0x4f/0x60
[ 5325.302941] Call Trace:
[ 5325.304389]  <IRQ>
[ 5325.315794]  ? skb_panic+0x4f/0x60
[ 5325.317457]  ? asm_exc_invalid_op+0x1f/0x30
[ 5325.319490]  ? skb_panic+0x4f/0x60
[ 5325.321161]  skb_put+0x4e/0x50
[ 5325.322670]  mana_poll+0x6fa/0xb50 [mana]
[ 5325.324578]  __napi_poll+0x33/0x1e0
[ 5325.326328]  net_rx_action+0x12e/0x280

As discussed internally, this alignment is not necessary. To fix
this bug, remove it from the code. So oversized packets will be
marked as CQE_RX_TRUNCATED by NIC, and dropped.

Cc: stable@vger.kernel.org
Fixes: 2fbbd712baf1 ("net: mana: Enable RX path to handle various MTU sizes")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1712087316-20886-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |    2 +-
 include/net/mana/mana.h                       |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -601,7 +601,7 @@ static void mana_get_rxbuf_cfg(int mtu,
 
 	*alloc_size = mtu + MANA_RXBUF_PAD + *headroom;
 
-	*datasize = ALIGN(mtu + ETH_HLEN, MANA_RX_DATA_ALIGN);
+	*datasize = mtu + ETH_HLEN;
 }
 
 static int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu)
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -39,7 +39,6 @@ enum TRI_STATE {
 #define COMP_ENTRY_SIZE 64
 
 #define RX_BUFFERS_PER_QUEUE 512
-#define MANA_RX_DATA_ALIGN 64
 
 #define MAX_SEND_BUFFERS_PER_QUEUE 256
 


