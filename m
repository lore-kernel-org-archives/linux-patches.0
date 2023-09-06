Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22AA6AB3
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 20:14:57 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-500b66f8b27so286632e87.3
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 13:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694031295; x=1694636095; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WPzah6a0gawYTHXatiWeFjlWd86MLCYavR2ag2EMlk=;
        b=SWMfZneR6SMEzPxAAtFHOyOMFDfjPHA7/lK7SNyEoEDTC9EsQIvKzl0aAdK6/yQJNu
         rlHfS3P/LJzb43frDCESqnxBcJS8JcA/SvtL9hbxZlmzRaynSD8GpaqUeAPIv4W2c9+9
         OisKM0QnXqOwvHthxl9JkBiO3kzKbZlkqjW9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694031295; x=1694636095;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/WPzah6a0gawYTHXatiWeFjlWd86MLCYavR2ag2EMlk=;
        b=LahQ49ITVB+XQivw5Zov/eFipZ47bifMMATmCJ9hVpMJW4AErrZj3aCtPHRloUENcT
         YZJTEHsEXYDz/5eTRM1uWIAexvV/P7pfxhz5lbPuKQOndQ3JI0/REiRxObTx1sL9h/v6
         cNkz8W4/mh9fia1n01DI4LcVWrJi5Dc5KJ/S6vO+eSJ3vckohniAiMCostkAaE8dKTv5
         IZKTpCJGyx675pQNIBLFQgdaRWDNKiloGxYyewNvOEuatkvnxa6lAfSxhjIzB0nueQ5f
         3W9sKJUVzWSHluYtmatBl9L/WrCvIuctkYEyiCwKr97WK9ir8YOT6kWsyUUUbjXg8fUC
         lAdw==
X-Gm-Message-State: AOJu0Yzh6hFvFOM2ARg8U11hakSqq+aDXfOfCYGtWMcTMSVxzKCXYdgK
	xgANorOYnkrcCnAxy7wIGTrPlYgFPl7owzzcCyNN8Q==
X-Google-Smtp-Source: AGHT+IHGpN/V+yPJHO3CFg5dhUD5tJnDqFY2Ihzc4V7ehcz+vvLZt/aeSmJ7tWFPH7XJJfq/zPjlLQcBvgUGt2PviR4=
X-Received: by 2002:a05:6512:547:b0:500:c292:e44e with SMTP id
 h7-20020a056512054700b00500c292e44emr2999496lfl.54.1694031295358; Wed, 06 Sep
 2023 13:14:55 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 6 Sep 2023 15:14:54 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZPjbZqIQBlIGpoCK@smile.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org> <20230906180944.2197111-2-swboyd@chromium.org>
 <ZPjbZqIQBlIGpoCK@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 6 Sep 2023 15:14:54 -0500
Message-ID: <CAE-0n52REGuVrqG8LUdWzjgqAun7uvDFPJeSkjX02OxD=fUhqg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, 
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Andy Shevchenko (2023-09-06 13:04:54)
> On Wed, Sep 06, 2023 at 11:09:41AM -0700, Stephen Boyd wrote:
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
>
> ...
>
> >  static inline int busy_loop(struct intel_scu_ipc_dev *scu)
> >  {
> >       unsigned long end = jiffies + IPC_TIMEOUT;
> > +     u32 status;
> >
> >       do {
> > -             u32 status;
> > -
> >               status = ipc_read_status(scu);
> >               if (!(status & IPC_STATUS_BUSY))
>
> > -                     return (status & IPC_STATUS_ERR) ? -EIO : 0;
> > +                     goto not_busy;
>
> Wouldn't simple 'break' suffice here?

Yes, at the cost of reading the status again when it isn't busy, or
checking the busy bit after the loop breaks out and reading it once
again when it is busy. I suppose the compiler would figure that out and
optimize so that break would simply goto the return statement.

The code could look like this without a goto.

	do {
		status = ipc_read_status(scu);
		if (!(status & IPC_STATUS_BUSY))
			break;
	} while (time_before(jiffies, end));

	if (status & IPC_STATUS_BUSY)
		status = ipc_read_status(scu);

	if (status & IPC_STATUS_BUSY)
		return -ETIMEDOUT;
	
	return (status & IPC_STATUS_ERR) ? -EIO : 0;
