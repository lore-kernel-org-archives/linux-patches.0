Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162E53B8120;
	Tue, 21 Jul 2026 20:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667529; cv=none; b=a0R5P/zHwE+eTof4uRK4UteuTmuF6lEX4dYMcv99iQCXjvbrjVCvCqcWNiz91O5cY5E8yTCm9cvGL2nAWGvoODqHe73kvCa1fRFp/nw6J1TE9KIENcyNlNPHDrkIoQX34L58wdSiuhIDgyTd0CFYPI+8kPlxmkvEoNffKLVmBAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667529; c=relaxed/simple;
	bh=vru5qnJPlRLvl9aV+JeKEtk+CWv6j8UsHFFdfpN19zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIHeLdUaBIjuuGccMCwaIPModmJYtbfBL/GT5HokutnqHSzf5t0WPK963H0Q0wpfUuLbqHahnDRWX0RUXSdJefjB7ZFSjmNXQ+wU29v/eB/kI5o45X9nyBjswfjb540cqoZL9+JeOczxnjeml+UUmecEexZ+7IWKH5wGq9opel0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y92TYrV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y92TYrV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AF11F000E9;
	Tue, 21 Jul 2026 20:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667527;
	bh=wYy+gP/WUmvJVuZZzJdcNbMhBPptaon9+TQuaJMyQBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y92TYrV6AZt/cGSalrE4Y+53vBhrzJXscx6vpCACT8NCgpuhv7Zes2TNKGDvN2zwW
	 pUmORYMaedeeVOyr/cLN0X1dtyudWVbmr1ilWX2cSFt5d2A3IHQJXb1Tt5+TjAGlul
	 HQ08t8+yYkaAqb8U9FYdefZms9hE+M3XYRcVSYvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1094/1266] batman-adv: retrieve ethhdr after potential skb realloc on RX
Date: Tue, 21 Jul 2026 17:25:31 +0200
Message-ID: <20260721152506.285130415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 035e1fed892d3d06002a73ff73668f618a514644 upstream.

pskb_may_pull() in batadv_interface_rx() could reallocate the buffer behind
the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

This was done correctly for the VLAN header but missed for the ethernet
header which is later used for the TT and AP isolation handling.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Fixes: c78296665c3d ("batman-adv: Check skb size before using encapsulated ETH+VLAN header")
[ move from mesh- to soft-interface.c ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/soft-interface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 680f729b3b0228..e4d302c93478b9 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -442,6 +442,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 		if (!pskb_may_pull(skb, VLAN_ETH_HLEN))
 			goto dropped;
 
+		ethhdr = eth_hdr(skb);
 		vhdr = skb_vlan_eth_hdr(skb);
 
 		/* drop batman-in-batman packets to prevent loops */
-- 
2.53.0



