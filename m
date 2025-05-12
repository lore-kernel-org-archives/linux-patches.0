Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5C1C32FF;
	Mon, 12 May 2025 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072041; cv=none; b=m/uz+v01WbbkmZ1qCFfO6Z+ybizZ99MLwmsUao/W0UWn3apFkVWedtci7NLg48P+QqT6OP1IH1PnxIAVD0cyjcuRQ5brMVoYd0DuqNnZVqaDX3VKkicyF5OIBHBpSGcRgjyCvA/RfwxQKBfCt3JsKpx5R7VHbERNAZb0i4DQWlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072041; c=relaxed/simple;
	bh=x3cVanksdeOzFdqcUmIu07dX/nzuaxrQ6/Y+6alxG5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSx+KmMtktR3EUaUs3W3ag0WcmCc7Yis2kMyMhco0nt7kpjXd2LxnT9MYC+GaEJYrsY5s8t+Ib0OS4c7kgBI0DGyluWm5eLfW1xEfhZ9RUelnwatFPnXiyI60wLHZ3HkO+lh+Ypod2hXz0dX2qknRblyuEZeDu+NWgc9s4viQKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ugvhl3bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ugvhl3bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B10CC4CEE7;
	Mon, 12 May 2025 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072040;
	bh=x3cVanksdeOzFdqcUmIu07dX/nzuaxrQ6/Y+6alxG5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ugvhl3bnkuqx/6LacvY98ITBvldz7iD1dnGep9fWuxn5p4FnPaHNPY0o+jSuGm4uN
	 7k40G90QO+LEUiHatZ51gADhezmir/fiAP8T4kWnUGJnHl2IygWwHCAuhtXVEHrdTi
	 nLmleWNRJ8HSZDPqFOIjLkxeeCTnpktnzpCNERe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 6.14 118/197] usb: uhci-platform: Make the clock really optional
Date: Mon, 12 May 2025 19:39:28 +0200
Message-ID: <20250512172049.183631057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -121,7 +121,7 @@ static int uhci_hcd_platform_probe(struc
 	}
 
 	/* Get and enable clock if any specified */
-	uhci->clk = devm_clk_get(&pdev->dev, NULL);
+	uhci->clk = devm_clk_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(uhci->clk)) {
 		ret = PTR_ERR(uhci->clk);
 		goto err_rmr;


