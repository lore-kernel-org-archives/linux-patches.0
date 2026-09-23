Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFB95383CA;
	Wed, 23 Sep 2026 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174858; cv=none; b=Il7Ex0f0nc2aFrc/eiHJ6Qq1aQdNjZNXJuf2FSFq5vLaX+AlD2UqaHeLKbOHN/mFPlZWCC2AQ49MJBW/uBeEEngb/V2A2tkXAoUOb+FKHYn4ntHyvtRG6GfiParS9dzEYYQFtDRvxyQTMQl63sRCJpJB03BVJJFjolV2002G/B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174858; c=relaxed/simple;
	bh=CIrb7s4aJqMAqchLXMyA3YmLaeEyqksnEWd+JmxuDHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwMHJ0AmKQsJxf6suuaN1sN69Q2JCautryWjo02C4AJ3SD7NWecFoXb70eYOTwOJCc6kQ4z/vv4ZdZJ020k2n1UT1VkdBz7kjxM9h+Og8Sd0YgkoorXYPfdsnYpLjttLhowHYMo+I1HE45NVcbykgCdBvopAkONe8swdFv0E5AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPoyNU9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPoyNU9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19861F000FF;
	Wed, 23 Sep 2026 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174857;
	bh=c+GGVwtZ1UWPaRPEwlguEFHsCGMSzWiyY8WUPEiHa2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPoyNU9rLNUDSkvBH8lcBPpyo7ugCNAJDAJmjgJg5EyQmbSXCxJpsgp/0OfdyFacP
	 BXyLR/KuOU1QqtxkH6QyjWdN3EjvqJ8FMSoV0LySb9gIvho/3Jrjt3pb492hUgjzh+
	 Xlgmb/sinWW0URl41ODeGw/GSC7KiETEMZ4aDsDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 241/398] dmaengine: ti: k3-udma-glue: fix NULL dereference in k3_udma_glue_release_rx_chn()
Date: Wed, 23 Sep 2026 16:05:15 +0200
Message-ID: <20260923140649.663765697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>

commit 0294b6dd515256c03ea2dbf508ddd3826d788579 upstream.

If devm_kcalloc() for rx_chn->flows fails in a channel request function,
the error path calls k3_udma_glue_release_rx_chn(), which dereferences
the NULL rx_chn->flows pointer in k3_udma_glue_release_rx_flow().

Skip the flow release loop in k3_udma_glue_release_rx_chn() when
rx_chn->flows is not allocated.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Cc: stable@vger.kernel.org
Reported-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Signed-off-by: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260812053426.3521589-1-Alexander.Chesnokov@kaspersky.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma-glue.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -1243,8 +1243,9 @@ void k3_udma_glue_release_rx_chn(struct
 		rx_chn->psil_paired = false;
 	}
 
-	for (i = 0; i < rx_chn->flow_num; i++)
-		k3_udma_glue_release_rx_flow(rx_chn, i);
+	if (rx_chn->flows)
+		for (i = 0; i < rx_chn->flow_num; i++)
+			k3_udma_glue_release_rx_flow(rx_chn, i);
 
 	if (xudma_rflow_is_gp(rx_chn->common.udmax, rx_chn->flow_id_base))
 		xudma_free_gp_rflow_range(rx_chn->common.udmax,


