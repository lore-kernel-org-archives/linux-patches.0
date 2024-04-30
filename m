Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1163B12C476;
	Tue, 30 Apr 2024 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474745; cv=none; b=Qzx48UAs9EaJxStv1KpUZwAfN+jvLbXaB8S4/Bw5K0PO2xarktDxn67RIxkiqs/gv/dgAJdSKZ3ltpdcHdVOh+y2hG3yVVtot4sBNPNhEQaQv8Ub4EiF/mSOyUGwWNMvFlEHmo6qXXasPofwkx2WRICeeXvVfDm14ZA6z05Js6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474745; c=relaxed/simple;
	bh=06phHfyLc1xEoQ4L2Gcf/Otiwq8fl8RlQZcXpPLPWiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvC/d9D0adQpDZfxXmXVAs9zsQPZc1RAZkr9Aw1Td8rkij/AgMCc9yzD8R0grcv2qWurjn+Ta0wrOFDcDU35ERPbTcL/VEg6f2PUnpdw3HGXSoVlstYNVFkgVOD6zgRy1771+KGnRF4Q8LylkvdLXfqlpuVgz1YDm66vIbe/RvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiydRy7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiydRy7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775CFC4AF19;
	Tue, 30 Apr 2024 10:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474744;
	bh=06phHfyLc1xEoQ4L2Gcf/Otiwq8fl8RlQZcXpPLPWiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiydRy7WgFbf6FsW/iZgN/idfDxPash0SJ85fg0BHK/7jM9LB5sKvpttRU0T3h0RV
	 XpMOUWediyJNDExtsQ51YI2nu9+JIdwkCM92j9j2So+nqsBcMnOl4B0/F8K//a5Cf7
	 9j17EFaZdVY3j8tX0C3VhBHY2ZhktcRdgwzveAnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daisuke Mizobuchi <mizo@atmark-techno.com>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 5.10 022/138] mailbox: imx: fix suspend failue
Date: Tue, 30 Apr 2024 12:38:27 +0200
Message-ID: <20240430103050.080946563@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daisuke Mizobuchi <mizo@atmark-techno.com>

imx_mu_isr() always calls pm_system_wakeup() even when it should not,
making the system unable to enter sleep.

Suspend fails as follows:
 armadillo:~# echo mem > /sys/power/state
 [ 2614.602432] PM: suspend entry (deep)
 [ 2614.610640] Filesystems sync: 0.004 seconds
 [ 2614.618016] Freezing user space processes ... (elapsed 0.001 seconds) done.
 [ 2614.626555] OOM killer disabled.
 [ 2614.629792] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
 [ 2614.638456] printk: Suspending console(s) (use no_console_suspend to debug)
 [ 2614.649504] PM: Some devices failed to suspend, or early wake event detected
 [ 2614.730103] PM: resume devices took 0.080 seconds
 [ 2614.741924] OOM killer enabled.
 [ 2614.745073] Restarting tasks ... done.
 [ 2614.754532] PM: suspend exit
 ash: write error: Resource busy
 armadillo:~#

Upstream commit 892cb524ae8a is correct, so this seems to be a
mistake during cherry-pick.

Cc: <stable@vger.kernel.org>
Fixes: a16f5ae8ade1 ("mailbox: imx: fix wakeup failure from freeze mode")
Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Reviewed-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/imx-mailbox.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -331,8 +331,6 @@ static int imx_mu_startup(struct mbox_ch
 		break;
 	}
 
-	priv->suspend = true;
-
 	return 0;
 }
 
@@ -550,8 +548,6 @@ static int imx_mu_probe(struct platform_
 
 	clk_disable_unprepare(priv->clk);
 
-	priv->suspend = false;
-
 	return 0;
 
 disable_runtime_pm:
@@ -614,6 +610,8 @@ static int __maybe_unused imx_mu_suspend
 	if (!priv->clk)
 		priv->xcr = imx_mu_read(priv, priv->dcfg->xCR);
 
+	priv->suspend = true;
+
 	return 0;
 }
 
@@ -632,6 +630,8 @@ static int __maybe_unused imx_mu_resume_
 	if (!imx_mu_read(priv, priv->dcfg->xCR) && !priv->clk)
 		imx_mu_write(priv, priv->xcr, priv->dcfg->xCR);
 
+	priv->suspend = false;
+
 	return 0;
 }
 


