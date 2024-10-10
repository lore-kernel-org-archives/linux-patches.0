Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFB51C2DBF
	for <patches@lists.linux.dev>; Thu, 10 Oct 2024 11:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728558356; cv=none; b=deNqX7vpbL0S2fvGeshVWE4i7b4gGn6N8KUDBgEXkluPiZ+A/+fIcBXF5bnTTY8qJJHE5NEo/2q/qB95aET8iRhNQMdS97A/axSKx10flutMN9qBgwVwLja+Bnr9cJnOXUugj0lfQKD8/1hWUIPyIDj3xFOdUbwDHT5IaGX0hV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728558356; c=relaxed/simple;
	bh=XkpZRgKc5lIvmH6H7fWaP8xWy9kk6ZsUYwNYQkPNdI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyhrnoWkTpyAghaBwdM6hRW7gjgUTtE6HBZoQdc+i6yYY5mVmkhbbdQsjf9njiwE8BIrwh7iCYgaVDDcrJwP3nzCusvoZxrM1Z6ADHZAIHTJlXHUm42Z3/ywE4QqTkoN1f/hFgaKuqJexDoT3wyJR0NTmSe69Ne+Q0B6WueGAIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 582DB497;
	Thu, 10 Oct 2024 04:06:23 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1ECE93F58B;
	Thu, 10 Oct 2024 04:05:51 -0700 (PDT)
Date: Thu, 10 Oct 2024 12:05:49 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	David Gow <davidgow@google.com>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] of: Skip kunit tests when arm64+ACPI doesn't populate
 root node
Message-ID: <Zwe1DWPOsM2buAs1@J2N7QTR9R3>
References: <20241009204133.1169931-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009204133.1169931-1-sboyd@kernel.org>

On Wed, Oct 09, 2024 at 01:41:31PM -0700, Stephen Boyd wrote:
> A root node is required to apply DT overlays. A root node is usually
> present after commit 7b937cc243e5 ("of: Create of_root if no dtb
> provided by firmware"), except for on arm64 systems booted with ACPI
> tables. In that case, the root node is intentionally not populated
> because it would "allow DT devices to be instantiated atop an ACPI base
> system"[1].
> 
> Introduce an OF function that skips the kunit test if the root node
> isn't populated. Limit the test to when both CONFIG_ARM64 and
> CONFIG_ACPI are set, because otherwise the lack of a root node is a bug.
> Make the function private and take a kunit test parameter so that it
> can't be abused to test for the presence of the root node in non-test
> code.
> 
> Use this function to skip tests that require the root node. Currently
> that's the DT tests and any tests that apply overlays.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/r/6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net
> Link: https://lore.kernel.org/r/Zd4dQpHO7em1ji67@FVFF77S0Q05N.cambridge.arm.com [1]
> Fixes: 893ecc6d2d61 ("of: Add KUnit test to confirm DTB is loaded")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  drivers/of/of_kunit_helpers.c | 15 +++++++++++++++
>  drivers/of/of_private.h       |  3 +++
>  drivers/of/of_test.c          |  3 +++
>  drivers/of/overlay_test.c     |  3 +++
>  4 files changed, 24 insertions(+)
> 
> diff --git a/drivers/of/of_kunit_helpers.c b/drivers/of/of_kunit_helpers.c
> index 287d6c91bb37..7b3ed5a382aa 100644
> --- a/drivers/of/of_kunit_helpers.c
> +++ b/drivers/of/of_kunit_helpers.c
> @@ -10,6 +10,19 @@
>  #include <kunit/test.h>
>  #include <kunit/resource.h>
>  
> +#include "of_private.h"
> +
> +/**
> + * of_root_kunit_skip() - Skip test if the root node isn't populated
> + * @test: test to skip if the root node isn't populated
> + */
> +void of_root_kunit_skip(struct kunit *test)
> +{
> +	if (IS_ENABLED(CONFIG_ARM64) && IS_ENABLED(CONFIG_ACPI) && !of_root)
> +		kunit_skip(test, "arm64+acpi doesn't populate a root node");
> +}
> +EXPORT_SYMBOL_GPL(of_root_kunit_skip);
> +
>  #if defined(CONFIG_OF_OVERLAY) && defined(CONFIG_OF_EARLY_FLATTREE)
>  
>  static void of_overlay_fdt_apply_kunit_exit(void *ovcs_id)
> @@ -36,6 +49,8 @@ int of_overlay_fdt_apply_kunit(struct kunit *test, void *overlay_fdt,
>  	int ret;
>  	int *copy_id;
>  
> +	of_root_kunit_skip(test);
> +
>  	copy_id = kunit_kmalloc(test, sizeof(*copy_id), GFP_KERNEL);
>  	if (!copy_id)
>  		return -ENOMEM;
> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
> index 04aa2a91f851..c235d6c909a1 100644
> --- a/drivers/of/of_private.h
> +++ b/drivers/of/of_private.h
> @@ -42,6 +42,9 @@ extern raw_spinlock_t devtree_lock;
>  extern struct list_head aliases_lookup;
>  extern struct kset *of_kset;
>  
> +struct kunit;
> +extern void of_root_kunit_skip(struct kunit *test);
> +
>  #if defined(CONFIG_OF_DYNAMIC)
>  extern int of_property_notify(int action, struct device_node *np,
>  			      struct property *prop, struct property *old_prop);
> diff --git a/drivers/of/of_test.c b/drivers/of/of_test.c
> index c85a258bc6ae..b0557ded838f 100644
> --- a/drivers/of/of_test.c
> +++ b/drivers/of/of_test.c
> @@ -7,6 +7,8 @@
>  
>  #include <kunit/test.h>
>  
> +#include "of_private.h"
> +
>  /*
>   * Test that the root node "/" can be found by path.
>   */
> @@ -36,6 +38,7 @@ static struct kunit_case of_dtb_test_cases[] = {
>  
>  static int of_dtb_test_init(struct kunit *test)
>  {
> +	of_root_kunit_skip(test);
>  	if (!IS_ENABLED(CONFIG_OF_EARLY_FLATTREE))
>  		kunit_skip(test, "requires CONFIG_OF_EARLY_FLATTREE");
>  
> diff --git a/drivers/of/overlay_test.c b/drivers/of/overlay_test.c
> index 19a292cdeee3..7cbf9a472111 100644
> --- a/drivers/of/overlay_test.c
> +++ b/drivers/of/overlay_test.c
> @@ -11,6 +11,8 @@
>  #include <kunit/of.h>
>  #include <kunit/test.h>
>  
> +#include "of_private.h"
> +
>  static const char * const kunit_node_name = "kunit-test";
>  static const char * const kunit_compatible = "test,empty";
>  
> @@ -62,6 +64,7 @@ static void of_overlay_apply_kunit_cleanup(struct kunit *test)
>  	struct device *dev;
>  	struct device_node *np;
>  
> +	of_root_kunit_skip(test);
>  	if (!IS_ENABLED(CONFIG_OF_EARLY_FLATTREE))
>  		kunit_skip(test, "requires CONFIG_OF_EARLY_FLATTREE for root node");
>  
> 
> base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
> -- 
> https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
> https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git
> 
