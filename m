Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A224505;
	Wed,  9 Aug 2023 19:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465ECC433C8;
	Wed,  9 Aug 2023 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691607735;
	bh=DLaLQ4nsUMcnLJe2hdcXxiDEkHoG+vblKTViNjeTKig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WsbhmUVDxxUU5AKtdMD+ld8irEp2+G7gGwMG+Jm/l7wEg5dHrvhMEq15+Llc/EpZ1
	 p4D062pr/7mTSZCfmNcTjTZ+yUEheVFNafMCMV858mlMKUA2uuJfeA7EX2R3TpIIul
	 vyMSJ5DHoN8DfD/jGXZQEZ4KcEa2lfkrEtWrE/GH2o1QxCa9I2MzMJKtInJQ/ecSY2
	 dDfbHj8dsaRTvTcYtYmc39Laz9Ka63tuAB1cQA4PvmsmoP4Pu60Xz+/OGRzOB5pd3a
	 GIce1u/nAXFqQkEBqomqIdqjvuPZCm65jnPGbyN44kacqajdoMQJCBkNC2zUGn8C4t
	 Sq0SoEWPCVuqA==
Date: Wed, 9 Aug 2023 12:02:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
	daniel.baluta@nxp.com, kai.vehmanen@linux.intel.com,
	ndesaulniers@google.com, trix@redhat.com, rander.wang@intel.com,
	sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] ASoC: SOF: Intel: Initialize chip in
 hda_sdw_check_wakeen_irq()
Message-ID: <20230809190212.GB3355565@dev-arch.thelio-3990X>
References: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
 <8eed2099-2853-df8d-92db-921d0702f512@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eed2099-2853-df8d-92db-921d0702f512@linux.intel.com>

On Wed, Aug 09, 2023 at 01:41:18PM -0500, Pierre-Louis Bossart wrote:
> 
> 
> On 8/9/23 13:12, Nathan Chancellor wrote:
> > Clang warns (or errors with CONFIG_WERROR):
> > 
> >   sound/soc/sof/intel/hda.c:423:6: error: variable 'chip' is uninitialized when used here [-Werror,-Wuninitialized]
> >     423 |         if (chip && chip->check_sdw_wakeen_irq)
> >         |             ^~~~
> >   sound/soc/sof/intel/hda.c:418:39: note: initialize the variable 'chip' to silence this warning
> >     418 |         const struct sof_intel_dsp_desc *chip;
> >         |                                              ^
> >         |                                               = NULL
> >   1 error generated.
> > 
> > Add the missing initialization, following the pattern of the other irq
> > functions.
> > 
> > Fixes: 9362ab78f175 ("ASoC: SOF: Intel: add abstraction for SoundWire wake-ups")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Indeed, thanks Nathan for flagging this obvious mistake. I must have
> done something wrong when extracting the patches.
> 
> Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Thanks for the quick response!

> That said, we DO compile with clang and there was no warning
> https://github.com/thesofproject/linux/actions/runs/5542372669/job/15010818307
> 
> Is this dependent on a specific version of clang? I'd like to make sure
> our tools and tests are updated.

It should not be, I can reproduce it with all the versions of clang that
the kernel supports (11.x+).

Looking at your GitHub Actions files, I am not sure exporting CC works
correctly so I don't think you are building with clang. If I do it
locally:

$ export CC=clang

$ make -j$(nproc) defconfig

$ grep -E 'CONFIG_(CC_IS|CLANG|GCC)' .config
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=130201
CONFIG_CLANG_VERSION=0
CONFIG_GCC11_NO_ARRAY_BOUNDS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set

$ make -j$(nproc) sound/soc/sof/intel/hda.o

$ head -1 sound/soc/sof/intel/.hda.o.cmd
savedcmd_sound/soc/sof/intel/hda.o := gcc ...

This was brought up some time ago and Masahiro made a decent point that
this might not be a desirable behavior change.

https://lore.kernel.org/CAK7LNAT6Yp3oemUxSst+htnmM-St8WmSv+UZ2x2XF23cw-kU-Q@mail.gmail.com/

Switching to passing CC via the actual make command should fix that.

Cheers,
Nathan
