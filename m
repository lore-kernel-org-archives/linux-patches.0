Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9874722301;
	Tue,  2 Sep 2025 04:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756788015; cv=none; b=g2XtPZuE6zt6eUA650EjKFsCsp3Jjcxf5Pr1jHoNrBOILZsRK3002TzAKBAqtpDqhYxYcpXMcym8jea/A7Ra4nu2LZMzfIF7jYX0xE2cRTlBvNUkLB99Sfp6rpJU+L6K6oD/DLAFDfkC3VwWRkInKLhZ2ryyjctnEyILRD51szk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756788015; c=relaxed/simple;
	bh=qCOo+EDJdNk2baz9ZX5MlWq6gVuoUvaqCXd5s0H2RDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KcgstwUPH3Qx6ypD5YEQ20SnpOhrm36208Mk1+PGq/jjB1vR2a08ilO0HlXcMyAL75RZPgX0QpKLUBeuLc338ewOaUsT66f1R1eW2W6kGuNK1Ffh6bIrXw6xpSKS+CxoUicFy3VKt6UHVhibtnMmeSFYKsueFDigVjynDtB55DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOC4rWRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOC4rWRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA16C4CEED;
	Tue,  2 Sep 2025 04:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756788015;
	bh=qCOo+EDJdNk2baz9ZX5MlWq6gVuoUvaqCXd5s0H2RDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JOC4rWRfNN9nEPMzQKJ8K8XQ+03Em7rO1P9pAgnfOCt+bNlTVVpwXNKxvXttEognd
	 tnRHJKE9sZrQencJl6ZezjSy8S5Q1QKDQdbno2yip+Cwf5wKzWZH8B+xNtGeE0tknJ
	 idpUEzq0Nb+4rPjw4p6eujn0u0+iE+NZJRVxjQx0=
Date: Tue, 2 Sep 2025 06:40:11 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: jinfeng.wang.cn@windriver.com
Cc: broonie@kernel.org, khairul.anuar.romli@altera.com,
	matthew.gerlach@altera.com, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.6 136/139] spi: spi-cadence-quadspi: Fix pm runtime
 unbalance
Message-ID: <2025090253-cannabis-moaner-7aca@gregkh>
References: <20250703143946.496631282@linuxfoundation.org>
 <20250902033442.145912-1-jinfeng.wang.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902033442.145912-1-jinfeng.wang.cn@windriver.com>

On Tue, Sep 02, 2025 at 11:34:42AM +0800, jinfeng.wang.cn@windriver.com wrote:
> 1. Issue
>   on branch 6.6.y using board Stratix10.
> 
>   I encountered cadence-qspi ff8d2000.spi: Unbalanced pm_runtime_enable! error.
> 
>   After reverting these two commitsi on branch 6.6.y:
>     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/spi/spi-cadence-quadspi.c?h=linux-6.6.y&id=cdfb20e4b34ad99b3fe122aafb4f8ee7b9856e1f
>     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/spi/spi-cadence-quadspi.c?h=linux-6.6.y&id=1af6d1696ca40b2d22889b4b8bbea616f94aaa84
>   Unbalanced pm_runtime_enable! error does not appear.
> 
> 2. Analyse of the codes
>   These two commits are cherry-picked from master branch, the commit id on master branch is b07f349d1864 and 04a8ff1bc351.
>   04a8ff1bc351 fix b07f349d1864. b07f349d1864 fix 86401132d7bb. 86401132d7bb fix 0578a6dbfe75.
>   6.6.y only backport b07f349d1864 and 04a8ff1bc351, but does not backport 0578a6dbfe75 and 86401132d7bb. And the backport 
>   of b07f349d1864 differs with the original patch. So there is Unbalanced pm_runtime_enable error. 
>   If revert the backport for b07f349d1864 and 04a8ff1bc351, there is no error.
>   If backport 0578a6dbfe75 and 86401132d7bb, there is hang during booting. I didn't find the cause of the hang.
>   Since 0578a6dbfe75 and 86401132d7bb are not backported, b07f349d1864 and 04a8ff1bc351 are not needed. 
>   How about reverting the bakcports cdfb20e4b34a and 1af6d1696ca4 for b07f349d1864 and 04a8ff1bc351 on 6.6?

If you wish to have things reverted, please send the reverts with the
reasons why.

thanks,

greg k-h
