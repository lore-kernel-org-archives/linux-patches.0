Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1F51527AC;
	Fri,  6 Dec 2024 15:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497887; cv=none; b=kZLD3LnfuKOctDIQmHBaqZ59PjWiavX8kviM1IE0DK6mkemZ9Jcb3AXZhojlYlt9EXYEmbSXROqX5V83b7ks6l13JAPGfLMO5CNryD1NtPrQeBrcmhAZ75zCbJXmHmJnXnfSZylyCSjs9WjPs9EcViR41KsrsxpmVOhMuVXz1yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497887; c=relaxed/simple;
	bh=bZQ6S/K7sxfvRaePwChVVaUTTauW5+o90iug0GKO5bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUgGkvrxtMK0AKxb4pVscVEBtsS57mWxnBNt93yz0cRhX8ZMNG45gIYbLhRrT1P51Rbcks8j2l3zwOMdo0o5N4Jsvy6e36brGmKfkiESWD0FeTrCSeExGeKpbD+Htkl5geLdI5ZOIuVBCXOjYdvpN4tvHjXySMpdh62jwcuveXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfLu6csN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfLu6csN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB82FC4CEDC;
	Fri,  6 Dec 2024 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497887;
	bh=bZQ6S/K7sxfvRaePwChVVaUTTauW5+o90iug0GKO5bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfLu6csNCqQMOcK2kvNxtAjFxLp+UxxLg8pnkWT9R3kOIjgfnWY3bTMRF8NnmjaGl
	 a+1oF9x4VPjKcc4gZK9wxTMPG8Z8V37sv2DTVa00aBzIAsw2kcQmFIpLUWjOW5xKb0
	 fFFIDPkAL5pllQO78awvMpR8gsD3vsZw+vt4/rrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	George McCollister <george.mccollister@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 415/676] net: hsr: fix hsr_init_sk() vs network/transport headers.
Date: Fri,  6 Dec 2024 15:33:54 +0100
Message-ID: <20241206143709.560386432@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9cfb5e7f0ded2bfaabc270ceb5f91d13f0e805b9 ]

Following sequence in hsr_init_sk() is invalid :

    skb_reset_mac_header(skb);
    skb_reset_mac_len(skb);
    skb_reset_network_header(skb);
    skb_reset_transport_header(skb);

It is invalid because skb_reset_mac_len() needs the correct
network header, which should be after the mac header.

This patch moves the skb_reset_network_header()
and skb_reset_transport_header() before
the call to dev_hard_header().

As a result skb->mac_len is no longer set to a value
close to 65535.

Fixes: 48b491a5cc74 ("net: hsr: fix mac_len checks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: George McCollister <george.mccollister@gmail.com>
Link: https://patch.msgid.link/20241122171343.897551-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index c5f7bd01379ce..906c38b9d66ff 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -253,6 +253,8 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 	skb->dev = master->dev;
 	skb->priority = TC_PRIO_CONTROL;
 
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
 	if (dev_hard_header(skb, skb->dev, ETH_P_PRP,
 			    hsr->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
@@ -260,8 +262,6 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 
 	skb_reset_mac_header(skb);
 	skb_reset_mac_len(skb);
-	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
 
 	return skb;
 out:
-- 
2.43.0



