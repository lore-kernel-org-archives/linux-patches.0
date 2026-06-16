Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03012477995;
	Tue, 16 Jun 2026 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627619; cv=none; b=b0qTGuvmZrpCUjUizEgjLXXeOIpOHkVemb4cKiRlLF7PTi7gQpjeiuK0u09YH1Uz7DDUtYJTrF3tHi4W6YkS7SNCoGyWZAMLxKhu1xu9Odn5YSGn+G12lYK3/t4MEvdjpkfQ1GrJ8QEeQ2riuUSXs6sayqr6w1rmGKErH6vJjd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627619; c=relaxed/simple;
	bh=a9u4pdQT5pc7tPr/xKyudgLSgQnaklRPLdau0JXlhA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD1cUVT+H9uZ2vyYDC4W0gh1aHkZDZWG7Mv7qkob2IEpejJ6/dZJBiH8A61s74qcRvkhFA6XONI7i5vUIyoG+dZMPoVX72+9/DW6QnzGAmWQ+4Shn4ebCuA/Zwj5NQqGUkj7bHvPw5iMrPrfPM87gOuV5HQWuCk9xmkTsOGLA+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHguuUHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHguuUHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926E71F00A3A;
	Tue, 16 Jun 2026 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627617;
	bh=1sIBX6MePmsPRuDc5cSFpnVUG402iY1vnzHLvECFiZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHguuUHp//y97f+NASrPh43mOzgSoB4Cp9Ehio00C15Gb+vSVIUFswL2AILndOKQB
	 R2QWJRrbycUUg8BGqHSi6cvQHfevRbwgU8T6BG2hxNqRhBe0jCXUGhZAgqD5yomPJ1
	 7sjDKTWM2rJ/KxioUASjMnOMO8MDfsaQa8pFIG38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 199/261] rtase: Reset TX subqueue when clearing TX ring
Date: Tue, 16 Jun 2026 20:30:37 +0530
Message-ID: <20260616145054.277659439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Justin Lai <justinlai0215@realtek.com>

commit ab1ecaabe74b7d86c38ab2ab44bd56cdcc33645a upstream.

rtase_tx_clear() clears the TX ring and resets the ring indexes.
However, the TX queue state and BQL accounting are not reset at
the same time.

This may leave __QUEUE_STATE_STACK_XOFF asserted after
rtase_sw_reset(), preventing new TX packets from being scheduled.

Reset the TX subqueue when clearing the TX ring so the TX queue
state and BQL accounting are restored together.

Fixes: 5a2a2f15244c ("rtase: Implement the rtase_down function")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260602114659.12335-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index ef13109c49cf..6ccbefb5acf2 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -239,6 +239,8 @@ static void rtase_tx_clear(struct rtase_private *tp)
 		rtase_tx_clear_range(ring, ring->dirty_idx, RTASE_NUM_DESC);
 		ring->cur_idx = 0;
 		ring->dirty_idx = 0;
+
+		netdev_tx_reset_subqueue(tp->dev, i);
 	}
 }
 
-- 
2.54.0



