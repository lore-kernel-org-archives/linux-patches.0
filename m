Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7830EBA32
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 20:04:37 +0000 (UTC)
Received: by mail-lj1-f174.google.com with SMTP id e13so23618086ljn.0
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 12:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pn/bUQqTAlACXsw2QFf1F1nB2X4q2bNMOyvZ55+9yP4=;
        b=Tr6VgupPvHBPkf9jtufKm+A27vFwaSYnsjcszGJP6IBI2qUNT2ZjMKC3evDBThaPTt
         NDh+pJGetVKcZxgpqrN4Egt5C9/fbftrgp2NmGzf/XYJr+GEh2BJBZfb8Au84H7RN/iq
         rNHLuEQVEZ/gODcLlT7B/nPWwOR/8Rw6AW/+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pn/bUQqTAlACXsw2QFf1F1nB2X4q2bNMOyvZ55+9yP4=;
        b=CQBN4U0sUxuJAfsViAZWit9iCsSP9LMHOybEwul1Kqo1nGDiaZwz0jOPN72D43hu3K
         iQBi4eivdFvT55MSP0HpQUc+cwhUKHpeQjKGK3cDqyCFm75Bcg/3tWvuRKaA9Kw7OF3u
         GZ4JQh0fo20gvDk7v22EPuwZVq8xTMFRjaq1hUQgtAhC+mzd6dbZ1DA9pApEa6DCVz1F
         fDFJB0k58bJpsfe+ltP4qxh28+zSi0BEgyqbKtEwqu29GUYc3krpH5d4Zqjnqzn0u+MC
         lm1BjYxIWNzlz8qIyIiTFJWGDgLeHgX52rzNeWr+EcfPeERpQt4FRyGrUbNP34vSMilB
         /z3w==
X-Gm-Message-State: AFqh2kqjDDtwlRdRd1MbNdn1JEd/SZ8W0XiZ2FV+vNAytLPTGiS/jM+L
	GKsVOTdZJsebbB+RdhAeGHEyhmNRkJVDlhjs+wk0rA==
X-Google-Smtp-Source: AMrXdXuxNP3qxjyfKL7UUHKMWbAhG7+AZ5pGsKgsViDpwuAAelWCvLAprFzP+G20mze9LfyTHRB9PaqUYqRLWMQPSzo=
X-Received: by 2002:a05:651c:332:b0:28b:62f7:5b6d with SMTP id
 b18-20020a05651c033200b0028b62f75b6dmr406063ljp.39.1673640275607; Fri, 13 Jan
 2023 12:04:35 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 13 Jan 2023 14:04:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y8ERv0712EfPJWtF@hovoldconsulting.com>
References: <20230113005405.3992011-1-swboyd@chromium.org> <20230113005405.3992011-5-swboyd@chromium.org>
 <Y8ERv0712EfPJWtF@hovoldconsulting.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 13 Jan 2023 14:04:35 -0600
Message-ID: <CAE-0n50bbUJGfdXLhD2FP6-dwZEn_AqyB-fCTxgnZ=YBUQdUAw@mail.gmail.com>
Subject: Re: [PATCH 5.15.y 4/4] phy: qcom-qmp-combo: fix runtime suspend
To: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Johan Hovold (2023-01-13 00:09:35)
> On Thu, Jan 12, 2023 at 04:54:05PM -0800, Stephen Boyd wrote:
> > diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > index 9fda6d283f20..d928afe2ebba 100644
> > --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> > +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > @@ -4985,15 +4985,11 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
> >  static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
> >  {
> >       struct qcom_qmp *qmp = dev_get_drvdata(dev);
> > -     struct qmp_phy *qphy = qmp->phys[0];
> > +     struct qmp_phy *qphy = qmp->usb_phy;
> >       const struct qmp_phy_cfg *cfg = qphy->cfg;
> >
> >       dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
>
> So this doesn't work currently either as the usb_phy pointer is not set
> for PCIe and UFS PHYs.

Cool, setting usb_phy for pcie and ufs fixes this.
