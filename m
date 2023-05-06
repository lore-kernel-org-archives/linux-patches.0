Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F8180
	for <patches@lists.linux.dev>; Sat,  6 May 2023 00:06:11 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6438d95f447so1692212b3a.3
        for <patches@lists.linux.dev>; Fri, 05 May 2023 17:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683331571; x=1685923571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=klXs9v7aA7ej680xjzts2OUwm25v6knlJ8Zui0RxixI=;
        b=B8euot9+iL9V/P1xe3MbEAtjNia4Ar85AQqNOMJsfqS2SRW0byLuRO5tzC5Lly7c0H
         su+mzKY6srmS+cB7Q/bZH9tS+d5hfnjNUyhQyu/KAutZkDRtlSABvUHdgr37pofT6KCP
         p46o6+LFKG0tsDQmRL948YADaBTSbai1Sk0oP6mDzzFclv/FoInKttstB97YcSykLemK
         Y9sEBu3ATjQohSd9v/OpmtxiyMlOn+7EJQOVUzLNVpHzb29r3c/vSdfFzbWHB2b8oZVk
         fHiBNhWvoVGGX1m1wjvcRLjRsFIQpGVZywMZkJnCv4xCX8Eh0tcCnz5yhCFOrlM0NHR7
         WKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683331571; x=1685923571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klXs9v7aA7ej680xjzts2OUwm25v6knlJ8Zui0RxixI=;
        b=drWr0sRWLqSJU+vu6GQIxWASQDBv8u5uOxReM029liSvD86tuz4yYvAPr69ymWdTKJ
         l5wyyjxmCO81fla2QQvPmvNlzZSjjyACY9gi7iqt85yr2dvrZkShEKFDQ1hhsyZ6uXp3
         1n3NbJjKcRKGn2ZOfTIxeNCTkT6f7W2eaXk+KCI2bTqoqLj4Rv+0ejtnZEqTCZqAr1rK
         W5tabVXdYvbWigxQ/L72HzHQmIW0or+Wl1zyh+lfQqq6rvBod3Pcv+5+8iOHdem4MxrW
         j+8rYDKtEC/pLztimbIyqKVnQnj/i3zoaZhQKAItrcaKpL+96HCSjLkcXxN834oOtknt
         6XgQ==
X-Gm-Message-State: AC+VfDwFKyih/4e7zu9QN09yzn6ie7L9HmDEB/UUwPzffdgm9NWdvPDM
	oJd0ifbWNNEAt3eQfadf3dM=
X-Google-Smtp-Source: ACHHUZ49tXczQW5SVIUYa/FGEJcucQomcFSS4BP2inuPdG18DUtp/4T/8bhsvFh2Cr/Y9JMg5ITZOQ==
X-Received: by 2002:a05:6a00:24cf:b0:63d:3411:f9e3 with SMTP id d15-20020a056a0024cf00b0063d3411f9e3mr4717752pfv.19.1683331571122;
        Fri, 05 May 2023 17:06:11 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:4440:ecf6:7bf5:244])
        by smtp.gmail.com with ESMTPSA id e19-20020a62ee13000000b0062e0c39977csm2094238pfi.139.2023.05.05.17.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 17:06:10 -0700 (PDT)
Date: Fri, 5 May 2023 17:06:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: google: Don't use devm for hid_hw_stop()
Message-ID: <ZFWZ785FRHDii/+5@google.com>
References: <20230505232417.1377393-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505232417.1377393-1-swboyd@chromium.org>

On Fri, May 05, 2023 at 04:24:16PM -0700, Stephen Boyd wrote:
> 
...
> Unfortunately, the hid google hammer driver hand rolls a devm function
> to call hid_hw_stop() when the driver is unbound and implements an
> hid_driver::remove() function. The driver core doesn't call the devm
> release functions until _after_ the bus unbinds the driver, so the order
> of operations is like this:

Excellent analysis, but the problem is not limited to the hammer driver
(potentially) and shalt be dealt with appropriately, at the HID bus
level.

Actually, it is not even limited to HID, but exists in most buses with
non-trivial ->remove() implementation. For example I fixed similar issue
in I2C in 5b5475826c52 ("i2c: ensure timely release of driver-allocated
resources"). I tried fixing it in SPI but Mark has some objections, and
wanted to fix it in the driver core, so I was thinking about it and then
dropped the ball. At this time I do not think fixing it at driver core
makes logic any clearer, so I think we just need to fix a handful of
buses.

Anyway, I'll CC you on an alternative patch.

Thanks.

-- 
Dmitry
