Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2019E3264C7;
	Mon,  6 Apr 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775490232; cv=none; b=AAGKMxqbz0FtxjEZDmjVYky+wqSnp5CR2cLbV5G6JfXbvPlfDsuY+7sv26Y/b48nw6wfpc12nZnJo4sdc/9I+hzZdK4/tp2NKgW7MSS3kozQixcbCFLUKwx9mUD70bDElqtwFdgMInKnAiCgNnmk5WW20U0cZgAhQaaxqltmn10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775490232; c=relaxed/simple;
	bh=6K2d1uCa9Dh10D+k8fmuJhHRkFmPdHPqVcDSK949lmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S+V7cbCtoulQw3hhEAbBPDSqKNKOEu93LB9VB0oeK+P/GskWfQ35uyOUusdsuW6yEm4PBxn8QDmKAsbVgWUWIJYvmEcjEKXED8jgwwdGeH7FKWuAhkyic65YaQwl1UOEyAuqFrHTYxoXMw/I5WPDR/GMvoThzVAKN9xRgQEN0r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTy47Pju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTy47Pju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC106C4CEF7;
	Mon,  6 Apr 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775490232;
	bh=6K2d1uCa9Dh10D+k8fmuJhHRkFmPdHPqVcDSK949lmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DTy47PjuGGPT5ooIA0Tzf3BI2lD7nsOwis0hLQM2NlcCTRqw9h6zwoWbO64l7jN4D
	 z8OCynGBfHBUvIj+kQUofS8rY2RYbU4kNsJD+Y7oxS3MeMOhyPqueQBobD5aCN+XqM
	 ykChi+nvFcFYr8c/oxtRLT4hn1YJS/P79fzhJcMZk5dKrDah6LrIWDqNdL4/bl/woR
	 c7pO+OGMnvSiYVHh2XtQxwMYtOemLlyfQSXrn9j9FDtsW7YkNQU9R5CM1XC8TEt223
	 0oBjGM813QusV8GfWHnT964dGHgVGtqFkjjX7s5wGfx5jFQttXyyVRBZaF7icjg523
	 9lMH6v+xHnFIQ==
Date: Mon, 6 Apr 2026 11:43:50 -0400
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 044/265] PCI: dw-rockchip: Dont wait for link since
 we can detect Link Up
Message-ID: <adPUtsthYnKHekY3@laps>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201019.793655649@linuxfoundation.org>
 <ffb3f43f-ffd0-4e60-9966-a77e8ed611cf@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ffb3f43f-ffd0-4e60-9966-a77e8ed611cf@oracle.com>

On Fri, Apr 03, 2026 at 06:47:06PM +0530, Harshit Mogalapalli wrote:
>Hi Greg and Sasha,
>
>
>On 13/03/26 01:37, Greg Kroah-Hartman wrote:
>>6.12-stable review patch.  If anyone has any objections, please let me know.
>>
>>------------------
>>
>>From: Niklas Cassel <cassel@kernel.org>
>>
>>[ Upstream commit ec9fd499b9c60a187ac8d6414c3c343c77d32e42 ]
>>
>>The Root Complex specific device tree binding for pcie-dw-rockchip has the
>>'sys' interrupt marked as required.
>>
>>The driver requests the 'sys' IRQ unconditionally, and errors out if not
>>provided.
>>
>>Thus, we can unconditionally set 'use_linkup_irq', so dw_pcie_host_init()
>>doesn't wait for the link to come up.
>>
>>This will skip the wait for link up (since the bus will be enumerated once
>>the link up IRQ is triggered), which reduces the bootup time.
>>
>>Link: https://lore.kernel.org/r/20250113-rockchip-no-wait-v1-1-25417f37b92f@kernel.org
>>Signed-off-by: Niklas Cassel <cassel@kernel.org>
>>[bhelgaas: commit log]
>>Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
>>Stable-dep-of: fc6298086bfa ("Revert "PCI: dw-rockchip: Don't wait for link since we can detect Link Up"")
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>We need a process improvement here.
>
>We are pulling in a broken commit as a stable-dep, so we can revert it.
>
>Patch 45 is the revert, same logic for pair (46 and 47)
>
>[PATCH 6.12 046/265] PCI: qcom: Dont wait for link if we can detect Link Up
>[PATCH 6.12 047/265] Revert "PCI: qcom: Dont wait for link if we can 
>detect Link Up"

This works in our favor: it helps us answer the future question of "why wasn't
this commit backported", and has absolutely no effect on the actual codebase.

What's wrong with this?

-- 
Thanks,
Sasha
