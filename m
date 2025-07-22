Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606F02B9A5;
	Tue, 22 Jul 2025 14:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193172; cv=none; b=d4GtnAor96EjGSwD6KUmMq2mK2L99eElzwgPqQpgTZUE9pKgJ4c9c5SDu+WMC+7NqaaNxhnM8LN3bSCt49qk+n9M1JGhA2Ibl7diUnY8+wkA46LQvJmg7awgB91K16r2krQPlMX4p3rzOUwwk2Kz+6xPBTZi0Wt/s1uXpKU9dkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193172; c=relaxed/simple;
	bh=yO9RPKUSu5v6YGYA0t5n7BVvWhGGKY24Yw2qYc+LQ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biWVpRZZjKvGN7DyM+pnNt1jaFc+MzGH6hyIpFycZ3IYNeH9aP5qPNfZJoM7r3MF9Bqum2rRhiP293bz9zU7LfTE4fGrOmnhzqERUFzR3iAI4oGBqfeW628aq9ryV/5DcZEh2K0n2EunL17Lw2qv6k956zwRNjBgTQuhb7i4LQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJizhb4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJizhb4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E63C4CEEB;
	Tue, 22 Jul 2025 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193172;
	bh=yO9RPKUSu5v6YGYA0t5n7BVvWhGGKY24Yw2qYc+LQ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJizhb4MeGghtj+YyLRbm1SBsqomsPcX0nY/dKxdiBGAumWKQcEdzmDu+eCYgnJoO
	 293SpHcNG9A9SgPTiuvwdH2Tx3bCcpEtAsidLBfSs2ttSeTZb3W+f6TjJXyLS21cmV
	 oYpPi74Huw7d1hVZPwdg8qxq50M3wWimlFjL77lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 013/187] i2c: omap: Fix an error handling path in omap_i2c_probe()
Date: Tue, 22 Jul 2025 15:43:03 +0200
Message-ID: <20250722134346.254698201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

commit 60c016afccac7acb78a43b9c75480887ed3ce48e upstream.

If an error occurs after pm_runtime_use_autosuspend(), a corresponding
pm_runtime_dont_use_autosuspend() should be called.

In case of error in pm_runtime_resume_and_get(), it is not the case because
the error handling path is wrongly ordered.
Fix it.

Fixes: 780f62974125 ("i2c: omap: fix reference leak when pm_runtime_get_sync fails")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/af8a9b62996bebbaaa7c02986aa2a8325ef11596.1751701715.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1521,9 +1521,9 @@ err_mux_state_deselect:
 	if (omap->mux_state)
 		mux_state_deselect(omap->mux_state);
 err_put_pm:
-	pm_runtime_dont_use_autosuspend(omap->dev);
 	pm_runtime_put_sync(omap->dev);
 err_disable_pm:
+	pm_runtime_dont_use_autosuspend(omap->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return r;


