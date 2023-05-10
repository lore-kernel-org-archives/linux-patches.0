Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663F221CDB
	for <patches@lists.linux.dev>; Wed, 10 May 2023 20:50:04 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ac8ee9cf7aso65516461fa.2
        for <patches@lists.linux.dev>; Wed, 10 May 2023 13:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683751802; x=1686343802;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rnjqrzqIodiFNqMDPXZNC+11o/o41P+KUMMoI8hij5U=;
        b=ONTU4AGc46YXcLPvKFxfLMjZ73LFxl77hOlaYGkBmsMjdG53mDTkPgH5jOrjAvf5uU
         gXJwiy+NDuvb+EQtWktY3t9VcGDT84tMQt+rhPF2yyaUjvPSs0fKRlEfDWyWZSFT4Art
         uOP5Rh5xrzu1xUcnNDKghKqzSWQyeMKJ3bIzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683751802; x=1686343802;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnjqrzqIodiFNqMDPXZNC+11o/o41P+KUMMoI8hij5U=;
        b=Hr2/WGt9eBvjMCb7s73p0ky56tLII34mBud/GYWCrmWSYWc7qyC2xQ1MCNpz+X2Rlk
         G5pAguVQfRrlt/TZCLFeRSeXEZpn6s9yf9ubXVAdkbTYgFeUx8B26eqdzcKwcLTIVsjR
         1Zm7r48kDAaGKNurmAFbNasSyBApZfGd8/a9qtx8U38kX8Py5kw7hRYc7Lqik0Rb1MUY
         aUPJA110P4qChbnzt3o9nI0XVEpJ6OylnAcWTpWPbdHmuPNOrLsrCQE6J5F3D4FSmZtL
         d9dHGx2Z6IrUrVCqbYGR3yJ0XfUo3eG2st/+rQ0A/xVBaK/UAxKsY0TrIL8TU9l1tkIC
         TGHQ==
X-Gm-Message-State: AC+VfDyXUaH3gTfSbchez7h6o1UqwP6mvjy/r28VwowNvJhW2ZTl0Vbc
	m72IONU6S5w8J1W+ARyCkEVN7KQJ+dTvyeiHnKGt/g==
X-Google-Smtp-Source: ACHHUZ6cKxRXP99aAnlmA3Yw1hxh80xqit1DBbDzIfBZrVqjp352ZMiZT0+kEya9yGVCWu8BTplRq3Hlp1nZE7OGCYI=
X-Received: by 2002:a2e:9d97:0:b0:2ac:d51f:2d60 with SMTP id
 c23-20020a2e9d97000000b002acd51f2d60mr2509104ljj.33.1683751802338; Wed, 10
 May 2023 13:50:02 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 10 May 2023 13:50:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZFv9aKZlZbfK1cVr@google.com>
References: <20230505232417.1377393-1-swboyd@chromium.org> <ZFWZ785FRHDii/+5@google.com>
 <CAE-0n521MhmdWjEb0-xwnPLQz07bMCGyXokZ3L87azYcw6_C_Q@mail.gmail.com> <ZFv9aKZlZbfK1cVr@google.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 10 May 2023 13:50:01 -0700
Message-ID: <CAE-0n52bv1-VaQikOV6hdFmuRyPBX6YV7MT=2+xrpReJecrgbQ@mail.gmail.com>
Subject: Re: [PATCH] HID: google: Don't use devm for hid_hw_stop()
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Quoting Dmitry Torokhov (2023-05-10 13:24:08)
> On Wed, May 10, 2023 at 11:51:31AM -0700, Stephen Boyd wrote:
> > Quoting Dmitry Torokhov (2023-05-05 17:06:07)
> > > On Fri, May 05, 2023 at 04:24:16PM -0700, Stephen Boyd wrote:
> > > >
> > > ...
> > > > Unfortunately, the hid google hammer driver hand rolls a devm function
> > > > to call hid_hw_stop() when the driver is unbound and implements an
> > > > hid_driver::remove() function. The driver core doesn't call the devm
> > > > release functions until _after_ the bus unbinds the driver, so the order
> > > > of operations is like this:
> > >
> > > Excellent analysis, but the problem is not limited to the hammer driver
> > > (potentially) and shalt be dealt with appropriately, at the HID bus
> > > level.
> >
> > Thanks. I thought of the bus level approach as well, but I was trying to
> > keep the fix isolated to the driver that had the problem. I'd like to
> > get the fix into the stable kernel, as this fixes a regression
> > introduced by commit d950db3f80a8 ("HID: google: switch to devm when
> > registering keyboard backlight LED") in v5.18.
> >
> > Is the bus level approach going to be acceptable as a stable backport?
>
> Sure, why not given the kind of stuff flowing into stable kernels. At
> least this would be fixing real issue that can be triggered with a real
> device.

Hmm, ok. I was worried it would be too much "new code" vs. fixing
something.

> >
> > This got me thinking that maybe both of these approaches are wrong.
> > Maybe the call to hid_close_report() should be removed from
> > hid_device_remove() instead.
> >
> > The device is being removed from the bus when hid_device_remove() is
> > called, but it hasn't been released yet. Other devices like the hidinput
> > device are referencing the hdev device because they set the hdev as
> > their parent. Basically, child devices are still bound to some sort of
> > driver or subsystem when the parent hdev is unbound from its driver,
> > leading to a state where the child drivers could still access the hdev
> > while it is being destroyed. If we remove the hid_close_report() call
> > from this function it will eventually be called by hid_device_release()
> > when the last reference to the device is dropped, i.e. when the child
> > devices all get destroyed. In the case of hid-google-hammer, that would
> > be when hid_hw_stop() is called from the devm release function by driver
> > core.
> >
> > The benefit of this approach is that we don't allocate a devres group
> > for all the hid devices when only two drivers need it. The possible
> > downside is that we keep the report around while the device exists but
> > has no driver bound to it.
> >
> > Here's a totally untested patch for that.
> >
> > ---8<----
> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 22623eb4f72f..93905e200cae 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -1211,8 +1211,8 @@ int hid_open_report(struct hid_device *device)
> >               hid_parser_reserved
> >       };
> >
> > -     if (WARN_ON(device->status & HID_STAT_PARSED))
> > -             return -EBUSY;
> > +     if (device->status & HID_STAT_PARSED)
> > +             hid_close_report(device);
> >
> >       start = device->dev_rdesc;
> >       if (WARN_ON(!start))
> > @@ -2662,7 +2662,6 @@ static void hid_device_remove(struct device *dev)
> >                       hdrv->remove(hdev);
> >               else /* default remove */
> >                       hid_hw_stop(hdev);
> > -             hid_close_report(hdev);
> >               hdev->driver = NULL;
> >       }
>
> This will probably work, but it I consider this still being fragile as
> at some point we might want to add some more unwinding, and we'll run
> into this issue again. I would feel much safer if the order of release
> followed (inversely) order of allocations more closely.
>

Sorry, I'm not following here. How is it fragile? Are you saying that if
we want to add devm calls into the bus layer itself the order of release
won't be inverse of allocation/creation?
