Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B62F23
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 21:31:53 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso7426906pjb.5
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 14:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HAP4pqEac4lfNJXlvViTtFzP0gATvktiVtnIJE/uYVU=;
        b=OgUsLuIUsRmFfr4A7P9lwSM4pawCMg07L9HQNRqW9PovWsQNVsSSizipMQzqnefQtR
         dT3AYO5SlxNk0rXJLXPlp/n3ufv7OeBnqnAver93U09NRMQVlXjaqS6SGF/LLoTnAtZb
         lxYTwF0Q2J+zQkytzs4WvXg+DAfVRYtVZNhcooK5MJqwXWKTzewMCMuhKyVsnwyWojWA
         Lg0X3NO4LmioIHph39lzBB0zSLqIrW51B9PvxXyxt/7F2CwwJ7DVKeC8ikgphhXHClc6
         +m0Zu+85RvBqAWQ5kMqdj10LFi1Qnzym+4+bnjKNYULR79BsWUVHcxHKVlhGiaW3rgTU
         Bpxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HAP4pqEac4lfNJXlvViTtFzP0gATvktiVtnIJE/uYVU=;
        b=awK5eCOmFeiuTNI20YXbya/0AMBdG7dZXPlfhv0lXCFoqI//dnks8DHyiZsNH69v64
         9BF+KhZv7WK+SgsNwmGXizad7RCgVo/5Gaded5C5yK0CrI66IYLbr9KxL7k3EHNS1S3l
         sitt/TWrL2jnP6+LtRKzX/wKZn4KsLeLFA9XGOtkIh9Yj+OOXBo8d83DW16mwY+LLl/l
         OduXmC8xr3sY+/jJ2r0+Nt4EQo4pnsFlhp8kqr1cPlIz2gnTln0FqUjBnWiV/yT1Dd88
         R5qQAx561eSKW/l4R/qo32WADg9hqzYeJHzJf8wAkmOTtnTwj/D+3jUTvwt/Q5fQx2R0
         e3vw==
X-Gm-Message-State: AOAM531KZjHPyIOQx1BrM/O1uckkivhiMvae7l/Wifqr99tR9+JPc3xp
	jBQl3REzH0uOKp0Amitm1gKySbSzOphxUXYD4l3naokPn54=
X-Google-Smtp-Source: ABdhPJzHhDGvKo68ukuom7cTV+SESOYW7n3f9obDLSXfAilPQCpARZg985t9+XOVyOdt2pul9ubiwJdi+IRUHLr5ncc=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr43905072pll.132.1649885513102; Wed, 13
 Apr 2022 14:31:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com> <20220413183720.2444089-3-ben.widawsky@intel.com>
In-Reply-To: <20220413183720.2444089-3-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 14:31:42 -0700
Message-ID: <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Endpoint decoder enumeration is the only way in which we can determine
> Device Physical Address (DPA) -> Host Physical Address (HPA) mappings.
> Information is obtained only when the register state can be read
> sequentially. If when enumerating the decoders a failure occurs, all
> other decoders must also fail since the decoders can no longer be
> accurately managed (unless it's the last decoder in which case it can
> still work).

I think this should be expanded to fail if any decoder fails to
allocate anywhere in the topology otherwise it leaves a mess for
future address translation code to work through cases where decoder
information is missing.

The current approach is based around the current expectation that
nothing is enumerating pre-existing regions, and nothing is performing
address translation.

>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/core/hdm.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index bfc8ee876278..c3c021b54079 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -255,6 +255,8 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>                                       cxlhdm->regs.hdm_decoder, i);
>                 if (rc) {
>                         put_device(&cxld->dev);
> +                       if (is_endpoint_decoder(&cxld->dev))
> +                               return rc;
>                         failed++;
>                         continue;
>                 }
> --
> 2.35.1
>
