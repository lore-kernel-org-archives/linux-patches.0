Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F111C07FF;
	Tue, 15 Oct 2024 13:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997774; cv=none; b=LwbHFX/aZQkqAwUfj3Q8vG0oaqJN+OJf3Q2JaAIvBJ9/ONy8QNxMffHPhwIYFZ8wVETuIcKSaL8m7N0GusDkqXIpGXuDgmB8pofXkQ4WwsKycRpbobrcnK7l9eJy6u/rFZeLGGMHwEwcPbOpreS4qN9hhyb5UmwFAvGEX5WGUxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997774; c=relaxed/simple;
	bh=m57SBefBHIrMGhYG+gQKfsqG7aPFQ0CKfQ+ZognvKKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CacL5nlz9i4xj6W8JjEFny5gc0U/1Hfexn0GtzYVNRNEsCU8MT/kx9Hgw9hU7g+ZV9eO7nntowWZUOmZFId96KpZOZocBocMOKUQyA2du5PXn/MRVtSoPtLi9DnJBiQqRYStaqdGeVtp68D8WGTC2I0Yr1oc5ZrdFxqnWRnlGdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auGlBwQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auGlBwQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFADC4CEC6;
	Tue, 15 Oct 2024 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997774;
	bh=m57SBefBHIrMGhYG+gQKfsqG7aPFQ0CKfQ+ZognvKKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auGlBwQnbqfK0v8xjcbs2T5F0GXTFd/P8NladraKG+nnd2n7IjjGZ0KUoc+hwbfyj
	 Ods76GxFBCVuIzYFecq6NUxaK769INaXR9C7OkL23GR5LtChu61Rv+kuAmOizmdu32
	 lKX0CTUhuoNij8rtiwyQV+VXtKuisQQuVzfCSG8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/518] i2c: xiic: Fix RX IRQ busy check
Date: Tue, 15 Oct 2024 14:43:07 +0200
Message-ID: <20241015123927.913308558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 294b29f15469e90893c2b72a738a962ee02a12eb ]

In case the XIIC does TX/RX transfer, make sure no other kernel thread
can start another TX transfer at the same time. This could happen since
the driver only checks tx_msg for being non-NULL and returns -EBUSY in
that case, however it is necessary to check also rx_msg for the same.

Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1d4a1adbed25 ("i2c: xiic: Try re-initialization on bus busy timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index c6447b2769f9d..b91ea900aae3a 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -545,7 +545,7 @@ static int xiic_busy(struct xiic_i2c *i2c)
 	int tries = 3;
 	int err;
 
-	if (i2c->tx_msg)
+	if (i2c->tx_msg || i2c->rx_msg)
 		return -EBUSY;
 
 	/* In single master mode bus can only be busy, when in use by this
-- 
2.43.0



