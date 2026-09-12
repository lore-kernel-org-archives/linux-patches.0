Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F66F313E2B;
	Sat, 12 Sep 2026 10:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210493; cv=none; b=WCJZUjJvoz9/thRy2itSqhzZ9kaw8ZTmVvK1LfkZ1JEjIzSkzQVYHq5twztICDwnQiLEdzMcnlxbtSh/byJ8iBlnxRGdGQVxeJQzXOTRBh45kqmyvkCaoyR0OC7yPMqm+pu1Wa03Sfl+Si1BA1UDx6a8qf4wze5MjuEkh1sjs7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210493; c=relaxed/simple;
	bh=LpTG2NFfxcT/lpOLdAdDkRaehY9cEpWyIywvjKtujmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyCOaY6pnUzff7OJ5oqVNXcXU2O7RnygxlE3iqQa10Yiocli5xeK+NzRMGx/DLa8hD6WlyN8fpI7IlEIv4lN00mGUwZ3qe0upj2rcYEC91Ea3psLGiteh5Jp2YqqyrlpWbhf68Z1BCRZutTleip+bfswHAYBmAm6SB9tKUpptbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9VhE0Gm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9VhE0Gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519C81F000FF;
	Sat, 12 Sep 2026 10:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210492;
	bh=xTW3RrVs1c7l7Yq/wXFmYfiJlkB/Tk0dGNflUmEomxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9VhE0Gm71Ln9rhf7/38EKWhsi5pKWaoc49/WZ3NZjUUJO+Mg0z1x5oV9xu1oMo88
	 of6B3XWghxxMFi4DT8/Y+U9CbYwCL1D8VU0GZyrXO96kxyDxZ+2KeyOvwjSYxYNIqa
	 E9KELSr3TzO6zTAYjQF/UIg3EEmcT+T5aWe8FQoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1037/1518] iio: light: gp2ap002: re-enable irq if runtime suspend fails
Date: Sat, 12 Sep 2026 08:53:26 +0200
Message-ID: <20260912065646.909739131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

[ Upstream commit 5d89e7cbac40057f5241a0832a86ce0fe97e4818 ]

gp2ap002_runtime_suspend() disables the irq before writing OPMOD. If
the write fails, the callback returns an error with the irq still
disabled while the PM core marks the device active again.

re-enable the irq before returning the error so the irq state matches
the active state the PM core restores.

Fixes: 97d642e23037c ("iio: light: Add a driver for Sharp GP2AP002x00F")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index 3abe02942d127..bb17ef2a829b7 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -649,6 +649,7 @@ static int gp2ap002_runtime_suspend(struct device *dev)
 	/* Disable chip and IRQ, everything off */
 	ret = regmap_write(gp2ap002->map, GP2AP002_OPMOD, 0x00);
 	if (ret) {
+		enable_irq(gp2ap002->irq);
 		dev_err(gp2ap002->dev, "error setting up operation mode\n");
 		return ret;
 	}
-- 
2.53.0



