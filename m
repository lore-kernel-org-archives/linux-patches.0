Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AF1377EDC;
	Fri,  4 Sep 2026 05:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500928; cv=none; b=ia4pgxjVn7nLkdJmpLiEpWBKmzuuGDZZqOowcw84eKspK72T+TsZVrjo+JQxSRZ3rLnj9Og+OY0GHulPSrNMBX/SvOumqyhumWdwt59k0gmOkI16gAA5LPcxc7EwC+82tNis/K6LePOKElLlt7S8Nlmmwtbm9GvuWYeG0lsUtJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500928; c=relaxed/simple;
	bh=rFDQe/Bg2wPXYIh0zAX3vsfr9rgzXfCiEbeHruahlu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3kHthiYyByJxK0l0K13iFUKCrpLvDKyfTEqa3abNoWcxEtEbOzBmIMxMInSF7QXa6XfZcXniUl2KlNcH6hNH6KA1epBUz4gmtUEoyS9RZyhp1NfNhzKEB8Up4z/E2rd53mxOaxMlC25pfAX7KZSgDhP2ArfQs2L4Xk11yjNzjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDnbMSuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDnbMSuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423441F00A3D;
	Fri,  4 Sep 2026 05:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500926;
	bh=qCvQY8a458AmzJZuZQu7MwosRrGdTRi1TSviYnQo4L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDnbMSuVAJ4AaYS+QV6of/VNtcQTZvOS3ADx32zg3KQsO3wbyxqrFYBPcrROIhiT8
	 JMjA2YhjOHuaI4GFW1/cCw96QdmlOTA2Th0OSHGBGo+B8hvChk0rdxYjEh79Pyh2m3
	 sbLTHDRoq5tdZzoHIDRL7TawMNIFfaPM7/b6GGfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Andy Gospodarek <gospo@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 229/552] bnxt_en: Write doorbell when linearizing skb fails
Date: Fri,  4 Sep 2026 06:56:26 +0200
Message-ID: <20260904045754.681956989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

commit 00eeab0c644a881a1dc86fbffb7e6047a6ce8ecd upstream.

When the driver is handed a burst of packets, the doorbell is deferred
until the end. If the last packet has a huge number of frags, but fails
to linearize, the doorbell will not be written adding latency on TX for
any packets in the ring and holding their DMA mappings until the next
TX. Note that the queue is not stopped, so this issue would delay
pending BDs until the next TX.

This issue was discovered by Sashiko and reading the code verifies that,
while unlikely, it is possible.

Fix this by jumping to tx_free, which replicates the same pre-existing
logic but also writes the doorbell.

Fixes: b91e82129400 ("bnxt_en: Linearize TX SKB if the fragments exceed the max")
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Link: https://patch.msgid.link/20260826000234.2031564-1-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -499,11 +499,8 @@ static netdev_tx_t bnxt_start_xmit(struc
 	if (skb_shinfo(skb)->nr_frags > TX_MAX_FRAGS) {
 		netdev_warn_once(dev, "SKB has too many (%d) fragments, max supported is %d.  SKB will be linearized.\n",
 				 skb_shinfo(skb)->nr_frags, TX_MAX_FRAGS);
-		if (skb_linearize(skb)) {
-			dev_kfree_skb_any(skb);
-			dev_core_stats_tx_dropped_inc(dev);
-			return NETDEV_TX_OK;
-		}
+		if (skb_linearize(skb))
+			goto tx_free;
 	}
 #endif
 	free_size = bnxt_tx_avail(bp, txr);


