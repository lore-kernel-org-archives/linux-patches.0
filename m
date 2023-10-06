Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5201C296
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QJJ4JElM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696588258; x=1728124258;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=XqzqC3u6ICreoTyLjbtbD1a0rx/MReQVULfRZwZtusQ=;
  b=QJJ4JElM2sFc0WJEZr9LHgPBGhfruFdbB7bZZrtrpSg55CXZ43D1ZbyD
   xNsWC4IM1nL/1j/jpDRPruP8mX1aNGv3tXFmUJEAJYGSzoauLd2DILzhJ
   /zBqmx6tvGher0IpEG4VkbitPyYgy/EfYx5853qfaEd+FcRv9pKD+3JMr
   DTI+nXUHD5G0GaOblI51PVYOPXNTzTfSNM4U1InfCdbZ68I2tut1Fiz2D
   NwT6CC2jSjYwFtgj5sMHxyP0gU/T5jjkOKNtWQ/uk6zS1w40Y1AxxE4tb
   oFAp1y/38ryPNDdnzZvUfKW0k8S/8E78pNCX4Sp45wZySs7GOLYEVZN8F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="469993913"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="469993913"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 03:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="822459341"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="822459341"
Received: from srab-mobl1.ger.corp.intel.com ([10.252.43.69])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 03:30:37 -0700
Date: Fri, 6 Oct 2023 13:30:33 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v4 9/9] platform/x86/intel/ifs: ARRAY BIST for Sierra
 Forest
In-Reply-To: <20231005195137.3117166-10-jithu.joseph@intel.com>
Message-ID: <34d7c827-4437-93c6-4c72-8b9b0c5f988@linux.intel.com>
References: <20230929202436.2850388-1-jithu.joseph@intel.com> <20231005195137.3117166-1-jithu.joseph@intel.com> <20231005195137.3117166-10-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 5 Oct 2023, Jithu Joseph wrote:

> Array BIST MSR addresses, bit definition and semantics are different for
> Sierra Forest. Branch into a separate Array BIST flow on Sierra Forest
> when user invokes Array Test.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> ---
>  drivers/platform/x86/intel/ifs/ifs.h     |  7 +++++
>  drivers/platform/x86/intel/ifs/core.c    | 15 +++++-----
>  drivers/platform/x86/intel/ifs/runtest.c | 37 +++++++++++++++++++++++-
>  3 files changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index f0dd849b3400..2dd5e3406dac 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -137,6 +137,8 @@
>  #define MSR_CHUNKS_AUTHENTICATION_STATUS	0x000002c5
>  #define MSR_ACTIVATE_SCAN			0x000002c6
>  #define MSR_SCAN_STATUS				0x000002c7
> +#define MSR_ARRAY_TRIGGER			0x000002d6
> +#define MSR_ARRAY_STATUS			0x000002d7
>  #define MSR_SAF_CTRL				0x000004f0
>  
>  #define SCAN_NOT_TESTED				0
> @@ -146,6 +148,9 @@
>  #define IFS_TYPE_SAF			0
>  #define IFS_TYPE_ARRAY_BIST		1
>  
> +#define ARRAY_GEN_0			0
> +#define ARRAY_GEN_1			1

Thank you for your contribution. I've applied this series to my local 
review-ilpo branch.

I ended up renaming these defines ARRAY_GEN_* -> ARRAY_GEN* to make
them more consistent.

-- 
 i.

