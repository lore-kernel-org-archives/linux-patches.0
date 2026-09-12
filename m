Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1F436728D;
	Sat, 12 Sep 2026 09:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204386; cv=none; b=N2Liuw0jHxB83vf6nW/XZd/itinfrBNZ4upX3GfIJMokgmxgYHiycDZ/wXWGIFNxSR5jNR8slZSjwP7PPVU3njpfVUdhbzCruWfWq8Ml707le6uhHmTDoMXqzXeADKmaH7yt8wM8grqpKjxZ9PMa7pmouYY0KvK1YRQfH8dviZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204386; c=relaxed/simple;
	bh=p4jPZPRj1OjraR6aIuHwQxSacDg+62k7aYjl60xPr4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIPx7uh7i+Lk1V9W4bQq0h4sz3+FBVU2qeLJcdRI23/mgAXi9OYTM88jA8wgpp1N1eG3/F+4mbQ5a/acOgZFIiu90Fg7DNwIE01JjTH4sszf3HHI5vlLCYARQ57jkq+SnLMTqR5V3SQmP/clm9PPvGQHdKg3pIO9k2r8yM1ESFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDU4aJCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDU4aJCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402F41F000FF;
	Sat, 12 Sep 2026 09:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204385;
	bh=htNxzky1874eRsBIBYo+m56E4A0Y7BXf4m3xF0Co62c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDU4aJCbL6vkWUtP7P6prEgZEYdra+sS4rGxiZxcTn87nP2AdwwLPbb8KoUS+pusb
	 ylQgNClRzM2FhO5y5zzLsVMwdkORsZ41GPtoSJsWmfkj6n7DnME50qH5QFDfZhVUp9
	 RaxIPk04YAg1sOy3GBM+rGfBqnd/ETwLxo2NBvx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1559/1815] octeontx2-af: initialize lmac_bmap in rvu_mcs_set_lmac_bmap()
Date: Sat, 12 Sep 2026 08:55:09 +0200
Message-ID: <20260912065725.594024290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4b92a3710d4a1d850ed6421c773e735cdca69b07 ]

rvu_mcs_set_lmac_bmap() declares lmac_bmap without initializing it and
only sets bits for valid lmacs with set_bit(), which ORs into the word
without clearing it first. Bits for invalid or skipped ports keep
whatever was on the stack, and the garbage is stored into
mcs->hw->lmac_bmap.

Initialize lmac_bmap to 0 so only valid lmacs are marked.

Found with Clang's -Wconditional-uninitialized.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260812060730.6181-1-kmehltretter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index d98b49f47970b..fce22e314cac0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -856,7 +856,7 @@ int rvu_mbox_handler_mcs_ctrl_pkt_rule_write(struct rvu *rvu,
 static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
 {
 	struct mcs *mcs = mcs_get_pdata(0);
-	unsigned long lmac_bmap;
+	unsigned long lmac_bmap = 0;
 	int cgx, lmac, port;
 
 	for (port = 0; port < mcs->hw->lmac_cnt; port++) {
-- 
2.53.0



