Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21597340293;
	Thu, 28 May 2026 20:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999309; cv=none; b=ZgoZCg57LUhnfEZbzD4jdkOAMI1uJl1ocNRYU8/F7xL/k/+xk5bMZf+IELtWBNIBrCAcHAYuIKLO/hW+PbiSsB8pXY9ANKa9MFyptzTeVY0hqIbCOFjd4l0Aaqy4BfvX5seJK2dgBgNpY9OrC7ISgnJ+SkeCJdzXH8tSbUjoCvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999309; c=relaxed/simple;
	bh=BJVuWEkbab3PiQaYUkcjp3JFRSFipj76wseNPvIaCRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ1NxuIFA+uIYQ4jzfl7XKsMS0J5OUG+AVev8JLVStqn1Xo8HHMTu0aYSdlwJ1tHVHnGG1VXknxTI+jpNmXPsFgtjM8Q7UQAUL4H/iraMzhWlEO7TxhukC0QENaCqegw8OM+mN2lwWX8d66c1Z0WDs38vhLxK/xZUd9LHziD6YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHIQzRjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHIQzRjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC901F000E9;
	Thu, 28 May 2026 20:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999308;
	bh=vV6HXoiyDkAv2DYYoQnvgn3ff9npPaTB1theWV1mlXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHIQzRjSc9TmLjDdabYDyMytjravlNZBrrv8YCulBpgLE6nPoD5oLKVVpW2YB1rCT
	 QSBdcn5dlPKb19V/UjrzNpIwwtUQsuHfnQI5H7zlKQyqJbAsJh8zQmDu/9hgVpVP22
	 6ogDiOVeJxf6lHFNKCtR90Ebq3MmFmeMLYXUe93Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/377] Revert "ice: Remove jumbo_remove step from TX path"
Date: Thu, 28 May 2026 21:44:18 +0200
Message-ID: <20260528194638.972865358@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

This reverts commit 55500245ec0420df96b2a89444aabf0cff2c60bc.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 90dbe5266ce78..73f08d02f9c76 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2594,6 +2594,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto out_drop;
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.53.0



