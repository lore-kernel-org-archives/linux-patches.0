Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FBA1D1E67;
	Wed,  2 Oct 2024 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878479; cv=none; b=E4c+uPpUksKdsZ16aw/S1CFtbf5btL/H6cAPkJzV+JIPKohHwBIOOuaEEU/3XVLPqsR7Br5bELvzJX7q2Zyi+gfgzHK0YrLbrXaIMtkCN84cSzCPkCbWIVxl+Kc1PmI3nkF3ZJ1eBvNUyT6ZzFOIgNVJDrvbservyiJ9PcRRJ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878479; c=relaxed/simple;
	bh=Ove8GWSy+fXDrwVAWvSGcULMGU3mK5G0Nnv9C96LZVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XROeB4nSoWrR6dfK2IOBiizkI1MASWxSRSU+I4mZduL1QhWtAqa4S9fvNdVvKjPC+AtvED9HHIbvl+nfP6wvbBJMTk7WuBuGGhHun900HQ9qokXyqMjZ/DnJP2hHALAbXppAUxvCxIEHG/thYTJjd8H0t1psseDgCdfgwUchURw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1V1bwC+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1V1bwC+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60362C4CECD;
	Wed,  2 Oct 2024 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878478;
	bh=Ove8GWSy+fXDrwVAWvSGcULMGU3mK5G0Nnv9C96LZVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1V1bwC+AWQ/B9lrp+Ba1MNKICLw1KtdslMvcNa0qcmTAAnOtBmAcrNENbJWe4h5BP
	 ZFnXSMJp6o0bwsuTX2tsc/0+Lp4K/mob98S4i/ZEWhaQo8vA/zvcKI9mNrZBnkOoNP
	 mZj6cfP3GSeNJxBSSvLx1NfW9+6YzFLy+jY9vrk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 427/634] interconnect: icc-clk: Add missed num_nodes initialization
Date: Wed,  2 Oct 2024 14:58:47 +0200
Message-ID: <20241002125827.956752811@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit c801ed86840ec38b2a9bcafeee3d7c9e14c743f3 ]

With the new __counted_by annotation, the "num_nodes" struct member must
be set before accessing the "nodes" array. This initialization was done
in other places where a new struct icc_onecell_data is allocated, but this
case in icc_clk_register() was missed. Set "num_nodes" after allocation.

Fixes: dd4904f3b924 ("interconnect: qcom: Annotate struct icc_onecell_data with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240716214819.work.328-kees@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/icc-clk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/interconnect/icc-clk.c b/drivers/interconnect/icc-clk.c
index d787f2ea36d97..a91df709cfb2f 100644
--- a/drivers/interconnect/icc-clk.c
+++ b/drivers/interconnect/icc-clk.c
@@ -87,6 +87,7 @@ struct icc_provider *icc_clk_register(struct device *dev,
 	onecell = devm_kzalloc(dev, struct_size(onecell, nodes, 2 * num_clocks), GFP_KERNEL);
 	if (!onecell)
 		return ERR_PTR(-ENOMEM);
+	onecell->num_nodes = 2 * num_clocks;
 
 	qp = devm_kzalloc(dev, struct_size(qp, clocks, num_clocks), GFP_KERNEL);
 	if (!qp)
@@ -133,8 +134,6 @@ struct icc_provider *icc_clk_register(struct device *dev,
 		onecell->nodes[j++] = node;
 	}
 
-	onecell->num_nodes = j;
-
 	ret = icc_provider_register(provider);
 	if (ret)
 		goto err;
-- 
2.43.0



