Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B50719F
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 00:07:19 +0000 (UTC)
Received: from [10.0.0.178] (c-76-135-56-23.hsd1.wa.comcast.net [76.135.56.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id AA1D320B74C0;
	Mon, 25 Sep 2023 17:07:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AA1D320B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1695686839;
	bh=QZodBqGHLOewJOW6wRe5geNAIIU82UjzOMXe88tfjPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kmTYP0lWHcekOyaKUSaNB5IUOvjE7JowCi4cvfizTGz5XrByutoXC7Nn8iodtOL5S
	 yd0NXd+7/jOmpmxv4AqC5GfNM9SbURuMj6c6nmdV1ClKyUL8JX7CCgIEW3ISjk295x
	 lAKUsxfmyJul+OZjhzVhc6tGwAGW9CQByXb1DnKY=
Message-ID: <e235025e-abfa-4b31-8b83-416ec8ec4f72@linux.microsoft.com>
Date: Mon, 25 Sep 2023 17:07:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/15] Drivers: hv: Add modules to expose /dev/mshv to
 VMMs running on Hyper-V
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-arch@vger.kernel.org, patches@lists.linux.dev, mikelley@microsoft.com,
 kys@microsoft.com, wei.liu@kernel.org, haiyangz@microsoft.com,
 decui@microsoft.com, apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
 ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
 stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
 vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
 catalin.marinas@arm.com
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1695407915-12216-16-git-send-email-nunodasneves@linux.microsoft.com>
 <2023092342-staunch-chafe-1598@gregkh>
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <2023092342-staunch-chafe-1598@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Resend in plain text instead of HTML - oops!

On 9/23/2023 12:58 AM, Greg KH wrote:
> On Fri, Sep 22, 2023 at 11:38:35AM -0700, Nuno Das Neves wrote:
>> +static int mshv_vtl_get_vsm_regs(void)
>> +{
>> +	struct hv_register_assoc registers[2];
>> +	union hv_input_vtl input_vtl;
>> +	int ret, count = 2;
>> +
>> +	input_vtl.as_uint8 = 0;
>> +	registers[0].name = HV_REGISTER_VSM_CODE_PAGE_OFFSETS;
>> +	registers[1].name = HV_REGISTER_VSM_CAPABILITIES;
>> +
>> +	ret = hv_call_get_vp_registers(HV_VP_INDEX_SELF, HV_PARTITION_ID_SELF,
>> +				       count, input_vtl, registers);
>> +	if (ret)
>> +		return ret;
>> +
>> +	mshv_vsm_page_offsets.as_uint64 = registers[0].value.reg64;
>> +	mshv_vsm_capabilities.as_uint64 = registers[1].value.reg64;
>> +
>> +	pr_debug("%s: VSM code page offsets: %#016llx\n", __func__,
>> +		 mshv_vsm_page_offsets.as_uint64);
>> +	pr_info("%s: VSM capabilities: %#016llx\n", __func__,
>> +		mshv_vsm_capabilities.as_uint64);
> 
> When drivers are working properly, they are quiet.  This is very noisy
> and probably is leaking memory addresses to userspace?
> 

I will remove these, thanks.

> Also, there is NEVER a need for __func__ in a pr_debug() line, it has
> that for you automatically.
> 

Thank you, I didn't know this.

> Also, drivers should never call pr_*() calls, always use the proper
> dev_*() calls instead.
> 

We only use struct device in one place in this driver, I think that is 
the only place it makes sense to use dev_*() over pr_*() calls.
> 
> 
>> +
>> +	return ret;
>> +}
>> +
>> +static int mshv_vtl_configure_vsm_partition(void)
>> +{
>> +	union hv_register_vsm_partition_config config;
>> +	struct hv_register_assoc reg_assoc;
>> +	union hv_input_vtl input_vtl;
>> +
>> +	config.as_u64 = 0;
>> +	config.default_vtl_protection_mask = HV_MAP_GPA_PERMISSIONS_MASK;
>> +	config.enable_vtl_protection = 1;
>> +	config.zero_memory_on_reset = 1;
>> +	config.intercept_vp_startup = 1;
>> +	config.intercept_cpuid_unimplemented = 1;
>> +
>> +	if (mshv_vsm_capabilities.intercept_page_available) {
>> +		pr_debug("%s: using intercept page", __func__);
> 
> Again, __func__ is not needed, you are providing it twice here for no
> real reason except to waste storage space :)
> 

Thanks, I will review all the uses of pr_debug().

>> +		config.intercept_page = 1;
>> +	}
>> +
>> +	reg_assoc.name = HV_REGISTER_VSM_PARTITION_CONFIG;
>> +	reg_assoc.value.reg64 = config.as_u64;
>> +	input_vtl.as_uint8 = 0;
>> +
>> +	return hv_call_set_vp_registers(HV_VP_INDEX_SELF, HV_PARTITION_ID_SELF,
>> +				       1, input_vtl, &reg_assoc);
> 
> 
> None of this needs to be unwound if initialization fails later on?
> 

I think unwinding this is not needed, not 100% sure.
Saurabh, can you comment?

Thanks,
Nuno

> thanks,
> 
> greg k-h

