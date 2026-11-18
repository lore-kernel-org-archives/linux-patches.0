Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025584;
	b=1j0doDXXJCmbi3wTRxqMyuht0U+9h45O9dax0Qh1xZmx5TGNImWpnU2Ix3oLNft68VMo
	 A+98rQ4bEvnuJ2kRCrojZauBZZLN9YJZxLRmE4ykj+fMYWHC7J5RDnfunNQ+WQ9aR7d5+
	 LowuvOo0GKGEUni4uVv7y7tOM7LWw+5tu2Nz0jfXoJSpLzCcpr18RLJ8mfmGyfrfGrqOf
	 s5JqPvEQXnpHDe2yMTUZ1ISGwv03N1f7ydxal9ZDFAXbQtvBefHROum/vPSHPiP7tw4nK
	 Zs4BwMjwX5OnGFrTo8EMKjNzLVbG9sQ6JUJjJH6E2iyKXEG2O5QTAM/LH62tFsUTWJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fNGiynF5HjkUec8O6MzmVKRTXDzM3fwAk486eFNBb7s=;
	b=hc4loN+85Z+j4iiS7ATjei6TvBuebSgrJXx7PSBFnt6K3xiuBdT93bXbYR6lwrYwcX9f
	 5byTFkBAIsr1jIgxorTUKLYxtU4fIeA26pV6foCVFYR/6cmuqypv0HXgEnsuuyKK2Jru2
	 HFL/58oxmFHz13v4BDlgkrrfO3WWoP+NCoT13Pqvqq3lI+roP5Ph7WByRvxhrbaaEeLQv
	 KNotTbmut3Z+tGYSOnlOFWp4mFjfEK7XH1ruBFe81l+5Vzciwl2EqkW2mZ10LOkRfzkPA
	 8Vj/woYPWiwPKvAbDtgkbMZ9fAS2xQSl4bOy/d4xui9ZZXtEZ9nvMEndEnTx1nJMNxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+EFIELU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C857B606A32A;
	Wed, 18 Nov 2026 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+EFIELU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255051F000C6;
	Wed, 18 Nov 2026 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025584;
	bh=fNGiynF5HjkUec8O6MzmVKRTXDzM3fwAk486eFNBb7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+EFIELUSBacacAgxCYpjq8Eh/23TLYOeM0ol6Dg2/IG2yw65pvjWuXMdiHIBckew
	 GzOryYsX/XiN2i8cjkBqJo0LwsfTe8anh7XAJJ3UMsXMiqrNAtqZL1aj1duz320NEA
	 PFVLsH5QKduZkwLtVlK0miJnNken/Y5GVsChvDEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1131/2151] dmaengine: ste_dma40: Fix logical channel bounds check
Date: Wed, 18 Nov 2026 15:47:46 +0100
Message-ID: <20261118150203.397032074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 57938e0c2a24f9f792fe9f611391ef6b58d1aa21 ]

d40_validate_conf() checks the raw dev_type against num_log_chans,
but d40_allocate_channel() derives the lookup_log_chans index as either
2 * dev_type or 2 * dev_type + 1.

Validate the dev_type against the derived logical channel index limit so
channel allocation cannot write past lookup_log_chans.

Fixes: 26955c07dcf3 ("dmaengine: ste_dma40: Amalgamate DMA source and destination channel numbers")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-19-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5c2a13b2f826d..c0c495e89ef27 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1750,15 +1750,26 @@ static int d40_validate_conf(struct d40_chan *d40c,
 {
 	int res = 0;
 	bool is_log = conf->mode == STEDMA40_MODE_LOGICAL;
+	bool invalid_dev_type = conf->dev_type < 0;
 
 	if (!conf->dir) {
 		chan_err(d40c, "Invalid direction.\n");
 		res = -EINVAL;
 	}
 
-	if ((is_log && conf->dev_type > d40c->base->num_log_chans)  ||
-	    (!is_log && conf->dev_type > d40c->base->num_phy_chans) ||
-	    (conf->dev_type < 0)) {
+	if (!invalid_dev_type && is_log) {
+		int max_dev_type;
+
+		if (conf->dir == DMA_DEV_TO_MEM)
+			max_dev_type = DIV_ROUND_UP(d40c->base->num_log_chans, 2);
+		else
+			max_dev_type = d40c->base->num_log_chans / 2;
+
+		invalid_dev_type = conf->dev_type >= max_dev_type;
+	}
+
+	if (invalid_dev_type ||
+	    (!is_log && conf->dev_type > d40c->base->num_phy_chans)) {
 		chan_err(d40c, "Invalid device type (%d)\n", conf->dev_type);
 		res = -EINVAL;
 	}
-- 
2.53.0



