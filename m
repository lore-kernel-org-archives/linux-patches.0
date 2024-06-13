Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F97212FF8E
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718299326; cv=none; b=go5spiu0RYQvx8XIcBowW0nmOIqNaLGLZa+ASWBiLjMtfyCQe+dhFxFcKZ3wjZEb6R/WhH9Z2UegvXLg4Ag+I4gTJAP9BkNxbUMn/3iX9uFCmrC7A1wjgxNtVeHI852W3g+Qob3bw+sTh+Y+2JH339SKRM6egwBRjAqkcR/PmJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718299326; c=relaxed/simple;
	bh=Wu4vLKYYfYmzdJTZcksSYwuoKqeJDPqUPkuJ0GJlQSY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=c5mcA+8NH6dyeGVzn/UpkbUedqQDcpx2+qlqTeKgKSZsW21r6DCz/3iEEZvuthw24JoxTHRrOXIhCJBVuodNg0vObcbIcEjLeEdIGtvoZUzcyMdatKBMll32E0V1TqvtW0P+dqkCWJEdMChfXKhCe3LsMXcr4UfGsbOmSBLptLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=Q5x+We/6; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Q5x+We/6"
Received: from [10.10.2.52] (unknown [10.10.2.52])
	by mail.ispras.ru (Postfix) with ESMTPSA id C113540737CA;
	Thu, 13 Jun 2024 17:21:52 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru C113540737CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1718299314;
	bh=g3v2Vty2w7Rq9q9Q5VvRCudaV6Bs94Q7Y2dxGyTz/bQ=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=Q5x+We/67O7dcMUgY778Wy/YvFgCPC8B49oF8/c9kbLP5Dp59JMrvsOEo8CsL1/y1
	 vHPFfAs4iFs7K+8sU8lbt5c/zvht87dGUS3lP8zNjRjNIPcYKRvYVgpGBfTuZdcP8E
	 e1ZQg391iNAdo9UfpOquqZAYyepQLP6ElA0owpes=
Subject: Re: [PATCH 5.10 004/317] r8169: Fix possible ring buffer corruption
 on fragmented Tx packets.
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ken Milmore <ken.milmore@gmail.com>,
 Heiner Kallweit <hkallweit1@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
References: <20240613113247.525431100@linuxfoundation.org>
 <20240613113247.702462647@linuxfoundation.org>
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Message-ID: <9592add5-b9e3-d14d-dd1b-2ef3d1057dd1@ispras.ru>
Date: Thu, 13 Jun 2024 20:21:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240613113247.702462647@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 13.06.2024 14:30, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.

The patch is cleanly applied to 5.10, but it leads to uninit value
access in rtl_tx_slots_avail().


	unsigned int frags;
	u32 opts[2];

	txd_first = tp->TxDescArray + entry;

	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
                                             ^^^^^ - USE OF UNINIT VALUE
		if (net_ratelimit())
			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
		goto err_stop_0;
	}

	opts[1] = rtl8169_tx_vlan_tag(skb);
	opts[0] = 0;

	if (!rtl_chip_supports_csum_v2(tp))
		rtl8169_tso_csum_v1(skb, opts);
	else if (!rtl8169_tso_csum_v2(tp, skb, opts))
		goto err_dma_0;

	if (unlikely(rtl8169_tx_map(tp, opts, skb_headlen(skb), skb->data,
				    entry, false)))
		goto err_dma_0;

	txd_first = tp->TxDescArray + entry;

	frags = skb_shinfo(skb)->nr_frags;
        ^^^^^^   - INITIALIZATION IS HERE AFTER THE PATCH

There is no such problem in upstream because rtl_tx_slots_avail() has no
nr_frags argument there.


Found by Linux Verification Center (linuxtesting.org) with SVACE.

--
Alexey Khoroshilov
Linux Verification Center, ISPRAS
