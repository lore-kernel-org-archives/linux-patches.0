Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA3A13A244;
	Tue, 27 May 2025 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364285; cv=none; b=uR6Dujn2I2vNamdVUZNvg2Kf8a9wbcXHk24hr8BmfvPJKOgecxlRyVBXm6BDe8lk9NkAxdZ7dcnZa7Ik4bwfwJNlzIpraX3XHhZsyD3vO4fmXvVXWnreT2y1aD1mbLetX1vdRe86NwsZZrXb1wDLUrCJr4sZjn6bthIgDfngI54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364285; c=relaxed/simple;
	bh=o7thB0WNPoy9p8QuXErqq2mkF31WsvfPFtPqqjoyZl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhsLg0QfK46vFBrBuGc2zzUItj0tcBsVxJYYoyM8eMZqhS4JjviJZxfNHeYGz1gcz0NgG6p4OYBG5Mek2DIt05qS4Fj0RTJ1jwdpJHIGVyKf5UTPDMeNEaYMaT7Q6oN1igicZoH4IiznBa6UKV1cbY5EYbJGnNasMyyb/KcPSEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHYxLyiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHYxLyiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136BBC4CEE9;
	Tue, 27 May 2025 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364285;
	bh=o7thB0WNPoy9p8QuXErqq2mkF31WsvfPFtPqqjoyZl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHYxLyiQajPaspLYfwg961TTPRvaIFJZ1CwFvwR+lMNKuxeIKBjSNdtTJE/ypAgon
	 tO5AJ0aZftDGoDjlISR11ypQcIYG2DTfJ/6VabjMz9w4AnZbZVjuzWDTc2Aoid9dBD
	 t+9x9sfqR8FSYQzG+CdJmuOo24PMgoJ5c4CDtjsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/626] i2c: designware: Fix an error handling path in i2c_dw_pci_probe()
Date: Tue, 27 May 2025 18:18:19 +0200
Message-ID: <20250527162445.310519037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1cfe51ef07ca3286581d612debfb0430eeccbb65 ]

If navi_amd_register_client() fails, the previous i2c_dw_probe() call
should be undone by a corresponding i2c_del_adapter() call, as already done
in the remove function.

Fixes: 17631e8ca2d3 ("i2c: designware: Add driver support for AMD NAVI GPU")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.13+
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/fcd9651835a32979df8802b2db9504c523a8ebbb.1747158983.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 433cb285d3b20..5ea6d40373e7e 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -278,9 +278,11 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 
 	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
 		dev->slave = i2c_new_ccgx_ucsi(&dev->adapter, dev->irq, &dgpu_node);
-		if (IS_ERR(dev->slave))
+		if (IS_ERR(dev->slave)) {
+			i2c_del_adapter(&dev->adapter);
 			return dev_err_probe(device, PTR_ERR(dev->slave),
 					     "register UCSI failed\n");
+		}
 	}
 
 	pm_runtime_set_autosuspend_delay(device, 1000);
-- 
2.39.5



