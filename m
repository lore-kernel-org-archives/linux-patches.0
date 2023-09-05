Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AB9A53
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 22:55:30 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2be5e2a3c86so3512351fa.0
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 15:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693954529; x=1694559329; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l/aE71jBwo2GV3dFrwiu+ky8ibuDJHJ6rVDggwijE/Q=;
        b=PZ1CwMMZsN1CISGeda9ZM5vbCLkmBOUGAZAthUdu/t+zpF7CYYK9WBvfwsSVqJTRKy
         YmcDQMFvSoVW8Qjs5zxMQHAR+ij+1NmY/Hugeky3r38A/DaUzbAN83uBlDVhiqV6H6Am
         rjc8DDYdzQaFpGTVfIBw3qJjZA/rVxKmOcnVw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693954529; x=1694559329;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/aE71jBwo2GV3dFrwiu+ky8ibuDJHJ6rVDggwijE/Q=;
        b=XSKa6BY81ixqBSu0bAMgRLpApsqdr4evNYMiioX38A116qc0MlIzqQz5qXJC+GbQtK
         pVKJFrYgKjJXsYW9RtPjiULXjrSWreRSeeHUNxDWPjeAOSlZ/UHGW6O+P3CnIqPPQL+m
         n0lNYL/Nj+TUnk7PWZO7nB2uZ6IRRmWYAE8Kps28NPxgji90pbDEaAjpCdzKPIt+DnjT
         aoIALNeFqr7SeTLNkq2S/6BK++EvRKYXXa34knHQIj15OSLvN0OmMuY9IkjEQthCpBPU
         5cIFLIdkWcUL+60JH5Vq5QFdp31Vv1PFALn1v0IPA/NeK9U9WqeP+N0car6JH32p9ccv
         ttpw==
X-Gm-Message-State: AOJu0YzugdsTF6OLGIvIpEjvUhn/ugUVKumMrgIBhAn1wIljvvMgawAV
	X/E9DfxYwDISNihe6EShRQSDtzKrUWrJl17Q0uHmUA==
X-Google-Smtp-Source: AGHT+IEgEaOl36GWSh3WGoRoX6/lnoq9wvrXbrbCTp7tUNsUX+/IwhS6KbYyiPo7tn1Z3Mq4uiJZq6Ny8oGgjGGDuIY=
X-Received: by 2002:a19:2d51:0:b0:4ff:62a4:7aaf with SMTP id
 t17-20020a192d51000000b004ff62a47aafmr420871lft.2.1693954528760; Tue, 05 Sep
 2023 15:55:28 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 5 Sep 2023 17:55:28 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <934250db-b05f-4d48-8138-06986a14b3fb@linux.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org> <934250db-b05f-4d48-8138-06986a14b3fb@linux.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 5 Sep 2023 17:55:28 -0500
Message-ID: <CAE-0n51phfrK2iMSisCb2zz+ETWx9nZ+zZ4ZS+3sPx8r3B+0RA@mail.gmail.com>
Subject: Re: [PATCH 0/3] platform/x86: intel_scu_ipc: Timeout fixes
To: Hans de Goede <hdegoede@redhat.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Mark Gross <markgross@kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Kuppuswamy Sathyanarayanan (2023-08-30 20:28:57)
>
>
> On 8/30/2023 6:14 PM, Stephen Boyd wrote:
> > I recently looked at some crash reports on ChromeOS devices that call
> > into this intel_scu_ipc driver. They were hitting timeouts, and it
> > certainly looks possible for those timeouts to be triggering because of
> > scheduling issues. Once things started going south, the timeouts kept
>
> Are you talking about timeouts during IPC command?

Yes? I see messages like this

	intel_scu_ipc intel_scu_ipc: IPC command 0x200a7 failed with -110

which led me to this driver and I wrote these patches based on that
failure message. I was trying to figure out how that could happen, and
it seems that it could simply be scheduling delays while nothing is
really timing out.

>
> > coming. Maybe that's because the other side got seriously confused? I
> > don't know. I'll poke at it some more by injecting timeouts on the
> > kernel side.
>
> Do you think it is possible due to a firmware issue?

I have no idea. Is there some way to figure that out? I'm not able to
reproduce the problem locally.
