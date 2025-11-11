Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F241D2D97A4;
	Tue, 11 Nov 2025 01:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824608; cv=none; b=qUE5sfZ9lHq++Asl1NCn5kLMdM5LVh+FaGMHlPbvFRPc+FQ5exEF9otxCZjLeKoDPK4L5rx1pff9y0VeUiZjIejnH1AlqJU3HFRkDIFTK86OOkc9tM8xi/QO+SDbCiC8EBQw2xn8pc2DlfU5b6f5tA0gMlKE0tC73ReM7YwDPuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824608; c=relaxed/simple;
	bh=opcqOgyKk7wKvB0Zj3039oSiCe5j28yUVM4STD2lTPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAeFzHQKhHmxYmX1H/wt1cQvI6kmD+D6qpGnirrI2+QNm55NjjguOq8nI0UVbuEfgDCIqv7ePjGQix+DMewoD7bM6dvwXgjmFpvCnU9f5j3XmckEasQ7Gr9MULtboSASHXAXMaXGhHevDmbmgkAa3KRVkJSsxf2fZiNn6agO3G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kl5M8mib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kl5M8mib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92495C4CEFB;
	Tue, 11 Nov 2025 01:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824607;
	bh=opcqOgyKk7wKvB0Zj3039oSiCe5j28yUVM4STD2lTPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kl5M8mibaQI9+1DsJZq3vYxoJIv4Lg8IBFRSEVKJFYSe8uJb+fAYMrdQ4/42Ma1vd
	 NbS3H70QPOZj3cddTo4gSId3REJLJSFezAdv3B97p1vfeox7SAw977goUgVdPjfwM3
	 2TO34WjrEUumjW10UzoFCxam8pHTJdBlZD1Ak6Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 533/849] net: mana: Reduce waiting time if HWC not responding
Date: Tue, 11 Nov 2025 09:41:43 +0900
Message-ID: <20251111004549.304594769@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit c4deabbc1abe452ea230b86d53ed3711e5a8a062 ]

If HW Channel (HWC) is not responding, reduce the waiting time, so further
steps will fail quickly.
This will prevent getting stuck for a long time (30 minutes or more), for
example, during unloading while HWC is not responding.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/1757537841-5063-1-git-send-email-haiyangz@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index ef072e24c46d0..ada6c78a2bef4 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -881,7 +881,12 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	if (!wait_for_completion_timeout(&ctx->comp_event,
 					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
 		if (hwc->hwc_timeout != 0)
-			dev_err(hwc->dev, "HWC: Request timed out!\n");
+			dev_err(hwc->dev, "HWC: Request timed out: %u ms\n",
+				hwc->hwc_timeout);
+
+		/* Reduce further waiting if HWC no response */
+		if (hwc->hwc_timeout > 1)
+			hwc->hwc_timeout = 1;
 
 		err = -ETIMEDOUT;
 		goto out;
-- 
2.51.0



