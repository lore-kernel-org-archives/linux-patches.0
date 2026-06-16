Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E7634889F;
	Tue, 16 Jun 2026 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624331; cv=none; b=cg36p8i0SSgijT2uHBAjAZmzGiblBBsYnzC8p7D1WQGeFb4WGTWKpmHdm/jH6Y21D+GcJEHtpOvwQXAulk8R8Tt7BI4JuON9NehKy1EshSGafaXjdvd+ea69YAb/vpIHe1JQw8skeAZrkLAL4W2QJOZ0+/2DASGGat+/gzqABIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624331; c=relaxed/simple;
	bh=9AYStCQ6WtdxM7hv2cyJfHl5hG9Qn3LmiTOllohaF0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/W4jawOoF+AO8jNcCmp7QliOg9/K/VnjgyjPo0T3EjILbX08MS38lWDN8hl9yLZPQ+7XiZJhbzP6SJRz+1oo85aQRRUzK1Tcr0+NnD+2s0p2v1uIaoqApPjzUWknkRMXIUpF0W/KdvXgSrUI03ckX69vKYOqC3FanRaweeC1p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJAiTpYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJAiTpYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC811F000E9;
	Tue, 16 Jun 2026 15:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624330;
	bh=8bMXHmT7TPjHNOCyK45zYj3OTFZ8EKnjue8MpC4FFvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJAiTpYQkHB9WUorABD1+8ztI5FtddZZB8zZ+9Plhp3TfkxygBsr3eGs9V92RM9Se
	 5A07NRscYjDUr4d4NC0wpE/p+HgqAr79GQRmqLU/d72IjERACGaS7hNG0BAjb8cIsQ
	 6SyqUG5NzZLnOIcSsL68p9f8yKT7bIbYh6MVO9i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 316/378] rtase: Reset TX subqueue when clearing TX ring
Date: Tue, 16 Jun 2026 20:29:07 +0530
Message-ID: <20260616145126.894310434@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/realtek/rtase/rtase_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -239,6 +239,8 @@ static void rtase_tx_clear(struct rtase_
 		rtase_tx_clear_range(ring, ring->dirty_idx, RTASE_NUM_DESC);
 		ring->cur_idx = 0;
 		ring->dirty_idx = 0;
+
+		netdev_tx_reset_subqueue(tp->dev, i);
 	}
 }
 


