Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AF044462
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 20:03:28 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3ae214a077cso612065b6e.0
        for <patches@lists.linux.dev>; Fri, 22 Sep 2023 13:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695413007; x=1696017807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92vwJf3WLmkpUBPfM1uX6jdmCsJTt9zpYit4o1iVPi8=;
        b=O+gSVq6F8X8MMMqcufmZ/MTtZTai2yYpRq49ZuuINt/QtL6nx+OM/ut60dWi+89NrF
         pXQ7H7OU99ouwkf6O1PW0Wr4iB4WbStTRkUpkt4QebI5i4OnSQnFM6fddSbVE2S0bqNz
         jbytSsQ++14MNhmb3WG+cscn4EvIS8Og1l3CMpS3cskWGMLRdMtzj/N/VJW4wkayjPaW
         0Xkc20MvOu+2ruustkZ13rY3p5ieUSUadnvPHh9YzBEmQ4gbWu41ykYX10pkFu1ElG29
         NDjlfzQ0Vi3mXWFjvfUs7Pmj7n9whVD+aV9hOB+yZ3qMScpOfPiQY/5WKhixv48XfNtP
         f9WA==
X-Gm-Message-State: AOJu0YwajTybgG3Q8mnEnT0hv8i8YFopS4rNbyhu+jlXR3GmH7K6vEoW
	/U9RbEFwZYfD3zafWUlTjXs=
X-Google-Smtp-Source: AGHT+IEP3JVa7YW6iKvp3c2447aJv58pC9gBEASQVTZuq+rvJLqoI+1fmX0Z9I0z5RQGrE60EI+KSw==
X-Received: by 2002:a05:6808:4d4:b0:3a7:35af:bbc0 with SMTP id a20-20020a05680804d400b003a735afbbc0mr664405oie.54.1695413007358;
        Fri, 22 Sep 2023 13:03:27 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id fe20-20020a056a002f1400b0068fadc9226dsm3614729pfb.33.2023.09.22.13.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 13:03:26 -0700 (PDT)
Date: Fri, 22 Sep 2023 20:02:43 +0000
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
Subject: Re: [PATCH v3 15/15] Drivers: hv: Add modules to expose /dev/mshv to
 VMMs running on Hyper-V
Message-ID: <ZQ3y47GDfhjf23Rh@liuwe-devbox-debian-v2>
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1695407915-12216-16-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1695407915-12216-16-git-send-email-nunodasneves@linux.microsoft.com>

On Fri, Sep 22, 2023 at 11:38:35AM -0700, Nuno Das Neves wrote:
> Add mshv, mshv_root, and mshv_vtl modules:
> 
> Module mshv is the parent module to the other two. It provides /dev/mshv,
> plus some common hypercall helper code. When one of the child modules is
> loaded, it is registered with the mshv module, which then provides entry
> point(s) to the child module via the IOCTLs defined in uapi/linux/mshv.h.
> 
> E.g. When the mshv_root module is loaded, it registers itself, and the
> MSHV_CREATE_PARTITION IOCTL becomes available in /dev/mshv. That is used to
> get a partition fd managed by mshv_root.
> 
> Similarly for mshv_vtl module, there is MSHV_CREATE_VTL, which creates
> an fd representing the lower vtl, managed by mshv_vtl.
> 
> Module mshv_root provides APIs for creating and managing child partitions.
> It defines abstractions for partitions (vms), vps (vcpus), and other things
> related to running a guest. It exposes the userspace interfaces for a VMM
> to manage the guest.
> 
> Module mshv_vtl provides VTL (Virtual Trust Level) support for VMMs. In
> this scenario, the host kernel and VMM run in a higher trust level than the
> guest, but within the same partition. This provides better isolation and
> performance.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

As far as I can tell, all my comments from the previous version are
addressed. I believe Saurabh and Boqun's comments are addressed, too.

The code looks good to me, so:

Acked-by: Wei Liu <wei.liu@kernel.org>

I will wait for some time for others to chime in, just in case the
community has more comments.
