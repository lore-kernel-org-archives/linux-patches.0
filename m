Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D532137B
	for <patches@lists.linux.dev>; Mon, 25 Sep 2023 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695656615; x=1727192615;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=KBtV9Wt5TwMqqcq4D9cO2jjNjTy6l+lb5oWWBcyEU1Q=;
  b=WcYOJDyU0UruY2LtcuMjfyh7DHEQd4uQspKtsRzFc72gsKlq0V96eDHN
   Lo/x56aR9Q/eANsjFno47oSShCEL6Rpj6Mg1uQLYzJ3tKEkYgCacKI8NJ
   YCO/oJ4tKMw0njw6AWdkMoWXnXfwozUFoGMTISFSPl6EMVxmPQxy6USVf
   5kpsNZUUpqtGOogbiZkr0m5u9SUBLu0SJkjnKaUkQgVfJNpsvniizJ80G
   +7SD9sW9iMojFDq5YinQQMnK/syY+DSpmoG+8GM9FQpbFzGNNYIOmaB0Q
   bzxwOoFhz4kr5JpF6tpvv9oXQZ4je2FBQR+Yi1kpZ0PrgSANtKbPu3JDg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="361536154"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="361536154"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 08:43:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="872090067"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="872090067"
Received: from stamengx-mobl1.ger.corp.intel.com ([10.249.32.149])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 08:43:27 -0700
Date: Mon, 25 Sep 2023 18:43:24 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v2 5/9] platform/x86/intel/ifs: Validate image size
In-Reply-To: <20230922232606.1928026-6-jithu.joseph@intel.com>
Message-ID: <318e7426-fcab-c1e4-6e84-752c332088f2@linux.intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com> <20230922232606.1928026-1-jithu.joseph@intel.com> <20230922232606.1928026-6-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 22 Sep 2023, Jithu Joseph wrote:

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
> index 6b827247945b..b09106034fac 100644
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
> +		return -EBADFD;

I don't think this error code is best suited for what occurred. I guess 
returning just -EINVAL would be fine.

-- 
 i.

> +	}
> +
>  	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
>  	if (ret)
>  		goto release;
> 
