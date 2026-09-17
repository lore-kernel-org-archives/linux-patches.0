Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0115218A2;
	Thu, 17 Sep 2026 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665936; cv=none; b=iRxjRjwHtRhhRW7PZZEJWTk8LO4bfA3i0qj6DwElOS3cDZ4b53TOKMUfltCrvlWLMlLNql5Z9A0wdWu/47C3N3gu9EJpVTdNA47G50MPgsRBM6f9WwgbB/2N46nDrWh5vjJZUv+elRUGPc9aoZLs7gbl8Gw2lT7e6yejMPlATZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665936; c=relaxed/simple;
	bh=aEvpm2EfE/TqKdU0RfyX9WQYmjPCuKIwqrkkZOi0/PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8JgCRp91EsmtnUrIf6SbUC0yy4h8Mh/OBV0icrkzjnjzxzxENdAK0TRSWstRsnfjr5MbmRZxFEpCycTpaI5QmIWVw7hKaE6Q54dn91WXxjzA1wvlgnxsFJQU06fpGylTu0iktu6neIJCfe25/TzRf0F8cLEjRUyJbUsk19pwRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDuRW61F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDuRW61F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3531F000FF;
	Thu, 17 Sep 2026 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665934;
	bh=+mCWnvMvarH9HTCidyTEpfqWDrdbW7z+wRp4SWMdMRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDuRW61FWkn7MGDvPxdXe3qqa0ULMB6oQwWNsP6SqBSthVwYM4fPz2Ij5frDYt/8d
	 eccONZWKUhUxlBcSWDN9+cwS4FxjGrlHNLR887xvYbf8JudXrc4prjcMCx/5y8lPRi
	 u8x8Ok/F1LMVDhniN9Q61CI9jeUfE5nt+/yDiC5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0870/1250] net: ethernet: cortina: No mapping is a dropped rx
Date: Thu, 17 Sep 2026 16:11:05 +0100
Message-ID: <20260917151615.555661272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 2cb156213093a62b80cf40b1ec71738e93491971 ]

Increase stats.rx_dropped++ even if this is the first fragment
(skb == NULL) so we are doing proper accounting.

Fixes: b266bacba796 ("net: ethernet: cortina: Drop half-assembled SKB")
Link: https://sashiko.dev/#/patchset/20260505-gemini-ethernet-fix-v2-1-997c31d06079%40kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260509-gemini-ethernet-fixes-v1-1-6c5d20ddc35b@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 6520198c430c ("net: ethernet: cortina: Count RX drops once per frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index faa9ce702081a..552eec5db396c 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1496,9 +1496,9 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
+			port->stats.rx_dropped++;
 			if (skb) {
 				napi_free_frags(&port->napi);
-				port->stats.rx_dropped++;
 				skb = NULL;
 				frag_nr = 0;
 			}
-- 
2.53.0



