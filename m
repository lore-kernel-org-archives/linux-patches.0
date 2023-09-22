Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BC242C11
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 18:53:07 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-690bfd4f3ebso2264128b3a.3
        for <patches@lists.linux.dev>; Fri, 22 Sep 2023 11:53:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695408786; x=1696013586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wLBzChvWAaHXw0NzmtTui405IC0LIuO1ZABr92XOq4=;
        b=pXtDL8U8FIARjHhF8+thuhxenI8HkHvreMicvO9h1GooW+MYxlcA41T7gXIOUUcTSY
         ucAz0FEZ+aO2WqK8ZV5LGyzV9iTdK/rDn3fTbcwOb7S7mkJ+WfGbw3Vq0MvEhzhlcko2
         y4NpGplWKlZGTiuk/8mX3yJ7bJ0IamkE2vG53FOYyy48f+akRdKMKZfyu5sJeKFNoNSx
         PQ9pmP4y1D6CiBbRQJgLAvMr5bNCOhsyjdxtCgMNKMs1l6vAr6O39YhCjXZ9m7cc02B/
         04TuA0CVa+Ehqg+9Qz2Mg5niqTUtIaQO6w+a2SiZ/Vur3UhvvW53Dq4lzr6rcXo8XqGb
         Hy3A==
X-Gm-Message-State: AOJu0Yyyo3OcijC+QzJvIDsH21N6DCLn33TWAXJqNzwHu79H/PNe0sk9
	q8boPBvSGtJf+iICDZcMT1c=
X-Google-Smtp-Source: AGHT+IEjoBVa60+ZQKSjWQpIoCIesiRffPKHRCzi43aByoaWcHWH1XO1QyyoWxdGTOA8xff1FjOW5A==
X-Received: by 2002:a05:6a20:3d21:b0:13d:a903:88e6 with SMTP id y33-20020a056a203d2100b0013da90388e6mr418305pzi.48.1695408786554;
        Fri, 22 Sep 2023 11:53:06 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id h19-20020a633853000000b0057c3b21c01dsm2276180pgn.49.2023.09.22.11.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 11:53:05 -0700 (PDT)
Date: Fri, 22 Sep 2023 18:52:22 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	gregkh@linuxfoundation.org, haiyangz@microsoft.com,
	decui@microsoft.com, apais@linux.microsoft.com,
	Tianyu.Lan@microsoft.com, ssengar@linux.microsoft.com,
	mukeshrathor@microsoft.com, stanislav.kinsburskiy@gmail.com,
	jinankjain@linux.microsoft.com, vkuznets@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
	catalin.marinas@arm.com
Subject: Re: [PATCH v3 01/15] hyperv-tlfs: Change shared HV_REGISTER_*
 defines to HV_MSR_*
Message-ID: <ZQ3iZuuROFm4/7kc@liuwe-devbox-debian-v2>
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1695407915-12216-2-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1695407915-12216-2-git-send-email-nunodasneves@linux.microsoft.com>

On Fri, Sep 22, 2023 at 11:38:21AM -0700, Nuno Das Neves wrote:
> In x86 hyperv-tlfs, HV_REGISTER_ prefix is used to indicate MSRs
> accessed via rdmsrl/wrmsrl. But in ARM64, HV_REGISTER_ instead indicates
> VP registers accessed via get/set vp registers hypercall.
> 
> This is due to HV_REGISTER_* names being used by hv_set/get_register,
> with the arch-specific version delegating to the appropriate mechanism.
> 
> The problem is, using prefix HV_REGISTER_ for MSRs will conflict with
> VP registers when they are introduced for x86 in future.
> 
> This patch solves the issue by:
> 
> 1. Defining all the x86 MSRs with a consistent prefix: HV_X64_MSR_.
>    This is so HV_REGISTER_ can be reserved for VP registers.
> 
> 2. Change the non-arch-specific alias used by hv_set/get_register to
>    HV_MSR_. This is also happens to be the same name HyperV uses for this
>    purpose.

HyperV -> Hyper-V. I can fix this up when I apply this patch.

> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
