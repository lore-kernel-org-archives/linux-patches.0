Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AF124505;
	Wed,  9 Aug 2023 20:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3F8C433C7;
	Wed,  9 Aug 2023 20:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691611748;
	bh=g6rYgy+MPs3unR3QlJahG1JrUzUL0BpSkhQKnWPcIdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sm8ESXXBEE1sOdivUjr4ohxWdrxwfJyjliUAyV3ATjwPV/ayS88fq4alKDBYxkt5d
	 sIex/4I4P0AyCcueQVlwSHnkrxZjV19Ha86LMmltS1Z3lWmzV1sW51aPUQp124aHkD
	 2apFExEONxiJ6I3GLe0AHEIiByQewI2kRPytVDTPCvZtgtQYibhlX7wqAzNVSH6eJj
	 osk3LzzEYAECZGKNBu7JAa3pN55l+7BTWPKBNDI6wu3mv1joKPJ3QCiL/piCip7vNo
	 7fZSzfNZrqjcqzTVGxaIhQfrs3CXC/jvxSGie1I+tDdrtf/SAqvT7Konp5ZD3qQObe
	 TdsUotB6LgHKQ==
Date: Wed, 9 Aug 2023 13:09:06 -0700
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
Message-ID: <20230809200906.GA4016444@dev-arch.thelio-3990X>
References: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
 <8eed2099-2853-df8d-92db-921d0702f512@linux.intel.com>
 <20230809190212.GB3355565@dev-arch.thelio-3990X>
 <2a2de1b5-4dd5-f170-bb0b-61d39230c3a7@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a2de1b5-4dd5-f170-bb0b-61d39230c3a7@linux.intel.com>

On Wed, Aug 09, 2023 at 02:57:13PM -0500, Pierre-Louis Bossart wrote:
> > Looking at your GitHub Actions files, I am not sure exporting CC works
> > correctly so I don't think you are building with clang. If I do it
> 
> D'oh. I did not see this one coming... nice.
> 
> > locally:
> > 
> > $ export CC=clang
> > 
> > $ make -j$(nproc) defconfig
> > 
> > $ grep -E 'CONFIG_(CC_IS|CLANG|GCC)' .config
> > CONFIG_CC_IS_GCC=y
> > CONFIG_GCC_VERSION=130201
> > CONFIG_CLANG_VERSION=0
> > CONFIG_GCC11_NO_ARRAY_BOUNDS=y
> > CONFIG_GCC_PLUGINS=y
> > # CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
> > # CONFIG_GCC_PLUGIN_STACKLEAK is not set
> > 
> > $ make -j$(nproc) sound/soc/sof/intel/hda.o
> > 
> > $ head -1 sound/soc/sof/intel/.hda.o.cmd
> > savedcmd_sound/soc/sof/intel/hda.o := gcc ...
> > 
> > This was brought up some time ago and Masahiro made a decent point that
> > this might not be a desirable behavior change.
> > 
> > https://lore.kernel.org/CAK7LNAT6Yp3oemUxSst+htnmM-St8WmSv+UZ2x2XF23cw-kU-Q@mail.gmail.com/
> > 
> > Switching to passing CC via the actual make command should fix that.
> 
> Not quite. We generate our .config using "make defconfig" as a baseline
> and then "merge_config.sh" to add a bunch of fragments we need [1]. And
> of course the latter script does not understand CC=clang and switches
> back to GCC.

Ah, I still think you will need to pass CC to make directly, rather than
through the environment but you should be able to prevent
merge_config.sh from getting in the way by passing '-m' to avoid having
it invoke make itself, then you can add a 'make olddefconfig' step after
that, perhaps something like this?

  - name: build start
    run: |
      export ARCH=x86_64 KCFLAGS="-Wall -Werror"
      export MAKEFLAGS=j"$(nproc)"
      bash kconfig/kconfig-sof-default.sh -m
      make CC=clang olddefconfig
      make CC=clang sound/
      make CC=clang drivers/soundwire/
      make CC=clang

Cheers,
Nathan
