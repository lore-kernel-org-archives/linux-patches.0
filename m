Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA28930BF6D
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 08:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123507; cv=none; b=KLG63rcF6ONqEjXwrxQXAIkrt0EhVwvTQ1OwF08P32b9zWEgYNQ793egvLhfitPHY8o28x10mtxWSyfI53VfJMIN8SVjJ3hREbt6Glsglk6d/ky9oeIZly9X0U1tU39P1W/MVyOFCgqy03N9e8ZfcJM+Tv4iknAIJCjGsdzznWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123507; c=relaxed/simple;
	bh=7JPKOUEFVzVdS9+oT3QEARXWQBTXWHUqd5QQt9ZdSJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyxHgo4+Im0Ql1x1VLMNNYJU1SV6yi5gQdT/geC/p0Dqm0jzzRoDDljossUmzexw5jie/cP211tEFOT33BBSfybNjP0AQ8JjzNaLDEnSrPus420j9IOydqyKOOAZXAvV/F32mF5pl0Mx0cAcx4xPW+t0jvLgU5Bzk6jleM75Xn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eH6He9ef; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eH6He9ef"
Date: Wed, 22 Oct 2025 01:28:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761123499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H+NkZdt9/8D7af5xNzbwT8FjO8g/Osa1zwilvJgVf3g=;
	b=eH6He9efJsMwbOixc9RvDFUh8tsZvahvJywM0N3eNmprrRZCBBkDXq2jBQ3ocOdwvuYfLM
	3b7ihsMOCQjAa6kRsba40fG51JDrGwreVRs6AsCj+cSD4n4Tr0dKZNk4rPHWvvpc4r28re
	Fh5DL23t70253d2pgt8vgRpGDTHZ3RA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 6.12 006/136] KVM: arm64: Prevent access to vCPU events
 before init
Message-ID: <aPiVtgLCCbQ9igWp@linux.dev>
References: <20251021195035.953989698@linuxfoundation.org>
 <20251021195036.111716876@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021195036.111716876@linuxfoundation.org>
X-Migadu-Flow: FLOW_OUT

Hey,

Can you please drop this patch from all but 6.17?

On Tue, Oct 21, 2025 at 09:49:54PM +0200, Greg Kroah-Hartman wrote:

[...]

> Cc: stable@vger.kernel.org # 6.17

FWIW, I called this out here.

Thanks,
Oliver

> Fixes: b7b27facc7b5 ("arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/arm64/kvm/arm.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1760,6 +1760,9 @@ long kvm_arch_vcpu_ioctl(struct file *fi
>  	case KVM_GET_VCPU_EVENTS: {
>  		struct kvm_vcpu_events events;
>  
> +		if (!kvm_vcpu_initialized(vcpu))
> +			return -ENOEXEC;
> +
>  		if (kvm_arm_vcpu_get_events(vcpu, &events))
>  			return -EINVAL;
>  
> @@ -1771,6 +1774,9 @@ long kvm_arch_vcpu_ioctl(struct file *fi
>  	case KVM_SET_VCPU_EVENTS: {
>  		struct kvm_vcpu_events events;
>  
> +		if (!kvm_vcpu_initialized(vcpu))
> +			return -ENOEXEC;
> +
>  		if (copy_from_user(&events, argp, sizeof(events)))
>  			return -EFAULT;
>  
> 
> 
