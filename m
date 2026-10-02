Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C1C218E91;
	Fri,  2 Oct 2026 12:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790942870; cv=none; b=I/jUdHklYkXmKJRhMiv+3dG3cCsx+RxPJXiEnug8QF2TyXyWMY20yOKS85wk2NNkfDy6GTdJpt64R4gagYtMeVIWXU9/QVu2N3f6kI4p++0Yi2vJhlOk9qH3vESeksABPEIduokDeQJlyyRui+ZvhLERG3hUSk8OSmdpRm8hT4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790942870; c=relaxed/simple;
	bh=JqGAdkby/jemI7ikYN7ouyEs/6SIHMjG/HalRqrDl2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjXCv9YJTaK7k9FNaeB4FoKz4+wSF3rAohJw8Wi61S+sOyi1SgpzSLJr6oWzbPe2rrhVTe0F5Zub+00IwSGmxiNvYk4rXSba7qJdfKYGp/QSwnkqO8ghq2nSVjisDdXZnYwPV79/Kd7xVMqNfm0hl3LhGhmjAUzQleVACnKQcw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbNdKiiX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbNdKiiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CD91F000FF;
	Fri,  2 Oct 2026 12:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790942867;
	bh=6rWRrSDf2psyCFgcd9EMY/QKrnORAyyizWrSQzqAUrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FbNdKiiXLPytlf+SD3bw+01UYJw+zzV/NfGq6dkEKID0UH/cKMbmOGr4k4BPqunob
	 DpvtPnU1h+7mAbj5zlEp/z6IBabTewf9O7oic3s7fZq+fOAV5SHBNbLASo9BP3IgzW
	 23g4EYTNVA3KquKigGWO5ohBoP1xUFMBoy5LTkSo=
Date: Fri, 2 Oct 2026 14:07:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 107/877] ASoC: soc-pcm: Apply
 snd_soc_dai_link_ch_map.codec_ch_mask to codec params
Message-ID: <2026100224-statutory-embolism-2b0f@gregkh>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152417.048647943@linuxfoundation.org>
 <73b99ddb-996b-4978-a801-69a825da9954@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73b99ddb-996b-4978-a801-69a825da9954@oracle.com>

On Fri, Oct 02, 2026 at 02:09:11AM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:46 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Richard Fitzgerald <rf@opensource.cirrus.com>
> > 
> > [ Upstream commit 6b382bdfe26a2232091bf743e454e6794295783e ]
> > 
> > In __soc_pcm_hw_params() if there is a snd_soc_dai_link_ch_map with
> > non-zero codec_ch_mask, use that channel mask to restrict which channels
> > are enabled on the codec. But only if there isn't a TDM mask.
> > 
> > It is possible that a snd_soc_dai_link_ch_map could include the same codec
> > multiple times on different CPUs so the for_each_rtd_ch_maps() loop
> > accumulates the channel masks for all entries of that codec.
> > 
> > If a TDM mask was also set, it takes priority and is used instead of any
> > possible snd_soc_dai_link_ch_map entries. (They cannot be ANDed together
> > because the bit positions are indicating different things: TDM is a bit
> > for each TDM slot, codec_ch_mask is a bit for each codec channel.)
> > 
> > This fixes a problem of incorrect TX channels enabled on the codec when
> > multiple codecs are aggregated on a single capture link. For example:
> > 
> > - Two CPUs with six 4-channel codecs.
> > - The machine driver chooses to assign one channel from each codec to
> >    one channel on the CPU
> > - But the codec hw_params() would be passed a channel count of 6, which
> >    (a) is more channels than the codec has and (b) allows enabling channels
> >    that should not be driving the audio bus.
> > 
> > Fixes: ac950278b087 ("ASoC: add N cpus to M codecs dai link support")
> > Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> > Link: https://patch.msgid.link/20260910114500.1586637-4-rf@opensource.cirrus.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi Greg/Sasha,
> 
> An AI-assisted review flagged a possible omission. I independently
> checked the core and SoundWire producer at 6.12.y f4ffa8dc360b.
> 
> The core backport correctly preserves TDM precedence and combines
> codec_ch_mask entries for each codec. The question is its missing
> SoundWire producer.
> 
> Upstream's companion has: 290845e151cd4e307cc1f25319583aaceb4eeb30,
> sound/soc/sdw_utils/soc_sdw_utils.c:
> 
> for_each_link_ch_maps(rtd->dai_link, i, ch_maps) {
>     ch_maps->cpu_ch_mask = cpu_ch_mask << (i * step);
>     ch_maps->codec_ch_mask = codec_ch_mask;
> }
> 
> 6.12.y asoc_sdw_hw_params() at f4ffa8dc360bce834e6ea7b0148eab0118f4a42e,
> sound/soc/sdw_utils/soc_sdw_utils.c:
> 
> for_each_link_ch_maps(rtd->dai_link, i, ch_maps)
>     ch_maps->cpu_ch_mask = ch_mask << (i * step);
> 
> Only the declaration and core consumer use codec_ch_mask in include/ and
> sound/. SoundWire leaves it zero, so without a TDM mask the codec keeps
> the aggregate channel count and capture restriction stays inactive.
> Hardware impact was not tested.
> 
> Could the ASoC maintainer confirm whether
> 290845e151cd4e307cc1f25319583aaceb4eeb30 ("ASoC: sdw_utils: Set
> snd_soc_dai_link_ch_map.codec_ch_mask for capture") should accompany
> this 6.12 series to complete the SoundWire capture fix?

If that is true, then that needs to be backported to all stable kernel
trees.

thanks,

greg k-h
