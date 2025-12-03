Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE08732860F;
	Wed,  3 Dec 2025 15:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776970; cv=none; b=Noj6xNx0GljfcTLub6ok3VTeIlCjm/pFlgmNMZ099itAh4MW0B+nq163EUDCeM+hxEM6Y8IbWCIzFxTwO+0DMYl8lUspK5Eu9phYNcx2sWBJUSsEVJtAIMxN6t1DOTn+fZWexugSvQV/3lgOQtUvN3aO9g5jooHjsKihmM0pV9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776970; c=relaxed/simple;
	bh=/MZCrQOKtsxcaHgFpulF7tRZ6gGOJewo+QuJS7DMNDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE6gjVIjIWgW3/iiWLU1+nEBvYYXFQuXLjifzam0KRT0tN09wOEN7ZpEmdISwwTy9LO2VVWc7q9p7LmYEBlFvhEg2+hjUQRT/SRfzgc1ldYfIJwvXoB9cSS7t+veJoLKLj0r8VefJZR6oDG9sts4AaYwZ1nHwRbICGHBpe2w0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRN4Yz9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRN4Yz9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C09C116B1;
	Wed,  3 Dec 2025 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776970;
	bh=/MZCrQOKtsxcaHgFpulF7tRZ6gGOJewo+QuJS7DMNDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRN4Yz9I/qgiQSBIYh2JWEvEO73suQWoEQPYSgk5wuIfT440t05XGDSxtvmE34PgB
	 LfZYenitaNSGTimDeQezyWfDwlRcOyzK0fGN4N/OLCj+CkcE9qq86awUzOWL7RRWsH
	 ssYca1MG7gjstF+ulDqsmINd7Bd/29PYWsVC7GpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 035/146] usb: gadget: renesas_usbf: Handle devm_pm_runtime_enable() errors
Date: Wed,  3 Dec 2025 16:26:53 +0100
Message-ID: <20251203152347.758211700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 74851fbb6d647304f8a7dc491434d3a335ef4b8d ]

devm_pm_runtime_enable() can fail due to memory allocation.
The current code ignores its return value, potentially causing
pm_runtime_resume_and_get() to operate on uninitialized runtime
PM state.

Check the return value of devm_pm_runtime_enable() and return on failure.

Fixes: 3e6e14ffdea4 ("usb: gadget: udc: add Renesas RZ/N1 USBF controller support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251124022215.1619-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/renesas_usbf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/renesas_usbf.c b/drivers/usb/gadget/udc/renesas_usbf.c
index 14f4b2cf05a48..4c201574a0af8 100644
--- a/drivers/usb/gadget/udc/renesas_usbf.c
+++ b/drivers/usb/gadget/udc/renesas_usbf.c
@@ -3262,7 +3262,9 @@ static int usbf_probe(struct platform_device *pdev)
 	if (IS_ERR(udc->regs))
 		return PTR_ERR(udc->regs);
 
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.51.0



