Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8D4416
	for <patches@lists.linux.dev>; Thu, 13 Oct 2022 18:45:03 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id f22so2302217qto.3
        for <patches@lists.linux.dev>; Thu, 13 Oct 2022 11:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jae7zEaFZOKi5wYvzAJM8ag+uUJf+3HKkiEPd4WrjYE=;
        b=oL0POgQHdVxvV8HwV9VIUupujirRhrwqU1NOGwu2tnMxb+4Hw/iOxk2qAq3/VEYE/5
         hVUJI9CI85n3R6tP99x4LEMM0Ft/tYTEobehWyyhh3MjEtqajIqumPmOHdDHuFGZLg0z
         ftZkUVUsal45ORg1sT3eT5tG6JOpbLXAY1XqL1Vxp+NDdD2JK2epHjNxRjLQ7Pi7a/aL
         24TyL6NqnK9Tr1DNih5MOqiKia747asgEIhHIG0znWbEsY9M3hYbdcrPplDJmPoOGfmb
         s1LE0A4NL7KkX6PvhV+7CGwo597KFlPtxejHCyNXz76LUdhNdauuTHBZuDl4JBVMabKi
         wwgQ==
X-Gm-Message-State: ACrzQf0JRKekJ0WOLDFL1Qf6dQC30d733PooqZ83ylLHLKhKMflZfFNS
	qTMwMgia6NOKz6E8GeEVlDHpQo1mSVvJBKMVJ+E=
X-Google-Smtp-Source: AMsMyM6XqtTdFSQRLAVpsaJboO1CJLydS6mW4adPKjiYAvHpBRKdAgYxtR0P2x2BMCv5pgvi99XSlFyCRLFHEuN7kIE=
X-Received: by 2002:ac8:5a07:0:b0:39c:1de3:e75c with SMTP id
 n7-20020ac85a07000000b0039c1de3e75cmr1090357qta.49.1665686702643; Thu, 13 Oct
 2022 11:45:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221006163258.318916-1-tony.luck@intel.com> <20221010203423.24300-1-tony.luck@intel.com>
In-Reply-To: <20221010203423.24300-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 13 Oct 2022 20:44:51 +0200
Message-ID: <CAJZ5v0iuv9e4+kvuKHLX+VyYHptW6_pRLJK4Qz3ZX0aEPcKwxA@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI / extlog: Handle multiple records
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 10, 2022 at 10:34 PM Tony Luck <tony.luck@intel.com> wrote:
>
> If there is no user space consumer of extlog_mem trace records, then
> Linux properly handles multiple error records in an ELOG block
>
>         extlog_print()
>           print_extlog_rcd()
>             __print_extlog_rcd()
>               cper_estatus_print()
>                 apei_estatus_for_each_section()
>
> But the other code path hard codes looking for a single record to
> output a trace record.
>
> Fix by using the same apei_estatus_for_each_section() iterator
> to step over all records.
>
> Fixes: 2dfb7d51a61d ("trace, RAS: Add eMCA trace event interface")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>
> Changes since v1: Oops. Cut & pasted the apei_estatus_for_each_section()
> line, but forgot to change the argument from "estatus" to "tmp". Need to
> walk the *copy* that was made, not the original because BIOS is allowed to
> stomp on it as soon as it sees block_status has been cleared.
>
>  drivers/acpi/acpi_extlog.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
> index 72f1fb77abcd..e648158368a7 100644
> --- a/drivers/acpi/acpi_extlog.c
> +++ b/drivers/acpi/acpi_extlog.c
> @@ -12,6 +12,7 @@
>  #include <linux/ratelimit.h>
>  #include <linux/edac.h>
>  #include <linux/ras.h>
> +#include <acpi/ghes.h>
>  #include <asm/cpu.h>
>  #include <asm/mce.h>
>
> @@ -138,8 +139,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
>         int     cpu = mce->extcpu;
>         struct acpi_hest_generic_status *estatus, *tmp;
>         struct acpi_hest_generic_data *gdata;
> -       const guid_t *fru_id = &guid_null;
> -       char *fru_text = "";
> +       const guid_t *fru_id;
> +       char *fru_text;
>         guid_t *sec_type;
>         static u32 err_seq;
>
> @@ -160,17 +161,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
>
>         /* log event via trace */
>         err_seq++;
> -       gdata = (struct acpi_hest_generic_data *)(tmp + 1);
> -       if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
> -               fru_id = (guid_t *)gdata->fru_id;
> -       if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
> -               fru_text = gdata->fru_text;
> -       sec_type = (guid_t *)gdata->section_type;
> -       if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
> -               struct cper_sec_mem_err *mem = (void *)(gdata + 1);
> -               if (gdata->error_data_length >= sizeof(*mem))
> -                       trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
> -                                              (u8)gdata->error_severity);
> +       apei_estatus_for_each_section(tmp, gdata) {
> +               if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
> +                       fru_id = (guid_t *)gdata->fru_id;
> +               else
> +                       fru_id = &guid_null;
> +               if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
> +                       fru_text = gdata->fru_text;
> +               else
> +                       fru_text = "";
> +               sec_type = (guid_t *)gdata->section_type;
> +               if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
> +                       struct cper_sec_mem_err *mem = (void *)(gdata + 1);
> +
> +                       if (gdata->error_data_length >= sizeof(*mem))
> +                               trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
> +                                                      (u8)gdata->error_severity);
> +               }
>         }
>
>  out:
> --

Applied as 6.1-rc material, thanks!
