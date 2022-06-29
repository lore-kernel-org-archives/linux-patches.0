Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0FA7B
	for <patches@lists.linux.dev>; Wed, 29 Jun 2022 18:25:50 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-317741c86fdso156573337b3.2
        for <patches@lists.linux.dev>; Wed, 29 Jun 2022 11:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QiTMGZ1Oor7xHDMn7+pM1tWPeKIIB+ASfs2U6Er3qi0=;
        b=KzVv10y8d6GXpju32yEEF4PnjbaiU07ULcBlWnO0tSVhYSVOk2owWDCQDvA7wm/lIv
         DD3hlzQonAhR6aLGMB60PmciC9nGfSw0/iv9AZiGApjvzaeviXiDEjMiWV1zMC+KNETv
         9GbPSt7l4hfAgZNC7WohIwv+EHe3uozhIazo7j1kMQNuhB4qTyaafHBSgMyUtGBkWrAI
         ZdJRHPcm6rHvMpDxiqqp++GyjUpscAqdxjP883qxILG4YK4ZleHzf32Y4LnmJ+aI9jdc
         SKbZD1o9Q93Zx3YJXb2LX+0BgWX5W7iJRaikxmtZ9J9RJCBf1AMulpjZbBlcGm7ihyah
         nhBg==
X-Gm-Message-State: AJIora/GGB+kToZ/EoOoOsk98C6T7czoxVgwRHlrDmdHNeqntzfQ6itF
	SHU4kR8jhxB/igzywKNM9v0sY8tce5ANph18iSU=
X-Google-Smtp-Source: AGRyM1smcSnklBIPzyeeyuMsfwAbAZCh1f1al96TpLvROYcYrsIjaBhd617UXVfMMs7YBNiyZznf+OuDnlggwpg/g2M=
X-Received: by 2002:a0d:c486:0:b0:31c:3b63:91fe with SMTP id
 g128-20020a0dc486000000b0031c3b6391femr535206ywd.7.1656527149184; Wed, 29 Jun
 2022 11:25:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <165611192645.990447.9154951000881269149.stgit@dwillia2-xfh>
In-Reply-To: <165611192645.990447.9154951000881269149.stgit@dwillia2-xfh>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 29 Jun 2022 20:25:37 +0200
Message-ID: <CAJZ5v0gGO+gDLXpbKhD+dstGA3Oz05myd3Uh5XvEb4h7-yUMDw@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Fix _EINJ vs EFI_MEMORY_SP
To: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael Wysocki <rafael.j.wysocki@intel.com>, Mustafa Hajeer <mustafa.hajeer@intel.com>, 
	Len Brown <lenb@kernel.org>, James Morse <james.morse@arm.com>, Borislav Petkov <bp@alien8.de>, 
	Tony Luck <tony.luck@intel.com>, Omar Avelar <omar.avelar@intel.com>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sat, Jun 25, 2022 at 1:05 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> When a platform marks a memory range as "special purpose" it is not
> onlined as System RAM by default. However, it is still suitable for
> error injection. Add IORES_DESC_SOFT_RESERVED to einj_error_inject() as
> a permissible memory type in the sanity checking of the arguments to
> _EINJ.
>
> Fixes: 262b45ae3ab4 ("x86/efi: EFI soft reservation to E820 enumeration")
> Cc: Rafael Wysocki <rafael.j.wysocki@intel.com>
> Cc: Mustafa Hajeer <mustafa.hajeer@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Reported-by: Omar Avelar <omar.avelar@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/apei/einj.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index d4326ec12d29..6b583373c58a 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -546,6 +546,8 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
>                                 != REGION_INTERSECTS) &&
>              (region_intersects(base_addr, size, IORESOURCE_MEM, IORES_DESC_PERSISTENT_MEMORY)
>                                 != REGION_INTERSECTS) &&
> +            (region_intersects(base_addr, size, IORESOURCE_MEM, IORES_DESC_SOFT_RESERVED)
> +                               != REGION_INTERSECTS) &&
>              !arch_is_platform_page(base_addr)))
>                 return -EINVAL;
>
>

Applied as 5.20 material, thanks!
