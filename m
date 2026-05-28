Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E417323394D;
	Thu, 28 May 2026 20:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001129; cv=none; b=CKmTAkUFCpmAT1fCRuiUebhvYPlcy206Ij9tvlA0C6Yj/TojxrcV3QRTVkddrEgyswIrnoCMnSd1fKtYAryuG4jM21r78bQMz4YsT9CZvWDS7PppWF2BzkD0/dc+oWsvWNgb9gsfRkQxG7ijUp964rFMVR+dv62e0HlnZ3CSMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001129; c=relaxed/simple;
	bh=aaGPL/f7HIuaAvsZKv2hYKpusgBoiq8yIZBpnavjHHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBotH8qfcOl9rmFWwPNoqsdUGOYEQ2AUospWgp1RX6oVJNpj7tHJ9jaenyy4TUvtIrFnH0aKdoUGlJaBSJJqDXtQOQkEpb9y8VldAb6VXcDouXSOJaY9fHuEchpyGRokBfXFSNPeYKd+p0PjoA6HWNDRilfPvEGpCfIIgGdWalA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA5Jk6I+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA5Jk6I+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B9B1F000E9;
	Thu, 28 May 2026 20:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001128;
	bh=1w8Yk58f3vbZ5UJ8ceMnFJ7vxgiMKpW0q4CBnAPfMi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA5Jk6I+ZusVaK5+smpGcOwOduZ10L+aFXGg/i6lFVdnAOFxS4qO5VYs7X51uKydE
	 /43UsuXhVRyQDu8fLXkJ5tl7kiPMmrF3lPHQcUECtMWfH3h3XngQSSHOVKQQy7aFVw
	 8TNAMrVB4G6o9KnPGEhTJNDnady/dPfjGfNffMSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/186] Revert "ice: Remove jumbo_remove step from TX path"
Date: Thu, 28 May 2026 21:48:18 +0200
Message-ID: <20260528194929.446096929@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

This reverts commit a753619ffecfe629ee73c821469edd8b37c72d3b.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 66da8a34be0f1..eae4376c68595 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2364,6 +2364,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto out_drop;
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.53.0



