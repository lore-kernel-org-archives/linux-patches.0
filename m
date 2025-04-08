Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D770265CAF;
	Tue,  8 Apr 2025 11:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111301; cv=none; b=SVuY5qhc74QNsfpuar82UM61N0OoC+0NH2l+BFnosuonrEsY2bmSChX3z1YTDDB2MTbKJH7jyTikEeGG+4vHc9qhc7awQdavldb8yA69rIqqdjmXlt+cbztY3Ry1cu4jf99Lxh/cXlo1tTQ5vlpMvOoFSZJcguF4jIC3XtJrIUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111301; c=relaxed/simple;
	bh=q6RcL0NSdLinZrhQBMHm93McFPFy4uJl7jL2lSma4w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IAZ57jx0093bAyQdz7FPGVLM4KoFESp8LksPFgB+ttEKr4QQFR+moBE529fEBVvpZHds/GI9j91HAfVD+oMgJZ5fQCZuRjdEqIb0qkhMx3xFkQe2gW6guvQC4ZVje+mXJWXPzJwigARKWBGSHpCvXJUH6jZMe38T4ptBV8tts4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhLiV4R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhLiV4R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBF7C4CEE5;
	Tue,  8 Apr 2025 11:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111301;
	bh=q6RcL0NSdLinZrhQBMHm93McFPFy4uJl7jL2lSma4w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhLiV4R60GvoDi71luLVWSzCcxkYbYvjXNM5OGTfZXOoIzdtnyQd4qOrSDvj5cIrZ
	 y7SjIrpRUna3lU0Mi+ey2DNM+0xSlwxaR0AzolI2uvHdNZSrBpEmQco5m12BlLiJVy
	 rWYgaNAFL6UTizx7WGyH/PWJtqPp3nLr+eZRXBT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 342/731] PCI/bwctrl: Fix pcie_bwctrl_select_speed() return type
Date: Tue,  8 Apr 2025 12:43:59 +0200
Message-ID: <20250408104922.229921185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



