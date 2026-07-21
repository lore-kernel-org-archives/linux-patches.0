Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DB932B132;
	Tue, 21 Jul 2026 19:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662046; cv=none; b=Obz/exD5MnPq4I7wwm9vmJdmN/rDa7a2nQ+7sbJLfW8ChisaiWZYzrp0J5M/40sGQAyTp401vB6Pl/cnG9yOTLLkNtm2mDXj2B0i7zCHE1mpIoLUjGjKL+D6xMsPcD0Eu4B5KBpwIpXOqKOCmF6X1tvEbmvZijeHgYiIuMywMh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662046; c=relaxed/simple;
	bh=mvdPqelJnHyLi1QJ9DaOD0XCDve9ppIka61vVbbaWN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSzUFDtneDGwLzPi1GzLijXoq2XpXnn1wrO6JoS1Hy/3RcEvCI9BYk/oBun5tzMXngMBzJwMDYrt0mlyltgR0BEACompNEN3bRm1jNMn40mFCfCPfy4aIlFuxdtxl5PqREa8CoVGd9ut6FqwnOYx+DZsyGdkjCb1tEV9pnierv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oizOb4Tj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oizOb4Tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7B41F00A3A;
	Tue, 21 Jul 2026 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662045;
	bh=FNT0ottbo3jpHOgVCAKYHD8Q8QVYpZBk944U5A25w0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oizOb4Tj6Z/qd3aFSuXw61wV7NMktWl0/JtpJaosyqsc0OETT555dw2DDLBhEr+JZ
	 t1XMGYmnFOiWLRjhqQ/HEAIAtxTwmsjysrZ/o8Rfr0RzMUZDSPRPHmf+Qr/4/38xRv
	 7/YOhTwWZiTeFsWCNemb0MnRq+yey8qo8jFEyDWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0296/1276] spi: meson-spifc: fix runtime PM leak on remove
Date: Tue, 21 Jul 2026 17:12:19 +0200
Message-ID: <20260721152452.714970281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 606c0826bd90384a54571c0c5475ca41f50164ea ]

pm_runtime_get_sync() increments the runtime PM usage counter even when it
returns an error. meson_spifc_remove() uses it to resume the controller
before disabling runtime PM, but never drops the usage counter again.

Balance the get with pm_runtime_put_noidle() after disabling runtime PM,
matching the teardown pattern used by other SPI controller drivers.

Found by static analysis. I do not have hardware to test this.

Fixes: c3e4bc5434d2 ("spi: meson: Add support for Amlogic Meson SPIFC")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260609052647.5-1-ruoyuw560@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spifc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
index fd8b26dd4a792a..8d155f753fd723 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -352,6 +352,7 @@ static void meson_spifc_remove(struct platform_device *pdev)
 {
 	pm_runtime_get_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



