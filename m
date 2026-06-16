Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A984534B3;
	Tue, 16 Jun 2026 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626108; cv=none; b=Ww/uDGV8dOpBUkwLeC93X3TgYjGprHdUaG1Uz+W00MwsaQQbUAPmMCkfMf5CyDlXdvDYIwq+K6yth0GqV22NsYPnqWH+IzUE35bkgg6SUqPSpsGosgVA3UMVftAu6pbd0p3MIys2683jHaFlD8mwF/axs4aAakD2Q7vBJ8gWnh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626108; c=relaxed/simple;
	bh=TdXKi0KuCHJZ7m5QsF6oMVWN6Yfb4waR9Dgq+WrzILM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6UY1GVnpDSc9OCiHqqh0FpNiE67ihf15XPx8ZVvHDzDsKUkkJRyHbTF6/gmJQI+6s3taEINVTtru5ivzCzh2M79HipDd2vUbxw4PeEY5HkWnv61oPL4QGRX3cAnRkKHTzoBKrBO373sthPyT46td9OAL/c+u67RwMk8MjJ1R4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU5yi4Tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU5yi4Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C7E1F000E9;
	Tue, 16 Jun 2026 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626107;
	bh=OyE/tWgnSG/pPp4Qw6h20LBFZvZr8rmLQuUecmECCU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uU5yi4TtGdmPQFUZ8Sbwh2dJTHUlxOpZIB5lIw+xBp0ocCHCHXCcI5Y88SKbTTN1m
	 b8vZQY50cNMy+mSXj3zf0VPjf3o/pIWm2LrTubgVdjoaKezlWmDtfyeWeDKdQ5rf5P
	 5EuxWoIrZ0INM9U56PpPUvXnOlVBACu4i09waw8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 265/325] rtase: Reset TX subqueue when clearing TX ring
Date: Tue, 16 Jun 2026 20:31:01 +0530
Message-ID: <20260616145111.834049216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
 


