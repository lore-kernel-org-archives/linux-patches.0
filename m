Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D4200AC;
	Thu, 10 Aug 2023 14:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7B6C433C7;
	Thu, 10 Aug 2023 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691678004;
	bh=IKeq5Z2PbwGi23k/nvlp7YWjgFV2LYLVb7jhG7tG1lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QbrDaeXcavNd7O6sJOBertdJqILy71c2hhn2rB/wwEj8QW3rxy7TXvVe6NovYdA1B
	 O0XO1sJAHzH18kOm7Vyi7m59Qir3sVomJ/bCV0iwnWfrXFw0ZzyGChQ3RrAKUDmb4E
	 sHLt4D/mo6IIIuxi/BxLUTwtN9U7uaG8VRGQTgmbHdttTsBiURo3cGv1Xy024RBYP9
	 fzCcztjzVYyEqUdi95AVqEYqlsVzfdQSDfOSZA0YCqgb47K3R2dS8XAqaoQrsTsjZi
	 9ACHR0ImHce4PkFNASr13ujsCbtyYj0mBdS8WLgFx7XL2F8NwvdmylvkiFKBzipbYy
	 SOubf9/oAuxoQ==
Date: Thu, 10 Aug 2023 07:33:21 -0700
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
Message-ID: <20230810143321.GA1549244@dev-arch.thelio-3990X>
References: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
 <8eed2099-2853-df8d-92db-921d0702f512@linux.intel.com>
 <20230809190212.GB3355565@dev-arch.thelio-3990X>
 <2a2de1b5-4dd5-f170-bb0b-61d39230c3a7@linux.intel.com>
 <20230809200906.GA4016444@dev-arch.thelio-3990X>
 <d224ef41-373f-186b-1ba2-86f00ea8fbce@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d224ef41-373f-186b-1ba2-86f00ea8fbce@linux.intel.com>

On Wed, Aug 09, 2023 at 03:42:44PM -0500, Pierre-Louis Bossart wrote:
> 
> > Ah, I still think you will need to pass CC to make directly, rather than
> > through the environment but you should be able to prevent
> > merge_config.sh from getting in the way by passing '-m' to avoid having
> > it invoke make itself, then you can add a 'make olddefconfig' step after
> > that, perhaps something like this?
> > 
> >   - name: build start
> >     run: |
> >       export ARCH=x86_64 KCFLAGS="-Wall -Werror"
> >       export MAKEFLAGS=j"$(nproc)"
> >       bash kconfig/kconfig-sof-default.sh -m
> 
> The -m doesn't work since it's added last, but it's not even needed. The
> sequence below re-adds clang, that's just fine.

Ah right!

> >       make CC=clang olddefconfig
> >       make CC=clang sound/
> >       make CC=clang drivers/soundwire/
> >       make CC=clang
> The fun part now is that I get tons of unrelated errors - but at least
> that's a sign we're using the clang compiler

> sound/pci/hda/hda_bind.c:232:18: error: format string is not a string
> literal (potentially insecure) [-Werror,-Wformat-security]

Heh, I suppose that is somewhat self inflicted with the '-Wall -Wextra',
as '-Wformat-security' gets re-enabled after being disabled in the main
Makefile. May be worth sticking a '-Wno-format-security' back on there.
Glad to hear that it is working now and thank you for testing with clang
to help catch issues before they make it to a tree :)

Cheers,
Nathan
