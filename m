Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4007C
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 10:30:22 +0000 (UTC)
Received: from nazgul.tnic (nat0.nue.suse.com [IPv6:2001:67c:2178:4000::1111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 59FEA1EC04A6;
	Wed,  2 Mar 2022 11:30:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1646217007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct8ODXDzLbCLONPoG2yj1wc8E2nvavpR37Cs+FqU5ag=;
	b=R5wW1oi/AzU3yAzJD8+u+SGICwfzIW3pZSnuhZdsvtnbTpftmxa+uVF8mQ8eT0pLdGfj8c
	+6VkwRxF5qBRG/T9VQ84/mofm2SpgblhZm/CsNV09Fz7KFpXUNVKoncuQGRZYvVs17ne+i
	oIdl3iciSmVJqa9rQEbpGzf1J1Gc1+k=
Date: Wed, 2 Mar 2022 11:30:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com, ashok.raj@intel.com,
	tony.luck@intel.com, rostedt@goodmis.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [RFC 01/10] x86/microcode/intel: expose collect_cpu_info_early()
 for IFS
Message-ID: <Yh9HKhESkcUIYzSr@nazgul.tnic>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-2-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220301195457.21152-2-jithu.joseph@intel.com>

On Tue, Mar 01, 2022 at 11:54:48AM -0800, Jithu Joseph wrote:
> @@ -58,6 +58,7 @@ static inline bool cpu_signatures_match(unsigned int s1, unsigned int p1,
>  	/* ... or they intersect. */
>  	return p1 & p2;
>  }
> +EXPORT_SYMBOL_GPL(cpu_signatures_match);
>  
>  /*
>   * Returns 1 if update has been found, 0 otherwise.
> @@ -342,7 +343,7 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
>  	return patch;
>  }
>  
> -static int collect_cpu_info_early(struct ucode_cpu_info *uci)
> +int collect_cpu_info_early(struct ucode_cpu_info *uci)
>  {
>  	unsigned int val[2];
>  	unsigned int family, model;
> @@ -372,6 +373,7 @@ static int collect_cpu_info_early(struct ucode_cpu_info *uci)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(collect_cpu_info_early);

This is not how this is done - simply exporting a couple of random
functions just because you need them:

drivers/platform/x86/intel/ifs/load.c: In function ‘find_ifs_matching_signature’:
drivers/platform/x86/intel/ifs/load.c:213:6: error: invalid use of void expression
  213 |  if (!cpu_signatures_match(uci->cpu_sig.sig, uci->cpu_sig.pf, shdr->sig, shdr->pf)) {
      |      ^
make[5]: *** [scripts/Makefile.build:288: drivers/platform/x86/intel/ifs/load.o] Error 1
make[4]: *** [scripts/Makefile.build:550: drivers/platform/x86/intel/ifs] Error 2
make[3]: *** [scripts/Makefile.build:550: drivers/platform/x86/intel] Error 2
make[2]: *** [scripts/Makefile.build:550: drivers/platform/x86] Error 2
make[1]: *** [scripts/Makefile.build:550: drivers/platform] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1831: drivers] Error 2

Hell, even your function signatures don't match.

And then, with that fixed it would build but then one would wonder a
long time why that ifs thing doesn't work. Well:

# CONFIG_MICROCODE is not set

So the proper thing to do is to extract the generic functionality for
comparing microcode patch signatures and for gathering the information
collect_cpu_info_early() collects, into intel-generic functions, like
I've done with intel_get_microcode_revision(), move that functionality
to arch/x86/kernel/cpu/intel.c and then use it *both* in the microcode
loader *and* your driver.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
