Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5F27F4FE;
	Tue, 22 Apr 2025 13:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745327193; cv=none; b=ACs0Ngyvl1iDfsKHvxCcCiXrUj5/K0emX9tsknTclPgrJYMXxEnkGmp+CiVYPLdFLSRvDBJC00bW6wqupEmbFYWUY0VvbTcIfM9PgcX922SpZn3bj7Ps+CY3kTS9BVCJqI5EbxeR0s4xfE19+1i+aGmgNouxo6dqGS9dcWC6fIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745327193; c=relaxed/simple;
	bh=1eRouNCpk5gJtF1aaLy1sSFCz50NfVP5rrUfuzi6eOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEtfG620BxgEQCUxD60h7GnuqssjEk99H7mtYdRQATSQVRxRKr0cCrFbjR6gpD48l3QFWcd5IiF2AbvFbWHpKycOZ8j2J6QxBum+GIycQcmPKeCWH5Ce0nT99yw6huYAyA2xeG+hIhuEkghNbEdlFajTBUGfD+ZRPTA2fnUx1W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZo/aWoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZo/aWoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D9CC4CEE9;
	Tue, 22 Apr 2025 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745327192;
	bh=1eRouNCpk5gJtF1aaLy1sSFCz50NfVP5rrUfuzi6eOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NZo/aWozcuE/G/nYl46T1EG2l6WXSmAYsVNhfql2SKExiYswdoXeE1sl70jZqS9bl
	 G000uf6MVTgQ2tlzkYEw5N6Q6opdCmPrFIuLP9+n0+s+iNaEudyoaQmCX2jfqUT6gY
	 qyqDf6b5Ao1Nzyve0b3h+VUsa0rQ57cjDYw1ftfY=
Date: Tue, 22 Apr 2025 15:06:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Tsoy <alexander@tsoy.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14.y v2 2/2] wifi: ath12k: Fix invalid entry fetch in
 ath12k_dp_mon_srng_process
Message-ID: <2025042207-patriarch-nuclear-e918@gregkh>
References: <20250422120237.228960-1-alexander@tsoy.me>
 <20250422120237.228960-2-alexander@tsoy.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422120237.228960-2-alexander@tsoy.me>

On Tue, Apr 22, 2025 at 03:02:37PM +0300, Alexander Tsoy wrote:
> From: P Praneesh <quic_ppranees@quicinc.com>
> 
> [ Upstream commit 63fdc4509bcf483e79548de6bc08bf3c8e504bb3 ]
> 
> Currently, ath12k_dp_mon_srng_process uses ath12k_hal_srng_src_get_next_entry
> to fetch the next entry from the destination ring. This is incorrect because
> ath12k_hal_srng_src_get_next_entry is intended for source rings, not destination
> rings. This leads to invalid entry fetches, causing potential data corruption or
> crashes due to accessing incorrect memory locations. This happens because the
> source ring and destination ring have different handling mechanisms and using
> the wrong function results in incorrect pointer arithmetic and ring management.
> 
> To fix this issue, replace the call to ath12k_hal_srng_src_get_next_entry with
> ath12k_hal_srng_dst_get_next_entry in ath12k_dp_mon_srng_process. This ensures
> that the correct function is used for fetching entries from the destination
> ring, preventing invalid memory accesses.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> 
> Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
> Link: https://patch.msgid.link/20241223060132.3506372-7-quic_ppranees@quicinc.com
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

You didn't sign off on this :(

And I don't think Sasha did either.

Be careful with these types of attributes please.

thanks,

greg k-h
