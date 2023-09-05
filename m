Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990ADDDD7
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 22:42:29 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-500cd6261fdso5327105e87.3
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 15:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693953747; x=1694558547; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3FWuqZR2Wn3X9VZ8AH7iRg0Yr6/SImaXIioCz91p84=;
        b=D6FfmIF1fghGoGo8g/013LpiI0+v5Shrzb7puga65Uq8sWMb6LoVR3tQIH1mobT6FV
         337I5oPl2l21Lx9eMWuRLsT6VJXfC6iI76gY1oWJaPowmjFHk+l/Dzoqh0h87YXngaug
         HSyXvgwP3BPrwpCquK3WRkZ/K6JGg6BUIlKLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693953747; x=1694558547;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3FWuqZR2Wn3X9VZ8AH7iRg0Yr6/SImaXIioCz91p84=;
        b=QbHcWoAISidIkGRKGvq40ujSyRuTyc4ushKKR+q//26+gR2R9OFm2RiC2cYl587WHm
         Xy+N7nDz8Z7YVu6jR1YI32ZlLmTYUSafFCbdYlqN6Jb9yyhoXjnTwIckqlEAHN9DS2xR
         O99IAXXj5WkRwJMP9wPbgUtxztUdoQwOAzM+sbFrZB7TTFjaO0olOp3yrC1MdiP/dN2x
         W3J5srzUx84p7JWJmeNY15/yd5bVmUplJGdDYyaz0gjKHzRsiEm7F99FZZVzMYVFc23g
         9JoujZDv+NmwnLGM6b483gTeMecjM1CjGOZEmIM8PYnb/zf8M0EzBkeziY4AXiRIvFdY
         /3Gw==
X-Gm-Message-State: AOJu0YwdRN8dh7Nki1Hen5eL13NoDI+vuspAupvwLeQOX59gw3MwePnx
	2h7Pg2bRK4IFJbI9LjrOlB+GZq5+axx+Bw4L8K3aDg==
X-Google-Smtp-Source: AGHT+IFAFTA7ToqE4LPj1zlDe/EZ6SMMTBm5ce+e69KM0+H1Ghgh2PkfFeJBhIhAxnlD514dPoH0B4MpsmAYuo8mZWw=
X-Received: by 2002:ac2:5326:0:b0:4ff:8863:be01 with SMTP id
 f6-20020ac25326000000b004ff8863be01mr863011lfh.8.1693953747163; Tue, 05 Sep
 2023 15:42:27 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 5 Sep 2023 17:42:26 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230901060633.GV3465@black.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org> <20230831011405.3246849-4-swboyd@chromium.org>
 <ZPCenoPp/SDesUek@smile.fi.intel.com> <20230901060633.GV3465@black.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 5 Sep 2023 17:42:26 -0500
Message-ID: <CAE-0n508ae9ygTNU+HVk08L2zPy85izLLsyNS-DS7d-LPrffNA@mail.gmail.com>
Subject: Re: [PATCH 3/3] platform/x86: intel_scu_ipc: Fail IPC send if still busy
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Mika Westerberg (2023-08-31 23:06:33)
> On Thu, Aug 31, 2023 at 05:07:26PM +0300, Andy Shevchenko wrote:
> > On Wed, Aug 30, 2023 at 06:14:03PM -0700, Stephen Boyd wrote:
> > > It's possible for interrupts to get significantly delayed to the point
> > > that callers of intel_scu_ipc_dev_command() and friends can call the
> > > function once, hit a timeout, and call it again while the interrupt
> > > still hasn't been processed. This driver will get seriously confused if
> > > the interrupt is finally processed after the second IPC has been sent
> > > with ipc_command(). It won't know which IPC has been completed. This
> > > could be quite disastrous if calling code assumes something has happened
> > > upon return from intel_scu_ipc_dev_simple_command() when it actually
> > > hasn't.
> > >
> > > Let's avoid this scenario by simply returning -EBUSY in this case.
> > > Hopefully higher layers will know to back off or fail gracefully when
> > > this happens. It's all highly unlikely anyway, but it's better to be
> > > correct here as we have no way to know which IPC the status register is
> > > telling us about if we send a second IPC while the previous IPC is still
> > > processing.
> >
> > > +static bool intel_scu_ipc_busy(struct intel_scu_ipc_dev *scu)
> >
> > static int ?
> >
> > > +{
> > > +   u8 status;
> > > +
> > > +   status = ipc_read_status(scu);
> > > +   if (status & IPC_STATUS_BUSY) {
> >
> > > +           dev_err(&scu->dev, "device is busy\n");
> >
> > 1. Wouldn't it exaggerate the logs? Shouldn't be rate limited?
> > 2. OTOH if we return -EBUSY directly from here, do we need this at all?
>
> Agree w/ returning -EBUSY here and dropping the dev_err() (or using
> dev_dbg()).

Ok. I'll change to dev_dbg(). I assume that this should never happen,
but you never know if some calling code will ignore the return -EBUSY
from the previous round and call again while the previous IPC is
processing.
