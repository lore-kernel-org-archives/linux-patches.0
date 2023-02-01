Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3EA881D
	for <patches@lists.linux.dev>; Wed,  1 Feb 2023 19:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675280747; x=1706816747;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5d9faIyt3THLEq6wTmtBD/I94RAQ6aWlbTrJuUrhtBs=;
  b=BQBLUizqQ32GC8BSTIVZNgZ2dAU2jkyODDAAWFPHxJ7hn4nq8qGcrwYj
   9+beUrukQy3TOMbkq3wpG9n8yRJJasVJ+pD98AENAXFhkepYp3Kyc8+8Y
   dheKMZ3FQbptbskl+WTTFYCUJn0HcB+CHO5IcPC7IRZlBVJFXtDNUIlWG
   iY98QUDLSJ/zIUsgp81SebSiE8Z4QG2T41q1sOGPvyafLj1L+up6gPpPr
   uzfFjUPlFMDT8Ksnv8qk7b8u/d752V8OkyOm2DEfjxKgba/K/oJ45QBVW
   NQxhKycEenhSJZn3aVNVufC2P0tT0ys2oJ8SwV3Q+PyVDwo3Of/4CgPkb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="325951344"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="325951344"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 11:45:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993811995"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="993811995"
Received: from sgkhacha-mobl1.amr.corp.intel.com (HELO [10.212.227.86]) ([10.212.227.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 11:45:45 -0800
Message-ID: <6a675f9b-2bbb-9317-2015-0b3362e49fdc@intel.com>
Date: Wed, 1 Feb 2023 11:45:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 4/5] platform/x86/intel/ifs: Implement Array BIST test
Content-Language: en-US
To: Jithu Joseph <jithu.joseph@intel.com>, hdegoede@redhat.com,
 markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230131234302.3997223-5-jithu.joseph@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230131234302.3997223-5-jithu.joseph@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/23 15:43, Jithu Joseph wrote:
> +static void ifs_array_test_core(int cpu, struct device *dev)
> +{
> +	union ifs_array activate, status;
> +	bool timed_out = false;
> +	struct ifs_data *ifsd;
> +	unsigned long timeout;
> +	u64 msrvals[2];
> +
> +	ifsd = ifs_get_data(dev);
> +
> +	activate.data = 0;
> +	activate.array_bitmask = ~0U;
> +	activate.ctrl_result = 0;

I think this whole 'ifs_array' as a union thing is bogus.  It's actually
obfuscating and *COMPLICATING* the code more than anything.  Look what
you have:

	union ifs_array activate; // declare it on the stack, unzeroed

	activate.data = 0; // zero the structure;
	activate.array_bitmask = ~0U; // set one field
	activate.ctrl_result = 0; // set the field to zero again???

Can we make it less obfuscated?  How about:

	struct ifs_array activate = {}; // zero it
	...
	activate.array_bitmask = ~0U; // set the only nonzero field

Voila!  Less code, less obfuscation, less duplicated effort.  Or, worst
case:

	struct ifs_array activate;
	...
	memset(&activate, 0, sizeof(activate));
	activate.array_bitmask = ~0U;

That's sane and everyone knows what it does and doesn't have to know
what unions are involved or how they are used.  It's correct code no
matter *WHAT* craziness lies within 'activate'.
