Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5511F5820;
	Sun, 18 May 2025 03:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747538614; cv=none; b=HaOrzRqFk04kYN7nhS3Sk4ktnM1o+Y8ds473gbIn6rM/d6MSJHvH+GCGOOOPdbFy3JqOAJUn/jf7KcSxirTZaT5os5+HfR1V68kRV1CpYT4v0mq8ZnDDzgKur7C32v37R969vRo/R+xm1/YmKCjNUeFNCn0qpdCTR8WNaqlnMQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747538614; c=relaxed/simple;
	bh=DRJTBn2N9UcoSq5qhAUtyiiO5e6DGtKWG56xu2Ig5X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSOpJF/2Te9u5r4fY0RdsPinsCg4ypzH/KQDR2S/HtGIVKHWEyuojTczMN831dRR1NEu8E4sS1yF6a4DFLwzAzezGHd73JsV4TjgcMMhTl9hgN7r11f5oIdCmlLgc92/j9oHTLIAxSZl6xjYt5Mv6CZ55jm5A0FzVbEpJTOUkjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oru3hPVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oru3hPVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B18C4CEEF;
	Sun, 18 May 2025 03:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747538613;
	bh=DRJTBn2N9UcoSq5qhAUtyiiO5e6DGtKWG56xu2Ig5X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oru3hPVVYEHiAIOsN6xEldBGsk8HKXGeYOhAB282doy0WL5pDMwGcf3NI4ySl/44u
	 pa6roBsjgi/eXs5YHCXZxf3VsV4earfrGXI+nE/F5vt/G0JgG+VaWZ9qf+JFYCrFhV
	 eKUMYQO/zoXMbRQiapv3mYJBPwp0cBGkIZI4JHnr+PREhnxSKUI3oH3RFXEECGxsuT
	 2gQDG2jX7FsnonX75dnlLCzgsQF26lOeP94/cTgsTmP8JouyroXASLzO89od89uAUo
	 UpkzaWhsyJ8M8m7dI6NYFxhqiK2Qe2qgmWnmORnTk3bJO947lBHBC1iNFx62JLGeke
	 1Q3v7S8S+4evQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 4/4] irqdomain: spmi: Switch to irq_domain_create_tree()
Date: Sat, 17 May 2025 20:23:29 -0700
Message-ID: <20250518032330.2959766-5-sboyd@kernel.org>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
In-Reply-To: <20250518032330.2959766-1-sboyd@kernel.org>
References: <20250518032330.2959766-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

irq_domain_add_tree() is going away as being obsolete now. Switch to
the preferred irq_domain_create_tree(). That differs in the first
parameter: It takes more generic struct fwnode_handle instead of struct
device_node. Therefore, of_fwnode_handle() is added around the
parameter.

Note some of the users can likely use dev->fwnode directly instead of
indirect of_fwnode_handle(dev->of_node). But dev->fwnode is not
guaranteed to be set for all, so this has to be investigated on case to
case basis (by people who can actually test with the HW).

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20250319092951.37667-37-jirislaby@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 5c058db21821..91581974ef84 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1737,7 +1737,7 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 
 	dev_dbg(&pdev->dev, "adding irq domain for bus %d\n", bus_index);
 
-	bus->domain = irq_domain_add_tree(node, &pmic_arb_irq_domain_ops, bus);
+	bus->domain = irq_domain_create_tree(of_fwnode_handle(node), &pmic_arb_irq_domain_ops, bus);
 	if (!bus->domain) {
 		dev_err(&pdev->dev, "unable to create irq_domain\n");
 		return -ENOMEM;
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

