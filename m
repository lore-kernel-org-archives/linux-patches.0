Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F837F7D7;
	Wed, 21 Feb 2024 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708534467; cv=none; b=XTrX3izKvACn5ZuLfUfKkxgZcbHtZftL/XSxFy7D1Vrm+lVKVoSLfeeu9ziUblzLo3B8kDWwnnWxvWCScLW5Pz5cyXJza3i5f9qOaQ8/R5OI549XxylXYxr4XpA0SgvmjAn+X+2cuuAHISLC70zL9NK+5pNrTt+9sc6v0cgtgGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708534467; c=relaxed/simple;
	bh=77aUkBq2D14lU0uBRL4qJmrXXMPNauDN+gtBYeK9HdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgYRmSCtk/rUs/gHYHu5mLIgFn7B/xrLM8YSPKH3Z0Bd2YMrcc2/vFnN5NPjlILjjRIaRQg9Kv+VR6EpcCGIaDNjdrmuhfNIC50RQIP8fwfmXv3RWpQjT3uGn7QpdfpKtyaqQryrkBTlAyiHq4TeLY8OqS4puTX2JxUCmv0EVLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4yglQW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4yglQW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEB8C433C7;
	Wed, 21 Feb 2024 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708534466;
	bh=77aUkBq2D14lU0uBRL4qJmrXXMPNauDN+gtBYeK9HdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F4yglQW8JpRtA1PEObAT6svN+d2EBxpqVrL4rzNB2821UBbivxaUnVYEKwCzgYyTK
	 xN6RaHBwMD+vC2/6bYDoPZp6xgeCnMi3ObIvMkO1cukwMNS5mr21G/xWPsauJfaEMn
	 e0sdQ2zVhEBGMQlxGKVLrLqFGfz3bH74KhtZ8qcFuwOf34kbu1wmUW2ok0TgXj40hR
	 dHZ17fcHjE2Yhomtqdb2O1DyvxkgYv3X2PSQMAEVxGQVPjLejzsxthD4aYivBLCDNQ
	 nXt1ZDVpIw0zyASbwlernGbpldgDi627L01lTk8wsrOojRo37nofvO6QMUOm6fQAXD
	 74yPiNjuBI+jw==
Date: Wed, 21 Feb 2024 09:54:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Fangrui Song <maskray@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH 5.15 380/476] kbuild: Fix changing ELF file type for
 output of gen_btf for big endian
Message-ID: <20240221165424.GC1782141@dev-arch.thelio-3990X>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130022.096353982@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221130022.096353982@linuxfoundation.org>

Hi Greg,

On Wed, Feb 21, 2024 at 02:07:11PM +0100, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Nathan Chancellor <nathan@kernel.org>
> 
> commit e3a9ee963ad8ba677ca925149812c5932b49af69 upstream.
> 
> Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> changed the ELF type of .btf.vmlinux.bin.o to ET_REL via dd, which works
> fine for little endian platforms:
> 
>    00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
>   -00000010  03 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |................|
>   +00000010  01 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |................|
> 
> However, for big endian platforms, it changes the wrong byte, resulting
> in an invalid ELF file type, which ld.lld rejects:
> 
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF............|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
>   +00000010  01 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
> 
>   Type:                              <unknown>: 103
> 
>   ld.lld: error: .btf.vmlinux.bin.o: unknown file type
> 
> Fix this by updating the entire 16-bit e_type field rather than just a
> single byte, so that everything works correctly for all platforms and
> linkers.
> 
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF............|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
>   +00000010  00 01 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
> 
>   Type:                              REL (Relocatable file)
> 
> While in the area, update the comment to mention that binutils 2.35+
> matches LLD's behavior of rejecting an ET_EXEC input, which occurred
> after the comment was added.
> 
> Cc: stable@vger.kernel.org
> Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> Link: https://github.com/llvm/llvm-project/pull/75643
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Justin Stitt <justinstitt@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  scripts/link-vmlinux.sh |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -236,8 +236,13 @@ gen_btf()
>  	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
>  		--strip-all ${1} ${2} 2>/dev/null
>  	# Change e_type to ET_REL so that it can be used to link final vmlinux.
> -	# Unlike GNU ld, lld does not allow an ET_EXEC input.
> -	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
> +	# GNU ld 2.35+ and lld do not allow an ET_EXEC input.
> +	if is_enabled CONFIG_CPU_BIG_ENDIAN; then

You may have missed my mail on the email saying this had been applied (I
didn't cc a lore list so no link):

I do not think this backport is correct for trees that do not have
commit 7d153696e5db ("kbuild: do not include include/config/auto.conf
from shell scripts"), even if it applies cleanly, as is_enabled() is not
available.

I think this diff should be squashed in to the patch for 5.15 and
earlier, you can add

  [nathan: Fix silent conflict due to lack of 7d153696e5db in older trees]
  Signed-off-by: Nathan Chancellor <nathan@kernel.org>

to the resulting patch if you would like.

Cheers,
Nathan

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 007bb773b222..5a5a0cfad69d 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -237,7 +237,7 @@ gen_btf()
 		--strip-all ${1} ${2} 2>/dev/null
 	# Change e_type to ET_REL so that it can be used to link final vmlinux.
 	# GNU ld 2.35+ and lld do not allow an ET_EXEC input.
-	if is_enabled CONFIG_CPU_BIG_ENDIAN; then
+	if [ -n "${CONFIG_CPU_BIG_ENDIAN}" ]; then
 		et_rel='\0\1'
 	else
 		et_rel='\1\0'
