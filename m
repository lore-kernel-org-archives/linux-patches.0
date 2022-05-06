Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA862F22
	for <patches@lists.linux.dev>; Fri,  6 May 2022 19:06:35 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651863992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wxjZwQifAYdhM0J4VQYq2cjp3Wo71QrUD1AE1URfaSg=;
	b=vOcUd/lmDHJJL+Wjm7RLEdKcEcChnT4ZknvyLz64mOH/YEleSdhoaACEWCfVrpMZf3A2am
	Xyd7ivGV3f4PUKlHc9Z46RGJK4DMUAkgmDEBZlybFFaob76fScq/QSdbFGudmcwauravCz
	vOS6gK9DMgTuoGviLkslDRGocC6PWKDkn9qxcoCnBMeKj/g0sbk8LAkGdlMH/YL2PQ9UUD
	xxd/1a/oiEv1Af2UivDg66d0eQ1XtEAIZ8ljQT9SfOwCdbCyPpdsoWol7rd2OyC3LRe1WC
	xhs30NLrjE0Ac4eiJCcLyftkzVrZzu7TdS8Nq0nhaHAxhMNBR+0UlZvSWdD+PQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651863992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wxjZwQifAYdhM0J4VQYq2cjp3Wo71QrUD1AE1URfaSg=;
	b=p8bHn1UkvG9MTT6yYjW8yIhIvMPQ05zlVK7KctnyNqRnOmtOfthHCPxamNZoKpTvMHi0N8
	/B8gZ//KBFrmRQDg==
To: "Luck, Tony" <tony.luck@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com
Subject: Re: [PATCH v6 08/11] platform/x86/intel/ifs: Add scan test support
In-Reply-To: <YnVtvJgWU5KDnGSl@agluck-desk3.sc.intel.com>
References: <20220428153849.295779-1-tony.luck@intel.com>
 <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506014035.1173578-9-tony.luck@intel.com> <87r156hjpl.ffs@tglx>
 <YnVtvJgWU5KDnGSl@agluck-desk3.sc.intel.com>
Date: Fri, 06 May 2022 21:06:32 +0200
Message-ID: <87ee16h45j.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 06 2022 at 11:49, Luck, Tony wrote:
> On Fri, May 06, 2022 at 03:30:30PM +0200, Thomas Gleixner wrote:
>> 1) How is that supposed to work on a system which has HT enabled in BIOS,
>>    but disabled on the kernel command line or via /sys/..../smt/control or
>>    when a HT sibling is offlined temporarily?
>> 
>>    I assume it cannot work, but I can't see anything which handles those
>>    cases.
>
> Correct. If HT is disabled in BIOS, then there is no other thread, so
> core tests just use a single thread.
>
> If a logical CPU is "offline" due to Linux actions, then core test will
> fail. In an earlier version we did attempt to detect this before trying
> to run the test. But we didn't find a simple way to determine that a
> core has one thread online, and another offline. Rather than a bunch of
> code to detect an operator error it seemed better to let it run &
> fail.

Fair enough.

> GregKH wasn't a fan of this itty bitty driver cluttering up
> Documentation/x86. He said:
>
>    I don't know which is better, it's just that creating a whole new
>    documentation file for a single tiny driver feels very odd as it will
>    get out of date and is totally removed from the driver itself.
>
>    I'd prefer that drivers be self-contained, including the documentation,
>    as it is much more obvious what is happening with that.  Spreading stuff
>    around the tree only causes stuff to get out of sync easier.

Well, I agree to some extent, but the documentation which I want to see
is documentation for admins. I'm not sure whether we want them to search
the code. Those are consumers of Documentation/ AFAICT.

> So the documentation patch was dropped after v3. Last version here:
>
> https://lore.kernel.org/r/20220419163859.2228874-3-tony.luck@intel.com
>
> That doc would need pathnames updated to match the move from a platform
> device to a virtual misc device. But otherwise seems still accurate.
>
> Does that cover what you want from documentation for this driver
> (wherever it gets located in the tree)? Are you looking for more?

It's pretty detailed on the inner workings, but lacks a big fat warning
for the admin vs. the impact, i.e. that it makes the core go out for
lunch for a while, which has consequences on workloads and interrupts
directed at that core. Plus some explanation vs. the HT (SMT=off, soft
offline) case above. Similar to what we have e.g. for buslocks.

Thanks,

        tglx

