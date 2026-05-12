Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E333CDBDD;
	Tue, 12 May 2026 17:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607772; cv=none; b=VxeAwKYeq6JaT4ZdYvWaUtZupAwYjapvpnmRmAsh6CotreEX3sq0T64CkRn/F1e+nq6RwSG2SJRi3IpOrvV9n19C5b1UYpPLNiw2H0n40Jg6LH0KrkBXfVXY4DgYx06f7rKFq2TbM5b2sOytN9NqDDdxavAIgmrFREbhi7F9P/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607772; c=relaxed/simple;
	bh=0TtdTtinQzUlx7pfLOW4eu3ZkdTOYQwQgi1ADAxzwg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK7RvVOy08kkURjtx07asQy5yXAmk70RbNenWLrOuD/ik5zuFWWxTo3mGM1mBn1EyXBGqPXK6dvgYefQfEt++wuim8407dKq1iu6z3RcGrP1mwtsIVhymSQ1Dn1nD3I1MHvWS1Xn/CIPLWh4uuBN8lcKIweCmMJ41RP6uGCvy4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ei38lpqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ei38lpqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F057C2BCB0;
	Tue, 12 May 2026 17:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607771;
	bh=0TtdTtinQzUlx7pfLOW4eu3ZkdTOYQwQgi1ADAxzwg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ei38lpqz8YAqdFM07uVniO6RzLD3xTe5uEppN8BbLDoBStyfylNhMpIxz+sPOCA2O
	 ZTHamOBUCRQf40LqBGSLeZh163boAFf9lvK0a7YN0YZ9JlSqw+4IBbw45LQt5bLDVO
	 oFLdGQi7jK5tbdyilCHL1U58ufkUiO0+Hx4SxZa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 012/206] spi: rockchip: fix controller deregistration
Date: Tue, 12 May 2026 19:37:44 +0200
Message-ID: <20260512173933.080165596@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 53e7a16070feb7d1d4d81a583eaac5e25048b9c3 upstream.

Make sure to deregister the controller before freeing underlying
resources like DMA channels during driver unbind.

Fixes: 64e36824b32b ("spi/rockchip: add driver for Rockchip RK3xxx SoCs integrated SPI")
Cc: stable@vger.kernel.org	# 3.17
Cc: addy ke <addy.ke@rock-chips.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260324082326.901043-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-rockchip.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -914,7 +914,7 @@ static int rockchip_spi_probe(struct pla
 		break;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register controller\n");
 		goto err_free_dma_rx;
@@ -942,6 +942,8 @@ static void rockchip_spi_remove(struct p
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


