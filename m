Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428DB2107
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 17:01:48 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5028F280236;
	Wed,  7 Dec 2022 17:53:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1670432028; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=Fd9owE0M0AMh/gPHes5KTqqFXaIkb5Vj2avnF3sKQ1E=;
	b=Ih6JIUE2lJuDDvGrjuqPNzW+X+ngnKX/YAV+Mw9EWqNAST5PPSbtR3mM5fs4a+AyCMO+Ie
	FE+2mWDmvTxLvu7QsKXpVXxyApay3HCT23WY60tU5FXHrftazLxcmB/6fop2AAAuupEpvN
	QScr7HAyMTtVuPbYKJ/bO+f4tfgF5O8dg7a7N2ZOzDXX5Lh22PM+FdIcLGXID/xFSpkvg3
	yqFzQGkMilZW7fgYjM6SUrjSwt/PndIuR23J/8s4o9LgvlpkTyf11WQuKJUZcUsvO1xagZ
	v4QUKX2M5fZ/y5edf2Sr+KRKHxRplw6E+RkxkW75c+ZNRg1ieDBxgB4xIsjM6g==
Message-ID: <36d27afc-bee8-127d-12d1-31c0a5dcda4e@cachyos.org>
Date: Wed, 7 Dec 2022 17:53:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] module/decompress: Support zstd in-kernel decompression
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-modules@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Piotr Gorski <lucjan.lucjanov@gmail.com>, Nick Terrell <terrelln@fb.com>
References: <20221206215318.3955400-1-swboyd@chromium.org>
From: Piotr Gorski <piotrgorski@cachyos.org>
In-Reply-To: <20221206215318.3955400-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Reviewed-by: Piotr Gorski <lucjan.lucjanov@gmail.com>

