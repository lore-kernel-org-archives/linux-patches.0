Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CC730CD85;
	Tue, 31 Mar 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977009; cv=none; b=BXuE8qGEkIc8d2PbEpff/Ff8s/8JlTmkG9ie6jTkHZh62eeqbQV5vyXatahd/ed3LdTXEpzLqyOnjFcuDUD8RwnkKv3HHl/yeOX46fZHrSkD9PO83skGKs0UasJiwvpBgrASfs9CnCZvT8WY/MCMwhx42Rt4CfX3CVdZDDwSrpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977009; c=relaxed/simple;
	bh=HaAGsflRlfdTPqoUTluNwi7sxB4ewK6ftcPqiq9gIQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0+MeeHSmF133pA++n0mEUKm6T6kNEi8nwWg4uDGKZDX6HSOn+ZkvnbXyA6j++hMknFrnCDosxrhDz+yM3Sp3MYGiR/AGSSPCAS7hZeZHfb01nxm86OoNOGkV+up3oWTO6Jr2kCxSuH8plv4PumouJvYSUjnHcCJuJJVApGSlgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCCWN+fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCCWN+fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28929C19423;
	Tue, 31 Mar 2026 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774977009;
	bh=HaAGsflRlfdTPqoUTluNwi7sxB4ewK6ftcPqiq9gIQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCCWN+fihtdn0N2EgDVKh6zN+MQK1Jl5DyEpBlbcCmaH3p/BIJWzP/Bm/Z7Ae5a9m
	 WsyApW12tth5iywTM+wf5h0DOM+fFIjoDl5Bf0h+gC+ak4FEH6ydJrfAF5LAQ1DDLU
	 pdI4nxfjKSdcPnUDTQ6Uppuf2qsfTrQwfE/74gUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 306/309] irqchip/renesas-rzv2h: Fix error path in rzv2h_icu_probe_common()
Date: Tue, 31 Mar 2026 18:23:29 +0200
Message-ID: <20260331161804.826235424@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 897cf98926429c8671a9009442883c2f62deae96 ]

Replace pm_runtime_put() with pm_runtime_put_sync() when
irq_domain_create_hierarchy() fails to ensure the device suspends
synchronously before devres cleanup disables runtime PM via
pm_runtime_disable().

Fixes: 5ec8cabc3b86 ("irqchip/renesas-rzv2h: Use devm_pm_runtime_enable()")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260323124917.41602-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzv2h.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzv2h.c b/drivers/irqchip/irq-renesas-rzv2h.c
index 3dab62ededec9..c9f9099a51294 100644
--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -569,7 +569,7 @@ static int rzv2h_icu_probe_common(struct platform_device *pdev, struct device_no
 	return 0;
 
 pm_put:
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
 
 	return ret;
 }
-- 
2.53.0



