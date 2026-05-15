Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122193FF1A0;
	Fri, 15 May 2026 15:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860354; cv=none; b=QFQ5Okw8fM974CeqKFxxNdalW2I1aBOnKSSalXN8E2ng3f7T3cAxhcJKy9yhCUZW7i7qdpgVV1cUWZYOPCybUJex4LIKUwvavYyfnIeKgs5sRgG5fiMts0im45Cm5NRsfV4qN8wb+u8O1pJlWDgeu3RTL7KxO3SXVuwC9B0NGzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860354; c=relaxed/simple;
	bh=CtbfDVY9CVfmeFiPg5a7ysZkZVppsq++0wWJbkKnrzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8oJlJ1VIlRR1rftx9DYIy+BJMQeroiYtzcZjnlyPsJgkqDtzQkpAXXQY4saIJw/hmZq55RtHLDXAjRMV0IHGrOv0lanmdgaWC4FvbLVl9SSLa2Y4uKaaqatCUC+ckF5V1EctE3HN7CZa5O0ouugP+o7KbxOX48XtSSRqXvdI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aq/6CobT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aq/6CobT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5F8C2BCB0;
	Fri, 15 May 2026 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860353;
	bh=CtbfDVY9CVfmeFiPg5a7ysZkZVppsq++0wWJbkKnrzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aq/6CobT+uhYvUZgGioBdon8BGGnZmyQUd4Hg0yqJ6IHZjvffaVFtLn/PHIGYwdNm
	 4TxmLi9gAUCOzx6H2hDA+YPDiQd24NHzPALBclC6wUCfrVasX+HH7rH18EcOpr2hjb
	 2JEoBAx4K4xBAT15axScAWACXHSKWL34RlMy3+Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 054/144] spi: img-spfi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:00 +0200
Message-ID: <20260515154654.799324473@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

commit fc3a83b0d9c16b941c9028f5a8db9541dce4ddf2 upstream.

Make sure to deregister the controller before disabling and releasing
underlying resources like clocks and DMA during driver unbind.

Fixes: deba25800a12 ("spi: Add driver for IMG SPFI controller")
Cc: stable@vger.kernel.org	# 3.19
Cc: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-16-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-img-spfi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -644,7 +644,7 @@ static int img_spfi_probe(struct platfor
 	pm_runtime_set_active(spfi->dev);
 	pm_runtime_enable(spfi->dev);
 
-	ret = devm_spi_register_controller(spfi->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -670,6 +670,10 @@ static void img_spfi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct img_spfi *spfi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	if (spfi->tx_ch)
 		dma_release_channel(spfi->tx_ch);
 	if (spfi->rx_ch)
@@ -680,6 +684,8 @@ static void img_spfi_remove(struct platf
 		clk_disable_unprepare(spfi->spfi_clk);
 		clk_disable_unprepare(spfi->sys_clk);
 	}
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM


