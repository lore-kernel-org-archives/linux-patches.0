Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F6268FF0;
	Tue,  8 Apr 2025 12:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114455; cv=none; b=IPa9vQvyzN1tmY0CjHr+quAOVK5HVZ3TivgZtAQw0Cw58Muov5zAFKgEAiybkrUTTCWs5nRuuFkyyoveJsJHSmHlVe6JGCcDVAZyLF8BX4UfSuejYsx8AVeNu7jTN/5cPdwkRWdBEu88357R2C8aB9qko0OzEBU/LI2vrDc5iyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114455; c=relaxed/simple;
	bh=dxR5S7MAFKLKFd2EWCg8g6CHo+lNzi2BSELU2DmlUII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0erBQNRzVzdblWrAz0B3ai/cwLX3E8I00owQ1FyedNxjWY5NXXNCzEO+RlD0SUxtciI+ud7Wf64np5lJd/NWktiORPnn+aWTydL14+tIUu1iSoxjbgv4tveFRrCgK4wt997sxzZWMSFdrGf/s8L2WFbXOEIPTTBqdKmZE38ys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4KH7jQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4KH7jQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F9EC4CEE5;
	Tue,  8 Apr 2025 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114455;
	bh=dxR5S7MAFKLKFd2EWCg8g6CHo+lNzi2BSELU2DmlUII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4KH7jQGgPpi1BZXEEhPxNMS3VxUtG3Z1+QytIuHqiWMMKqRiEfluFf4mAWzc1AR6
	 6GwQMrbkxDxAycBXm2F7Jodb3fb9wwnRBbFpGrPoXdGLPetbRqWHvj8S1PPK0brcJr
	 LfuQjkRdDdIyVrvMDJcVyitH8Owjrr8NIs9R110E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 112/499] PCI/bwctrl: Fix pcie_bwctrl_select_speed() return type
Date: Tue,  8 Apr 2025 12:45:24 +0200
Message-ID: <20250408104853.996296674@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 026e4bffb0af9632f5a0bbf8d594f2aace44cf07 ]

pcie_bwctrl_select_speed() should take __fls() of the speed bit, not return
it as a raw value. Instead of directly returning 2.5GT/s speed bit, simply
assign the fallback speed (2.5GT/s) into supported_speeds variable to share
the normal return path that calls pcie_supported_speeds2target_speed() to
calculate __fls().

This code path is not very likely to execute because
pcie_get_supported_speeds() should provide valid ->supported_speeds but a
spec violating device could fail to synthesize any speed in
pcie_get_supported_speeds(). It could also happen in case the
supported_speeds intersection is empty (also a violation of the current
PCIe specs).

Link: https://lore.kernel.org/r/20250321163103.5145-1-ilpo.jarvinen@linux.intel.com
Fixes: de9a6c8d5dbf ("PCI/bwctrl: Add pcie_set_target_speed() to set PCIe Link Speed")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/bwctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/bwctrl.c b/drivers/pci/pcie/bwctrl.c
index 0a5e7efbce2cc..58ba8142c9a31 100644
--- a/drivers/pci/pcie/bwctrl.c
+++ b/drivers/pci/pcie/bwctrl.c
@@ -113,7 +113,7 @@ static u16 pcie_bwctrl_select_speed(struct pci_dev *port, enum pci_bus_speed spe
 		up_read(&pci_bus_sem);
 	}
 	if (!supported_speeds)
-		return PCI_EXP_LNKCAP2_SLS_2_5GB;
+		supported_speeds = PCI_EXP_LNKCAP2_SLS_2_5GB;
 
 	return pcie_supported_speeds2target_speed(supported_speeds & desired_speeds);
 }
-- 
2.39.5



