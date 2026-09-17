Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885EE3A5E84;
	Thu, 17 Sep 2026 18:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670642; cv=none; b=DmHrtTEJNt41q6sBTulLUFhiHqC167z9A6SxEVWa2wgVXOGSoZny4P0vDoH2ROd6zavFB3fAlTuCOb4WlvDwO+2iMKQ9+Rug81xDPMcklydWBe+It5X496tiOCIljPF3bfc5/Z4oSidcWM4YNSwpE2L+sN3QuHJz9mfpOM04Pck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670642; c=relaxed/simple;
	bh=hdapSi6w9gslO4s28G9LuBSHlBcRaHo4+dRiwHZLpqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDngiD5jBMak731RjGU6gIvf8BC0sSnfpD/denI7gherI25xCYL6XFYLAu4rurYDRdms+06XUGZekq1i7rtyid/tyS4UoaO9+/uGuO1SgsOXOMFvJQtlwA4F2rXToqofT+uHTvjKtu+S3IC44nAUg8gvEm7AuThEnQDmRirpIGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hj+vf+N7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hj+vf+N7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E244F1F000FF;
	Thu, 17 Sep 2026 18:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670641;
	bh=EvKJ6E3LFYxiRtnW8Durr53GiJCU+EkpR28sskd8+K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hj+vf+N7ti7+oLmwEJzq7C78nJ0oH93dqupwWye4orHx5Vv1IEFjMqLEHydUQklVm
	 JIQ9B6YvpI+FrKVgPQ/rHeEO4fp/vRskck9Zyw9Jp0lwvHo+LTI3uglUy8D9oMPwCN
	 i7kGfLcQEQbGy5M34itu8pz1kg/eICGKQsZS5Urw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0727/1102] net: ethernet: cortina: Count dropped frames as NAPI work
Date: Thu, 17 Sep 2026 16:11:10 +0100
Message-ID: <20260917151558.620425703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit b856c552f556bc0341c1dbe0bf88e630fd1dc4b7 ]

The RX loop only consumes budget when it successfully delivers a frame.
Error paths keep consuming descriptors without reducing the budget, so a
stream of bad frames can process the entire receive ring in one poll.

Move the budget accounting to a common end-of-frame path. This counts
each completed frame as NAPI work whether it was delivered or dropped,
matching the behavior of the vendor driver.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260903-gemini-ethernet-fixes-v2-3-2bbbd598ca6e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 353530b4091ae..612b18ebbd251 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1501,7 +1501,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				skb = NULL;
 				frag_nr = 0;
 			}
-			continue;
+			goto next_desc;
 		}
 		page = gpage->page;
 
@@ -1523,7 +1523,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 
 		} else if (!skb) {
 			put_page(page);
-			continue;
+			goto next_desc;
 		}
 
 		if (word3.bits32 & EOF_BIT)
@@ -1546,10 +1546,8 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			napi_gro_frags(&port->napi);
 			skb = NULL;
 			frag_nr = 0;
-			budget--;
-			received++;
 		}
-		continue;
+		goto next_desc;
 
 err_drop:
 		if (skb) {
@@ -1562,6 +1560,13 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			put_page(page);
 
 		port->stats.rx_dropped++;
+
+next_desc:
+		/* Final or single-descriptor fragment, advance things */
+		if (word3.bits32 & EOF_BIT) {
+			budget--;
+			received++;
+		}
 	}
 
 	port->rx_skb = skb;
-- 
2.53.0



