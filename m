Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154B94F7CC3;
	Wed, 30 Sep 2026 18:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791541; cv=none; b=lMB/M8irzAkLNIXQM6HKfzIzb5F+Fw789xxZ0OX8F0SnzZrHJQ03RS1ZFREeDrR3BdlI2vaPP0IevJR/MLfP526OUHhJvbxnFUqC+EOQpDx8m0HhDxi6bYqDGPnVS2GooHNzs0Tri+XBhkA72wL8EnifeXV+pueSlIOaJZuWWuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791541; c=relaxed/simple;
	bh=rpceGRebnwOaE0F4Hhh3432/oU9S+T9HpL/9jZcCMB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCwqE0lb4HlrFt3wVc/O7nalb4ry27gTVJgrhhBg8wZSmPSi1rlwTZDDXRKPsL4bECm6ABiBDbDPPEq8P90tvSE421XNzREQZo2eQROg7VGgtJ5l88vpRkS9d395iqhWMn6fKjYXczY4DzRBlfkqWNZ3evKxuxMLUQ6DZQlQV6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+Z0Sc+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+Z0Sc+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136DE1F000FF;
	Wed, 30 Sep 2026 18:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791539;
	bh=IhM7pygD+w0QZT5CfcWnCm4ZUSgVvq9WfX4HcXrNZX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+Z0Sc+Xq+FxHQcApbDUWrnj9SJzWbEbjqaL2E6Xtl9i0pSP/91tVYx/qqTbDBj5T
	 IeTcU3MpgNY5QIlQO+hK1JV/GOgtlIe/oXb2aSy89MI7agKQ0QwCufjyp/0ojwSIXW
	 IOTU6OPrPL1HiJs1CsW8wAxZVxs7dU05PF4BpVdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/752] net: ethernet: cortina: Count dropped frames as NAPI work
Date: Wed, 30 Sep 2026 17:23:28 +0200
Message-ID: <20260930152405.604614446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea5f1df313d62..9b65d554196de 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1470,7 +1470,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				skb = NULL;
 				frag_nr = 0;
 			}
-			continue;
+			goto next_desc;
 		}
 		page = gpage->page;
 
@@ -1492,7 +1492,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 
 		} else if (!skb) {
 			put_page(page);
-			continue;
+			goto next_desc;
 		}
 
 		if (word3.bits32 & EOF_BIT)
@@ -1515,10 +1515,8 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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
@@ -1531,6 +1529,13 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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



