Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8147520F082;
	Wed, 19 Feb 2025 21:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740000922; cv=none; b=pC8e2VUENcOdgXTtq68fuesnJRJmrRZTFH7/5KapGu8lp7xzSIQ2GZ4LkExhmtJOoL1pexwQkBICavh3lGjy1XU0cdjPoLPY2dPEAvZfG9CFTZWULbwyUMl0RhRcTNXZcnoH7MIf2zroQzvlcBmzRH1eShjPKTWcv8a4fOufZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740000922; c=relaxed/simple;
	bh=e4aJMAv1V4CuQwKgqxlK6659bCn6Finu4jYa97q8UPU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LDXiUWUlulp4VMaxRhqKK/81UoAQtetUouzRdDaRZjQS2/XzEhPiD2Rg4h3Ej5ftjZcOldMw0ww3f9LMOnBlbLkOHOWkJhY+ZUCv3J3e68q16lshnkMAbhPIR6TO7+xPU48MtHx8XwkNAnPFZmP6yHwjuruecF3ALc35QD/uCU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hABoKHFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hABoKHFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D8CC4CED1;
	Wed, 19 Feb 2025 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740000921;
	bh=e4aJMAv1V4CuQwKgqxlK6659bCn6Finu4jYa97q8UPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hABoKHFqZTUTY9EggftxV5DLIE0HbtiSQlvNoh112UWJjTdWjVetJj/NFTfU85Im8
	 CI4sbGgyihWA0UBT25LqoON/ErvLwhbiQfC5i4YOAzVPDxuanr5DLkzKXGWxSxN3Zs
	 eh7pJK3X7ybZCPMx4sPKBZDO2YW395bqoYv/6pF1Hqwwy2IkK3lkDEzynBIYvxfay2
	 cVC2l5uNgIfQm3FqJEhaUFCTgdMqnVJ8TDO8bi1616ZUgt3IoswOi9o7SNdRPecDhI
	 oKILY1S7HirOPSqESGCrNyi5fbx//IclwrqWG1ipC2sEH9DJQHLp5XFzwT159l6EQD
	 OPnIf6xenUhFA==
Date: Wed, 19 Feb 2025 13:35:21 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Joe Damato
 <jdamato@fastly.com>, Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, Sasha
 Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 231/274] net: add netdev_lock() / netdev_unlock()
 helpers
Message-ID: <20250219133521.6d6a9f3c@kernel.org>
In-Reply-To: <20250219082618.621038202@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
	<20250219082618.621038202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 09:28:05 +0100 Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit ebda2f0bbde540ff7da168d2837f8cfb14581e2e ]
> 
> Add helpers for locking the netdev instance, use it in drivers
> and the shaper code. This will make grepping for the lock usage
> much easier, as we extend the lock to cover more fields.
> 
> Reviewed-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Link: https://patch.msgid.link/20250115035319.559603-2-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")

please drop from all branches
