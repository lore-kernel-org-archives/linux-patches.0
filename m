Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD06E527587;
	Thu, 17 Sep 2026 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665933; cv=none; b=A35RuA2Hi6rrkhJdl6dPqN7TI4WgGH9vtG3LuVYCsw9dzfml1C3tmjlal3aPaJKWOz0uBk88XQTZjtdAlz6WbaZY/DP9arq+DXVF2GC1Fb+c+PszAOMcMX8Ken6sFZdJwm4optvqrkb4GzzB68SPYp2KNZmHsyPlZ6ki2nVuYx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665933; c=relaxed/simple;
	bh=tSzMyb+ooZSFqQ6rA+ASQ5y8Oh/5pPqSsAKPHqi1VkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3bq8a857KTYHmealHP9AiNuDZk++zkhqT1+7hAYrRAuIZIp1hidB5fdPlyIXV55+Bb59mGZ7vAqzv7FlwLgwrsUBYuNhO89OTmRqz0cu37ns28HQIW5hff/5bFPXaayYbhWfcu4FiWPG6s7qh9UET5tp83kcaH/UiiwCCKavkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZX7907k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZX7907k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4143B1F00893;
	Thu, 17 Sep 2026 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665931;
	bh=S6ryOP7DiEFBAjhSlHlzHsSZMfpw88JndOIHn9hyrV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZX7907k/iVRss0O4Lg5psZsQ2sAX/sCywYgru5mJ6MWwDmNCLUa7bIXD2aN9SmFR
	 3C852o/DpCaUg5MaW56p6F1szX33fL2gqB1q3MGefFycakjBJLPB2hXBoh6vdIxH9f
	 SB/e2lGouMgubfSdMjp2I4i8OwdqrC4g8DRQ3jNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0869/1250] net: ethernet: cortina: Count dropped frames as NAPI work
Date: Thu, 17 Sep 2026 16:11:04 +0100
Message-ID: <20260917151615.528766510@linuxfoundation.org>
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
index b2e1c9db1279f..faa9ce702081a 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1502,7 +1502,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				skb = NULL;
 				frag_nr = 0;
 			}
-			continue;
+			goto next_desc;
 		}
 		page = gpage->page;
 
@@ -1524,7 +1524,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 
 		} else if (!skb) {
 			put_page(page);
-			continue;
+			goto next_desc;
 		}
 
 		if (word3.bits32 & EOF_BIT)
@@ -1547,10 +1547,8 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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
@@ -1563,6 +1561,13 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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



