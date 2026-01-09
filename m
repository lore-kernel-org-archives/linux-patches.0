Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6359832BF21;
	Fri,  9 Jan 2026 11:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959587; cv=none; b=T/dvHELSY2QPsUb/IseQfHGXMXxNmjyLj2hde5S8dpBTx/kawKd0lBK2ttYsOcUXVP83gwqoUa349g8Q8YsyGxaHVOaXbqkfVVxF97yOBI4otAoIVI9f7iFuVN9d6xcwRkH6ZQCGpnrO3e/77NFHTWX5iXPxPN6D10780u32qu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959587; c=relaxed/simple;
	bh=5BhlmDvlfXuhjuCLgMbEmzab3orp0qHTpsCv4dbYlQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmEFEY81fBr4daezWbuW+nvBFrvJVegu2sLiCNMeRNxpixvmwKI/lXxb9W5WumwMs4duiiOWjMY/+EQquwll1iJiwnqisbW0Q6OzMP1cJ71N9COHBz33vrWF1nKitq8jATU5CiFfBhc7CjugVPS5BjW2Xu2Vlh1V53JVet0rp04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGS32zwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGS32zwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A24C4CEF1;
	Fri,  9 Jan 2026 11:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959587;
	bh=5BhlmDvlfXuhjuCLgMbEmzab3orp0qHTpsCv4dbYlQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGS32zwYpk6r7dLHmaxkpH8ddcJbVYb0WaeMbYXEu3l1VPhsr7KUW/RUIOYToJAs5
	 UCaPPtBwkHKTO8tCju422jqkjCmpLW+BIVYUBf6twVutgAj7VctwMrvmCj0BlAh0Z8
	 SbvkGH76LUFWHTX8VqtSzZmZkXjCNEkLFoo5AbOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/737] i3c: master: Inherit DMA masks and parameters from parent device
Date: Fri,  9 Jan 2026 12:34:02 +0100
Message-ID: <20260109112137.876350323@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6995e767850b..29e591bcc0646 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2775,6 +2775,10 @@ int i3c_master_register(struct i3c_master_controller *master,
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



