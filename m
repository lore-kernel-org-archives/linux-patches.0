Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB27E2F4D
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 20:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C48C385A9;
	Wed, 27 Apr 2022 20:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1651092765;
	bh=v307TXmNX7Dq2c5DVdjkniPVMOiPiXk6sD1IgSoBwuk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P9m+UfRC0IpQ/qL6+CZa0XyV1aGev8ss06l5wt3Yo2ywAQRD6OP06klVRAbABES23
	 N2Oi/mMC6KXz8eVr+GUoeKqkDgCD3YM+hptXm57Kaduc2pB5MwXp2P/shI0Nwr1ZL1
	 E08z7RTZdZxY1tyd/di4kcYEcLU5syNHhpzpn8fnNZT3ejRECInNUE98m+DgDZ91W6
	 /SOxVtJO58S/Xqw2Z5vIszx0U93UwjtzsZBk6V7liJHJ2sZEL4FrGIL1VqCZsgn+uU
	 h5CZnWI1yyF0PeSvJNSnrWD/2HBEcDyY7HdbPu8A+o0iBz6/jEWHvn8wz0Ypms0rmb
	 /qlh5sdvvsJGQ==
Message-ID: <38149635-26ee-ab02-7c69-c5dd5f64fab5@kernel.org>
Date: Wed, 27 Apr 2022 23:52:39 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] interconnect: Restore sync state by ignoring ipa-virt in
 provider count
Content-Language: en-US
To: Alex Elder <elder@linaro.org>, Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 Bjorn Andersson <bjorn.andersson@linaro.org>,
 Doug Anderson <dianders@chromium.org>, Taniya Das <quic_tdas@quicinc.com>,
 Mike Tipton <quic_mdtipton@quicinc.com>
References: <20220427013226.341209-1-swboyd@chromium.org>
 <fb1f9a17-9b27-b0ac-124d-66644851e204@linaro.org>
From: Georgi Djakov <djakov@kernel.org>
In-Reply-To: <fb1f9a17-9b27-b0ac-124d-66644851e204@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.04.22 15:00, Alex Elder wrote:
> On 4/26/22 8:32 PM, Stephen Boyd wrote:
>> Ignore compatible strings for the IPA virt drivers that were removed in
>> commits 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0
>> interconnects") and 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0
>> interconnects") so that the sync state logic can kick in again.
>> Otherwise all the interconnects in the system will stay pegged at max
>> speeds because 'providers_count' is always going to be one larger than
>> the number of drivers that will ever probe on sc7180 or sdx55. This
>> fixes suspend on sc7180 and sdx55 devices when you don't have a
>> devicetree patch to remove the ipa-virt compatible node.
>>
>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Cc: Doug Anderson <dianders@chromium.org>
>> Cc: Alex Elder <elder@linaro.org>
>> Cc: Taniya Das <quic_tdas@quicinc.com>
>> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
>> Fixes: 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0 interconnects")
>> Fixes: 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0 interconnects")
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> 
> So of_count_icc_providers() counts the number of
> interconnect providers defined in the DTB, regardless
> of whether anything in the code supports it.

Yes, that's the case currently. There could be multiple provider drivers
in different modules, and the modules may be loaded even not during boot,
but later. So we rely on DT.

Thanks,
Georgi

> This seems to be a more general problem, but I
> suppose in practice it's not likely to occur.
> 
> I think your solution looks fine, but I'm interested
> in what Georgi has to say.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>
> 
> 
>> ---
>>   drivers/interconnect/core.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
>> index 9050ca1f4285..c52915a58b22 100644
>> --- a/drivers/interconnect/core.c
>> +++ b/drivers/interconnect/core.c
>> @@ -1087,9 +1087,15 @@ static int of_count_icc_providers(struct device_node *np)
>>   {
>>       struct device_node *child;
>>       int count = 0;
>> +    const struct of_device_id ignore_list[] = {
>> +        { .compatible = "qcom,sc7180-ipa-virt" },
>> +        { .compatible = "qcom,sdx55-ipa-virt" },
>> +        {}
>> +    };
>>       for_each_available_child_of_node(np, child) {
>> -        if (of_property_read_bool(child, "#interconnect-cells"))
>> +        if (of_property_read_bool(child, "#interconnect-cells") &&
>> +            likely(!of_match_node(ignore_list, child)))
>>               count++;
>>           count += of_count_icc_providers(child);
>>       }
>>
>> base-commit: 2fb251c265608636fc961b7d38e1a03937e57371
> 

