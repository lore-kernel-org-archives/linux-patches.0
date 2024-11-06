Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938761DF24E;
	Wed,  6 Nov 2024 12:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895193; cv=none; b=RrXG6EyTJlpnF4vqnV63GL//AWC5q8eUaCzwJ4yNvXG2iZdkcRTwUTT6GN0pBwZ7M+XHv2JttTAmqrW6Bt0UNyZv/HzpE8bsxun3pic1cNDu5XQe2+yUgzOrIOZX2pSERkkIVr17c2in8ZQ3cw/ZA0gli/8RMhZllqQlthneJCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895193; c=relaxed/simple;
	bh=vWILMgTlg1g10ZoDqF9FL/04UaAc2aVo0MdJ8c79U80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgGNtKXA1TgDX2Ifpmmpknp3SymZPRtDJgoBBp60K4Glq7sYDziAWqunTE5wSNC18B8yIumV1qBRJoLRJWHDoQB6dT9SpA5yGSLK+oqm8oDjgLH7hB1h48Sja5e+pXaiDlubGvXn9zsJVUkskltA2XetcInrMw6CWqpr31K52/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mckB83Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mckB83Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171C2C4CECD;
	Wed,  6 Nov 2024 12:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895193;
	bh=vWILMgTlg1g10ZoDqF9FL/04UaAc2aVo0MdJ8c79U80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mckB83XjgqC+KqA+Wg6nxOTJbTrBe0mzigzKRpygpywmXHq9zmuLUqkVLJU7P1XvZ
	 D+eNVdjb8ykaubVsor7crB10Vi2FqpiMnq7N6moNivRENe0jgqcMgQUtQ+luxA21nD
	 DGkT/BPr4p8UciJYxilIoLxdX3DjQtwdEads4QXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/350] clk: ti: dra7-atl: Fix leak of of_nodes
Date: Wed,  6 Nov 2024 13:00:16 +0100
Message-ID: <20241106120323.070835852@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 9d6e9f10e2e031fb7bfb3030a7d1afc561a28fea ]

This fix leaking the of_node references in of_dra7_atl_clk_probe().

The docs for of_parse_phandle_with_args() say that the caller must call
of_node_put() on the returned node. This adds the missing of_node_put()
to fix the leak.

Fixes: 9ac33b0ce81f ("CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240826-clk-fix-leak-v1-1-f55418a13aa6@baylibre.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-dra7-atl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index a4b6f3ac2d34a..afd71c894150b 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -257,6 +257,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		}
 
 		clk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
 		if (IS_ERR(clk)) {
 			pr_err("%s: failed to get atl clock %d from provider\n",
 			       __func__, i);
-- 
2.43.0



