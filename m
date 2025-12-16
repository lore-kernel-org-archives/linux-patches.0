Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6942434251D;
	Tue, 16 Dec 2025 11:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884382; cv=none; b=EGBhFD2mj3QaOO6Iw06NJ1MUuyo6immNWCpRBFkaFDblXsG9lcj/17xIOULaX48zzVpfEYaTifwCfsH7vLCTzSphlAk9KpRTfoKwBbCsIWpvfqVq9Hs/ZaKY0QdIh5/2OqUmRQtQO75w+tuMSiloyVxpCJaYzcOP2yQnsZMwGRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884382; c=relaxed/simple;
	bh=/EdQwVBq/aWc7A/CjZP8suirLyQ57LGGremq6++0Bcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCAJbbNZfp0CSRHSRgO5TgZpTQ8BCDym/V7Nf61X9pK+57Dudl3RPZK8LjyUBwISuWuWX+eQCNkJIlPFeUE4gphS+//b9OglnJfeDvvx4Ga+X1CAnsJ4et6CZi58BxdURS07J7wFzdvqv2Go4OKxE618fB1shcNWIb5xBL7xUuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+K6j5oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+K6j5oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67FFC4CEF1;
	Tue, 16 Dec 2025 11:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884382;
	bh=/EdQwVBq/aWc7A/CjZP8suirLyQ57LGGremq6++0Bcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+K6j5ocIadw8vLjq2VMTYR5BNzgg2Kf8xLKK/CJq6AyzxFhWjJ/fgZ1LN5utk0BF
	 OeXEPO/w6NLX5ZTuQGNANiEEFbUT+uR07F8EGh15zpzi1Ne1RJJHwkLSKdcUypE0/6
	 LSFxn+zsr/KQANBz4Z2aY+389/eBkl+7DLOOXWjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/354] wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()
Date: Tue, 16 Dec 2025 12:11:50 +0100
Message-ID: <20251216111326.097756880@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 5e88e864118c20e63a1571d0ff0a152e5d684959 ]

In one of the error paths, the memory allocated for skb_rx is not freed.
Fix that by freeing it before returning.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251110175316.106591-1-nihaal@cse.iitm.ac.in
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/bh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/st/cw1200/bh.c
index 3b4ded2ac801c..37232ee220375 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -317,10 +317,12 @@ static int cw1200_bh_rx_helper(struct cw1200_common *priv,
 
 	if (wsm_id & 0x0400) {
 		int rc = wsm_release_tx_buffer(priv, 1);
-		if (WARN_ON(rc < 0))
+		if (WARN_ON(rc < 0)) {
+			dev_kfree_skb(skb_rx);
 			return rc;
-		else if (rc > 0)
+		} else if (rc > 0) {
 			*tx = 1;
+		}
 	}
 
 	/* cw1200_wsm_rx takes care on SKB livetime */
-- 
2.51.0



