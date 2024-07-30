Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8BE1B5837;
	Tue, 30 Jul 2024 15:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354752; cv=none; b=m1OqeGhn4A4Or21+/jQxMdPvi6cuXPhBNOrfjs8lh6ZQiZPdci1cCG3CRQf6RpdfAppLJU22Il0bNsCNrGjbZQUsoOy6kRSYfmeqVG+PagpgeGTUKhtihpUZHO/ioSW2Nmt4kdB++Y7ErOSoV59LweucbgrKVXBCwC5LXQV6rgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354752; c=relaxed/simple;
	bh=0MSj6OQDCZ1cLDCllcVWoKepoG8NHDNP7DbbrHfUkwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9MTq6VhMsWrr+qsPysKzn8lwvsZzblR/oFV0p7bGeT1phNwbxPdhXJhiR5KLupP7+34aXa37NTqRE+kx+NhiZDel6QxmUzF6/exDeL2E71dTs8NRClSqofpOffmOebrErDIXpqy0WYRg4K94J++JC/2Ps1ay00bUtIrv7OCyfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjgHAeF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjgHAeF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB97C4AF0F;
	Tue, 30 Jul 2024 15:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354752;
	bh=0MSj6OQDCZ1cLDCllcVWoKepoG8NHDNP7DbbrHfUkwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjgHAeF5+TlHvm5u6ykTLWViqQp1p4zKtAmG0RqOR1qz9X08xOvxidlEpMBShOxud
	 Gu3JVUPMBD0gNIZ3LB4kV098oPuJfrZz0ULnXTywjHxxWT2eNnP3Z9B8SgQElnU55t
	 T2ID7f3rPNDwrH4x9e5PCb3rcG54knAa9ayYUKD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/568] spi: atmel-quadspi: Add missing check for clk_prepare
Date: Tue, 30 Jul 2024 17:41:49 +0200
Message-ID: <20240730151639.899059219@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ef901b38d3a4610c4067cd306c1a209f32e7ca31 ]

Add check for the return value of clk_prepare() and return the error if
it fails in order to catch the error.

Fixes: 4a2f83b7f780 ("spi: atmel-quadspi: add runtime pm support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://msgid.link/r/20240515084028.3210406-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 3d1252566134b..4cc4f32ca4490 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -756,8 +756,15 @@ static int __maybe_unused atmel_qspi_resume(struct device *dev)
 	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
 	int ret;
 
-	clk_prepare(aq->pclk);
-	clk_prepare(aq->qspick);
+	ret = clk_prepare(aq->pclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare(aq->qspick);
+	if (ret) {
+		clk_unprepare(aq->pclk);
+		return ret;
+	}
 
 	ret = pm_runtime_force_resume(dev);
 	if (ret < 0)
-- 
2.43.0



