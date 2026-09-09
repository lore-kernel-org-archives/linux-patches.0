Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD4425783C;
	Wed,  9 Sep 2026 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963442; cv=none; b=Sabfv679km4lODDF7657jME4r0vxkuoQnn2L7lQmsNfjyO4vjqeWBVreYhim4n31DULB0v8xSg3ZCCBXohQGplB5ZLY+ZEPSG2qQsHgmayiMRJzGMAsW01H1ooELVdrnY++i+5i7ISVjwiL/Fp0ocVaJZtarcLR3JeJSQ1EpPgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963442; c=relaxed/simple;
	bh=ieBfEiwkbo4wG2oLGrRBRaXhq/nr1HLVb4jaWAuVnVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myrFTdXgTSojTCDxjbr/1vbZptM9nilWNlm9oNtT4qcG2XsN7oSSMBJqvHLCrDfpK/J5te0FqMBL33RiSBlcW1GsEQGAKFS8IkrEMnczXd9f6lFT2zilMUtxvWc/Jr/oOnMlCkqcS842NbgQ1pRs34tkURYgbD7X0K0k0VDWKSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxyRpMNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxyRpMNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410511F00A3D;
	Wed,  9 Sep 2026 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963440;
	bh=4SAO1ZvMGTqS7sQV0CZrMsmne0xQ/cW241S4w+A5G+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxyRpMNGtNbYlarYOBM0p5QKXrqXBrPbQ8gUFLQfoH0bDjSOErwBdtvI7RR1O37mt
	 I4PXz+9CRKjZvpXOgKCcdHl94ZQM8xq88cBn1ImODWLXPyI4UpzLZKR1kl+gDEf0Tb
	 /xGz8z4CDJj9frfo4/g4sU4AiONtKWRddpEgRnOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 041/583] spi: bcm63xx: disable clock on resume failure
Date: Wed,  9 Sep 2026 15:35:26 +0200
Message-ID: <20260909134239.347645953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit 2b62c2c134fa32d9d3a9e7323c8ac74518eeb4ac upstream.

bcm63xx_spi_resume() enables the controller clock before restarting the
SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves the clock enabled. Propagate the error and disable the clock
before returning.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Link: https://patch.msgid.link/20260804071831.860784-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -661,7 +661,11 @@ static int bcm63xx_spi_resume(struct dev
 	if (ret)
 		return ret;
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


