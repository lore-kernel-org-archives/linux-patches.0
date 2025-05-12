Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177ED2550C6;
	Mon, 12 May 2025 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072450; cv=none; b=OxxMwaVQcDLz90NYLIkf13ltqzbUUuxcZrCmm4S1DZyNRlFF4Twbp+MjA44SgPiVEIsBRK97ddEgDricXwrkoA4zTaxOfsrkGvik4iPsdBSjha9bXhcRbMlpmFRbUBf5Z97X2sMKwBWSm00c3lqKLdQ+dxtZeuXQHApKAtkgnZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072450; c=relaxed/simple;
	bh=U7LqlkH9n1psc3HnnlJ6jph5mozRSErhBLRW1i9AMYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNkTLCRc0yk6KxR8xdtQHf+w5PW8l/eyXfrtN5cvemRFM50tNaqFiOQREdkrgQUwTbNxHzwp6Zvg2GOdTXn6pmGXJVdZFZUUpjBuwsF1kqhzCDTBJdOia6w/QyLqYNx+Kh+DU12aHemV4jx3ZIVGEFRyAnrGTtEBrLVgsIk0qLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeiQ3ukw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeiQ3ukw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE46C4CEE7;
	Mon, 12 May 2025 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072450;
	bh=U7LqlkH9n1psc3HnnlJ6jph5mozRSErhBLRW1i9AMYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeiQ3ukwbIT+C/roYnprCiMk2JhBcxjtx2YtEXliSxwaiT2+lYVrV47eEYr9iti8r
	 0z6vydx3WzV5A8dE+gTR2++r7vCbldLhEMli4tW1M7getcHtCmgjMB/yyg4YboPnxb
	 StQN9acZKDEO6H2EiqZZhH2CPgAir0V9QyKUjbDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 6.1 44/92] usb: uhci-platform: Make the clock really optional
Date: Mon, 12 May 2025 19:45:19 +0200
Message-ID: <20250512172024.912580872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@gmail.com>

commit a5c7973539b010874a37a0e846e62ac6f00553ba upstream.

Device tree bindings state that the clock is optional for UHCI platform
controllers, and some existing device trees don't provide those - such
as those for VIA/WonderMedia devices.

The driver however fails to probe now if no clock is provided, because
devm_clk_get returns an error pointer in such case.

Switch to devm_clk_get_optional instead, so that it could probe again
on those platforms where no clocks are given.

Cc: stable <stable@kernel.org>
Fixes: 26c502701c52 ("usb: uhci: Add clk support to uhci-platform")
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Link: https://lore.kernel.org/r/20250425-uhci-clock-optional-v1-1-a1d462592f29@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/uhci-platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -122,7 +122,7 @@ static int uhci_hcd_platform_probe(struc
 	}
 
 	/* Get and enable clock if any specified */
-	uhci->clk = devm_clk_get(&pdev->dev, NULL);
+	uhci->clk = devm_clk_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(uhci->clk)) {
 		ret = PTR_ERR(uhci->clk);
 		goto err_rmr;


