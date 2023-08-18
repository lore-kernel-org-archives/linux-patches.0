Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D01360
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 00:17:45 +0000 (UTC)
Received: from [10.16.85.5] (unknown [131.107.8.5])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1FA82211F7C3;
	Thu, 17 Aug 2023 17:17:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1FA82211F7C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1692317865;
	bh=csV7ZACSrVEacKGzoMpSrcR2rZW6i0vHTyutS2HuYhQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GMcz4iOZDKGKi5T6TPN8LXOuLnZwfuhRF6slYzWNZ3CNDZt35mPHqto+WCDesTJOH
	 j3p+vlN0u5aHCvPgin5TWoVd7YDSDiEAc+lOgBQTOkxJBbT+MPqKunE0/nWs5+29Ba
	 7k6p4KRxwnb/O0P6f9w8vq3C5w6ln9q5ppo+HAf8=
Message-ID: <8161aa90-5535-4ef9-ad30-1655746a1053@linux.microsoft.com>
Date: Thu, 17 Aug 2023 17:17:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] mshyperv: Introduce
 numa_node_to_proximity_domain_info
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org
Cc: patches@lists.linux.dev, mikelley@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, haiyangz@microsoft.com, decui@microsoft.com,
 apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
 ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
 stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
 vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
 catalin.marinas@arm.com
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-4-git-send-email-nunodasneves@linux.microsoft.com>
 <3b1ca61c-fa3f-a802-6705-a8c1f37ad58f@intel.com>
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <3b1ca61c-fa3f-a802-6705-a8c1f37ad58f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/2023 4:22 PM, Dave Hansen wrote:
> On 8/17/23 15:01, Nuno Das Neves wrote:
>> +static inline union hv_proximity_domain_info
>> +numa_node_to_proximity_domain_info(int node)
>> +{
>> +	union hv_proximity_domain_info proximity_domain_info;
>> +
>> +	if (node != NUMA_NO_NODE) {
>> +		proximity_domain_info.domain_id = node_to_pxm(node);
>> +		proximity_domain_info.flags.reserved = 0;
>> +		proximity_domain_info.flags.proximity_info_valid = 1;
>> +		proximity_domain_info.flags.proximity_preferred = 1;
>> +	} else {
>> +		proximity_domain_info.as_uint64 = 0;
>> +	}
>> +
>> +	return proximity_domain_info;
>> +}
> 
> Pop quiz: What are the rules for the 30 bits of uninitialized data of
> proximity_domain_info.flags in the (node != NUMA_NO_NODE) case?
> 
> I actually don't know off the top of my head.  I generally avoid
> bitfields, but if they were normal stack-allocated variable space,
> they'd be garbage.

I'm not sure what you are getting at here - all the fields are
initialized.

> 
> I'd also *much* rather see the "as_uint64 = 0" coded up as a memset() or
> even explicitly zeroing all the same variables as the other half of the
> if().  As it stands, it's not 100% obvious that proximity_domain_info is
> 64 bits and that .as_uint64=0 zeroes the whole thing.  It *WOULD* be
> totally obvious if it were a memset().

I agree that it could be made clearer with memset().
Now that I'm thinking about it, hv_proximity_domain_info should really
just be a struct...then zeroing it is just:

	struct hv_proximity_domain_info proximity_domain_info = {};

and I can remove the else branch and zeroing the reserved bits.
