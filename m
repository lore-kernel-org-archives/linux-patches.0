Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612D24523;
	Wed,  9 Aug 2023 19:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691611036; x=1723147036;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b7rRtFZvCdrSzvxKPCv1b1fyqfgdn3+o7xdr+LnZuYQ=;
  b=QOEdBwAjlX+AB3pjcq6NABi+0hZih7+v42Y39TAwWZj0nOWRUiF8I9C+
   6ibuYDtSCBO/5o7IGD0sZqmf0GELYOQhXQMDKgov14mhM+3baaCHXaZcd
   7GAWS72tNPnQb9yWGSpKP7jcFXQkVp22ywMhubFTQ0/Zjgf+7i4+FzloX
   IPTRwxV3d/mzlFdAIe8AffWrekKehtk6ZKkaXjBAyEn7rKUgD7vpb2KGU
   lMgfWc5OUtpFY93AE0xrUw9BhwZdyLbBducuAvMqjyUgnMSDP9DIe2JV5
   nYu3J7ovq6/eFPMU/AK8EkrNSbILt2xVX6odG2YhEVvbfaurqQHLf7n7V
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="361349676"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="361349676"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 12:57:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="766977515"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="766977515"
Received: from jcaminer-mobl.amr.corp.intel.com (HELO [10.212.58.36]) ([10.212.58.36])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 12:57:14 -0700
Message-ID: <2a2de1b5-4dd5-f170-bb0b-61d39230c3a7@linux.intel.com>
Date: Wed, 9 Aug 2023 14:57:13 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH] ASoC: SOF: Intel: Initialize chip in
 hda_sdw_check_wakeen_irq()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>
Cc: broonie@kernel.org, lgirdwood@gmail.com, peter.ujfalusi@linux.intel.com,
 yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
 daniel.baluta@nxp.com, kai.vehmanen@linux.intel.com,
 ndesaulniers@google.com, trix@redhat.com, rander.wang@intel.com,
 sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
 <8eed2099-2853-df8d-92db-921d0702f512@linux.intel.com>
 <20230809190212.GB3355565@dev-arch.thelio-3990X>
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20230809190212.GB3355565@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




>> That said, we DO compile with clang and there was no warning
>> https://github.com/thesofproject/linux/actions/runs/5542372669/job/15010818307
>>
>> Is this dependent on a specific version of clang? I'd like to make sure
>> our tools and tests are updated.
> 
> It should not be, I can reproduce it with all the versions of clang that
> the kernel supports (11.x+).
> 
> Looking at your GitHub Actions files, I am not sure exporting CC works
> correctly so I don't think you are building with clang. If I do it

D'oh. I did not see this one coming... nice.

> locally:
> 
> $ export CC=clang
> 
> $ make -j$(nproc) defconfig
> 
> $ grep -E 'CONFIG_(CC_IS|CLANG|GCC)' .config
> CONFIG_CC_IS_GCC=y
> CONFIG_GCC_VERSION=130201
> CONFIG_CLANG_VERSION=0
> CONFIG_GCC11_NO_ARRAY_BOUNDS=y
> CONFIG_GCC_PLUGINS=y
> # CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
> # CONFIG_GCC_PLUGIN_STACKLEAK is not set
> 
> $ make -j$(nproc) sound/soc/sof/intel/hda.o
> 
> $ head -1 sound/soc/sof/intel/.hda.o.cmd
> savedcmd_sound/soc/sof/intel/hda.o := gcc ...
> 
> This was brought up some time ago and Masahiro made a decent point that
> this might not be a desirable behavior change.
> 
> https://lore.kernel.org/CAK7LNAT6Yp3oemUxSst+htnmM-St8WmSv+UZ2x2XF23cw-kU-Q@mail.gmail.com/
> 
> Switching to passing CC via the actual make command should fix that.

Not quite. We generate our .config using "make defconfig" as a baseline
and then "merge_config.sh" to add a bunch of fragments we need [1]. And
of course the latter script does not understand CC=clang and switches
back to GCC.

Looks like I painted myself in a corner for the last 5 years...Any
recommendations would be welcome.

[1]
https://github.com/thesofproject/kconfig/blob/master/kconfig-sof-default.sh
