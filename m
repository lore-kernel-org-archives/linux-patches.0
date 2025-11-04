Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B77248868;
	Tue,  4 Nov 2025 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762264115; cv=none; b=Ygu33DSAv4reXq891jXowj8LnlGEDwNVKnqUXjzoOQ5hIVg7IhSxLP1Psw9TyrKEXXJOfJ/bYNIbN1tL03bUZtxms4JqbtZGwGZdGaUPz2tNDUP6jddzcVO1iTcLClBd3F3tVWInb9cBxWQZKl6KlIpygaRQ7MAmNpDRdYf2LCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762264115; c=relaxed/simple;
	bh=Fys00hKrSht6OkXXuSM3NsdKGKtbrLAyEbirnSp/+6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/Raw69lTPHQKaLrgq0DOhVwjnzkflJvkmTT90IM7TuBBxVSs/kNePoXpwm6E/86TMnjQAfNdK/mjLWrR0mdIsHu1XhsyDTsmrUe0cCaUtwIPXL++2fnqQzLW0LyVObOQmOyEWs/5MCioH7X++vouVcCryBVlfHrYgA1VeBYhMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tulPogJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tulPogJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FF5C4CEF7;
	Tue,  4 Nov 2025 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762264113;
	bh=Fys00hKrSht6OkXXuSM3NsdKGKtbrLAyEbirnSp/+6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tulPogJ90B3JWNxlXGE4+7cM7ofn5VjxAnrPIPVM98pEnxLU5L3XQlHxF9y1ZB625
	 A4kOV+UKkC0xW2+mSZ31WZZdKoQ3dTDH+G0CQoJFD44zC3OcI/A+Jedhyf6KmIHHeZ
	 Mi0+0tdYHf3Cb4YQ3AFsNSgddfhqT86Ltu/79WnbBrat6cs1xxxgjFSpvEBD+3eK4j
	 y5uw2p6mjs0Xw/sYVdGNBHdLiYOTzNZlx3jzJCNSHT+JdAQaKWNAGvSFt8M6mjZnPF
	 pdZEikmZxclQtVomwjEiURHlOUyr0hVvkcWveUNVBuqpiMQx+l9IJt9wD0KHAWgD0A
	 96kWd8swZWr9Q==
Date: Tue, 4 Nov 2025 08:48:32 -0500
From: Sasha Levin <sashal@kernel.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 6.17-6.6] char: misc: Make misc_register()
 reentry for miscdevice who wants dynamic minor
Message-ID: <aQoEMJ9HT8wg05Dn@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-64-sashal@kernel.org>
 <aP6Cc9G8Il3W1LGb@quatroqueijos.cascardo.eti.br>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aP6Cc9G8Il3W1LGb@quatroqueijos.cascardo.eti.br>

On Sun, Oct 26, 2025 at 05:20:03PM -0300, Thadeu Lima de Souza Cascardo wrote:
>On Sat, Oct 25, 2025 at 11:54:55AM -0400, Sasha Levin wrote:
>> - Backport notes
>>   - Older trees (like this one) use a 64-bit dynamic minor bitmap with
>>     indices mapped via `i = DYNAMIC_MINORS - misc->minor - 1` and
>>     `clear_bit(i, misc_minors)` (drivers/char/misc.c:241–250), not
>>     `misc_minor_free()`. The equivalent backport should reset
>>     `misc->minor = MISC_DYNAMIC_MINOR` only if the minor was dynamically
>>     allocated, which can be inferred by the same range check already
>>     used before clearing the bit:
>>     - If `i < DYNAMIC_MINORS && i >= 0` then it was a dynamic minor;
>>       after `clear_bit(i, misc_minors);` set `misc->minor =
>>       MISC_DYNAMIC_MINOR;`.
>>   - Newer trees using `misc_minor_free()` may use a different condition
>>     (as in the diff). Adjust the condition to the tree’s semantics; the
>>     intent is “if this was a dynamically allocated minor, reset it.”
>>
>
>The LLM got it right here. This won't work for 6.6.y and 6.12.y. The check
>for dynamically allocated minors is different on those versions.
>
>> - Risk assessment
>>   - Very low risk:
>>     - Static-minor devices are unaffected.
>>     - Dynamic-minor devices now always behave as “dynamic” on re-
>>       register, which is the intended contract.
>>     - Change is localized, under the same mutex as the rest of the
>>       deregistration path.
>>   - Positive impact:
>>     - Fixes real user-visible failures on unbind/rebind or probe/remove
>>       cycles.
>>     - Consistent with `misc_register()` error path behavior
>>       (drivers/char/misc.c:214).
>>
>> - Stable criteria
>>   - Fixes a real bug that affects users (unbind/rebind failures).
>>   - Small, contained change in a well-scoped subsystem.
>>   - No new features or architectural changes.
>>   - Signed-off-by by Greg Kroah-Hartman, matching subsystem ownership.
>>
>> Given the above, this is a strong candidate for stable backport.
>>
>>  drivers/char/misc.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
>> index 558302a64dd90..255a164eec86d 100644
>> --- a/drivers/char/misc.c
>> +++ b/drivers/char/misc.c
>> @@ -282,6 +282,8 @@ void misc_deregister(struct miscdevice *misc)
>>  	list_del(&misc->list);
>>  	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
>>  	misc_minor_free(misc->minor);
>> +	if (misc->minor > MISC_DYNAMIC_MINOR)
>> +		misc->minor = MISC_DYNAMIC_MINOR;
>
>For 6.12 and 6.6, this should be:
>
>	if (misc->minor > MISC_DYNAMIC_MINOR ||
>	    (misc->minor < DYNAMIC_MINORS && misc->minor >= 15))
>		misc->minor = MISC_DYNAMIC_MINOR;
>
>Or pick 31b636d2c416 ("char: misc: restrict the dynamic range to exclude
>reserved minors"), or just drop this from 6.6 and 6.12.

I've picked 31b636d2c416 up for 6.12 and 6.6, thanks!

-- 
Thanks,
Sasha
