Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56A624677D;
	Thu, 24 Jul 2025 09:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753349635; cv=none; b=RVSRDCIf7PjDreE3hSMuxVwFu5ACtZGxW8krRZAdMxt3lDB4OQgfCP1nbQj4u1yl5ngunT6FAt/V9dziOn8gZjQgPaczZslAnfWA9diEmgi7d5sPAf6zf7MDITADo5UaOANOwvt0iyLL+ZVttyfhPj3d7Br2gP/T+H4of4mPXXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753349635; c=relaxed/simple;
	bh=SBONkVjsyY/VAVA5PVkqpHEDoKp8UhHde5k4WBO3d4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRnH4XYj/BkCKA4ho7jAZ2qCcwnQ0gBX2wJQpfskCmknAw8YcZeIORrY0KpiuJNYsYhVVqeND4dAXndnyJ0xzoS5vpwtnVl7shHuNPH9ot4XkHmao+Tj2ozwykoJHw+UVyM/XxEIXvUiEVdybT9hiLUxPJjBY1wE+libqdqpDzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRpa85so; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRpa85so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2F2C4CEED;
	Thu, 24 Jul 2025 09:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753349634;
	bh=SBONkVjsyY/VAVA5PVkqpHEDoKp8UhHde5k4WBO3d4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cRpa85soK6UIr0qZrSQOYwi8+zbeZr3Kou0/F3pEbAnoj5YwDSrAuYxx6ZkJXOSjR
	 aDqZpVhXSZyQ8QYXQ7MIvCi7ASaCBgtI3i4Iazm9TiWyHYZBa6qydiizNJBqyAq8RT
	 +TcfNUd9tN89gmKklaGYdLZeljPBe+JbZSchRbi0=
Date: Thu, 24 Jul 2025 11:33:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-usb@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: atm: cxacru: Merge cxacru_upload_firmware() into
 cxacru_heavy_init()
Message-ID: <2025072433-professed-breeding-152a@gregkh>
References: <20250722-usb-cxacru-fix-clang-21-uninit-warning-v2-1-6708a18decd2@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722-usb-cxacru-fix-clang-21-uninit-warning-v2-1-6708a18decd2@kernel.org>

On Tue, Jul 22, 2025 at 12:11:18PM -0700, Nathan Chancellor wrote:
> After a recent change in clang to expose uninitialized warnings from
> const variables [1], there is a warning in cxacru_heavy_init():
> 
>   drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>    1104 |         if (instance->modem_type->boot_rom_patch) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/usb/atm/cxacru.c:1113:39: note: uninitialized use occurs here
>    1113 |         cxacru_upload_firmware(instance, fw, bp);
>         |                                              ^~
>   drivers/usb/atm/cxacru.c:1104:2: note: remove the 'if' if its condition is always true
>    1104 |         if (instance->modem_type->boot_rom_patch) {
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/usb/atm/cxacru.c:1095:32: note: initialize the variable 'bp' to silence this warning
>    1095 |         const struct firmware *fw, *bp;
>         |                                       ^
>         |                                        = NULL
> 
> While the warning is technically correct that bp is conditionally passed
> uninitialized to cxacru_upload_firmware(), it is ultimately a false
> positive warning on the uninitialized use of bp because the same
> condition that initializes bp, instance->modem_type->boot_rom_patch, is
> the same one that gates the use of bp within cxacru_upload_firmware().
> As this warning occurs in clang's frontend before inlining occurs, it
> cannot know that these conditions are indentical to avoid the warning.
> 
> Manually inline cxacru_upload_firmware() into cxacru_heavy_init(), as
> that is its only callsite, so that clang can see that bp is initialized
> and used under the same condition, clearing up the warning without any
> functional changes to the code (LLVM was already doing this inlining
> later).
> 
> Cc: stable@vger.kernel.org
> Fixes: 1b0e61465234 ("[PATCH] USB ATM: driver for the Conexant AccessRunner chipset cxacru")
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2102
> Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v2:
> - Rather than initialize bp to NULL, manually inline
>   cxacru_upload_firmware() into cxacru_heavy_init() so that clang can
>   see the matching conditions for bp's initialization and use (based on
>   feedback from Greg).
> - Drop accessrunner-general@lists.sourceforge.net, as I got bounces when
>   sending to it unsubscribed.
> - Link to v1: https://lore.kernel.org/r/20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org
> ---
>  drivers/usb/atm/cxacru.c | 106 ++++++++++++++++++++++-------------------------
>  1 file changed, 49 insertions(+), 57 deletions(-)

Sorry for the churn, but hey, it's less code now!

Nice work :)

greg k-h
