Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC13085D4;
	Thu, 19 Jun 2025 04:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750306897; cv=none; b=QYw7JcHcRfjtnCsphj5URBhhjk4kPIOJuCwJ21ebSoprb4fKHq8QFiUY1oE+fU7RmJ27rWuSnoERsWX9S9S3bUJcbsyDxFeO1wBVaiFx3plscPOLO3KxZJ0Cj8BTrtkRnqMQCWOO1WBvIwJxlWGQGUR5PAhTDXkEz3ykWfXHBZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750306897; c=relaxed/simple;
	bh=LkRZBPKJWwPW1gB/1P/KICclKg3aXSxCU0F2kAGn2ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZhVw7AwGKIr6Y1G5h4wJ20h8EZAPxr+7q0cFLeF4hLlMQjBCQnMo5F+G82t6OVEG3x3Si2uWXykk1Pqj9xk2zsCKiDEDucLUN+OtIjHy9FoXD3pJALt1UeVOCnc8Z3D6ncJn4YWceqSIhlqdtlhzWb82ObYPrRNarau/+vFblw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIPPwMnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIPPwMnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD37BC4CEEA;
	Thu, 19 Jun 2025 04:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750306897;
	bh=LkRZBPKJWwPW1gB/1P/KICclKg3aXSxCU0F2kAGn2ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RIPPwMnJIyg7RYNVvWClfuE1QXljXFC8OBpNV/cn/hMpSYb8Nd47UZe1DEA9rlipn
	 zHUEfSpsFoHi23+bvackLsWNYuW3Zx7Ey+u/Ejm/tP/k9UqisNQQNd3gSy0BQuZeK6
	 /bdtEj972Om+mVIW6knQHy2l5m8tccM7OJFEI0VY=
Date: Thu, 19 Jun 2025 06:21:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Casey Connolly <casey.connolly@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 296/356] ath10k: snoc: fix unbalanced IRQ enable in
 crash recovery
Message-ID: <2025061953-alarm-oxidize-1967@gregkh>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152350.087643471@linuxfoundation.org>
 <a91ca229-0603-4385-9f9e-01f3c3ede855@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a91ca229-0603-4385-9f9e-01f3c3ede855@linaro.org>

On Wed, Jun 18, 2025 at 08:06:45PM +0200, Casey Connolly wrote:
> 
> 
> On 6/17/25 17:26, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Caleb Connolly <caleb.connolly@linaro.org>
> > 
> > [ Upstream commit 1650d32b92b01db03a1a95d69ee74fcbc34d4b00 ]
> > 
> > In ath10k_snoc_hif_stop() we skip disabling the IRQs in the crash
> > recovery flow, but we still unconditionally call enable again in
> > ath10k_snoc_hif_start().
> > 
> > We can't check the ATH10K_FLAG_CRASH_FLUSH bit since it is cleared
> > before hif_start() is called, so instead check the
> > ATH10K_SNOC_FLAG_RECOVERY flag and skip enabling the IRQs during crash
> > recovery.
> > 
> > This fixes unbalanced IRQ enable splats that happen after recovering from
> > a crash.
> > 
> > Fixes: 0e622f67e041 ("ath10k: add support for WCN3990 firmware crash recovery")
> > Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> 
> If fixing my name is acceptable, that would be appreciated...

I can, to what?  This was a cherry-pick from what is in Linus's tree
right now, and what was sent to the mailing list, was that incorrect?

thanks,

greg k-h
