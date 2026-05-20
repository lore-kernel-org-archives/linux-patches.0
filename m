Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664883EFD3D;
	Wed, 20 May 2026 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298744; cv=none; b=B3qTmXFtxHIfJnNjpxmZP+LZeEUpYhz2V0N7/NrZlRd75q9Kn/tiiB/g6FvQc/mOFHZRjnYRiehwjOSbM7CYeAJDD0SjlYqoCaxOWDeKRlu/0epk2g6B+WEbjaFMJ4DubtGAQa7C3rWjO/lHWk2Iovt9Uvvsu6nu3g381sH1tLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298744; c=relaxed/simple;
	bh=JmbxJAdyi35ytRNidajJ+OB8xE6QV+6beZiI55CEOqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzm6sSUrFd+P721+3402DAZ0AyE4umeHIjVVfLjU7g19EkaUQY4SG6a1a+PcHTSGVQVZZ6MUyXXhSKFxMoTxGAa1XD9F4vWWsIrJQrBTxTQBRZGZFKcaBZuHZvglp4CtzWoMseRsDyUnHUOwWzFjhi71chiP7Nz08zriayJLYjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM3PZzfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM3PZzfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5CC1F000E9;
	Wed, 20 May 2026 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298743;
	bh=3hz0EsOurOHVW0yP/L7hGmfwP37TuEGPrqlLWIrkSJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CM3PZzfTgUDw6tynRdMTyTdsNPVZPByjY+yumJAuRHD46WQuajl8ifF1O2njlcnH4
	 thvWNWhtf8b+CgEkdF1oz9Iuk6ogKI03f8fZmKGPvdxlVGyXcFceubmreF/amHTjVg
	 7X6h+lsAJRJaQODoqQVVvUZPkmWTWA2cVqFb3OMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 525/957] i3c: dw: Fix memory leak in dw_i3c_master_i3c_xfers()
Date: Wed, 20 May 2026 18:16:48 +0200
Message-ID: <20260520162145.919518972@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 256cc1f1305a8e5dcadf8ca208d04a3acadd26f1 ]

The dw_i3c_master_i3c_xfers() function allocates memory for the xfer
structure using dw_i3c_master_alloc_xfer(). If pm_runtime_resume_and_get()
fails, the function returns without freeing the allocated xfer, resulting
in a memory leak.

Since dw_i3c_master_free_xfer() is a thin wrapper around kfree(), use
the __free(kfree) cleanup attribute to handle the free automatically on
all exit paths.

Fixes: 62fe9d06f570 ("i3c: dw: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260404-dw-i3c-2-v3-1-8f7d146549c1@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index c6cfcacb18106..585f320119741 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/err.h>
@@ -905,7 +906,6 @@ static int dw_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct dw_i3c_master *master = to_dw_i3c_master(m);
 	unsigned int nrxwords = 0, ntxwords = 0;
-	struct dw_i3c_xfer *xfer;
 	int i, ret = 0;
 
 	if (!i3c_nxfers)
@@ -925,7 +925,7 @@ static int dw_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 	    nrxwords > master->caps.datafifodepth)
 		return -EOPNOTSUPP;
 
-	xfer = dw_i3c_master_alloc_xfer(master, i3c_nxfers);
+	struct dw_i3c_xfer *xfer __free(kfree) = dw_i3c_master_alloc_xfer(master, i3c_nxfers);
 	if (!xfer)
 		return -ENOMEM;
 
@@ -976,7 +976,6 @@ static int dw_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 	}
 
 	ret = xfer->ret;
-	dw_i3c_master_free_xfer(xfer);
 
 	pm_runtime_put_autosuspend(master->dev);
 	return ret;
-- 
2.53.0



