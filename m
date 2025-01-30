Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E0B1E98F3;
	Thu, 30 Jan 2025 15:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738252604; cv=none; b=qCiUQazwReMtH3Tfs9+0l5d+gajQaCiMxfDJ1yuJqqvxLPNP7IQ6YREw9Euw5lZRUxuZnxmr+wQwbnfGz9IOoaO8H9SREvvjUA769ZF8qrWc+gGD/d4VypZwreZjFp5HKmnbMltZM8pYaxxK5aOk90SGpJBuKXKEYBx3GcadpBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738252604; c=relaxed/simple;
	bh=kyueqhJCMqDvblVFcCdgbr8Ha4b8qWO7dbnUxsJEkrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F2yjtUIM1Bw/mpu/8PSxcuTrfyocJnwC6PnhA7FPhdLjQTwlgfUE2FF9tVW2Sa3vXXPnhgsizaU+AJ+MXeo5dn4L1+Blogy0PoSRYqgyrrF2BjYkV7nH0yZKSHbLYl42JvBSvhdfuD4SxBeKeZTQdbomyilewYc5jvA2yhFZHRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=IJaRPwpF; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="IJaRPwpF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=y8WowStiuFjtFiRY/j+QKKzZT9+b6Vju/ceYoKEPRYk=; b=IJaRPwpF4gbIObU8fUTSiyhgEV
	YzFhvVx5h9DEqE71We2TGaRnvnxdE5eOYMlC9VTAXR2D8jNDz0y/6UhAB9g0+NqouafIrwCk8eeEe
	lbgAqNWAloEDPV0fpDPqfoLyTiBkzU9WrdIVZO7ItX24my+5om2eKhgnMHFPONTCKAjSJVwXMpM3H
	9JdXbU8/H002fEFaicIwfZAHtpwPViyeSL/TlvuoJASByGPKOXIoXVp+Pd+wUMqSqhzEfWQqv7Xy4
	zmLUVLGBedQRamU+BLYl3UjZ8p3kX6e/u+qrdYjfmU1gVTtdZnjA23u9mPIdSTGI6re29MvUObz3T
	XefyNjTQ==;
Received: from [189.16.81.54] (helo=[10.154.220.147])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1tdWu1-0015Mv-1g; Thu, 30 Jan 2025 16:56:31 +0100
Message-ID: <12607ce2-01f3-4fb6-8b50-33a9f7f26381@igalia.com>
Date: Thu, 30 Jan 2025 12:56:25 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 082/133] drm/v3d: Ensure job pointer is set to NULL
 after job completion
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
 Sasha Levin <sashal@kernel.org>
References: <20250130140142.491490528@linuxfoundation.org>
 <20250130140145.823285670@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>
In-Reply-To: <20250130140145.823285670@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

This patch introduced a race-condition that was fixed in
6e64d6b3a3c39655de56682ec83e894978d23412 ("drm/v3d: Assign job pointer
to NULL before signaling the fence") - already in torvalds/master. Is it
possible to push the two patches together? This way we wouldn't break
any devices.

If possible, same thing for 5.4.

Best Regards,
- Maíra

On 30/01/25 11:01, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Maíra Canal <mcanal@igalia.com>
> 
> [ Upstream commit e4b5ccd392b92300a2b341705cc4805681094e49 ]
> 
> After a job completes, the corresponding pointer in the device must
> be set to NULL. Failing to do so triggers a warning when unloading
> the driver, as it appears the job is still active. To prevent this,
> assign the job pointer to NULL after completing the job, indicating
> the job has finished.
> 
> Fixes: 14d1d1908696 ("drm/v3d: Remove the bad signaled() implementation.")
> Signed-off-by: Maíra Canal <mcanal@igalia.com>
> Reviewed-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20250113154741.67520-1-mcanal@igalia.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/v3d/v3d_irq.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
> index c88686489b888..22aa02d75c5cc 100644
> --- a/drivers/gpu/drm/v3d/v3d_irq.c
> +++ b/drivers/gpu/drm/v3d/v3d_irq.c
> @@ -103,6 +103,7 @@ v3d_irq(int irq, void *arg)
>   
>   		trace_v3d_bcl_irq(&v3d->drm, fence->seqno);
>   		dma_fence_signal(&fence->base);
> +		v3d->bin_job = NULL;
>   		status = IRQ_HANDLED;
>   	}
>   
> @@ -112,6 +113,7 @@ v3d_irq(int irq, void *arg)
>   
>   		trace_v3d_rcl_irq(&v3d->drm, fence->seqno);
>   		dma_fence_signal(&fence->base);
> +		v3d->render_job = NULL;
>   		status = IRQ_HANDLED;
>   	}
>   
> @@ -121,6 +123,7 @@ v3d_irq(int irq, void *arg)
>   
>   		trace_v3d_csd_irq(&v3d->drm, fence->seqno);
>   		dma_fence_signal(&fence->base);
> +		v3d->csd_job = NULL;
>   		status = IRQ_HANDLED;
>   	}
>   
> @@ -157,6 +160,7 @@ v3d_hub_irq(int irq, void *arg)
>   
>   		trace_v3d_tfu_irq(&v3d->drm, fence->seqno);
>   		dma_fence_signal(&fence->base);
> +		v3d->tfu_job = NULL;
>   		status = IRQ_HANDLED;
>   	}
>   

