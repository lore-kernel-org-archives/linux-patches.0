Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94692877F1;
	Tue, 22 Jul 2025 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192587; cv=none; b=n447m/fs8WjV3LWOhwSN5WBPpROu+8saD+C7UNAJkrtpfAzkkmPH937z5LtqOCNq7jDx8n6oRwx2a9mYkboP7LLYIfLOnGa53ZUEPiE/3X44hVPeIn6WCpCApLFS2J+PY5HzHVUpuQX8oFvOk1m9D898LTeTC7VM6lygnpWsWbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192587; c=relaxed/simple;
	bh=b5e3RDXMxqWfI3RhIzmb3019sSVALe5g2hu8Y3v7kIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEdiLwn4/+xDyscCWnKXIHJnSXOimCN85plFpSvPajGLxVcA//Kh7eFK5ofSjvBrEMahnWeIXxS5Xjf7QNuXA60FzllbsAQfqfTTBiUQF235eHjFmBMEJEPr9rWMVkG3uZVnlLztsumOB3UJ3842EjSq7WGG+UdOaJodUxNYftw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5f8gA18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5f8gA18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F981C4CEEB;
	Tue, 22 Jul 2025 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192587;
	bh=b5e3RDXMxqWfI3RhIzmb3019sSVALe5g2hu8Y3v7kIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5f8gA18z98w1f09Q3KdGpooHSS+deNX0Sa9vR2eKkClJU3uMCO2P5SR1qnNXQPP/
	 RGnWHwa6N1xmoUc6KxKDDEwyxgJndKBKAQriuBu1iCHs2Y2OYNpC8fKe4c3OMn4LL6
	 zkUQGNvSDPdF4yPTIKTVdvfzVgrDbXVcaRoavdrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/111] i2c: omap: Fix an error handling path in omap_i2c_probe()
Date: Tue, 22 Jul 2025 15:45:18 +0200
Message-ID: <20250722134337.250359816@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: a9503a2ecd95 ("i2c: omap: Handle omap_i2c_init() errors in omap_i2c_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1464,13 +1464,13 @@ omap_i2c_probe(struct platform_device *p
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
 
@@ -1518,6 +1518,9 @@ omap_i2c_probe(struct platform_device *p
 
 err_unuse_clocks:
 	omap_i2c_write_reg(omap, OMAP_I2C_CON_REG, 0);
+	if (omap->mux_state)
+		mux_state_deselect(omap->mux_state);
+err_put_pm:
 	pm_runtime_dont_use_autosuspend(omap->dev);
 	pm_runtime_put_sync(omap->dev);
 err_disable_pm:


