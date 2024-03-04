Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F08647A5D;
	Mon,  4 Mar 2024 21:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588253; cv=none; b=bhUdQpBZ6InUA5svB1Jkkft74BlZb8Fd1uBfdoM0z1u+GOLCZYNn0CUCsXwBncqV6B4dBXDURrUY1WthlJn9bvEJTN/65+W9DaXRRF6DokFqxr3T4gQO04v15Zq9TX/XwrSkwnOn3We4yE28PxhFQGC6ttxKXGp+XoFJSuXc0Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588253; c=relaxed/simple;
	bh=WMn91iR0S8+VoJuSRKDkbOQmGT29gw8kHxgCUZunCF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTqRz3l1An4IGT9G37Ip3hRylzIZEzYsCzMjy9LVvmIhMNUaky18bDbRLL8G/0eI+13SOQz75SAGomaGEE0tZocqBGnHHnb4XPSaksc8QCq5y8HULu+z2WuXtM09txZVPBiqMBHIgAS8ounInuYwHK7qJByKOoMt8PNhIeRzPg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZmXlGxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZmXlGxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B172FC433C7;
	Mon,  4 Mar 2024 21:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588253;
	bh=WMn91iR0S8+VoJuSRKDkbOQmGT29gw8kHxgCUZunCF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZmXlGxEsT2tNEeicxgBhUzQ5lhmjPmDyigCix+8gG7ZO4AK3PHTZ3pOpLB30A8u7
	 Gmpihzo49bgxA9uDWHBBGgOVyvSMHS23eqjThkzJJAM8eJxoAhptAaD3F95knu0GH/
	 9EDfYPf7UtLuRhFmspvulRridQV/D6GlxsKGWb08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/143] net: hsr: Use correct offset for HSR TLV values in supervisory HSR frames
Date: Mon,  4 Mar 2024 21:22:37 +0000
Message-ID: <20240304211551.129426675@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 51dd4ee0372228ffb0f7709fa7aa0678d4199d06 ]

Current HSR implementation uses following supervisory frame (even for
HSRv1 the HSR tag is not is not present):

00000000: 01 15 4e 00 01 2d XX YY ZZ 94 77 10 88 fb 00 01
00000010: 7e 1c 17 06 XX YY ZZ 94 77 10 1e 06 XX YY ZZ 94
00000020: 77 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000030: 00 00 00 00 00 00 00 00 00 00 00 00

The current code adds extra two bytes (i.e. sizeof(struct hsr_sup_tlv))
when offset for skb_pull() is calculated.
This is wrong, as both 'struct hsrv1_ethhdr_sp' and 'hsrv0_ethhdr_sp'
already have 'struct hsr_sup_tag' defined in them, so there is no need
for adding extra two bytes.

This code was working correctly as with no RedBox support, the check for
HSR_TLV_EOT (0x00) was off by two bytes, which were corresponding to
zeroed padded bytes for minimal packet size.

Fixes: eafaa88b3eb7 ("net: hsr: Add support for redbox supervision frames")
Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240228085644.3618044-1-lukma@denx.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 80cdc6f6b34c9..0323ab5023c69 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -83,7 +83,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 		return false;
 
 	/* Get next tlv */
-	total_length += sizeof(struct hsr_sup_tlv) + hsr_sup_tag->tlv.HSR_TLV_length;
+	total_length += hsr_sup_tag->tlv.HSR_TLV_length;
 	if (!pskb_may_pull(skb, total_length))
 		return false;
 	skb_pull(skb, total_length);
-- 
2.43.0