> Add support for zstd compressed modules to the in-kernel decompression
> code. This allows zstd compressed modules to be decompressed by the
> kernel, similar to the existing support for gzip and xz compressed
> modules.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Piotr Gorski <lucjan.lucjanov@gmail.com>
> Cc: Nick Terrell <terrelln@fb.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   kernel/module/Kconfig      |  3 +-
>   kernel/module/decompress.c | 92 +++++++++++++++++++++++++++++++++++++-
>   2 files changed, 92 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/module/Kconfig b/kernel/module/Kconfig
> index 26ea5d04f56c..424b3bc58f3f 100644
> --- a/kernel/module/Kconfig
> +++ b/kernel/module/Kconfig
> @@ -221,9 +221,10 @@ endchoice
>   
>   config MODULE_DECOMPRESS
>   	bool "Support in-kernel module decompression"
> -	depends on MODULE_COMPRESS_GZIP || MODULE_COMPRESS_XZ
> +	depends on MODULE_COMPRESS_GZIP || MODULE_COMPRESS_XZ || MODULE_COMPRESS_ZSTD
>   	select ZLIB_INFLATE if MODULE_COMPRESS_GZIP
>   	select XZ_DEC if MODULE_COMPRESS_XZ
> +	select ZSTD_DECOMPRESS if MODULE_COMPRESS_ZSTD
>   	help
>   
>   	  Support for decompressing kernel modules by the kernel itself
> diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
> index c033572d83f0..44f14643d014 100644
> --- a/kernel/module/decompress.c
> +++ b/kernel/module/decompress.c
> @@ -50,7 +50,7 @@ static struct page *module_get_next_page(struct load_info *info)
>   	return page;
>   }
>   
> -#ifdef CONFIG_MODULE_COMPRESS_GZIP
> +#if defined(CONFIG_MODULE_COMPRESS_GZIP)
>   #include <linux/zlib.h>
>   #define MODULE_COMPRESSION	gzip
>   #define MODULE_DECOMPRESS_FN	module_gzip_decompress
> @@ -141,7 +141,7 @@ static ssize_t module_gzip_decompress(struct load_info *info,
>   	kfree(s.workspace);
>   	return retval;
>   }
> -#elif CONFIG_MODULE_COMPRESS_XZ
> +#elif defined(CONFIG_MODULE_COMPRESS_XZ)
>   #include <linux/xz.h>
>   #define MODULE_COMPRESSION	xz
>   #define MODULE_DECOMPRESS_FN	module_xz_decompress
> @@ -199,6 +199,94 @@ static ssize_t module_xz_decompress(struct load_info *info,
>   	xz_dec_end(xz_dec);
>   	return retval;
>   }
> +#elif defined(CONFIG_MODULE_COMPRESS_ZSTD)
> +#include <linux/zstd.h>
> +#define MODULE_COMPRESSION	zstd
> +#define MODULE_DECOMPRESS_FN	module_zstd_decompress
> +
> +static ssize_t module_zstd_decompress(struct load_info *info,
> +				    const void *buf, size_t size)
> +{
> +	static const u8 signature[] = { 0x28, 0xb5, 0x2f, 0xfd };
> +	ZSTD_outBuffer zstd_dec;
> +	ZSTD_inBuffer zstd_buf;
> +	zstd_frame_header header;
> +	size_t wksp_size;
> +	void *wksp = NULL;
> +	ZSTD_DStream *dstream;
> +	size_t ret;
> +	size_t new_size = 0;
> +	int retval;
> +
> +	if (size < sizeof(signature) ||
> +	    memcmp(buf, signature, sizeof(signature))) {
> +		pr_err("not a zstd compressed module\n");
> +		return -EINVAL;
> +	}
> +
> +	zstd_buf.src = buf;
> +	zstd_buf.pos = 0;
> +	zstd_buf.size = size;
> +
> +	ret = zstd_get_frame_header(&header, zstd_buf.src, zstd_buf.size);
> +	if (ret != 0) {
> +		pr_err("ZSTD-compressed data has an incomplete frame header\n");
> +		retval = -EINVAL;
> +		goto out;
> +	}
> +	if (header.windowSize > (1 << ZSTD_WINDOWLOG_MAX)) {
> +		pr_err("ZSTD-compressed data has too large a window size\n");
> +		retval = -EINVAL;
> +		goto out;
> +	}
> +
> +	wksp_size = zstd_dstream_workspace_bound(header.windowSize);
> +	wksp = kmalloc(wksp_size, GFP_KERNEL);
> +	if (!wksp) {
> +		retval = -ENOMEM;
> +		goto out;
> +	}
> +
> +	dstream = zstd_init_dstream(header.windowSize, wksp, wksp_size);
> +	if (!dstream) {
> +		pr_err("Can't initialize ZSTD stream\n");
> +		retval = -ENOMEM;
> +		goto out;
> +	}
> +
> +	do {
> +		struct page *page = module_get_next_page(info);
> +
> +		if (!IS_ERR(page)) {
> +			retval = PTR_ERR(page);
> +			goto out;
> +		}
> +
> +		zstd_dec.dst = kmap_local_page(page);
> +		zstd_dec.pos = 0;
> +		zstd_dec.size = PAGE_SIZE;
> +
> +		ret = zstd_decompress_stream(dstream, &zstd_dec, &zstd_buf);
> +		kunmap(page);
> +		retval = zstd_get_error_code(ret);
> +		if (retval)
> +			break;
> +
> +		new_size += zstd_dec.pos;
> +	} while (zstd_dec.pos == PAGE_SIZE && ret != 0);
> +
> +	if (retval) {
> +		pr_err("ZSTD-decompression failed with status %d\n", retval);
> +		retval = -EINVAL;
> +		goto out;
> +	}
> +
> +	retval = new_size;
> +
> + out:
> +	kfree(wksp);
> +	return retval;
> +}
>   #else
>   #error "Unexpected configuration for CONFIG_MODULE_DECOMPRESS"
>   #endif
>
> base-commit: 76dcd734eca23168cb008912c0f69ff408905235
