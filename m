Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0818935B137;
	Fri,  9 Jan 2026 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961604; cv=none; b=gKCBeJKfYpGEzVebhVLjE75oosa9YouD+6hX5Gf8sYtg6VGKCKqBacEJcMYM4iUZy+9ktO0kTOics1ClScIwe66Gu9cp1bEB4p5kz7J5fDNDKU7Uzg2FTR4ExsiT/TjJEZg1yjJmxitV8bX29PUgUekjrVgvywgCe6dOg3tZylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961604; c=relaxed/simple;
	bh=T9W1z4cDZZp5CcHZVZ/HYr53s9VbcOyBF40Eg6ixyz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UM6tvrdNbTqxCrSN/P8j+5k5dA/zV+SoN0rzlNXG7CLlKmDaB2G/s8vRx1ZWO/kTLcDCQYZpQYYvZ7SJujqaygGLxVbUYS/zyOivEgopMonkrt7ASyxXpPr9WP99fuvCEbXyAnVuMj/yx88CDoo2uoXHTL3TvCrWUcplFNM04SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnEAJaRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnEAJaRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BFDC19421;
	Fri,  9 Jan 2026 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961603;
	bh=T9W1z4cDZZp5CcHZVZ/HYr53s9VbcOyBF40Eg6ixyz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnEAJaRgYcWtLTgw01Y3JRGSpsvkwnIAlY1ZtqaT8KDNP/v7wqipkz7oGsa88/yRP
	 XDlXCNKkIvZWcTPQvOoLfVaKWVqkwCnfyw3Nipi5OmPUaxaoJGTdsdGNUahIt4y1pu
	 4Od7yjVximl5YsonlOvgy7RrZioGbwC1posXWkGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/634] i3c: master: Inherit DMA masks and parameters from parent device
Date: Fri,  9 Jan 2026 12:35:51 +0100
Message-ID: <20260109112120.189492924@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 0c35691551387e060e6ae7a6652b4101270c73cf ]

Copy the DMA masks and parameters for an I3C master device from parent
device so that the master device has them set for the DMA buffer and
mapping API.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20230921055704.1087277-2-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 2f5cef08e737e..60a61e39e2bb7 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2770,6 +2770,10 @@ int i3c_master_register(struct i3c_master_controller *master,
 	device_initialize(&master->dev);
 	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
+	master->dev.dma_mask = parent->dma_mask;
+	master->dev.coherent_dma_mask = parent->coherent_dma_mask;
+	master->dev.dma_parms = parent->dma_parms;
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0



