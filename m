Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2F71C68AE;
	Tue, 27 Aug 2024 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771629; cv=none; b=NKaiZvyi+YyFRZiaUV8J/ywpY3XINUea305jpYccxxi9W4Zn4+eR+JhgygVxRs5NfeUX89k+TNkawXa3r3Fa1MmQ7x3IRU+ghIZf2P3epC/vA+LYpG84k5p/PM26NjETl7hOb+X+c/BYgX+BUBlwpMQoOlSnNxczHxfscdSs13w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771629; c=relaxed/simple;
	bh=Iut19NSt1YkxrJBSwfXJogKJDs/aaxKqe5TIUdZIGDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGrvsy7TbM/ek4oLVq/p6SiUB3jVXD62mYYVPaWVoUGaZhZ52+mKvpG52IznZmIoOl6oA91yL35F3yViMT5vcyD46E89+HVc/zy3jgGQzA9BAsR6iTmJDcfolkTDu8chA2Im8puDLA1SRpNHeX2xr9RmfzpXuRslht8VMEx3Np8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqMu7Maz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqMu7Maz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC24C6106B;
	Tue, 27 Aug 2024 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771629;
	bh=Iut19NSt1YkxrJBSwfXJogKJDs/aaxKqe5TIUdZIGDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqMu7Maz0sYx2a/dxPMBlpq8yL0SXV4ytmgdqUqmbMNs3El7mq0b5LSlr0gdaTfCq
	 rUgR+8H/HR5wZerSn/T2dT3s1sIWiZ9UwpSSPctTZzXnAcz9gBAZX9Yx7CaZXirvDE
	 8SyRf5h7upuwnZO4NttX2tFVXNDOhC6I3w950ndg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Whitten <ben.whitten@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.10 247/273] mmc: dw_mmc: allow biu and ciu clocks to defer
Date: Tue, 27 Aug 2024 16:39:31 +0200
Message-ID: <20240827143842.803177048@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Ben Whitten <ben.whitten@gmail.com>

commit 6275c7bc8dd07644ea8142a1773d826800f0f3f7 upstream.

Fix a race condition if the clock provider comes up after mmc is probed,
this causes mmc to fail without retrying.
When given the DEFER error from the clk source, pass it on up the chain.

Fixes: f90a0612f0e1 ("mmc: dw_mmc: lookup for optional biu and ciu clocks")
Signed-off-by: Ben Whitten <ben.whitten@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240811212212.123255-1-ben.whitten@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -3293,6 +3293,10 @@ int dw_mci_probe(struct dw_mci *host)
 	host->biu_clk = devm_clk_get(host->dev, "biu");
 	if (IS_ERR(host->biu_clk)) {
 		dev_dbg(host->dev, "biu clock not available\n");
+		ret = PTR_ERR(host->biu_clk);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
 	} else {
 		ret = clk_prepare_enable(host->biu_clk);
 		if (ret) {
@@ -3304,6 +3308,10 @@ int dw_mci_probe(struct dw_mci *host)
 	host->ciu_clk = devm_clk_get(host->dev, "ciu");
 	if (IS_ERR(host->ciu_clk)) {
 		dev_dbg(host->dev, "ciu clock not available\n");
+		ret = PTR_ERR(host->ciu_clk);
+		if (ret == -EPROBE_DEFER)
+			goto err_clk_biu;
+
 		host->bus_hz = host->pdata->bus_hz;
 	} else {
 		ret = clk_prepare_enable(host->ciu_clk);


