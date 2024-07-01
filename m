Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26260C8C7;
	Mon,  1 Jul 2024 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719860837; cv=none; b=Zcxpwyo5YKv1ChTXI0KNOo6c3yyo69NHDwGMPMDVrDIBVfyX7s5ddnRQj9W2zDi8oLQR8BhqxKIkgi0J2s+UyxS4cLRlOXEZlbEpv0ncwnPk0qtK/kNRs0UZZ5dbpxDzxeAJ3jCmLl+zOvI4+jjbH+I605uzsBegAWGsZ/o2Iw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719860837; c=relaxed/simple;
	bh=MOxxmRlmg/SZh0P5F1EfQwqNwAEyA+LTm2j/JaqyIPA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OnM4foEmSS0gwP0v76da+HZEFKfLza6nE74HfNt+rOsqI5PRwRt7riP4KIK0PD+brVhXEKb+gWulK9wHaqV/4hgFJxAaXRWzLhGmM19cgnls+YzIscm49sivOpETmF8fyrJxoDAtjf01rwOrSkAfdGtuskVfiiTkoKswDtQgrKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rChvuHha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rChvuHha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDC4C116B1;
	Mon,  1 Jul 2024 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719860837;
	bh=MOxxmRlmg/SZh0P5F1EfQwqNwAEyA+LTm2j/JaqyIPA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=rChvuHhaHG3NIc3ImXLO/wxd7Tmuj2m0n2q/Jqx8hJxthew4FGw4jDS8hLlESPcSS
	 +1G5A5hWFyqpSmWEWRWleCItygEbW8UgkNELU6EE+OhPFwb5kumXnJqWwJ2OYIlIOS
	 Kh8wLkBklQCNh+drgAUqCAKIKJkxd2OQb7c5hsVJHxC4RybggVFRlZlUEnY0HiWvl0
	 bCbOB7OmA6PnMU9LAuOCFUutGVKKgzMQO3CV6v2t9OPMV9MYWCw5hkqs1vr9HpvUKM
	 /O+vmbUh53T8KIuvZ/pgKltLWc3l+NBD4mS1owDGl7VOgFkSNfokJmRaSlUNX7IIT8
	 aVp0s4pTNqAlQ==
From: Mark Brown <broonie@kernel.org>
To: "J.M.B. Downing" <jonathan.downing@nautel.com>, 
 Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>, 
 Nathan Chancellor <nathan@kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>, Liam Girdwood <lgirdwood@gmail.com>, 
 alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org, 
 linux-sound@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
In-Reply-To: <20240701-lpc32xx-asoc-fix-uninitialized-ret-v1-1-985d86189739@kernel.org>
References: <20240701-lpc32xx-asoc-fix-uninitialized-ret-v1-1-985d86189739@kernel.org>
Subject: Re: [PATCH] ASoC: fsl: lpc3xxx-i2s: Avoid using ret uninitialized
 in lpc32xx_i2s_probe()
Message-Id: <171986083478.121161.16800838408013522320.b4-ty@kernel.org>
Date: Mon, 01 Jul 2024 20:07:14 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14-dev-d4707

On Mon, 01 Jul 2024 09:24:16 -0700, Nathan Chancellor wrote:
> clang points out that ret may be used uninitialized in
> lpc32xx_i2s_probe() in an error pointer path (which becomes fatal with
> CONFIG_WERROR):
> 
>   sound/soc/fsl/lpc3xxx-i2s.c:326:47: error: variable 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
>     326 |                                      "failed to init register map: %d\n", ret);
>         |                                                                           ^~~
>   sound/soc/fsl/lpc3xxx-i2s.c:310:9: note: initialize the variable 'ret' to silence this warning
>     310 |         int ret;
>         |                ^
>         |                 = 0
>   1 error generated.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: fsl: lpc3xxx-i2s: Avoid using ret uninitialized in lpc32xx_i2s_probe()
      commit: f4662e6d51ffc0826f975429d3c1b6d1f1a295f1

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

