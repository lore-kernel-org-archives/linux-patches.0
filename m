Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAE6143C69;
	Tue, 29 Oct 2024 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730225780; cv=none; b=ohsyelU66HHnwyle7bdTPFET4EGtdNfKFMXYOiAAS7HK8F4IGDQbQdkRr4co+faaD+A85i/qi5cHDHSo8r5RV2Pd/RGpNSRZ34iRqECS+xgH3Xeti1L4fljXVLUhRbZoFwUlw5wKGwB43wmS9wpv7pdLJhwRpy20gM87vDsKOfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730225780; c=relaxed/simple;
	bh=h/W+10MsplW2v1+o0mJGvMzXwQ1SiArm3GGYR2TcSz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUfvclhqFg/ddIQ/eR0oBQgmQHnNENB9g7kz93nctwN+FO4A2fsmsK1fYUIMiOpfDD02tXth/6ilLLIn9kxBxReg9j2bygVjhj+UQbJEGDqa3JJks90K0FBcO/glZHcUqY9iVadofbewb6ntwZDwC3kP0rEoIfeKBC/SlGF/j6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YRnBadkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YRnBadkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84350C4CECD;
	Tue, 29 Oct 2024 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730225779;
	bh=h/W+10MsplW2v1+o0mJGvMzXwQ1SiArm3GGYR2TcSz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YRnBadkGj/UfYKc4eZD1UvrqnXfGSBc1jHPSFAijs7IL4izeg/gEfntn9KldBFgDs
	 kZEiXAXLHalZ/LW/Yvtt5BLh2Ap0haJiVpoIhxlkv1AGFmrtm8hBi3ntsygY4CXUf1
	 y1lbm8BAYdPIvyrNG6bGDaAyj7hUpZg9CxjMFOC0zl7lspyJ0plkOyM2O11XnXAS9k
	 81NMaO/fnX1fZsEF04oDosNXSr0bjREyIcJDGqLXpUIrFak1w/yAOSh7czfZNKMdN7
	 ksIAwT37MCB4ovok+6dmBSxCvXDzjoipX2074HJ2aoFxqsq4G1Em3ntkLshsipbzuz
	 54s40WihhAMZA==
Date: Tue, 29 Oct 2024 14:16:17 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Rodolfo Giometti <giometti@enneenne.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.1 068/137] tty/serial: Make
 ->dcd_change()+uart_handle_dcd_change() status bool active
Message-ID: <ZyEmce1_x7tiEdF_@sashalap>
References: <20241028062258.708872330@linuxfoundation.org>
 <20241028062300.638911047@linuxfoundation.org>
 <b80395aa-5e1a-4f9c-b801-34d0e1f96977@kernel.org>
 <ZyDGgPiAJBVWNJ18@sashalap>
 <ba1da208-22d8-4145-826f-9cfdc5c18eee@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba1da208-22d8-4145-826f-9cfdc5c18eee@kernel.org>

On Tue, Oct 29, 2024 at 12:40:54PM +0100, Jiri Slaby wrote:
>On 29. 10. 24, 12:26, Sasha Levin wrote:
>>On Tue, Oct 29, 2024 at 06:59:55AM +0100, Jiri Slaby wrote:
>>>On 28. 10. 24, 7:25, Greg Kroah-Hartman wrote:
>>>>6.1-stable review patch.  If anyone has any objections, please 
>>>>let me know.
>>>>
>>>>------------------
>>>>
>>>>From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>>>
>>>>[ Upstream commit 0388a152fc5544be82e736343496f99c4eef8d62 ]
>>>>
>>>>Convert status parameter for ->dcd_change() and
>>>>uart_handle_dcd_change() to bool which matches to how the parameter is
>>>>used.
>>>>
>>>>Rename status to active to better describe what the parameter means.
>>>>
>>>>Acked-by: Rodolfo Giometti <giometti@enneenne.com>
>>>>Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
>>>>Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>>>Link: https://lore.kernel.org/r/20230117090358.4796-9- 
>>>>ilpo.jarvinen@linux.intel.com
>>>>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>Stable-dep-of: 40d7903386df ("serial: imx: Update mctrl 
>>>>old_status on RTSD interrupt")
>>>
>>>As I wrote earlier, why is this Stable-dep-of that one?
>>
>>Here's the dependency chain:
>>
>>40d7903386df ("serial: imx: Update mctrl old_status on RTSD interrupt")
>>968d64578ec9 ("serial: Make uart_handle_cts_change() status param 
>>bool active")
>>0388a152fc55 ("tty/serial: Make 
>>->dcd_change()+uart_handle_dcd_change() status bool active")
>>
>>If you go to 6.1.y, and try to apply them in that order you'll see that
>>it applies cleanly. If you try to apply just the last one you'll hit a
>>conflict.
>
>Oh, well, so instead of taking two irrelevant and potentially 
>dangerous patches (0388a152fc55 + 968d64578ec9), this simple context 
>fix should have been in place:
>-       uart_handle_cts_change(&sport->port, !!usr1);
>+       uart_handle_cts_change(&sport->port, usr1);
>
>Right?

No :)

1. If we make changes like the above, future patches that touch that
code simply fail to backport, no one cares enough to fix them up, and
older trees stop getting those fixes. Staying aligned with upstream
means less work in the longer term.

2. Is that everything that's needed for the fix? Maybe? I don't know...
I'm not a TTY expert, I'm not sure that that fix is correct, nor do I
have no way to test that. Do you really trust me that much around your
subsystem? :)

3. We simply don't scale to doing this for every conflict over the (too
many) trees we support. At some point we need to trust our automation,
CI, and testers to catch issues with the "extra" patches we backport.

-- 
Thanks,
Sasha
