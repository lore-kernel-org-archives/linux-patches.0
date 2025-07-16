Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C272B1D79BE;
	Wed, 16 Jul 2025 15:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752680588; cv=none; b=WmFPmi4uN+d936xx76pmQdXrL/2BBQL1TLwTpx19qoyg9gyYsD//NnREUxSvGpa4NYF+lb9O+n2C4NJsVDFu0nie1/5WVEmzAEPQmmd2mRiR6rHeivpOeZXWnyUFmx48494DhrI+fnSyzBIGx3A71MpswLxLxCR+kVuusry2W4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752680588; c=relaxed/simple;
	bh=YmoYgi+Z8Rk0G8PfGmH0mIpcN33QeyjM51E5rSRT2ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=burBDj9nGAkW6NaHTleSQ27HgyofAx6n+wRpv2rBIKnJprwHem/qUmYfE4Pvhzh+erP042XwNTxvAntdhwEXMgYJlZNV6kO91Bouwla7CQ5fFJsEN5OYXiSDIMZ2BFt+xEQEOPp87QXX9BbZJbl6Qxq363Y6IfmdZTz03DTn2Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbJ47Num; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbJ47Num"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0103C4CEE7;
	Wed, 16 Jul 2025 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752680588;
	bh=YmoYgi+Z8Rk0G8PfGmH0mIpcN33QeyjM51E5rSRT2ME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jbJ47NumH3GUuFBTW5QfD5IpvqKhlX7KuiXX8+daoIHSQ9sshQUmFAfTdrM7QAzrR
	 WaxN86aDlX5OwGKEYluRPdxzC7XuA8SAXgWFhzF55VAaY79UJukVtJ0QFWCPdsKPTl
	 VJa424+P/dNroGHeFK47xpEU9EBGhyaWyP0r14OA2kufCJJqBkHryh3XlPB6fMPWJF
	 x05wrOeDO6Yfp0HymWR1jOO6in8N0wYwHieQP6sL12LdWoMuSVdMPp8kRikksWPOr5
	 ORsa6yEYRrBkNlUZALA4r/zRlPUbcUSgeSGsEl7WccxGbwl1sTxJhV7VMmriZATnrv
	 TscymJJ5TeX1Q==
Date: Wed, 16 Jul 2025 08:43:04 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] usb: atm: cxacru: Zero initialize bp in
 cxacru_heavy_init()
Message-ID: <20250716154304.GA2740255@ax162>
References: <20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org>
 <2025071618-jester-outing-7fed@gregkh>
 <20250716052450.GA1892301@ax162>
 <2025071616-flap-mundane-7627@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025071616-flap-mundane-7627@gregkh>

On Wed, Jul 16, 2025 at 10:00:10AM +0200, Greg Kroah-Hartman wrote:
> No, I take it back, it is unreasonable :)
> 
> At runtime, there never is a uninitialized use of this pointer, the
> first time it is used, it is intended to be filled in if this is a "boot
> rom patch":
> 	ret = cxacru_find_firmware(instance, "bp", &bp);
> 
> Then if that call fails, the function exits, great.
> 
> Then later on, this is called:
> 	cxacru_upload_firmware(instance, fw, bp);
> so either bp IS valid, or it's still uninitialized, fair enough.
> 
> But then cxacru_upload_firmware() does the same check for "is this a
> boot rom patch" and only then does it reference the variable.

Right but how would you know this if you were unable to look at what's
inside cxacru_upload_firmware()? That's basically what is happening with
clang, it is only able to look at cxacru_heavy_init().

> And when it references it, it does NOT check if it is valid or not, so
> even if you do pre-initialize this to NULL, surely some other static
> checker is going to come along and say "Hey, you just dereferenced a
> NULL pointer, this needs to be fixed!" when that too is just not true at
> all.

If a static checker has the ability to see the NULL passed to
cxacru_upload_firmware() from cxacru_heavy_init(), I would expect it to
notice the identical conditions but point taken :)

