Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E802943C
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 12:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-20320077ac8so12644fac.0
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 04:51:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702471915; x=1703076715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZdG9f53iWojvJlp0dRw/Gg/hPo7SN2nW69zkEzGkVc=;
        b=QjezS6DpUfABFAjKWmHCi7+/NZImChP6scRtNxuDA95F8gOWWUDAFkAlYmCvHqo9cI
         w2wLenu2Zjy+0Ztn2ff4p/S7g9hFD2QA8Rs9liKpzjHAIoBlh30mf/H/DGideb3cPIQj
         /LNW08KCfdWLfQMxMZdRd9EhWZbrKjybA7ryEVfZXRMguS3zNEy3fLRtyQj9hQWf7h4E
         zcFkBJzARFql3B273QP5kcfi+eZIPPhGSngjV98PElulew07qa54SZ6//5d/8FvWD+0F
         3jdljvs6mZIyYSqCE1CCdLif6MOWFRH11ZHJIr+UsTRLPuqDqHAbGc8cf7A0sl34F0Rl
         /bTg==
X-Gm-Message-State: AOJu0YxZ/BR8GxckGR1vHVpmdsR5KMIUK4uAZyBy1jbM5442CaKGKtnH
	Rk9F63oKiz6tdsqFHqQgYchFrI6f3l/dZ4eDy10=
X-Google-Smtp-Source: AGHT+IF2GvASrlb2vnHcx3R+WpqWs3lUMJPslS5M8PZ2C1ZfKJahHhmnOrKvbW6AXAX5qntO0Ob2wHWnBjSLO13DsHc=
X-Received: by 2002:a05:6870:f6aa:b0:1fb:10e7:4f00 with SMTP id
 el42-20020a056870f6aa00b001fb10e74f00mr14653654oab.4.1702471914679; Wed, 13
 Dec 2023 04:51:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231212212239.8971-1-tony.luck@intel.com>
In-Reply-To: <20231212212239.8971-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 13 Dec 2023 13:51:43 +0100
Message-ID: <CAJZ5v0j4djPUdJ3pdzH+E0npJHxMCHFYj4sG2-=S50=XyX_0qg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: extlog: Clear Extended Error Log status when
 RAS_CEC handled the error
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Erwin Tsaur <erwin.tsaur@intel.com>, 
	Borislav Petkov <bp@alien8.de>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 10:22=E2=80=AFPM Tony Luck <tony.luck@intel.com> wr=
ote:
>
> When both CONFIG_RAS_CEC and CONFIG_ACPI_EXTLOG are enabled, Linux does
> not clear the status word of the BIOS supplied error record for corrected
> errors. This may prevent logging of subsequent uncorrected errors.
>
> Fix by clearing the status.
>
> Fixes: 23ba710a0864 ("x86/mce: Fix all mce notifiers to update the mce->k=
flags bitmask")
> Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/acpi/acpi_extlog.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
> index e120a96e1eae..71e8d4e7a36c 100644
> --- a/drivers/acpi/acpi_extlog.c
> +++ b/drivers/acpi/acpi_extlog.c
> @@ -145,9 +145,14 @@ static int extlog_print(struct notifier_block *nb, u=
nsigned long val,
>         static u32 err_seq;
>
>         estatus =3D extlog_elog_entry_check(cpu, bank);
> -       if (estatus =3D=3D NULL || (mce->kflags & MCE_HANDLED_CEC))
> +       if (!estatus)
>                 return NOTIFY_DONE;
>
> +       if (mce->kflags & MCE_HANDLED_CEC) {
> +               estatus->block_status =3D 0;
> +               return NOTIFY_DONE;
> +       }
> +
>         memcpy(elog_buf, (void *)estatus, ELOG_ENTRY_LEN);
>         /* clear record status to enable BIOS to update it again */
>         estatus->block_status =3D 0;
> --

Applied as 6.8 material, thanks!
