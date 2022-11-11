Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1F724F35
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 16:16:56 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e727329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e727:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 47D7E1EC042F;
	Fri, 11 Nov 2022 17:16:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668183414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=eMsQDKWlL6uraJj5HUJ5zGvCAF7tvNGuIrG9jb/77bQ=;
	b=VyMmcjUcFzrEj87XvYgjPWlJQ/nyBUi8rvS6Ssa/rQLLvz5ySP90o3+lLi470c2UGCJH4Q
	XHMNVCYWD8K8q5Bdj+yxPeozoc4uL0Sna1f5+BEWGNiCz8qNA230r0nmeJxcwutsJB+XOh
	w1RL933kcSGlhMUDsr4IHlBsuIY72JE=
Date: Fri, 11 Nov 2022 17:16:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
Subject: Re: [PATCH v2 08/14] platform/x86/intel/ifs: Add metadata support
Message-ID: <Y251cGhb+x7Lqk9W@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-9-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221107225323.2733518-9-jithu.joseph@intel.com>

On Mon, Nov 07, 2022 at 02:53:17PM -0800, Jithu Joseph wrote:
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index 89ce265887ea..60ba5a057f91 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -44,6 +44,38 @@ static const char * const scan_authentication_status[] = {
>  	[2] = "Chunk authentication error. The hash of chunk did not match expected value"
>  };
>  
> +#define META_TYPE_END		(0)

MC_HEADER_META_TYPE_END

> +
> +struct metadata_header {
> +	unsigned int		type;
> +	unsigned int		blk_size;
> +};
> +
> +static struct metadata_header *ifs_find_meta_data(void *ucode, unsigned int meta_type)

It's a static function - no need for the ifs_ prefix.

> +{
> +	struct metadata_header *meta_header;
> +	unsigned long data_size, total_meta;
> +	unsigned long meta_size = 0;
> +
> +	data_size = get_datasize(ucode);
> +	total_meta = ((struct microcode_intel *)ucode)->hdr.metasize;
> +


^ Superfluous newline.

> +	if (!total_meta)
> +		return NULL;
> +
> +	meta_header = (ucode + MC_HEADER_SIZE + data_size) - total_meta;
> +
> +	while ((meta_header->type != META_TYPE_END) && meta_header->blk_size &&

You don't need the brackets.

> +	       meta_size < total_meta) {

And you can align all three conditions vertically for better readability:

        while (meta_header->type != META_TYPE_END && 
               meta_header->blk_size &&
               meta_size < total_meta) {

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
