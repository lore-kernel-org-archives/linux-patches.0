Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0851D54EE;
	Wed,  6 Nov 2024 08:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730883368; cv=none; b=cQZs2B0ueU+/o3Ga+zPcY7I6iKb0Pah/tKh66dF2RRJr+EYY1NEQtgnJFud37mZtfcXDNG8yUPHfkLnRIllfaLnKFmgQISisherhBbSGySnL0moZ84Jx0oegjozfEFG5RcRnMWDRnVWGO8kClERRy7pch6yRFH2dJaWDl9yzb4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730883368; c=relaxed/simple;
	bh=Y0dQB1ZgQx+DrmGc6ZBFECmZ51gAbPGgkwCJb99SIM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FHUWIAoTKJ5SNJ8K84ZzCxwdiGurL/A1BIhcRhqjMUAiZGLmpUMCI4v7PNy6lMl5GBrkwSFVGPGX3ASshW0VbPz0hzduBNCbzzfcqb2+rTwGYdnw6sCcqIyUXr7a2S9r68TNgoRZADif/UkEtTNu2aRe0pUG6aH8nr3Kdw8+BJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4XjzZR0Ldwz9sRr;
	Wed,  6 Nov 2024 09:55:59 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5HmlH4RdKwyO; Wed,  6 Nov 2024 09:55:58 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4XjzZQ6gnwz9sRk;
	Wed,  6 Nov 2024 09:55:58 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D44F78B77B;
	Wed,  6 Nov 2024 09:55:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id oCC65t6-tMXu; Wed,  6 Nov 2024 09:55:58 +0100 (CET)
Received: from [192.168.232.93] (unknown [192.168.232.93])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id B3A5C8B77A;
	Wed,  6 Nov 2024 09:55:58 +0100 (CET)
Message-ID: <884cf694-09c7-4082-a6b1-6de987025bf8@csgroup.eu>
Date: Wed, 6 Nov 2024 09:55:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc/vdso: Drop -mstack-protector-guard flags in
 32-bit files with clang
To: Nathan Chancellor <nathan@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, stable@vger.kernel.org
References: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 30/10/2024 à 19:41, Nathan Chancellor a écrit :
> Under certain conditions, the 64-bit '-mstack-protector-guard' flags may
> end up in the 32-bit vDSO flags, resulting in build failures due to the
> structure of clang's argument parsing of the stack protector options,
> which validates the arguments of the stack protector guard flags
> unconditionally in the frontend, choking on the 64-bit values when
> targeting 32-bit:
> 
>    clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
>    clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
>    make[3]: *** [arch/powerpc/kernel/vdso/Makefile:85: arch/powerpc/kernel/vdso/vgettimeofday-32.o] Error 1
>    make[3]: *** [arch/powerpc/kernel/vdso/Makefile:87: arch/powerpc/kernel/vdso/vgetrandom-32.o] Error 1
> 
> Remove these flags by adding them to the CC32FLAGSREMOVE variable, which
> already handles situations similar to this. Additionally, reformat and
> align a comment better for the expanding CONFIG_CC_IS_CLANG block.

Is the problem really exclusively for 32-bit VDSO on 64-bit kernel ?
In any case, it is just wrong to have anything related to stack 
protection in VDSO, for this reason we have the following in Makefile:

ccflags-y += $(call cc-option, -fno-stack-protector)

If it is not enough, should we have more complete ?

Christophe
