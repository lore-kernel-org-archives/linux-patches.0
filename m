Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A064691
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 20:58:45 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-690b7cb71aeso3210626b3a.0
        for <patches@lists.linux.dev>; Sat, 23 Sep 2023 13:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695502725; x=1696107525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+JQqm/IVrcsmgTAsdrlxoxSmuKKq2qQmGkyMVhE/DVg=;
        b=DHfg8uK3sKMadnP1ylSWWue8dHR9KSZfJ3GvcWJnysyAExqiC1ZpN8uNuNSCL1AKAt
         bivZWHmYalSaAHqDg7qsrKCcIbBmDK/1R5m7v9XMNYIEjLzAFlemUTdVBs0fwW6Cq4VB
         d3quWQAUcy+9grZA43z+QOxQhBJxgLw2iB3Etas8Yd1EmT5ru68vCrYBXOCI4L+R6h+5
         S+j+0oLbuYblar9Vhf1CNbXwE/HXgZv0UkQ59Y2LW5s5Sl0z/9HqifgyfvPztB2adN1H
         skcnzvx0UrAfRlz/M3TEkakaiJnlHffFVY/8/0C+9qm89hF6Dm7igFRTUFHglQuXaSau
         zUhw==
X-Gm-Message-State: AOJu0YxYYpt/CxJXLf2ugsS7FB8haBgUca0mdZp3Me56lQtcE3/ch+uu
	HBsEI52xttf3dcQBtj+0g04=
X-Google-Smtp-Source: AGHT+IGLsgmqCfwszNPSgEZ54z3W+6vxUJ/kWD5yJUxDrK/C3A/n6GNmdW50LzQ5Yrx+aO9ZIIeQaQ==
X-Received: by 2002:a05:6a00:32cc:b0:68f:c8b4:1a2b with SMTP id cl12-20020a056a0032cc00b0068fc8b41a2bmr9179930pfb.17.1695502724656;
        Sat, 23 Sep 2023 13:58:44 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id z22-20020aa791d6000000b0068a0c403636sm5309505pfa.192.2023.09.23.13.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Sep 2023 13:58:43 -0700 (PDT)
Date: Sat, 23 Sep 2023 20:58:00 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	haiyangz@microsoft.com, decui@microsoft.com,
	apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
	vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v3 15/15] Drivers: hv: Add modules to expose /dev/mshv to
 VMMs running on Hyper-V
Message-ID: <ZQ9RWMPDh3RBZJZI@liuwe-devbox-debian-v2>
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1695407915-12216-16-git-send-email-nunodasneves@linux.microsoft.com>
 <2023092318-starter-pointing-9388@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023092318-starter-pointing-9388@gregkh>

Greg, thank you for looking at the code.

On Sat, Sep 23, 2023 at 09:56:13AM +0200, Greg KH wrote:
> On Fri, Sep 22, 2023 at 11:38:35AM -0700, Nuno Das Neves wrote:
> > +static int __init mshv_vtl_init(void)
> > +{
> > +	int ret;
> > +
> > +	tasklet_init(&msg_dpc, mshv_vtl_sint_on_msg_dpc, 0);
> > +	init_waitqueue_head(&fd_wait_queue);
> > +
> > +	if (mshv_vtl_get_vsm_regs()) {
> > +		pr_emerg("%s: Unable to get VSM capabilities !!\n", __func__);
> > +		BUG();
> > +	}
> 
> 
> So you crash the whole kernel if someone loads this module on a non-mshv
> system?
> 
> That seems quite excessive and hostile :(
> 

I agree this can be more lenient. It should be safe to just return an
error code (ENODEV) and let user space decide the next action.

Saurabh, let me know what you think.

Thanks,
Wei.

> Or am I somehow reading this incorrectly?
> 
> thanks,
> 
> greg k-h
> 
