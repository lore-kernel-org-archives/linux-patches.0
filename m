Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABCFFC0F
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 22:24:31 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-500c7796d8eso4841877e87.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 15:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693952669; x=1694557469; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qYhc2Ab3VZYZ8IlYXlqDSrtZZTVSJAYsW6CaMnCEvOs=;
        b=AUOKdLXDw/84MQgpFFqARGchs0t9dwAVUY+fHtj7GXYSPxVBOeA9uzDIROFGsduwgO
         Rr4E78wqTolf6N6at6aPi9aypn52rh9H8QXr5WAp29yvpEECrK3xPaRtSizxhgiVATdS
         dD+KOsVRZKcjE94H1Pk5sWiwKNLtHamodYA18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693952669; x=1694557469;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYhc2Ab3VZYZ8IlYXlqDSrtZZTVSJAYsW6CaMnCEvOs=;
        b=dCcmVwDMw1JlTUS3Jkqn19UwNBe5jaY08vOk6cYEF5777noCeQDEawGUmXHXm68bCu
         91xOfQsbWNrPz+2PfcT28LX4acf9WKKKIPuljMBLkcElL4edKoabkxzRbFlOM1iLVYq8
         /jrVYmzeiAHYTiTINz4Qde9byQiS2MQrl16IAgRMNwJgdgyWKHe6uu21AQ7TdkNYwKHD
         NYXlIFDz80Sv8rZeyZCzomYnTw+nUVNzggDStrEJ6iJMIEGieq6FSWsTApAyPQ/1JLPg
         i+ST4lh2t2iKxO4IYdeCTAuUVdXwcUh9XtIccq9QUkPvAXcMm6uOT2rVQKh3Ayn81k2d
         H/tw==
X-Gm-Message-State: AOJu0YxfhCBLSVZR4XVmOG89JeFyv4zkfu26sar3Ip2Lktm9HapfSHZ2
	WM+xgl5wLs7057zpa4vG5HD9zg4/48hiBFYK4HHdSw==
X-Google-Smtp-Source: AGHT+IEaJFDN/Ujwzx4KejG+aid9NsVzxVXssaZhS2Q/zd9KxlbT13Wu7F94SUSUesxv5jh0Q1PZ3bqmbbOc3qbXw0A=
X-Received: by 2002:a19:7913:0:b0:501:b960:e1af with SMTP id
 u19-20020a197913000000b00501b960e1afmr732260lfc.23.1693952669541; Tue, 05 Sep
 2023 15:24:29 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 5 Sep 2023 17:24:29 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZPCbSse3J6ksZwJa@smile.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org> <20230831011405.3246849-2-swboyd@chromium.org>
 <ZPCbSse3J6ksZwJa@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 5 Sep 2023 17:24:29 -0500
Message-ID: <CAE-0n52wAqsmm4cs6JX2W2G10VxjLzocXVmF9c_GC+52Fi4djQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform/x86: intel_scu_ipc: Check status after
 timeouts in busy_loop()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, 
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Andy Shevchenko (2023-08-31 06:53:14)
> On Wed, Aug 30, 2023 at 06:14:01PM -0700, Stephen Boyd wrote:
> > It's possible for the polling loop in busy_loop() to get scheduled away
> > for a long time.
> >
> >   status = ipc_read_status(scu);
> >   <long time scheduled away>
> >   if (!(status & IPC_STATUS_BUSY))
> >
> > If this happens, then the status bit could change and this function
> > would never test it again after checking the jiffies against the timeout
> > limit. Polling code should check the condition one more time after the
> > timeout in case this happens.
> >
> > The read_poll_timeout() helper implements this logic, and is shorter, so
> > simply use that helper here.
>
> I don't remember by heart, but on some older Intel hardware this might have
> been called during early stages where ktime() is not functional yet.
>
> Is this still a case here?

I have no idea if that happens in early stages. What about
suspend/resume though? I suppose timekeeping could be suspended in that
case, so we can't really check anything with ktime.

I can rework this patch to simply recheck the busy bit so that we don't
have to figure out if the code is called early or from suspend paths.
