Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53D0FC0F
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 22:27:25 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-4ff9b389677so4807270e87.3
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 15:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693952843; x=1694557643; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oUOKbypPycGaibquhiHpCbUwj8/Cuiw080z6tXHBtyE=;
        b=evzfTRadUTbRa5qdn9o6B8R1zroXKyEm1bq59+t+Pdd8+61sbMVDdI3CacwTMIbPne
         5LuNitbkBUpHk1v4CSwpXI6jhmkqfpbe3jpwAHlNRGFCIrtPSy5avJTkwLmV8mUf5E5P
         4G4vSH7pLWI0E5NWnmACvKFl/W32ll6rxw8gU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693952843; x=1694557643;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUOKbypPycGaibquhiHpCbUwj8/Cuiw080z6tXHBtyE=;
        b=Yx+qglzu0uLuBFufYNS/5EPKPjbJ9ir+CT9dZQ9OCeOChCYYRzWwUgf3t8kzz1pJLP
         e3GgTPuG1fUY6DuViDMtCLWIuAaIvfx+vzp9dlN+sQHxI5DeKsALPFZ5tAhSWxSCRONQ
         cOrYWsEZniwjx1m0UJJwxyHCxlLtwvEdtZSpK5rC3idaiTwwCyYZFxEhQsZ2rpM10X1R
         guC+ZfJFldkHf5kba3KxwGU5fURTWRSGVLVC4OaaJCtjM/R1wN7MU/Gwu0ZtSbqMCIs2
         jNbZs5s+XR4uibtW5qlOW5JbCYjgryI6+nSJHds2tDrIrS34NSkavXPTdJXA2CnzvZNv
         9WvQ==
X-Gm-Message-State: AOJu0YwYDQEnMQZbsi5Nk/D2rEDbimJK9uMl4k7rgFooOsKzrYaox8YO
	JwuS9IzXMuP/79YNUFWTTFjPgmFC8OJMKdXUPbyPAkZVXR0C3X9y
X-Google-Smtp-Source: AGHT+IEFY5QAWw0Wz8S+7TKv5jGQ8nerbW6isiVGv1RG13u+enH77qyZg81YHw/ApBgnGwd3cNZNPgH/BHzjwSYFpdc=
X-Received: by 2002:a05:6512:291:b0:4fd:f7a8:a9f3 with SMTP id
 j17-20020a056512029100b004fdf7a8a9f3mr845683lfp.38.1693952843686; Tue, 05 Sep
 2023 15:27:23 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 5 Sep 2023 17:27:23 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230901055011.GT3465@black.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org> <20230831011405.3246849-2-swboyd@chromium.org>
 <20230901055011.GT3465@black.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 5 Sep 2023 17:27:23 -0500
Message-ID: <CAE-0n50XCw7ugkoTAUfb5Jrr6-Vh=bvXfTOSeHV_ymyOQfRB2g@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform/x86: intel_scu_ipc: Check status after
 timeouts in busy_loop()
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Mika Westerberg (2023-08-31 22:50:11)
> On Wed, Aug 30, 2023 at 06:14:01PM -0700, Stephen Boyd wrote:
> > It's possible for the polling loop in busy_loop() to get scheduled away
> > for a long time.
> >
> >   status = ipc_read_status(scu);
> >   <long time scheduled away>
> >   if (!(status & IPC_STATUS_BUSY))
>
> How can the status bit change here as we are the only user and the SCU
> access is serialized by ipclock?

I don't know how the SCU works. I thought that IPC_STATUS_BUSY bit was
cleared by the SCU when it was done processing. With that assumption, I
tried to show that the status is read and then the process schedules
away for a long time and has an outdated view of the busy bit.
