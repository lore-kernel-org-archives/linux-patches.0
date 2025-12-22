Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C43842AA6;
	Mon, 22 Dec 2025 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766425847; cv=none; b=Iqs01rNAoU21L/2P6UtYHupk4nGoplRZt89HxAqYkXYn9kuHdVNrwp2Mcxyto/1hc4nFr7nEyV6LL8jVNheybzF7Kh3sK6X0xxWnoV6745Y73VhmdGKoj4jI62AUq338Kf1Z3GjnoLmE96c+XTzGUsByVu8xpugLFo0zTnmjz+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766425847; c=relaxed/simple;
	bh=TaE4TgIrr4He9lFdeyYoAqLDs3cuOBInUm1iz8AuHgQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=r+6fhfqDrAX/UziK+yUMLUddEikZM5G8p3NhO5rKmtFZqncn4Ev/sPB+muEHF49CLKObN9EgWFi9p8ZPDgjOszjcJaKFYgnVsDFgWp98iw9/oHKGMWLT9gsMr03kIn38Rj/1THbUCtLqHzzHiaD5dsQ71e/l67AoKSa0XiY43AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjNACTyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjNACTyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63048C4CEF1;
	Mon, 22 Dec 2025 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766425845;
	bh=TaE4TgIrr4He9lFdeyYoAqLDs3cuOBInUm1iz8AuHgQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=VjNACTyMyohwQlbQ254N+Z7xQo8HRRIUuPkRFlfpn0M6nXxT0bo4g3H/8zr4wSvZZ
	 zu1G/xK9i+7AXh0p7m8Pmxj3fXBF+meCYzyLZcIaCkAVAlpk2dHusv/KnUpBgQzP8W
	 SUuhLR+OsXQOd0r7phDaXFlpmcmamJ0lFn09vE8CmC/4Mw15aKHi6LeUIfc5i3Shnt
	 tTkEafo9p3JTszuVs8pn0kYPen5uYZ/k3wQl0Hkta+ndFhBOCcMHUvfVJAPCpqCZSC
	 TmjBa54r7qAS9w+T6sUby7e+GWwBkhdih576dhYUWmOZks98DkRI9WexgeF5FSEcTS
	 ilkaaxRLoedUQ==
From: Mark Brown <broonie@kernel.org>
To: Shuming Fan <shumingf@realtek.com>, Oder Chiou <oder_chiou@realtek.com>, 
 Liam Girdwood <lgirdwood@gmail.com>, Nathan Chancellor <nathan@kernel.org>
Cc: linux-sound@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>
In-Reply-To: <20251219-rt1320-sdw-avoid-uninit-ret-v1-1-faa3e250ebc4@kernel.org>
References: <20251219-rt1320-sdw-avoid-uninit-ret-v1-1-faa3e250ebc4@kernel.org>
Subject: Re: [PATCH] ASoC: rt1320: Change return type of rt1320_t0_load()
 to void
Message-Id: <176642584412.925274.11167480957596799795.b4-ty@kernel.org>
Date: Mon, 22 Dec 2025 17:50:44 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773

On Fri, 19 Dec 2025 16:08:08 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   sound/soc/codecs/rt1320-sdw.c:1387:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>    1387 |         if (!fw_ready) {
>         |             ^~~~~~~~~
>   sound/soc/codecs/rt1320-sdw.c:1421:9: note: uninitialized use occurs here
>    1421 |         return ret;
>         |                ^~~
>   sound/soc/codecs/rt1320-sdw.c:1387:2: note: remove the 'if' if its condition is always false
>    1387 |         if (!fw_ready) {
>         |         ^~~~~~~~~~~~~~~~
>    1388 |                 dev_warn(dev, "%s, DSP FW is NOT ready\n", __func__);
>         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1389 |                 goto _exit_;
>         |                 ~~~~~~~~~~~~
>    1390 |         }
>         |         ~
>   sound/soc/codecs/rt1320-sdw.c:1366:9: note: initialize the variable 'ret' to silence this warning
>    1366 |         int ret;
>         |                ^
>         |                 = 0
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: rt1320: Change return type of rt1320_t0_load() to void
      commit: 9e692bb5412a7b0e6534ba2d7158a57ed4b00658

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

