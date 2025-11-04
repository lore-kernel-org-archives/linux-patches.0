Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35473271F0;
	Tue,  4 Nov 2025 13:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762264015; cv=none; b=Y8+I/8WfumEF7PGHBS6B5i5sPmALxjeGeFy5+ze+4YqMxsF1TjxJnkOCQOAZQ9fBCEadBLzqD64Cv1n/MuoqUTAuXy86ttPLu5/B9N+m9OE8Bjj9QN0C6ybw6qrpiXmPzoXAySXVddrPvyOvBP/wrHu/qubk1QitCDVBGhamMxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762264015; c=relaxed/simple;
	bh=rxIxZWESadAdS+X1adkiZqNofVz64OCQHp0O7UOm4gE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfJbm4TIxbfcoVlPRGElXaVgbt611dVfggs49mxwBOEO40hNQTWdTf+41vnv8TcNdUgxck6OfdpHYEOY04YdO6yzDY/DkqIuqoBBowkY/9dAALEyJYnJu1vse6WfIqjG3+v44PQmEluj2ZN2gYa2RnzcD1e1hsLvY2iedsCCxYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9n/Yx2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9n/Yx2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8FAC4CEF7;
	Tue,  4 Nov 2025 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762264015;
	bh=rxIxZWESadAdS+X1adkiZqNofVz64OCQHp0O7UOm4gE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f9n/Yx2+FyUeRLS7mMCSRJ4mxKrHBILim5sT4VRdKLErt2ShB+KD0Wonp+vFS6sCk
	 lQOgvYGod3pHsOyd9zUmWyRe7v3J52mimsGIYPvShnI1QP4mOSsjcLbKB2ImGHCPK6
	 5zWg8qVk4zNU6FtjJPBSa7PBrNXNSsk/n2T0mVvhdAZObFK+VY4JqqkVKQtbjdQ6Eq
	 RBcF1ZRj7taMvvleUePOvZPDjLVkuiiTi2ccSnIWPjGYu7sEHdYFW9A+oyjg8snb/k
	 ImoDUga1kWM8CIcgXoXBqoUYfS6xWHzcROHTCBbDBVBUqUSAXH1i5AoC6xMCK41iLY
	 GD/qwnYAhwbGQ==
Date: Tue, 4 Nov 2025 08:46:53 -0500
From: Sasha Levin <sashal@kernel.org>
To: Michal Pecio <michal.pecio@gmail.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Nick Nielsen <nick.kainielsen@free.fr>, grm1 <grm1@mailbox.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	mathias.nyman@intel.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.12] usb: xhci-pci: add support for hosts
 with zero USB3 ports
Message-ID: <aQoDzWhD5A3oUBuE@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-36-sashal@kernel.org>
 <20251025184740.15989ebe.michal.pecio@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251025184740.15989ebe.michal.pecio@gmail.com>

On Sat, Oct 25, 2025 at 06:47:40PM +0200, Michal Pecio wrote:
>On Sat, 25 Oct 2025 11:54:27 -0400, Sasha Levin wrote:
>> From: Niklas Neronin <niklas.neronin@linux.intel.com>
>>
>> [ Upstream commit 719de070f764e079cdcb4ddeeb5b19b3ddddf9c1 ]
>>
>> Add xhci support for PCI hosts that have zero USB3 ports.
>> Avoid creating a shared Host Controller Driver (HCD) when there is only
>> one root hub. Additionally, all references to 'xhci->shared_hcd' are now
>> checked before use.
>>
>> Only xhci-pci.c requires modification to accommodate this change, as the
>> xhci core already supports configurations with zero USB3 ports. This
>> capability was introduced when xHCI Platform and MediaTek added support
>> for zero USB3 ports.
>>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220181
>> Tested-by: Nick Nielsen <nick.kainielsen@free.fr>
>> Tested-by: grm1 <grm1@mailbox.org>
>> Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Link: https://lore.kernel.org/r/20250917210726.97100-4-mathias.nyman@linux.intel.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>Hi Sasha,
>
>This is completely broken, fix is pending in Greg's usb-linus branch.
>(Which is something autosel could perhaps check itself...)
>
>8607edcd1748 usb: xhci-pci: Fix USB2-only root hub registration

I'll add the fix on top, thanks!

-- 
Thanks,
Sasha
