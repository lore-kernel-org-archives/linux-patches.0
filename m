Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412F722F762;
	Mon,  2 Jun 2025 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875301; cv=none; b=nawknuzr7QQXN4sV5tlcDG5zjHbild/VuuVd/B9PpUinT2ApNjQPEAbJ3sZlW/rOQ+WqcvYVfxe9GTgL+69Bah5CmDQYu/WVg+w/CsAKBLwzHKNFXcQoeZr6a2FBMOFLUgmYgYTDG0uYOp4+QxohSmD9C9JS9+9MvsNiBJTNbLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875301; c=relaxed/simple;
	bh=2fdJMZkJa/Z2z2fneCImylIIUR7SBywB+UnZaRSrbgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sU+rky5zdP5b9212nehWCPPoCXKuJji5poXZW4IGv1ZNBLtA94Uoqf2mDSaY4/S8+DQ2ao3g0YBuQgn5vVyC1Ljo2HseNJBx93hF2uGRvSfjLvcME587SCwzqVXF+y4w0pTQucZIcwV5F9qteCM2neKNoP6azyK7JwLGSeqArug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2FAzDU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2FAzDU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD845C4CEEB;
	Mon,  2 Jun 2025 14:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875301;
	bh=2fdJMZkJa/Z2z2fneCImylIIUR7SBywB+UnZaRSrbgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2FAzDU6lfUvmn9i/JMKPKFro/ZtYaSom9efT3fo27CpDtCcPOUrGF2NJiIwXXxi9
	 MykcCpGhZxn7hCxTL96a/ZUE7Tr3Gx2LC7pvWEmwPH4RtT/BO3330SPFOyKRNHcBsT
	 tzcqdmNTHcunLMlG6XqdHBRu+PqMYbmgnopLsYag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 5.10 063/270] usb: uhci-platform: Make the clock really optional
Date: Mon,  2 Jun 2025 15:45:48 +0200
Message-ID: <20250602134309.768104774@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


