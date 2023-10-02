Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BB8883E
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 11:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696247463; x=1727783463;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=5jRlI7Om0cVUdpbhJuCnbv244tLYqa2yEKAiKz+E9FM=;
  b=HxTUuytMffSxDAih71YcGb7igjfLYUkk2i2j3rpuNDHbLvCXjcCj2zYV
   8EWSCps9R39WQT2quUgyo7W8iVmg/9d2MGOfmWCdXyS0PTiGkT1/didfw
   POKzRaD3Ok35oQlXRhMhwWuiD/VQtGNnTQObQVx/zPWoo25UoNA5IAI7s
   rlUXY3oJvF1gSZWaRo4vHDAPVUomnVp3Gn698b9HBkWG0OafBm6aOaUmu
   +p4PGY+zqyDDoCYy4JB+UJmv3zRnBxf3dNhtK3to/SzWekvA3rngPCHNg
   DncgDgSb20sveR3OSar4n+nWEM6FruAhBsEFUnN5FvP6405YHPPxZhJjw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="362003542"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="362003542"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:51:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="750558998"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="750558998"
Received: from roliveir-mobl1.ger.corp.intel.com ([10.251.222.16])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:50:58 -0700
Date: Mon, 2 Oct 2023 14:50:55 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v3 5/9] platform/x86/intel/ifs: Validate image size
In-Reply-To: <f5a560b6-3410-f4bd-479c-c9ebec7fdc63@linux.intel.com>
Message-ID: <b3ae7831-9634-ee63-c0a9-baad59b6fabf@linux.intel.com>
References: <20230922232606.1928026-1-jithu.joseph@intel.com> <20230929202436.2850388-1-jithu.joseph@intel.com> <20230929202436.2850388-6-jithu.joseph@intel.com> <f5a560b6-3410-f4bd-479c-c9ebec7fdc63@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-222638547-1696247462=:2459"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-222638547-1696247462=:2459
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 2 Oct 2023, Ilpo Järvinen wrote:

> On Fri, 29 Sep 2023, Jithu Joseph wrote:
> 
> > Perform additional validation prior to loading IFS image.
> > 
> > Error out if the size of the file being loaded doesn't match the size
> > specified in the header.
> > 
> > Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> > ---
> >  drivers/platform/x86/intel/ifs/load.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> > index 6b827247945b..da54fd060878 100644
> > --- a/drivers/platform/x86/intel/ifs/load.c
> > +++ b/drivers/platform/x86/intel/ifs/load.c
> > @@ -375,6 +375,7 @@ int ifs_load_firmware(struct device *dev)
> >  {
> >  	const struct ifs_test_caps *test = ifs_get_test_caps(dev);
> >  	struct ifs_data *ifsd = ifs_get_data(dev);
> > +	unsigned int expected_size;
> >  	const struct firmware *fw;
> >  	char scan_path[64];
> >  	int ret = -EINVAL;
> > @@ -389,6 +390,13 @@ int ifs_load_firmware(struct device *dev)
> >  		goto done;
> >  	}
> >  
> > +	expected_size = ((struct microcode_header_intel *)fw->data)->totalsize;
> > +	if (fw->size != expected_size) {
> > +		dev_err(dev, "File size mismatch (expected %d, actual %ld). Corrupted IFS image.\n",
> > +			expected_size, fw->size);
> > +		return -EINVAL;
> > +	}
> > +
> >  	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
> >  	if (ret)
> >  		goto release;
> > 
> 
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

Just after sending the rev-by, I realized this also has %d vs unsigned int
problem, and %ld should be using %zu as fw->size of size_t.

Feel free to add my rev-by after those two problems have been fixed.

-- 
 i.

--8323329-222638547-1696247462=:2459--
