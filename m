Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B498E566
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 11:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696247155; x=1727783155;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=I3VMcrfrrzVRMP7tew8/AAjMaayozfUSJGNVjbPHSZI=;
  b=VGOr1ijLoqOlTyJ5V19upf+Ztb/Q5PnAS8weHpk6Es8LNqNQfnihiT3m
   yWIQJP2v6sXfQLFYGsYr51IqkUApXVtK34Q5QpORgadA57cw7WmgEP/Sj
   I7sMpPPgSQJ2kexB+HSE/7z9g6uTe7lrwJGhFH3eptSYfWy9CUP9A3xaE
   uxZpcfbSVyuZeKuThZq7dGxdMfbyZ9K0KP7CXcu80nS+/DiybjVsplIcl
   23HhNMY3sKonxQ5wQI4sH4u5aflu7gpITcyzWKZFk5OnB786tr7NLAgTt
   OzZbNWjscGUKhCWyZ/FoHsXKxvQLDncHSgTpd4eqym1YcK90JLBZ4DB1Z
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="413537595"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="413537595"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:45:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="816261582"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="816261582"
Received: from roliveir-mobl1.ger.corp.intel.com ([10.251.222.16])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:45:50 -0700
Date: Mon, 2 Oct 2023 14:45:47 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v3 5/9] platform/x86/intel/ifs: Validate image size
In-Reply-To: <20230929202436.2850388-6-jithu.joseph@intel.com>
Message-ID: <f5a560b6-3410-f4bd-479c-c9ebec7fdc63@linux.intel.com>
References: <20230922232606.1928026-1-jithu.joseph@intel.com> <20230929202436.2850388-1-jithu.joseph@intel.com> <20230929202436.2850388-6-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1671406893-1696247153=:2459"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1671406893-1696247153=:2459
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 29 Sep 2023, Jithu Joseph wrote:

> Perform additional validation prior to loading IFS image.
> 
> Error out if the size of the file being loaded doesn't match the size
> specified in the header.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> ---
>  drivers/platform/x86/intel/ifs/load.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index 6b827247945b..da54fd060878 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -375,6 +375,7 @@ int ifs_load_firmware(struct device *dev)
>  {
>  	const struct ifs_test_caps *test = ifs_get_test_caps(dev);
>  	struct ifs_data *ifsd = ifs_get_data(dev);
> +	unsigned int expected_size;
>  	const struct firmware *fw;
>  	char scan_path[64];
>  	int ret = -EINVAL;
> @@ -389,6 +390,13 @@ int ifs_load_firmware(struct device *dev)
>  		goto done;
>  	}
>  
> +	expected_size = ((struct microcode_header_intel *)fw->data)->totalsize;
> +	if (fw->size != expected_size) {
> +		dev_err(dev, "File size mismatch (expected %d, actual %ld). Corrupted IFS image.\n",
> +			expected_size, fw->size);
> +		return -EINVAL;
> +	}
> +
>  	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
>  	if (ret)
>  		goto release;
> 

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-1671406893-1696247153=:2459--
