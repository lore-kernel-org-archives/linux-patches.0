Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296B7A
	for <patches@lists.linux.dev>; Thu, 21 Apr 2022 12:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60C7C385A5;
	Thu, 21 Apr 2022 12:41:46 +0000 (UTC)
Date: Thu, 21 Apr 2022 08:41:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org"
 <markgross@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "gregkh@linuxfoundation.org"
 <gregkh@linuxfoundation.org>, "andriy.shevchenko@linux.intel.com"
 <andriy.shevchenko@linux.intel.com>, "Joseph, Jithu"
 <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
 <platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
 <patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [PATCH v3 10/11] trace: platform/x86/intel/ifs: Add trace point
 to track Intel IFS operations
Message-ID: <20220421084145.3b0c3539@gandalf.local.home>
In-Reply-To: <adc49af263e2464f86b20ccc2d8f184d@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
	<20220419163859.2228874-1-tony.luck@intel.com>
	<20220419163859.2228874-11-tony.luck@intel.com>
	<20220420193839.6e9d810b@gandalf.local.home>
	<adc49af263e2464f86b20ccc2d8f184d@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 21 Apr 2022 04:26:39 +0000
"Luck, Tony" <tony.luck@intel.com> wrote:

> >> +TRACE_EVENT(ifs_status,
> >> +
> >> +	TP_PROTO(union ifs_scan activate, union ifs_status status),  
> >
> > Really, you want to pass the structure in by value, so that we have two
> > copies? One to get to this function and then one to write to the ring
> > buffer?  
> 
> These "structures" are just bitfield helpers for a u64 that is passed into
> WRMSR (in the case of activate) and received back from RDMSR in
> the case of status.
> 
> So this is really just a pair of u64 arguments, with the compiler handling
> the bit field extractions into the ring buffer.

I was just wondering if passing by reference would be better, but as you
stated, they are just two u64 arguments.

> 
> Here are the definitions:
> 
> union ifs_scan {
>         u64     data;
>         struct {
>                 u32     start   :8;
>                 u32     stop    :8;
>                 u32     rsvd    :16;
>                 u32     delay   :31;
>                 u32     sigmce  :1;
>         };
> };
> 
> union ifs_status {
>         u64     data;
>         struct {
>                 u32     chunk_num               :8;
>                 u32     chunk_stop_index        :8;
>                 u32     rsvd1                   :16;
>                 u32     error_code              :8;
>                 u32     rsvd2                   :22;
>                 u32     control_error           :1;
>                 u32     signature_error         :1;
>         };
> };
> 
> Would it be better to do the bit extractions of the start/stop fields first?

No, I'm just paranoid about passing structures / unions in by value and not
reference. If you are fine with this, then I'm OK too.

-- Steve

