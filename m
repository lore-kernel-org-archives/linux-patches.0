Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F3519E96D;
	Wed,  4 Feb 2026 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219110; cv=none; b=UMnqHASNrvFhkdU4Scf+Lmw/eDaDou0WbdBTDJYFNVU+lOGhh6LNq0pefNjYYSiKUI43Xn5esk1/u2iHxIay34bIVhMBgw1Iwqi8J7VjUSbYl4GNmD/dDPhk1j5ha06+ZeXqWdeorUM7B0ejpEJXvrF397dQEZRHeQ3qG+lj5g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219110; c=relaxed/simple;
	bh=ZfsvijXP1SOMvaWsmnh9XkQ+dwMJvwRONs9I4FXD45A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WT1s7NnrBOa4rCHV29mzEannrOxC6Off92wql5ohDps9KvWM1zGPUQFO4kg5ee80ga4wvVYSFriD4+M5TgjASotA951d2kijhgnPt6qCE9e7cyZMgjImf+VJ9RGJ18QwPJae5nHJtj/oh/K1VF1/OXcmKm8C1N5cUfHYvN/H+cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qkliqNtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qkliqNtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4205C4CEF7;
	Wed,  4 Feb 2026 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770219110;
	bh=ZfsvijXP1SOMvaWsmnh9XkQ+dwMJvwRONs9I4FXD45A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qkliqNtI7Y0yxkjRt+5gv55OYMT35/xUdlTk0RF4ZYcKZuISeHfzkgiwa2KZMQs7g
	 n5cEJBALF0VKiqTsORDA9ko0kDj1DGTNA8zOLl3xRnShflzzYAotx41KlABUPnI+XH
	 QO2/fO8fzovHP9fp0ppu3xxxwyhG9JvUS+Au7Xrn1rxnLchVvA/RlvsmwYI2IqNvXn
	 MOkBVAo6c1iDgYHleE12Bc/LRGqXL+0rCLhYmoeSXnWO3wuV2u1VzrYMOFWjzlteY6
	 fKCrfXtrdsnIbIBuCbb8uuPLjU7UFW7IPRLICIr2amNYgPphBcIBWN5gBLGGZLgJxk
	 CcY4UhrXL9rvg==
Message-ID: <91b2c3d1-02b7-4ef6-bca0-4ae9c375ccbe@kernel.org>
Date: Wed, 4 Feb 2026 09:31:48 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 062/280] drm/amd: Clean up kfd node on surprise
 disconnect
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, kent.russell@amd.com,
 Alex Deucher <alexander.deucher@amd.com>
References: <20260204143909.614719725@linuxfoundation.org>
 <20260204143911.886376244@linuxfoundation.org>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20260204143911.886376244@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 8:37 AM, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mario Limonciello (AMD) <superm1@kernel.org>
> 
> commit 28695ca09d326461f8078332aa01db516983e8a2 upstream.
> 
> When an eGPU is unplugged the KFD topology should also be destroyed
> for that GPU. This never happens because the fini_sw callbacks never
> get to run. Run them manually before calling amdgpu_device_ip_fini_early()
> when a device has already been disconnected.
> 
> This location is intentionally chosen to make sure that the kfd locking
> refcount doesn't get incremented unintentionally.
> 
> Cc: kent.russell@amd.com
> Closes: https://community.frame.work/t/amd-egpu-on-linux/8691/33
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> Reviewed-by: Kent Russell <kent.russell@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 6a23e7b4332c10f8b56c33a9c5431b52ecff9aab)
> Cc: stable@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -4102,6 +4102,14 @@ void amdgpu_device_fini_hw(struct amdgpu
>   	/* disable ras feature must before hw fini */
>   	amdgpu_ras_pre_fini(adev);
>   
> +	/*
> +	 * device went through surprise hotplug; we need to destroy topology
> +	 * before ip_fini_early to prevent kfd locking refcount issues by calling
> +	 * amdgpu_amdkfd_suspend()
> +	 */
> +	if (drm_dev_is_unplugged(adev_to_drm(adev)))
> +		amdgpu_amdkfd_device_fini_sw(adev);
> +
>   	amdgpu_device_ip_fini_early(adev);
>   
>   	amdgpu_irq_fini_hw(adev);
> 
> 

There was a regression [1] reported on this patch yesterday.

I haven't had time to dig into it; but I think we should hold off 
letting it go to any more stable kernels until it's understood.

https://lore.kernel.org/all/b0c22deb-c0fa-3343-33cf-fd9a77d7db99@absolutedigital.net/
