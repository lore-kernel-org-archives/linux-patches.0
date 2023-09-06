Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57201079A
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 20:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694031670; x=1725567670;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3kMW/s9vc1JzXHZ7uyADzsTe7V4Y9mN4qtrmBkPH9GE=;
  b=CzxbEVdfKkENWcS4tEoGULXYNHFyGPH1O+MnLK4DAEKOxI3sEiSsy34R
   LkLQ0IwgE4L8y0D+89Lu3XtbZV1ljFcBdgJpBnUi9YM5TT3y9oao9thgJ
   owOczD8ymQVMIX6OuqMie2qR47wjoYu/mjyBp87lBauTiTGSPAooUzur2
   cf+2Xaxf9GeBIgCI4c5LLac+MVu7JE66A6EidvbvAIcJSLTKgdf8xczl7
   PxUKGQiTF9zbXLzb33nKhlrjQAmdUClIwZNtRICBWqh2OEUUc3r03chaD
   LX6UP46RRW3gsWJkxmvVvpb43/bBFc49AubATnhy6yo6pd0x4YCXrP+Dd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="380968207"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="380968207"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 13:20:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="744813919"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="744813919"
Received: from jseong-mobl45.amr.corp.intel.com (HELO [10.209.51.7]) ([10.209.51.7])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 13:20:48 -0700
Message-ID: <1248ebb9-ff14-418a-ae01-cfa5c8ca9d68@linux.intel.com>
Date: Wed, 6 Sep 2023 13:20:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
 Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, Prashant Malani <pmalani@chromium.org>
References: <20230906180944.2197111-1-swboyd@chromium.org>
 <20230906180944.2197111-2-swboyd@chromium.org>
 <ZPjbZqIQBlIGpoCK@smile.fi.intel.com>
 <CAE-0n52REGuVrqG8LUdWzjgqAun7uvDFPJeSkjX02OxD=fUhqg@mail.gmail.com>
From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <CAE-0n52REGuVrqG8LUdWzjgqAun7uvDFPJeSkjX02OxD=fUhqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/6/2023 1:14 PM, Stephen Boyd wrote:
> Quoting Andy Shevchenko (2023-09-06 13:04:54)
>> On Wed, Sep 06, 2023 at 11:09:41AM -0700, Stephen Boyd wrote:
>>> It's possible for the polling loop in busy_loop() to get scheduled away
>>> for a long time.
>>>
>>>   status = ipc_read_status(scu); // status = IPC_STATUS_BUSY
>>>   <long time scheduled away>
>>>   if (!(status & IPC_STATUS_BUSY))
>>>
>>> If this happens, then the status bit could change while the task is
>>> scheduled away and this function would never read the status again after
>>> timing out. Instead, the function will return -ETIMEDOUT when it's
>>> possible that scheduling didn't work out and the status bit was cleared.
>>> Bit polling code should always check the bit being polled one more time
>>> after the timeout in case this happens.
>>>
>>> Fix this by reading the status once more after the while loop breaks.
>>
>> ...
>>
>>>  static inline int busy_loop(struct intel_scu_ipc_dev *scu)
>>>  {
>>>       unsigned long end = jiffies + IPC_TIMEOUT;
>>> +     u32 status;
>>>
>>>       do {
>>> -             u32 status;
>>> -
>>>               status = ipc_read_status(scu);
>>>               if (!(status & IPC_STATUS_BUSY))
>>
>>> -                     return (status & IPC_STATUS_ERR) ? -EIO : 0;
>>> +                     goto not_busy;
>>
>> Wouldn't simple 'break' suffice here?
> 
> Yes, at the cost of reading the status again when it isn't busy, or
> checking the busy bit after the loop breaks out and reading it once
> again when it is busy. I suppose the compiler would figure that out and
> optimize so that break would simply goto the return statement.
> 
> The code could look like this without a goto.
> 
> 	do {
> 		status = ipc_read_status(scu);
> 		if (!(status & IPC_STATUS_BUSY))
> 			break;
> 	} while (time_before(jiffies, end));
> 
> 	if (status & IPC_STATUS_BUSY)
> 		status = ipc_read_status(scu);

IMO, you can remove the if condition and read again the status in all cases.
It is more readable. But it is up to you.

/* Always read again to double check and get the latest status */
status = ipc_read_status(scu);

> 
> 	if (status & IPC_STATUS_BUSY)
> 		return -ETIMEDOUT;
> 	
> 	return (status & IPC_STATUS_ERR) ? -EIO : 0;

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
