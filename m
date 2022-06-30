Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C72A35
	for <patches@lists.linux.dev>; Thu, 30 Jun 2022 07:11:36 +0000 (UTC)
Received: from zn.tnic (p200300ea97156a35329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:6a35:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1ECBA1EC0445;
	Thu, 30 Jun 2022 09:11:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1656573090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=p6So9uuYutkE30brAv3tVVhQwZ1sLZ/kD9J8wJbCh5g=;
	b=kxKNiOzaSpGQyEXEy72Uy1FktoPEmFArCT0h92R6Q5i87PqqY5Gumk/9yRixyUr2eUBS4O
	BmxPek3Bls/OTArpACQn8DhaZlhyKu55L2uml3yEKhex3Z8P8y+EWr4lapwTpR11UQmcFT
	t4vChu/xOtiaPrHv8L3RBJFbugQcjUM=
Date: Thu, 30 Jun 2022 09:11:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: Re: [PATCH] RAS/CEC: Reduce default threshold to offline a page to
 "2"
Message-ID: <Yr1MntoeRKAmkxAf@zn.tnic>
References: <20220607212015.175591-1-tony.luck@intel.com>
 <YrnBWjkX82OhXAtL@zn.tnic>
 <7da92773f7084c57814f7ef4d033bc53@intel.com>
 <Yrsleko0MnGtwaaR@zn.tnic>
 <8f580a2544d846c69c9941e151fa7cc3@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f580a2544d846c69c9941e151fa7cc3@intel.com>

On Tue, Jun 28, 2022 at 04:51:49PM +0000, Luck, Tony wrote:
> It fails to use the capabilities of h/w an Linux to avoid a fatal
> error in the future. Corrected errors are (sometimes) a predictor of
> marginal/aging memory. Copying data out of a failing page while there
> are just corrected errors can avoid losing that whole page later.

Hm, for some reason you're trying to persuade me that 2 correctable
errors per page mean that that location is going to turn into
uncorrectable and thus all pages which get two CEs per 24h should
immediately be offlined.

It might and it is commonly accepted that CEs in a DIMM could likely
lead to UEs in the future but not necessarily. That DIMM could trigger
those CEs for years and if the ECC function in the memory controller is
good enough, it could handle those CEs and keep on going like nothing's
happened.

I.e., I'm not buying this unconditional 2 CEs/24h without any sensible
proof. That "study" simply says that someone has done some evaluation
and here's our short-term solution and you should accept it - no
questions asked.

Hell, that study is even advocating the opposite:

"not all the faults (or the pages with the CE rate satisfying a certain
condition) are equally prone to future UEs. The CE rate in the past
period is not a good predictive indicator of future UEs."

So what you're doing is punishing DIMMs which can "wobble" this way with
a couple of CEs for years without causing any issues otherwise.

> Explain further. Apart from the "ostrich" case I'm not sure what they
> are.

Actually, you should explain why this drastic measure of only two
correctable errors, all of a sudden?

The most common failure in DIMMs is single-device failure, modern ECC
schemes can handle those just fine. So what's up?

> It's far more a property of DIMMs than of the CPU. Unless AMD are
> using some DECTED or better level of ECC for memory.

Well, it does the usual any number of bit flips in a single DRAM device
ECC recovery:

https://www.amd.com/system/files/documents/advanced-memory-device-correction.pdf

And the papers quoted there basically say that the majority of failures
are to single DRAM devices which the ECC scheme can handle just fine.

And the multiple DRAM devices failures are a very small percentage of
all the failures.

Which makes me wonder even more why is your change needed at all?

I'd understand if this were some very paranoid HPC system doing very
important computations and where it can't allow itself to suffer UEs so
it'll go and proactively offline pages at the very first sign of trouble
but the data says that the ECC scheme can handle single device failure
just fine and those devices fail only very seldomly and after a loooong
time.

So, if anything, your change should be Intel-only.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
