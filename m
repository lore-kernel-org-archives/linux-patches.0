Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA07344044;
	Wed,  3 Dec 2025 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777500; cv=none; b=OX6zQ52AFLrE2MCjGYvzQJyPYPiUvmnHLxBlaDISr1fVXbq0BHNoS0trlQwYSKPzhRr2iaYixuCU/7jRzDNL4XIBJposEh3dL2GIZbkovpL9IcuR//fYK/8/B43AGMZpysaoOn1qDHv3UYYimsYMKKT66HHV+DYVlSnRZjVxgoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777500; c=relaxed/simple;
	bh=hpEwcPPDltj2Ar3qLuvGz5GhkNAQeuLMrNbGaW+MTEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E42Xbm3LJxHXZVaDI9ZF2eoa3h3Nh5uiPC06wlUUoxlcJXp7bnUJ1oHZd4sZO3IrWhtwD9i3nkcLEuEoUun2JE7QzX+fTqNOJc/gR5/XEkY3OTdWs7Ou+73XC0p2O1Pc3lbH39xICWUnn2R9xLDEleU+MUO/svfrxXziz91w3wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUj/Q6TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUj/Q6TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAD4C4CEF5;
	Wed,  3 Dec 2025 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777498;
	bh=hpEwcPPDltj2Ar3qLuvGz5GhkNAQeuLMrNbGaW+MTEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUj/Q6TJ1s0VMi06h0CFE66K7yurVjITUC1WedOx4m+1UUcXlAthkWaH02voa2ckg
	 JXa9sohy9NXTrSx2KShJXXsipJCvF/sPfbkmS6utcyI+fMjL2AEJ18lF55Z3u1ZiCp
	 Vw40fOWnJyuz52Kmggw8/Pjdv1AH+QRa1kAQ3LKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/392] soc: ti: pruss: dont use %pK through printk
Date: Wed,  3 Dec 2025 16:23:26 +0100
Message-ID: <20251203152416.174842571@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit a5039648f86424885aae37f03dc39bc9cb972ecb ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250811-restricted-pointers-soc-v2-1-7af7ed993546@linutronix.de
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/pruss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index b36779309e49b..84f992320c4d8 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -270,7 +270,7 @@ static int pruss_probe(struct platform_device *pdev)
 		pruss->mem_regions[i].pa = res.start;
 		pruss->mem_regions[i].size = resource_size(&res);
 
-		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %pK\n",
+		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %p\n",
 			mem_names[i], &pruss->mem_regions[i].pa,
 			pruss->mem_regions[i].size, pruss->mem_regions[i].va);
 	}
-- 
2.51.0



