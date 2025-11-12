Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD760303A23;
	Wed, 12 Nov 2025 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762945427; cv=none; b=cgwWB8AQXU75pc/Rl9hcv82YxVB0rruIdDBh/69as2VfuyuyiOrFiU53FXA6IRMSQ2bpl3uSUWMINBxZNzxq0PesmS74yBF5h3PKpUlnDUw+etxmRM2dX9IzZzpBjyrYOJikYvReZGmnKuFoTurvKcDoUk927tIlGms35pI1Xt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762945427; c=relaxed/simple;
	bh=5IXrfE2oasfZJMMKvh+6QkZSemvYWXFqZziofrKzceg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9+g94DXl59nkV+Hxzq3P47WdUt72nwRSA7iNbtG2HFd93dr1yhQJc+uEW2CcqR3i/5CEaI/lSI9epUJp2pbL7TkZC7r02U7knYaHXIgTtPP/Ti/lwR0biNk6woZaXOSLV4gKEyxAFzzwNA0gOwOd8AIIY1vLVHp9k/SFvszDdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW8Y4U5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW8Y4U5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589ABC16AAE;
	Wed, 12 Nov 2025 11:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762945426;
	bh=5IXrfE2oasfZJMMKvh+6QkZSemvYWXFqZziofrKzceg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qW8Y4U5UDNODo5CoaKbmQVUq1UqcMBjBUIMCOaq6ww8WG+p16u//fWJ2BvEMxskAe
	 VB0aU+Q987z7odUnSI/hH13SDt0U9y3H9XZ1PynhwZg4lukxceTS+7nDo8EsiuUEDK
	 hA81cP8Xg2JLjaAawiPY/Uv9pByGW370sxrtWVcE=
Date: Wed, 12 Nov 2025 06:03:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 145/849] bpftool: Add CET-aware symbol matching for
 x86_64 architectures
Message-ID: <2025111232-overspend-bonus-3c7d@gregkh>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004539.911440769@linuxfoundation.org>
 <50a08711-858b-4b37-a835-641c8d489006@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50a08711-858b-4b37-a835-641c8d489006@leemhuis.info>

On Tue, Nov 11, 2025 at 11:17:48AM +0100, Thorsten Leemhuis wrote:
> Below patch broke by rpm build for Fedora (based on Fedora's official
> srpms) for me when building bpftool:
> 
> """
> link.c: In function ‘is_x86_ibt_enabled’:
> link.c:288:37: error: array type has incomplete element type ‘struct kernel_config_option’
>   288 |         struct kernel_config_option options[] = {
>       |                                     ^~~~~~~
> [...]
> cc1: all warnings being treated as errors
> make[2]: *** [Makefile:259: /builddir/build/BUILD/kernel-6.17.8-build/kernel-6.17.8-rc1/linux-6.17.8-0.rc1.300.vanilla.fc43.x86_64/tools/testing/selftests/bpf/tools/build/bpftool/link.o] Error 1
> """
> 
> Full log: 
> https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora-rc/fedora-43-x86_64/09786021-stablerc-fedorarc-releases/builder-live.log.gz
> 
> Reverting below change fixed things for me.
> 
> Haven't tried yet, but according from a quick search on lore as well
> as what Sasha's AI says in
> https://lore.kernel.org/all/20251009155752.773732-64-sashal@kernel.org/
> it might also be possible to fix this by backporting 70f32a10ad423
> ("bpftool: Refactor kernel config reading into common helper")

I've just now dropped the offending commit, thanks for testing!

greg k-h
