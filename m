Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043C31C3BFC;
	Wed, 20 May 2026 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299066; cv=none; b=H1xv4DGTwujylN3Z7Z4vY2BUwQ8h/hT4XZdIk7kjxB/OnIDGgw330otaKdAf86xsZQts8seJ7EBy0UKj5VlUuQmc54jOeVFhLRo602iNcvgJTV3YW0kAPnoBSEoBDvxP96f1W54zyXcR59PZA5E102CFnXDnqCMxN4KjDojBe2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299066; c=relaxed/simple;
	bh=ROgacIQtwCaS80dFD+3vBfzkpIpM+kqV5S/LaKNx8Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inVIKF/sMDQ+OwO1PiPedeE0cmyYzkyd00V0EEWNOjhu39PgT70D7asHujnbBvB3dcVt7RzTUkerHkPDSlsHtYlWaf1N6vYUux73YOVdFdMhp7O/ZiTYl9TUv1qrl/GPAwAE0q77D/jdKebvpdW+I3s+M9Nq1EvnQ/Hdzx7k49g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8g/POAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8g/POAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26171F000E9;
	Wed, 20 May 2026 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299064;
	bh=vYEgn7ij4I3UgUglpgYdJ0vyFFNVaGan6DgPTEQRtoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8g/POAGZrfbrmvaSd5l8mEUUnMKxhITVUSOct0iUjhQewnkPh5bVGdUmhLtJOVQ1
	 g96GR51yqqIkDdaAO+IfjepmjqjoHeB9sJ7bifSdm5TRlKPzisgSIYnh+jphkZoDRq
	 JLNaOMjvvE6/gtZhZ0NxHlIqCJaqo1KkGzoED+T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 648/957] ice: Remove jumbo_remove step from TX path
Date: Wed, 20 May 2026 18:18:51 +0200
Message-ID: <20260520162148.582539866@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 73f08d02f9c76..90dbe5266ce78 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2594,9 +2594,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
-	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
-		goto out_drop;
-
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.53.0



