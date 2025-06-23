Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049EE4315A;
	Mon, 23 Jun 2025 21:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714973; cv=none; b=aAT1ZxHEWbY5orj30hwNjU7AdEK3JHD7fC7cEHFwDjff/cJi4+5VnT9NkOGrPAUGTPLib4ibkfWFl5ASt+8j90xq6/6LpW/DWpFghJRaG8MIKOCcoNXt2OezA+7LZIAQJ7GrA+S+uLlNJA0+Hsdo5GzGkXJyMWcDe/RuknxEt1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714973; c=relaxed/simple;
	bh=JI78QqjXedzoG9JnwkMxbXGzDuwKp28r47X6n/HqPEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utENBrE09COo2GEwQzNa2lSSSR0hvvmpk7PqGqAyNGKULNA8Sc5kgs1HQv3GtASe9U3M55YY176L1viQluuAFwaJQviIyy60ttrSrXkNf8THjNkcMrVtBLbWKp2o8+1z5NWeV7ht2ytBNw31L0bw7hFQ5aAIijLjDsIraIBlfIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9DAh4rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9DAh4rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907C8C4CEEA;
	Mon, 23 Jun 2025 21:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714972;
	bh=JI78QqjXedzoG9JnwkMxbXGzDuwKp28r47X6n/HqPEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9DAh4rb3mjTy+kNWZ7I9DBi0Rts9h2pDKg+R2VgH/a8l9Xpitb5HVnmRfiO9COEc
	 BYP6gJHDTi8ALKjcqh5NnqyGlgIXYxytdcYEnvWy7SSGJagUVNZ+KncImEDur+eQt+
	 rUMPIfXMkVHE7/PRKyYD+SQIh+MuMWvE6203QTmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 429/592] i3c: mipi-i3c-hci: Fix handling status of i3c_hci_irq_handler()
Date: Mon, 23 Jun 2025 15:06:27 +0200
Message-ID: <20250623130710.640055028@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 279c24021b838e76ca8441e9446e0ab45271153a ]

Return IRQ_HANDLED from the i3c_hci_irq_handler() only if some
INTR_STATUS bit was set or if DMA/PIO handler handled it.

Currently it returns IRQ_HANDLED in case INTR_STATUS is zero and IO
handler returns false. Which could be the case if interrupt comes from
other device or is spurious.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20250409140401.299251-2-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index a71226d7ca593..5834bf8a3fd9e 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -594,6 +594,7 @@ static irqreturn_t i3c_hci_irq_handler(int irq, void *dev_id)
 
 	if (val) {
 		reg_write(INTR_STATUS, val);
+		result = IRQ_HANDLED;
 	}
 
 	if (val & INTR_HC_RESET_CANCEL) {
@@ -605,12 +606,11 @@ static irqreturn_t i3c_hci_irq_handler(int irq, void *dev_id)
 		val &= ~INTR_HC_INTERNAL_ERR;
 	}
 
-	hci->io->irq_handler(hci);
+	if (hci->io->irq_handler(hci))
+		result = IRQ_HANDLED;
 
 	if (val)
 		dev_err(&hci->master.dev, "unexpected INTR_STATUS %#x\n", val);
-	else
-		result = IRQ_HANDLED;
 
 	return result;
 }
-- 
2.39.5



