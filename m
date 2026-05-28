Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179952FD7C3;
	Thu, 28 May 2026 20:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998739; cv=none; b=j9wLk55U5c6li3+UQmhGgAgLgAKEVKwIHd4p6b0Qfm3kMtNoaXtkJ51O2u6DXzM9Tb5qmz8BGS616a5AcO9b8khSrSAzoMi6rPVWJ62FbANusk+5FsOSE6RhS5CHyhM0M5BeRm6lEDSNi7k+QnBjfcA642ZYRsXOc+FST2KrsXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998739; c=relaxed/simple;
	bh=QOQJ8MyFZtkEN87yTH3Rkn9fJS9bWytk7HMTrKdq6pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJxa0FR2bmjTkrVEqREeMNUs+jKcHsGJycU6015NRTfxZoHQuES/eBfjae0YmIr8qzjjpEKL187LhAOs5yC48ArFy6QAiHgnYqja7AyI+8Hd1to4lo7XqPZk/P1TxtGvZyWoBb/A2IeO4lt0QRM9O2tdr2YqysCNZ9tMiexh7Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC75XX/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC75XX/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B5B1F000E9;
	Thu, 28 May 2026 20:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998738;
	bh=Wb0PR+dbX0ONu+FuOt0tlFwX9Aqh6JxnMaeeoFzDCFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BC75XX/aMmF/6g2JjAGyXX56u3OZUi1OkDYb1Dlx/w/SAq0qUer/Z53pvAke8mCdv
	 M2gOxxg2hEivO5+3UJge4F2vDGrlSYxgwGlUd1G+/6VTEd7Zo5urHR7Qreb3kiAoYx
	 qJJLs4VJoTshsUI+Xqnzr4W9ZUaeDBh3WgpAvqL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Haarmann-Thiemann <eitschman@nebelreich.de>,
	Linus Walleij <linusw@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 273/461] net: ethernet: cortina: Drop half-assembled SKB
Date: Thu, 28 May 2026 21:46:42 +0200
Message-ID: <20260528194655.073602255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Haarmann-Thiemann <eitschman@nebelreich.de>

[ Upstream commit b266bacba796ff5c4dcd2ae2fc08aacf7ab39153 ]

In gmac_rx() (drivers/net/ethernet/cortina/gemini.c), when
gmac_get_queue_page() returns NULL for the second page of a multi-page
fragment, the driver logs an error and continues — but does not free the
partially assembled skb that was being assembled via napi_build_skb() /
napi_get_frags().

Free the in-progress partially assembled skb via napi_free_frags()
and increase the number of dropped frames appropriately
and assign the skb pointer NULL to make sure it is not lingering
around, matching the pattern already used elsewhere in the driver.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Andreas Haarmann-Thiemann <eitschman@nebelreich.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260505-gemini-ethernet-fix-v2-1-997c31d06079@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ebd8ec2b309e ("net: ethernet: cortina: Carry over frag counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 57a25030f883c..e8d973b8fb0c3 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1493,6 +1493,11 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
+			if (skb) {
+				napi_free_frags(&port->napi);
+				port->stats.rx_dropped++;
+				skb = NULL;
+			}
 			continue;
 		}
 		page = gpage->page;
-- 
2.53.0



