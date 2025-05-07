Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E28211283;
	Wed,  7 May 2025 18:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643782; cv=none; b=M9JZiwftdPzbUQaulsdlJIu2gzk2tLcb0AOpaekK/nGnwMQqJ8obOV5fpmwHUv1oLcnXkFdROiTg+5pZgaZgCWCeVjPOMOily15PeLXdIJBdHaowgsUGA7ii6TZLyFJrmTlQmuU6loWMd6S176jjIIWutcVY5rD06I9m6oSFO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643782; c=relaxed/simple;
	bh=wK1/e/2CFsZ5npQsEbUK9bvLekc+x8K9ZmeG2YNs9k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0XAigwLyrq7spbwr9be8McOHfVtP9kMgIwtyaBC/zNHlA3cvsIwJ4AICssgqnyGTksH+Klzdl+0CZKiq/ari06FRXV9OvY6ULpXKXqbHGUY3+/V7OwU60zoRMQ4bpkBS8J00zLtNaLMgOXa16Vet1a+IjxriHcDByJNLCAsjRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjMrnfwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjMrnfwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714B3C4CEE2;
	Wed,  7 May 2025 18:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643781;
	bh=wK1/e/2CFsZ5npQsEbUK9bvLekc+x8K9ZmeG2YNs9k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjMrnfwl8/+dcGt2zltTLrb4W8jlWw9Vw2hl8hUdYMV6bBJHjEq0E8nNopYjBH9DB
	 HkjzaOKgLnZmNV1hBhwD+y4sGw+x5GZWjLcLtVA6SgNztGYRt92YvoWvff58HSC7DE
	 X2Rsis8sWICPIYLcSZbINGt5kbWCQQ2NRj/1Kauk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 005/183] ASoC: renesas: rz-ssi: Use NOIRQ_SYSTEM_SLEEP_PM_OPS()
Date: Wed,  7 May 2025 20:37:30 +0200
Message-ID: <20250507183824.905799492@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit c1b0f5183a4488b6b7790f834ce3a786725b3583 upstream.

In the latest kernel versions system crashes were noticed occasionally
during suspend/resume. This occurs because the RZ SSI suspend trigger
(called from snd_soc_suspend()) is executed after rz_ssi_pm_ops->suspend()
and it accesses IP registers. After the rz_ssi_pm_ops->suspend() is
executed the IP clocks are disabled and its reset line is asserted.

Since snd_soc_suspend() is invoked through snd_soc_pm_ops->suspend(),
snd_soc_pm_ops is associated with soc_driver (defined in
sound/soc/soc-core.c), and there is no parent-child relationship between
soc_driver and rz_ssi_driver the power management subsystem does not
enforce a specific suspend/resume order between the RZ SSI platform driver
and soc_driver.

To ensure that the suspend/resume function of rz-ssi is executed after
snd_soc_suspend(), use NOIRQ_SYSTEM_SLEEP_PM_OPS().

Fixes: 1fc778f7c833 ("ASoC: renesas: rz-ssi: Add suspend to RAM support")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20250410141525.4126502-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/renesas/rz-ssi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/renesas/rz-ssi.c
+++ b/sound/soc/renesas/rz-ssi.c
@@ -1244,7 +1244,7 @@ static int rz_ssi_runtime_resume(struct
 
 static const struct dev_pm_ops rz_ssi_pm_ops = {
 	RUNTIME_PM_OPS(rz_ssi_runtime_suspend, rz_ssi_runtime_resume, NULL)
-	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 static struct platform_driver rz_ssi_driver = {


