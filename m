Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB99231A32;
	Mon,  2 Jun 2025 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874597; cv=none; b=BXWNBHe9q4mSjVr0aOAU5BLELGwNPc1QBuAa4ds6GTaxNrwYffNZMnnAukdduuAnuXkzdLkc+Lk9CcaL3liXF1bohZnWZEL/EdxuWe7rK7dFY0ug1sQAcYAEtEdsyCMeOQ+T5F74BxKlWp0bK964R2uFgeHq48KB/EQkqnwM30Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874597; c=relaxed/simple;
	bh=VZ8s+AlidHtPTcEwNBls1xQ3VfzAy1GCd4rDgsy+ChI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4NgsfWrmUoYoR3wONXfSrRuSMJr31/Iuns4g0dNIyeoF0H1RNdt51g7dWMDDgDYsIZahTGoFlYORHzOFlrekJRzF1pFBSKmcin/m2+FGIRs39R9kWiiHox4BjhQviYEId9XrElU/L0vYrlC/QVPiqhCb6qMV/ChS/MHTOxeesU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLcCJZaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLcCJZaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2199C4CEEB;
	Mon,  2 Jun 2025 14:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874597;
	bh=VZ8s+AlidHtPTcEwNBls1xQ3VfzAy1GCd4rDgsy+ChI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLcCJZaVX2vCG3MM3WbYpbR9ZhR0gJxJmpeNG2FKsXMWanh4kEk8plnIVgGgzikxT
	 iRMxScHeS7Ewf9kbiRfOFTUapRhnouAeljv5gphv2GEJAal9hCcnGFSSn72SeToq5o
	 QUsGtm+UzcX3gEl3i+pmVI+Ncs5Up+9hdckNMyho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 5.4 045/204] usb: uhci-platform: Make the clock really optional
Date: Mon,  2 Jun 2025 15:46:18 +0200
Message-ID: <20250602134257.449462238@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


