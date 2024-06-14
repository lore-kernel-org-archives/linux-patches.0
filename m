Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D807A148FE0
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 07:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718350034; cv=none; b=i3V2pcgaUfWOtfzESXInE1B/zvg+rQ3gbKY50GE/YZwv0IH2ul8/B8bNPrT0+VXsLjmcl3+aH5Dcc02f2wpil/xghjM1iK6EMCUMIVQ47FIpTMhmNQfK7Iw8cpJN0QZT255+YHIgTHEonhrJPrgrbI3brxwH2gz26+M3zYM8/8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718350034; c=relaxed/simple;
	bh=/5hWId5YmtsyMOhRIhKRwGN1qpcOZRo4MAszCsksz/s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rWtD7vNutMVRT4ChmL8sqkptTV+e1Us/mZLhrH8kQaDMu7Hw0mjyIoIc4Hb3AMkBIorZEMjlZyQ+sLbvB0EDHYzro+pn4/6x9QPwZgcOWEC7lhv+N88Pmx7lJTpvWAB//OFzZTG9R/OtKzb5jCgZwfyy5y3zcqHfo1WqLAVX8q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=DzEZhFVG; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="DzEZhFVG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1718350023;
	bh=sZZIq6nqaxk/VPxNvN8lNGGq2t4CThr2RloNNxr331s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DzEZhFVGlHjUE6j+6SpGlsV+1R3lE8qFN1VlnSaMC3D7hZS+iiCvRjyTGAFILOvDT
	 gmditDZHUEiFPSIXSww4KqkY05alJcTlJ1FL6Y7wqZONXHKRu/ILvDw48Knim206YX
	 NGM0vvLDRxgwakZWQgZqCGtVlNhCmWkYVK8sik6jDmS3hJuE+QXIClFjjE/R3G7niL
	 rh7hUaxcWTkQUmh04K/sPcNKaj8WlGU1zyApRcPuf8399Uw4V/4i6tFC+GppMMgFz7
	 494FkcmJICkViE58PxQdxjsCmmKrM8X6mo0nzrcN43WSwX7yn2pLv7KNDlbZDwhXkJ
	 LuaSbOzKbxmxg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4W0rSk4BN8z4wcg;
	Fri, 14 Jun 2024 17:27:02 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 patches@lists.linux.dev, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 260/317] powerpc/uaccess: Use asm goto for get_user
 when compiler supports it
In-Reply-To: <20240613113257.605251513@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
 <20240613113257.605251513@linuxfoundation.org>
Date: Fri, 14 Jun 2024 17:27:00 +1000
Message-ID: <87zfronfwb.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Christophe Leroy <christophe.leroy@csgroup.eu>
>
> [ Upstream commit 5cd29b1fd3e8f2b45fe6d011588d832417defe31 ]
>
> clang 11 and future GCC are supporting asm goto with outputs.
>
> Use it to implement get_user in order to get better generated code.
>
> Note that clang requires to set x in the default branch of
> __get_user_size_goto() otherwise is compliant about x not being
> initialised :puzzled:
>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/403745b5aaa1b315bb4e8e46c1ba949e77eecec0.1615398265.git.christophe.leroy@csgroup.eu
> Stable-dep-of: 50934945d542 ("powerpc/uaccess: Use YZ asm constraint for ld")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/powerpc/include/asm/uaccess.h | 55 ++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)

This is causing a build break. Please drop it.

There have been a lot of changes to uaccess.h since v5.10. I think
rather than trying to pull in enough of them to allow backporting the
recent uaccess fixes it'd be better to do a custom backport. I'll send
one once I've done some build tests.

cheers
