Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790E47EF1B;
	Mon,  8 Apr 2024 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583074; cv=none; b=UEn9OwlVxNeBWIIsBsmXWHVCqJ/vkmlZfPTze4Ng+IGLFkj/Ko3nTsbeywDertkE5og0Sv+LVov9IEl7FknRpV29Ubib9wQ+uM11OF0vJvG43OPMvDNYBvvI0tDgN3XuAgwyqL8z3FVAP3CUjiTV8GiATqSBJVTJg8XP8KimMvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583074; c=relaxed/simple;
	bh=8kHpTRoViLbK8EtwmSnXxjn0vbB5iG0Uk1GMJtkyD3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSRvRENFM2YaeWbFRTeqsf2XMmI+6tXjv2GIkL//zOG+u7T7P4r+7kB4S5caaVUW4ius9XNvOkYpmpSD0JQPdyfHwcWU0M6s1i1c9r4G+UQNUGE8V3EGzzOKY0ewamsnMolr0PvW0WvnnUUeiTZXCf2oZd9WUG6qpfw55wpTY/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtbZ534X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtbZ534X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB55C433F1;
	Mon,  8 Apr 2024 13:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583074;
	bh=8kHpTRoViLbK8EtwmSnXxjn0vbB5iG0Uk1GMJtkyD3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtbZ534X799ABEV+frJsr1uxo0HWbjBOQU6UxSLlBOYVv3USfc0sDGAmkYRD1fpA8
	 LmmisJdf6lClr0f+xEeCadu0O9FHmDeQ/u662Q+ZmViHvE3ifCNI1EWN4o/g21Hc43
	 SaEf48OG52z7rTKWdQSmpRofIUnQ1N6GCaFlCiT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/252] net: ravb: Always process TX descriptor ring
Date: Mon,  8 Apr 2024 14:57:33 +0200
Message-ID: <20240408125311.439287743@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit 596a4254915f94c927217fe09c33a6828f33fb25 ]

The TX queue should be serviced each time the poll function is called,
even if the full RX work budget has been consumed. This prevents
starvation of the TX queue when RX bandwidth usage is high.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20240402145305.82148-1-paul.barker.ct@bp.renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b87e9252ea176..14595d23b1903 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1292,12 +1292,12 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	int q = napi - priv->napi;
 	int mask = BIT(q);
 	int quota = budget;
+	bool unmask;
 
 	/* Processing RX Descriptor Ring */
 	/* Clear RX interrupt */
 	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
-	if (ravb_rx(ndev, &quota, q))
-		goto out;
+	unmask = !ravb_rx(ndev, &quota, q);
 
 	/* Processing TX Descriptor Ring */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1307,6 +1307,9 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	netif_wake_subqueue(ndev, q);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	if (!unmask)
+		goto out;
+
 	napi_complete(napi);
 
 	/* Re-enable RX/TX interrupts */
-- 
2.43.0



