Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D0E223328;
	Thu, 28 May 2026 20:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000400; cv=none; b=uTcHQdsUl50DakEkRiGOZJBsf9fC+zQD1NAUO9Wq3pGO41hzCp7rV/it5H8O8rTDoLNTx36FkSR0DIEPWv90RHMB0/Za5+JHNdZIZzLW3ZNygupHe7p3qw0AhwXbW9BhcBZbkgbFXXTKk+hiDmfUSFyhg5Pd7DcABW3ARxKZX2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000400; c=relaxed/simple;
	bh=iegIqmGth57hvd0Ow+NzJ+ktq40MxzgfaOpCJuUt/CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNLPZs3k2Ncvo/J0sSo0bmNcWHPz+xBs/xsAiXJjeyuX+8bSxYZe3SXAgMXJ8CJZVjZqTOfxV9hcWysjwCVm8iKbNHeV55tFKq9bQgErxccBUrRe9UGIs6FwgQG/TLyh1qIYqqCGOvb0kpQD2PZfIW0g012/UZ3UWvtDTxdMs74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtr9YX6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtr9YX6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF39C1F000E9;
	Thu, 28 May 2026 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000399;
	bh=a5290TukFBOk6SfEhQ9Icdl77kGi3eVvTBGAQDDTeNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtr9YX6nADPXfBPfB+/o6N7gWwokUJ3IdqsevgUkdJRga8/tpGWdtcD3/d5QwPm/w
	 t2g2lbFGFwKXHzss4YNzEQ3QFgpvnQAhn61LGFJ/9Zs8Ih8oORS7gfuiD5jpiumX8C
	 /xNg5bIRwW4WlptMFA/AvZC9uyawVih57jS8iNZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/272] Revert "ice: Remove jumbo_remove step from TX path"
Date: Thu, 28 May 2026 21:46:45 +0200
Message-ID: <20260528194630.261409610@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

This reverts commit 7332d208c9d2067546eb7af5339773c966ac5625.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 08d1757f40888..431a6ed498a4e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2346,6 +2346,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto out_drop;
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.53.0



