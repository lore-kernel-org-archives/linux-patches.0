Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9A8258B
	for <patches@lists.linux.dev>; Thu,  7 Jul 2022 00:02:27 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id w83so21710846oiw.1
        for <patches@lists.linux.dev>; Wed, 06 Jul 2022 17:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=PnPr/1wV1VsDM5AHnYfjPAu3D3lvVU7n3T6uqgg9/R0=;
        b=cy5YW5oK8azkNdczvWFJwyh++jfARujG2dfBKCYuhU29WcT/XmK1mxCRYPxCTDuzHD
         S930YX/X6BdzGqHueKcrrFx+425I4eqBGTp0flDBv9boMS5HM7KjVEznIn2TJd0cJpBS
         pKupIMlhavC4356aVBEbh/9Lt/TaZMJ3fl0C4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=PnPr/1wV1VsDM5AHnYfjPAu3D3lvVU7n3T6uqgg9/R0=;
        b=HB0kSy+Iyy1cgjGYCPe3mr+AD8Pe2M+IBSa0jil6tWeDRKh3Fm8AQZKl6Ir5cBHETT
         XWvgQbD/cSJ2Dc7Lo6G297cqITVZf74sC17xoIGb3KfV66ihQDYZClQk/R/gA72iOU4O
         4F/rKlY//tJEqgdtm5JQshQBswHIw6b3RZeuVgxWfDKXWviLtE6VYZ0uilRfU8YaYlPg
         YzpebHeK/ZyYoGr4UoRUu4UGGSazHy0RK5xQZKQOfOuIZQvIB8qT+m7Rdmo5mQf1bxUw
         w974t3g4wPQGVeesmACVbfa3ZmuMi65NNiTVFFh0TMDWEq64iIfdEBR3TQDHjdbTkiF0
         PZPQ==
X-Gm-Message-State: AJIora8ljV5Uk+KzT/KDfLXTmL1ca9zjgY+5w+7jqfiuUomiZJH3RlYi
	0agjn9ZUUzdoFcjEg9bMzR0UPx5qYmKW21sFnlBTxQ==
X-Google-Smtp-Source: AGRyM1vW63Yppk8g9ETKCFgydRa/5t3+pkplkfQ29ri3PaE1IB+DZLPNqhEt4I43L+jR0L5u6CSyYIFc3FbBzB2Bd/k=
X-Received: by 2002:a05:6808:171c:b0:334:9342:63ef with SMTP id
 bc28-20020a056808171c00b00334934263efmr808946oib.63.1657152147038; Wed, 06
 Jul 2022 17:02:27 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 6 Jul 2022 20:02:26 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Yr5xS/HCrBuNrn9N@builder.lan>
References: <20220628201340.3981860-1-swboyd@chromium.org> <Yr5xS/HCrBuNrn9N@builder.lan>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 6 Jul 2022 20:02:26 -0400
Message-ID: <CAE-0n51Ex7T+B0PwwYmH-o9VAy5PYgzGFb=bOTu8ae4t0sGZKw@mail.gmail.com>
Subject: Re: [PATCH/RFC] clk: qcom: rpmh: Block system suspend if XO is enabled
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
	Taniya Das <quic_tdas@quicinc.com>, Mike Tipton <quic_mdtipton@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Bjorn Andersson (2022-06-30 21:00:11)
> On Tue 28 Jun 15:13 CDT 2022, Stephen Boyd wrote:
>
> > Tracking down what RPMh resource is blocking XO shutdown in suspend is
> > hard. Largely because we need external debug tools to dump the RPMh
> > internal state to figure out what resource is enabled. Instead of doing
> > that, let's just block system wide suspend in the kernel if the RPMh XO
> > resource is enabled by something in the kernel. This will help us narrow
> > down XO shutdown failures to the XO clk, and not something else like an
> > interconnect or regulator RPMh resource.
> >
> > I'm sending this as an RFC because it breaks suspend for me on Trogdor
> > boards. I found out that the XO resource is always enabled on these
> > devices because the audio driver leaves an audio clk always on. This
> > means that the XO resource must not be used to determine if XO shutdown
> > is achievable, or we're leaving power savings on the table.
> >
> > Cc: Taniya Das <quic_tdas@quicinc.com>
> > Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>
> > ---
> >
> > Please don't apply. It will break suspend on Trogdor boards.
> >
>
> This seems like a useful debug feature for people outside of Qualcomm,
> so I assume you're saying that we shouldn't merge it until someone has
> fixed the audio driver? Or did you post it just as a debug tool?
>

I mainly posted it to get a response from Qualcomm on what's going on. I
haven't tried to fix the audio driver so far, but I can certainly look
into it. The audio clk driver keeping XO on doesn't seem to matter for
power because we're hitting the deepest of sleeps on Trogdor boards.

I also realized that due to clk adoption logic we can't be certain that
this driver's suspend function will be called after other clk providers
that consume XO run their suspend functions. We can probably assume clk
consumers that aren't providers will probe after clk-rpmh, so this check
is generally safe because we don't have clk providers disabling clks
during their suspend functions. It's just not totally safe.

Maybe this is a good reason to add some sort of suspend op to clk_ops
and then call that during system wide suspend.
