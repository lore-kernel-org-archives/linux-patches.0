Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698442F25FE;
	Wed, 22 Oct 2025 08:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120422; cv=none; b=OxbJMH2+w3D8vhMftsdh1lhAxgyrTy2/bO3RVQSAUQtNdYnfcjcAdUuAgLsa0RDws8hkGOxPMXrvoi0k37j31XAlhpqHSMXXaW6v66ESTgj15uTu6aqpFqOrilAek7GW/q7Y5IxE3Yc5YxoSXL1o+2AXhuX20k8h5vzVWV/NOZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120422; c=relaxed/simple;
	bh=OM7CPTJLKR05vVdLWJGBng1LQi8Ec980nsTIXgOThVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2Q105mW5b+V3QGUzywH/0hOvivsqr6FJ1huAnCMGzaOIb6frNeMIwg2Zg2+G/iOI84qbE70EzVE0a8/Yn6Jqzm3iqQYnpGAPPzd33yOTZ7zSBfWIwPG2Z4sSnAwyCQ9rkLsmKdKzRqn7EeseJghd7YiZxDcsGiFuX8dF7YcQ7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoPa0HH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoPa0HH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86DDC4CEE7;
	Wed, 22 Oct 2025 08:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761120422;
	bh=OM7CPTJLKR05vVdLWJGBng1LQi8Ec980nsTIXgOThVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hoPa0HH38I0XgcPJskGVNUka9z1xuWPw0amhNjj2b5FhHeoMlEY8f639peDYUamwm
	 rZVuso1tEje2Jivw64JRokIAr8Rtvi7ieCs0WjdnjWtdUURs2vkd8JN2rT0ZLCiRtL
	 3dvvat+rsbbMxXyWwD6gjUCt0AvvhKfKuX+sa0bE=
Date: Wed, 22 Oct 2025 10:06:59 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jack Wang <jinpu.wang@ionos.com>
Cc: stable@vger.kernel.org, axboe@kernel.dk, hare@suse.de,
	john.g.garry@oracle.com, patches@lists.linux.dev, sashal@kernel.org,
	yukuai3@huawei.com
Subject: Re: [PATCH 6.12 111/136] md/raid0: Handle bio_split() errors
Message-ID: <2025102240-zesty-unveiling-4f99@gregkh>
References: <20251021195035.953989698@linuxfoundation.org>
 <20251021195038.635577649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021195038.635577649@linuxfoundation.org>

On Wed, Oct 22, 2025 at 09:53:07AM +0200, Jack Wang wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: John Garry <john.g.garry@oracle.com>
> 
> [ Upstream commit 74538fdac3e85aae55eb4ed786478ed2384cb85d ]
> 
> Add proper bio_split() error handling. For any error, set bi_status, end
> the bio, and return.
> 
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Link: https://lore.kernel.org/r/20241111112150.3756529-5-john.g.garry@oracle.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Stable-dep-of: 22f166218f73 ("md: fix mssing blktrace bio split events")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -464,6 +464,12 @@ static void raid0_handle_discard(struct
>  		struct bio *split = bio_split(bio,
>  			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
>  			&mddev->bio_set);
> +
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return;
> +		}
> 
> The version of bio_split return NULL or valid pointer, so we need adapt the
> check to if (IS_ERR_OR_NULL(split)) for all the 3 commits about Handle
> bio_split() errors for md/raidx.
> 

Sorry, I do not understand the request here, is this not ok as-is?
