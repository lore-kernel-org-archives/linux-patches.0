Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0D0332EAE;
	Sat, 12 Sep 2026 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221250; cv=none; b=B4WjAMo27+aKvYWqhSALGkY4jrLWPVO60+vB4Mo0/W/pIUcZbY++r00iHQf/beyLi/NuUzL5j/Ib723zXoNoDSPj3OzlH/471EGu7y8BSm3hknvo9hFcSrJqny3Doe4jckPoeHSQSGuGDDtu5yVD+Fvuxl4HuskdM+QvfI8HfqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221250; c=relaxed/simple;
	bh=13U/WJUJmS0N+MNdnfGcZYj6m3FbbePgCHCjOCTURkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxdoqsPKwWwi/SprxFyQkhxcn/++UFGXtHRhZ9hgbOmVhrQSYHZ7LoHfjfFZ25HmWxdIN5blrhuh7vCLmnzLW2r3f4z4dGgGZaefV41THwcWChAm+lcKDVNzR3Vt0pMcqdXQaUCIDfn5xqGlM7IjjHeytvpd62xJZe6E8sSZoy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x77LNC9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x77LNC9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F351F000FF;
	Sat, 12 Sep 2026 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221245;
	bh=c0q416njL5BVp2m5wJ1E4ERRxnT1PjFImuSB61douKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x77LNC9+qRl+TH5SYwL9R03tkSMf6eHJa6yOvivUxZ1bz8kNGi/VBSNUWFoQI3jfx
	 wDV8CSp4uHPyJ7wXO9hb6KDFO5ziCx89Bng1YVqBpwVtb+ewHlOAjMfd4b1oz8PnHa
	 UpQxK6I7dY+fomdcKr4KK7snecSY35ZqzW0Tqgnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0341/1424] spi: bcmbca-hsspi: disable clocks on resume failure
Date: Sat, 12 Sep 2026 08:46:13 +0200
Message-ID: <20260912065614.921864536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit d2f5a606710ad70c341dc609430a20a5645618d5 upstream.

bcmbca_hsspi_resume() enables the HSSPI clock, and optionally the PLL
clock, before restarting the SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves those clocks enabled. Propagate the error and disable the
clocks before returning.

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Link: https://patch.msgid.link/20260804071904.860842-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcmbca-hsspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -621,7 +621,13 @@ static int bcmbca_hsspi_resume(struct de
 		}
 	}
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		if (bs->pll_clk)
+			clk_disable_unprepare(bs->pll_clk);
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


