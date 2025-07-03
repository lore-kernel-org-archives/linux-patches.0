Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D042E339E;
	Thu,  3 Jul 2025 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554944; cv=none; b=tSVf4x3Mmmxzk0Q+qg2A/jIqbtwQ7cMt4+6D37FLogSo2RTn4byu9b8Fpezk8uBdPuAVzZu7d53BiYpm0TFHLteEC4WTwl/LCrqyi/27/v2675vqZyJuZFDJLHBuHZdZQI5/GpOtpaO7Aou2MQ8CXwXCczTa8KFOUiymSrBI6TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554944; c=relaxed/simple;
	bh=qyvQmIndpK4v5S+j1AvzgjbmdtIW83yFuAWXVkCVDF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ob34odDBP+hUW+fj+kURM4hrOat/Y4H6pI6ZcoNv6qykLNUNJWbBsM/M/Bh7Zxogevx3xdNMhlHbnq9WPMq/32QBFGXxUVkRoGH2lBX7mQm7m1KdVLo88Yd1x1TYak+ATtITMiIl/uaaAvKFcXVFI8gr1kTuk7CSFUSPItQMzrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPSa43dh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPSa43dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FAAC4CEE3;
	Thu,  3 Jul 2025 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554944;
	bh=qyvQmIndpK4v5S+j1AvzgjbmdtIW83yFuAWXVkCVDF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPSa43dhQtvN1FFLCv8jtdBhOm+bZE6lRW5tzBrACjJ/w2oNJfjFPxkZRcDFa23P9
	 jYJCCFbMFZCrT1CDKHKnH5ri0beQbUBArQ+9Wt6dudt6bIsAx5bDIdLpoVLRUP3AVZ
	 q8QuNn5/v0UIjqIk27Nx4CNlYrb4Nco/Ed0cFbBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 097/263] i2c: omap: Fix an error handling path in omap_i2c_probe()
Date: Thu,  3 Jul 2025 16:40:17 +0200
Message-ID: <20250703144008.189959412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 666c23af755dccca8c25b5d5200ca28153c69a05 upstream.

If an error occurs after calling mux_state_select(), mux_state_deselect()
should be called as already done in the remove function.

Fixes: b6ef830c60b6 ("i2c: omap: Add support for setting mux")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/998542981b6d2435c057dd8b9fe71743927babab.1749913149.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index f1cc26ac5b80..8b01df3cc8e9 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1461,13 +1461,13 @@ omap_i2c_probe(struct platform_device *pdev)
 		if (IS_ERR(mux_state)) {
 			r = PTR_ERR(mux_state);
 			dev_dbg(&pdev->dev, "failed to get I2C mux: %d\n", r);
-			goto err_disable_pm;
+			goto err_put_pm;
 		}
 		omap->mux_state = mux_state;
 		r = mux_state_select(omap->mux_state);
 		if (r) {
 			dev_err(&pdev->dev, "failed to select I2C mux: %d\n", r);
-			goto err_disable_pm;
+			goto err_put_pm;
 		}
 	}
 
@@ -1515,6 +1515,9 @@ omap_i2c_probe(struct platform_device *pdev)
 
 err_unuse_clocks:
 	omap_i2c_write_reg(omap, OMAP_I2C_CON_REG, 0);
+	if (omap->mux_state)
+		mux_state_deselect(omap->mux_state);
+err_put_pm:
 	pm_runtime_dont_use_autosuspend(omap->dev);
 	pm_runtime_put_sync(omap->dev);
 err_disable_pm:
-- 
2.50.0



