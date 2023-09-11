Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8785B2F44
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 21:41:52 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2bcb0b973a5so80188371fa.3
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694468510; x=1695073310; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OUB9pQ99asoGOgqvxmkpQIQ255CUSXO571C6qXV5/QY=;
        b=SLQAETHwoBhw5qyDuM3aRQfBZoAfNFVeJFpaWDdv2FbcbQ+WOL9aEz7R1d1BG4ZbCu
         kjXL6Uf9LVt6I17/zbii8hugp9DirTYaBpH2TcntgV1IQOKp7Cm8+L8yUlwHlIy/j9QY
         JPF/GL+FVXTCj6fWh2JcBWpuAwxLfiEBgJN/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694468510; x=1695073310;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OUB9pQ99asoGOgqvxmkpQIQ255CUSXO571C6qXV5/QY=;
        b=KjwhXuacFuJu7y7CVh113u9Yld9J9i2O30m46tOoiGbpg9OZ0wS+Yr6Iokov+FuiN7
         E6yM8GPtf1E+DgnvwTS3Opn2lmrU8JxU6LIAIS2B2b4bG+m+kZUaL19E50BHSD0k1gpx
         WtM7M4Uf9St1UuNX7gRoQrOXmCe4eBT/3jA1EQ3+osrb3uSwi5aYVBP8rOKrJYHgTX/f
         Hmtgcs3suhINfZzrIUzOmj+xI0/msm3pWW4hjQUD78CccZBKFNJamlHc7NJDU5Xg5/Hz
         G3Ovsxeu0AM3hzwU4GfzNshBV0GnIfZehVyVQKikcmVJNrlytgjOXnGo+ZzNDBKAPYRm
         3x6w==
X-Gm-Message-State: AOJu0YwZAlx1/dZYWexiLXzSqs6DCdCnHURn9uXD9LqvHZNkub10ijNU
	DzVX2w6OcZjO/IyKkQdWKTPHU0lFAdsQSULYRDVsdQ==
X-Google-Smtp-Source: AGHT+IHTfh2/l5NDrFmzs478pSCg3HnYRUxWfxEhRfh3L6QE0nsgCzAHcDa28aBNjuW3dNSDxWds+sBGbPakrgojpHI=
X-Received: by 2002:a2e:321a:0:b0:2bb:a28b:58e1 with SMTP id
 y26-20020a2e321a000000b002bba28b58e1mr8678269ljy.41.1694468510418; Mon, 11
 Sep 2023 14:41:50 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 Sep 2023 14:41:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZP+D4hlUXhAboFBJ@smile.fi.intel.com>
References: <20230911193937.302552-1-swboyd@chromium.org> <20230911193937.302552-2-swboyd@chromium.org>
 <ZP+D4hlUXhAboFBJ@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 11 Sep 2023 14:41:49 -0700
Message-ID: <CAE-0n52Rs05Grmno5g9YPdDS-nwJuSk0dvbg8SF1D52XJczPCA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, 
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Andy Shevchenko (2023-09-11 14:17:22)
> On Mon, Sep 11, 2023 at 12:39:33PM -0700, Stephen Boyd wrote:
> > It's possible for the polling loop in busy_loop() to get scheduled away
> > for a long time.
> >
> >   status = ipc_read_status(scu); // status = IPC_STATUS_BUSY
> >   <long time scheduled away>
> >   if (!(status & IPC_STATUS_BUSY))
> >
> > If this happens, then the status bit could change while the task is
> > scheduled away and this function would never read the status again after
> > timing out. Instead, the function will return -ETIMEDOUT when it's
> > possible that scheduling didn't work out and the status bit was cleared.
> > Bit polling code should always check the bit being polled one more time
> > after the timeout in case this happens.
> >
> > Fix this by reading the status once more after the while loop breaks.
> > The read_poll_timeout() macro implements all of this, and it is
> > shorter, so use that macro here to consolidate code and fix this.
> >
> > There were some concerns with using read_poll_timeout() because it uses
> > timekeeping, and timekeeping isn't running early on or during the late
> > stages of system suspend or early stages of system resume, but an audit
> > of the code concluded that this code isn't called during those times so
> > it is safe to use the macro.
>
> ...
>
> > +     err = read_poll_timeout(ipc_read_status, status, !(status & IPC_STATUS_BUSY),
> > +                             100, jiffies_to_usecs(IPC_TIMEOUT), false, scu);
>
> Since "false" you probably can utilize readx_poll_timeout().
>

You mean 'addr' will be 'scu'? Ok.