> So the logic here is all "safe" for now, and if you set this to NULL,
> you are just papering over the fact that it is right, AND setting us up
> to get another patch that actually does nothing, while feeling like the
> submitter just fixed a security bug, demanding a CVE for an impossible
> code path :)

Wouldn this be sufficient to avoid such a situation?

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index b7c3b224a759..fcff092fe826 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -1026,7 +1026,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	}
 
 	/* Boot ROM patch */
-	if (instance->modem_type->boot_rom_patch) {
+	if (instance->modem_type->boot_rom_patch && bp) {
 		usb_info(usbatm, "loading boot ROM patch\n");
 		ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, BR_ADDR, bp->data, bp->size);
 		if (ret) {


> So let's leave this for now because:
> 
> > This type of warning
> > is off for GCC because of how unreliable it was when it is done in the
> > middle end with optimizations. Furthermore, it is my understanding based
> > on [1] that just the passing of an uninitialized variable in this manner
> > is UB.
> > 
> > [1]: https://lore.kernel.org/20220614214039.GA25951@gate.crashing.org/
> 
> As gcc can't handle this either, it seems that clang also can't handle
> it.  So turning this on for the kernel surely is going to trip it up in
> other places than just this one driver.

I turned this warning on in 5.3 in commit 3a61925e91ba ("kbuild: Enable
-Wuninitialized"), so it is already enabled and it has found many, many
legitimate instances in doing so, just go run 'git log
--grep=Wuninitialized' or 'git log --grep=Wsometimes-uninitialized' in
the kernel sources. While there have been other places in the kernel
where this warning has been falsely triggered such as here, I have
rarely received pushback from maintainers on fixes to silence them
because the majority of them are legitimate (and the false positive
fixes usually result in more robust code). For example, the
strengthening of the warning in clang-21 resulted in what I would
consider legitimate fixes:

https://lore.kernel.org/20250715-mt7996-fix-uninit-const-pointer-v1-1-b5d8d11d7b78@kernel.org/
https://lore.kernel.org/20250715-net-phonet-fix-uninit-const-pointer-v1-1-8efd1bd188b3@kernel.org/
https://lore.kernel.org/20250715-drm-msm-fix-const-uninit-warning-v1-1-d6a366fd9a32@kernel.org/
https://lore.kernel.org/20250715-riscv-uaccess-fix-self-init-val-v1-1-82b8e911f120@kernel.org/
https://lore.kernel.org/20250715-trace_probe-fix-const-uninit-warning-v1-1-98960f91dd04@kernel.org/
https://lore.kernel.org/20250715-sdca_interrupts-fix-const-uninit-warning-v1-1-cc031c913499@kernel.org/

> If you _really_ want to fix this, refactor the code to be more sane and
> obvious from a C parsing standpoint, but really, it isn't that complex
> for a human to read and understand, and I see why it was written this
> way.

Yes, I agree that it is not complex or hard to understand, so I would
rather not refactor it, but I do need this fixed so that allmodconfig
builds (which enable -Werror by default) with clang-21 do not break.
Won't Android eventually hit this when they get a newer compiler?

> As for the UB argument, bah, I don't care, sane compilers will do the
> right thing, i.e. pass in the uninitialized value, or if we turned on
> the 0-fill stack option, will be NULL anyway, otherwise why do we have
> that option if not to "solve" the UB issue?).

As far as I understand it, clang adds "noundef" to function parameters
when lowering to LLVM IR, which codifies that passing an uninitialized
value is UB. I suspect that cxacru_upload_firmware() gets inlined so
that ends up not mattering in this case but it could in others.

While '-ftrivial-auto-var-init=zero' does "solve" the UB issue, I see it
more of a mitigation against missed initializations, not as a
replacement for ensuring variables are consistently initialized, as zero
might not be the expected initialization. Since that is the default for
the kernel when compilers support it, why not just take this patch with
that fixup above to make it consistent? I would be happy to send a v2 if
you would be okay with it.

Cheers,
Nathan
