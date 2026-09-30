Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91CB4F5E0E;
	Wed, 30 Sep 2026 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783072; cv=none; b=f9d8Pkig2i1Yd8Op8Rl4Nv5CiHC6PF8QbG9LRScDX8wTBdYqsxoeps93aYTRbr9LVnXp5sXK+qBFpijGdbsGBbX6bQXDB5e+ic1gaI2B4SgvVCasgwiKape+5kvFgg7i+GYG6zFxpqEw9+h+OuFmrBwRcA733BGv6Yy+makGmOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783072; c=relaxed/simple;
	bh=nvO/foUuBTvupsOZxjwNcCx38tuB7OzJzx6L49mUcp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZII6EaISEzaVlcNU6/Ohkn4tJlV2NJ8xys92sjo29UisbV2e7Uk1O0o2elvZNYQzte4gdrXmb9dCZGCp2pbJtltYM4k0RBO25M2RMLQu9yD8WX0cuH9N8Ub09Lmak3qRh5f6Z9ouUKOpgKbDmUvAXo9XO5xKA564iNdg26i263c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o46wt7Zl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o46wt7Zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CED1F00893;
	Wed, 30 Sep 2026 15:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783066;
	bh=NQb6Z8m6oaHlPKHxRQJG3loiWDG1JvvqpP8tQ0A2XUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o46wt7Zl3+CKtEjn7tO7A3YFO1UZ45hYrxkhorE7TKyUFJfWSjuscl2KR7o2tYvkw
	 GIrspgwG9oQWNpHovTSAjJFUe7TJKvvhc85FnEc1igO1z0YKgwryvAepqUT/L6oR0W
	 e9fSKTCa78JjfO0GZmgRRE8cHRj5rl6CoUIxgxyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/595] net: ethernet: cortina: No mapping is a dropped rx
Date: Wed, 30 Sep 2026 17:22:42 +0200
Message-ID: <20260930152353.495859204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 87be7b9f803be..30ed2baa033ea 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1465,9 +1465,9 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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



