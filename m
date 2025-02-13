Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0646526B080;
	Thu, 13 Feb 2025 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458870; cv=none; b=jWquGfwmblMjb1aeef5LmZ02L3ECiYP5qi3IhmrbhYBsVRSuo1rTa3Dpi2hxA+flYYuemQVYzkSJUdwrhZfdGDEGb6DvN/Ef7izTU51h1rvmjD/82bnH9IHgBae7HKFvR5LlljhhtodqnpsXK9jC1Zstyq8kSSJVw1NRMDESmFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458870; c=relaxed/simple;
	bh=0ul/nY5OYe/K8yyMvuI0wHmOqlDvdwCsv9+4y9J0vJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LadRdSgQ6XzfOpPWXGgkxe4f9Q6gXgkhCd4x8laHVAsg9e2KSy0Cs9iU5VIxRXixyI9S/XSoMRjFHizA04BbEHzyMIK7hSJziO5Z2J9VGHDAmpJcsuFb7LgwqyOYTJIyFZlAgqdAkh4rNsS0xXaD/oXvxHU4ZJL4A6hNMGxOaPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGhjTeJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGhjTeJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D6DC4CEE4;
	Thu, 13 Feb 2025 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458869;
	bh=0ul/nY5OYe/K8yyMvuI0wHmOqlDvdwCsv9+4y9J0vJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGhjTeJCWgH3l028cM5tSIUkk4iMO6p0lj1Qvr29nquHujoKrwWjAIQKUJQ+7fKRb
	 k48d/uPBbACga5EElnE+QTiOnKotXHIFsxm/9Z/gu5A+IOUZ2LJ1hHDNurLscEW6zS
	 kjAFNhw3KjsmO3h0Jc+8FWSJVXihtwL2xG8xybXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macroalpha82@gmail.com>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 069/443] Revert "mfd: axp20x: Allow multiple regulators"
Date: Thu, 13 Feb 2025 15:23:54 +0100
Message-ID: <20250213142443.280351390@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit b246bd32a34c1b0d80670e60e4e4102be6366191 ]

As Chris and Vasily reported, the attempt to support multiple AXP PMICs
in one system [1] breaks some of the battery and charging functionality
on devices with AXP PMICs. The reason is that the drivers now fail to get
the correct IIO channel for the ADC component, as the current code seems
to rely on the zero-based enumeration of the regulator devices.
A fix is possible, but not trivial, as it requires some rework in the AXP
MFD driver, which cannot be fully reviewed or tested in time for the
6.13 release.

So revert this patch for now, to avoid regressions on battery powered
devices. This patch was really only necessary for devices with two
PMICs, support for which is not mainline yet anyway, so we don't lose
any functionality.

This reverts commit e37ec32188701efa01455b9be42a392adab06ce4.

[1] https://lore.kernel.org/linux-sunxi/20241007001408.27249-4-andre.przywara@arm.com/

Reported-by: Chris Morgan <macroalpha82@gmail.com>
Closes: https://lore.kernel.org/linux-sunxi/675489c1.050a0220.8d73f.6e90@mx.google.com/
Reported-by: Vasily Khoruzhick <anarsoul@gmail.com>
Closes: https://lore.kernel.org/linux-sunxi/CA+E=qVf8_9gn0y=mcdKXvj2PFoHT2eF+JN=CmtTNdRGaSnpgKg@mail.gmail.com/
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20250108164359.2609078-1-andre.przywara@arm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index 251465a656d09..bce85a58944ac 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1445,7 +1445,7 @@ int axp20x_device_probe(struct axp20x_dev *axp20x)
 		}
 	}
 
-	ret = mfd_add_devices(axp20x->dev, PLATFORM_DEVID_AUTO, axp20x->cells,
+	ret = mfd_add_devices(axp20x->dev, PLATFORM_DEVID_NONE, axp20x->cells,
 			      axp20x->nr_cells, NULL, 0, NULL);
 
 	if (ret) {
-- 
2.39.5



