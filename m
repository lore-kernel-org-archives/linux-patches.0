Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2015208BB;
	Thu,  4 Jan 2024 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEHIlwHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F29C433CA;
	Thu,  4 Jan 2024 08:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704358732;
	bh=FnM+N0lP11+6X4DeBmtarWzZHMX+s3RDl2T6VN8sUFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CEHIlwHaujbs18TLbjfmMDCDJH1zvaIA8olrPoksPUY6WLLbDXT0SeA850O7tjm/5
	 u8iNFeMtLtDy1I7ujnb2Svyolw68DU7FNyOrgiuNHQUKTI17DckXmRlVqaEdw7H5Uv
	 2h8oNNEbN8W8uVe5hS+7oAaAkjPxEXVi1IbtFQ70=
Date: Thu, 4 Jan 2024 09:58:49 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.1 086/100] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
Message-ID: <2024010401-shell-easiness-47c9@gregkh>
References: <20240103164856.169912722@linuxfoundation.org>
 <20240103164909.026702193@linuxfoundation.org>
 <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt>

On Thu, Jan 04, 2024 at 08:54:48AM +0000, Shinichiro Kawasaki wrote:
> On Jan 03, 2024 / 17:55, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > 
> > commit b28ff7a7c3245d7f62acc20f15b4361292fe4117 upstream.
> > 
> > p2sb_bar() unhides P2SB device to get resources from the device. It
> > guards the operation by locking pci_rescan_remove_lock so that parallel
> > rescans do not find the P2SB device. However, this lock causes deadlock
> > when PCI bus rescan is triggered by /sys/bus/pci/rescan. The rescan
> > locks pci_rescan_remove_lock and probes PCI devices. When PCI devices
> > call p2sb_bar() during probe, it locks pci_rescan_remove_lock again.
> > Hence the deadlock.
> > 
> > To avoid the deadlock, do not lock pci_rescan_remove_lock in p2sb_bar().
> > Instead, do the lock at fs_initcall. Introduce p2sb_cache_resources()
> > for fs_initcall which gets and caches the P2SB resources. At p2sb_bar(),
> > refer the cache and return to the caller.
> > 
> > Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Fixes: 9745fb07474f ("platform/x86/intel: Add Primary to Sideband (P2SB) bridge support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > Link: https://lore.kernel.org/linux-pci/6xb24fjmptxxn5js2fjrrddjae6twex5bjaftwqsuawuqqqydx@7cl3uik5ef6j/
> > Link: https://lore.kernel.org/r/20231229063912.2517922-2-shinichiro.kawasaki@wdc.com
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> 
> Greg, please drop this patch from 6.1-stable for now. Unfortunately, one issue
> has got reported [*].
> 
> [*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg394bP6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u

What about 6.6.y, this is also queued up there too.

And when is this going to be reverted in Linus's tree?  6.7-rc8 has this
issue right now, right?

thanks,

greg k-h
