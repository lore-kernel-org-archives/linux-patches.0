Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50028980F;
	Fri, 19 Jun 2026 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781880103; cv=none; b=lTPImJchFNZeRwwbiyPOqbDIwHeGH8Zk4Vo0UEfOdV4QKZAGKTVaas+/LaDtVt9ses5ieqCDrH7yRJZuah0qP3zbyKXHgVs2QZnahaZbK8dk8474mEq17g2S/TP2JMutK+y3VzKzF4rFY5TK5fyfARc1SC7O9iB2IV8BupSYuaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781880103; c=relaxed/simple;
	bh=K9IKWSIGlS34gxiEbPaL4E5x6wsl47KVizn0XF4Obfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIIcAFazex+KXe0VTgfFySRnQ4wakHXkRRwO+dYbgwGS8gy3pl5WhQftvJD5VgT/dfS6AfCjY4RTxRy1HintISrD5jCljgleRwNogruNiGf+IITINur2/ZEAelUGIOL4QpBVLoprlc9HbhaACYWRLh6/K2nDd6R+swg5169kmAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3941F000E9;
	Fri, 19 Jun 2026 14:41:39 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: jgg@nvidia.com
Cc: airlied@gmail.com,
	christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	jani.nikula@linux.intel.com,
	joonas.lahtinen@linux.intel.com,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	patches@lists.linux.dev,
	rodrigo.vivi@intel.com,
	simona@ffwll.ch,
	sumit.semwal@linaro.org,
	tursulin@ursulin.net,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	kunit-dev@googlegroups.com
Subject: Re: [PATCH 1/5] dma-buf: Change st-dma-resv.c to use kunit
Date: Fri, 19 Jun 2026 16:41:37 +0200
Message-ID: <20260619144137.1582409-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <1-v1-0a349a394eff+14110-dmabuf_kunit_jgg@nvidia.com>
References: <1-v1-0a349a394eff+14110-dmabuf_kunit_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

	Hi Jason,

> Modernize the open coded test framework by using kunit.
> 
> The kunit tool can be used to build a kernel and run it in a VM with:
> 
> $ tools/testing/kunit/kunit.py run --build_dir build_kunit_x86_64 --arch x86_64 --kunitconfig ./drivers/dma-buf/.kunitconfig
> 
> Along with the other ways to run kunits.
> 
> To make the kunit tool work like this the DMABUF_KUNIT_TEST kconfig must
> select DMA_SHARED_BUFFER to get it turned on without building a driver
> using it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks for your patch, which is now commit 15b9bde78baddc27 ("dma-buf:
Change st-dma-resv.c to use kunit") upstream.

> --- /dev/null
> +++ b/drivers/dma-buf/.kunitconfig
> @@ -0,0 +1,2 @@
> +CONFIG_KUNIT=y
> +CONFIG_DMABUF_KUNIT_TEST=y
> diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
> index 8d4f2f89f24e3c..7d13c8f4484dd3 100644
> --- a/drivers/dma-buf/Kconfig
> +++ b/drivers/dma-buf/Kconfig
> @@ -54,6 +54,14 @@ config DMABUF_SELFTESTS
>  	default n
>  	depends on DMA_SHARED_BUFFER
>  
> +config DMABUF_KUNIT_TEST
> +	tristate "KUnit tests for DMA-BUF" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	select DMA_SHARED_BUFFER

This select means that enabling KUNIT_ALL_TESTS also enables extra
functionality, which may not be desirable in a production system.
Unfortunately DMA_SHARED_BUFFER is invisible, so just changing this from
"select" to "depends on" may not be the most desirable solution.

> +	default KUNIT_ALL_TESTS
> +	help
> +	   Enable kunit tests for DMA-BUF
> +
>  menuconfig DMABUF_HEAPS
>  	bool "DMA-BUF Userland Memory Heaps"
>  	select DMA_SHARED_BUFFER

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
