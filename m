Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C342901
	for <patches@lists.linux.dev>; Fri, 22 Apr 2022 14:54:01 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2f7b90e8b37so10390447b3.6
        for <patches@lists.linux.dev>; Fri, 22 Apr 2022 07:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c5f9R41E0Bd290of4rCDhR29V/pdJsF5Vk0y2KIrqB0=;
        b=jJ3O+OZqAQ51XAT1y9zo2HmmWgCMg1Eb1R8VtJXUSTL294B8SOkt3EgO2+MCLzYvBn
         fWy0N6cLyYNbhiaEdZEZJQgLIsDBqNsUmoA8aoH9BksIscGA2Cv8xDr00RbwngtvqZ1M
         nngG+d8Y32Pv8VTd6Fa4thsb2UMVwuUBmoPm9kcEhgFBTfeTMXchubF9kbvPDhNfcPjy
         zqelm9Y00Pfu08jNinoGMoSHnU39DsuYA2/TU44L5LiAQTvZzYptyk/fholndfQFexXS
         l4ALfj41dSIjJA8XgRsQREXaDxEawivJiQSUx1xAQhoN8SZu3DXwaNGLL3mDbaGdZGQk
         JEtw==
X-Gm-Message-State: AOAM533ikihUsQnCh3j5w3zVe3vNpIsDhdOCIvOAdHWz6lGmBkcsmObE
	kCOE36TZyJn6ZrIttZaYgtm83esoDbGR/IzXTJQ=
X-Google-Smtp-Source: ABdhPJy1PiGkkd+MuQd6tHkZA93+e1SowzE8gJ+C/aSTwE9zvQcj8wPj2GuRRfxG6Y1k4OQlyMu0j44jBZlPRCoapvU=
X-Received: by 2002:a81:1096:0:b0:2ec:4a46:7e5a with SMTP id
 144-20020a811096000000b002ec4a467e5amr5400988ywq.196.1650639240745; Fri, 22
 Apr 2022 07:54:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220419211921.2230752-1-tony.luck@intel.com>
In-Reply-To: <20220419211921.2230752-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 22 Apr 2022 16:53:49 +0200
Message-ID: <CAJZ5v0jd+OpnhijpH74B2+rr+52pcnZ3x05qccF7VU0Pa4L21w@mail.gmail.com>
Subject: Re: [PATCH] ACPI, APEI, EINJ: Refuse to inject into the zero page
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	James Morse <james.morse@arm.com>, Borislav Petkov <bp@alien8.de>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 11:19 PM Tony Luck <tony.luck@intel.com> wrote:
>
> Some validation tests dynamically inject errors into memory used by
> applications to check that the system can recover from a variety of
> poison consumption sceenarios.
>
> But sometimes the virtual address picked by these tests is mapped to
> the zero page.
>
> This causes additional unexpected machine checks as other processes that
> map the zero page also consume the poison.
>
> Disallow injection to the zero page.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> ---
> I picked -EADDRINUSE as a somewhat descriptive error code distinct
> fromm -EINVAL used elsewhere in EINJ, but I'm not strongly attached
> to it. Any other non -EINVAL value would be as good an indicator to
> the validation tests that they shouldn't inject to this address.
> ---
>  drivers/acpi/apei/einj.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index 95cc2a9f3e05..d4326ec12d29 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -549,6 +549,9 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
>              !arch_is_platform_page(base_addr)))
>                 return -EINVAL;
>
> +       if (is_zero_pfn(base_addr >> PAGE_SHIFT))
> +               return -EADDRINUSE;
> +
>  inject:
>         mutex_lock(&einj_mutex);
>         rc = __einj_error_inject(type, flags, param1, param2, param3, param4);
> --

Applied as 5.19 material, thanks!
