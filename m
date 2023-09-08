Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA3A1C39
	for <patches@lists.linux.dev>; Fri,  8 Sep 2023 21:30:00 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2bcfdadd149so44184091fa.0
        for <patches@lists.linux.dev>; Fri, 08 Sep 2023 14:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694208598; x=1694813398; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2qDdudysz/QEH80r6EgYVihuuCpmrfhapLn+3lG+eMs=;
        b=S8X+IByWa+6gq9yMuOXrVftfFJMo6cQYJPQp/wywIv+jKEwHK49yQgaatG5LPnpEd2
         i73YJ2ewKoqjfIsgUqI8HdhHIEfMwFocZ+1KjRnkUPLd88XWcSXKOrmvXMvH2c5/utLf
         akTUsYyG55351+2wN7Tym/1z+GmpQE1eIFpzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694208599; x=1694813399;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qDdudysz/QEH80r6EgYVihuuCpmrfhapLn+3lG+eMs=;
        b=OM0qiP9pYEwSOsa1HiJrXmq016SnoLvb1204uJiyZXdhGbqx0MF5A/eJBv4H53XDNg
         +DBQwp6ijb1nx3bwhs63VQdtrD8yuoYYRDpgVxMQtBM8bXhWWeL/gxWZRMvxmbtx/ufj
         a9UQR8mwUq0tkkMRZbQuNh7BJb/LKKeE2cVxY516mTbBJu7Pk4tgKilsJN/dvaFyiobm
         phec5ZtDIWqPrhcc9IYqMWSIKzXWyRvN9K89wO1bVtRLgCyNWtPp8F9NeE6RPeVntKwu
         nr1sAfBIFBonaswsD/SSN7sNHvSjVu6l2+d8bs6zDB2LN1ImvbQefIW/Ccv5hawBdcJM
         Gs/w==
X-Gm-Message-State: AOJu0YzicOL3qaYD2qKKoD4r9d041vSHlqWa4pdLNbtgceWoR/U6CFJG
	WaX4O/HlxS8+pNrTtN8jVrAh4l8JFIK066mvBAqkJg==
X-Google-Smtp-Source: AGHT+IHLxc6Pt+LOz/vNpPU9ODhICc7VbTgK0zhU7UukD8vadAWyMGPJPmRY8v9AfR6NmoYisAx+6DTfyXICbK2T2eY=
X-Received: by 2002:ac2:4839:0:b0:500:ac71:8464 with SMTP id
 25-20020ac24839000000b00500ac718464mr2558487lft.66.1694208598596; Fri, 08 Sep
 2023 14:29:58 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 8 Sep 2023 16:29:57 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230908045946.GM1599918@black.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org> <20230906180944.2197111-2-swboyd@chromium.org>
 <20230907053513.GH1599918@black.fi.intel.com> <CAE-0n51Ut296M2ZetuzXGpX32pS11bbWzfcbaFfqNxgSjzafJw@mail.gmail.com>
 <20230908045946.GM1599918@black.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 8 Sep 2023 16:29:57 -0500
Message-ID: <CAE-0n52VoAFopSgXiLMoSzBAdSLg4=x3i2R9Agjz5L7o8=1hew@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Mika Westerberg (2023-09-07 21:59:46)
> On Thu, Sep 07, 2023 at 01:11:17PM -0700, Stephen Boyd wrote:
> >
> > We can't use readl_busy_timeout() (you mean readl_poll_timeout() right?)
> > because that implements the timeout with timekeeping and we don't know
> > if this is called from suspend paths after timekeeping is suspended or
> > from early boot paths where timekeeping isn't started.
>
> Yes readl_poll_timeout(). :)
>
> I don't think this code is used anymore outside of regular paths. It
> used to be with the Moorestown/Medfield board support code but that's
> gone already. Grepping for the users also don't reveal anything that
> could be using it early at boot.

Ok. Assuming this isn't used from paths during suspend/resume when
timekeeping is suspended it look like readl_poll_timeout() is the
shorter and simpler approach. So if that works for you I'll send another
round with that and a fix for the ipcdev being overwritten.
