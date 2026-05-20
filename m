Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E6E3E5ECF;
	Wed, 20 May 2026 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301182; cv=none; b=ajUCqXjbQKclo1bHOI7mrCm5TRODLdwI/02/u/yoDSvJiq65kdQebA4SyF3cAHWBL3BmBcbS2EO4yARsXtFu/wP6Ps0ZIv6/PzGBodfTtksPAVSV3ipokH3mr/So7nXYCwww0g4/v2YBwc1jyqjHQxruR5Cu18cFJ3Up2CO8epY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301182; c=relaxed/simple;
	bh=3rjOV/xZe0B5uwYdsnm8cJL7MJMOUSYDIX6hV8nfJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqf7PYJl3AApLDa76T1a320gLpGZ3uaoUVXJoeShz7eSlcj8qp4kBI5SxOR0g8qN0CCGxaZbgA3TSAv+XXWre78hqiSxObkx/Ohh+IKQXMkoKGhfpcDomQ4s0sexSCD8PPS9GE5A8Q6IalfUOkWfsStm/Iz2BZpvoRcnc0+9Rvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueUuGTgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueUuGTgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480071F000E9;
	Wed, 20 May 2026 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301180;
	bh=q3JNt0WilEoqTJeEVbUzE4vUGQ0aV9niycPepPopz94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueUuGTgT+I3W4nzZh3lN4wHhJF9SUYMQLZ+RCWQjnVJCZxdpo50Xh69w88MsbIA+H
	 o6NRH9BtZqJb/8L6W6tw4NFwQjq/b8PIBN+RsoBxDSdXOBFd1WdzkMSgP5Wv7aN1wo
	 t26ConwZFG4nDktDqKVS2MbGFnsGgYl8TSXDBDWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/666] ice: Remove jumbo_remove step from TX path
Date: Wed, 20 May 2026 18:21:08 +0200
Message-ID: <20260520162121.174781778@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 8b76102c5e00d1f090e0c31d17b060c76d8fa859 ]

Now that the kernel doesn't insert HBH for BIG TCP IPv6 packets, remove
unnecessary steps from the ice TX path, that used to check and remove
HBH.

Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260205133925.526371-8-alice.kernel@fastmail.im
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1a303baa715e ("ice: fix double-free of tx_buf skb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 431a6ed498a4e..08d1757f40888 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2346,9 +2346,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
-	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
-		goto out_drop;
-
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.53.0



