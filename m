Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9241115E5AE;
	Tue, 22 Apr 2025 13:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745327202; cv=none; b=rRuIEpZ4PoF3bMtRjanHLGO5RrEq4ael/O9jfNZnjfW5/N96I0PsIoZ1R0JsnXL6GbyErEfJWPqPZclHS8xlUtJvmr9OdSi8TqMhM3LafBpAHfs+5Iu3rmnr3anZRGCdCpKxnwbY7WHCvjEWDhjyIoIv55dYJzXbOL0HOx62Kgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745327202; c=relaxed/simple;
	bh=OucVHQFmKmn/lEIF48B8zkvwd0aX13DHN2cV65n+hcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTaOAh39Ozd73bVFuO78QhCpBX/7bEjrQn+XUzFXYYRhnSh3i7Yswn1SS0ENgV1JPxmGJ3lr5tikZBeEmK8AxokzumPu2U8MaopCTDyAUcacz6B6HKckny3N8qcOBKMysKZkMudoXxDplRZNPnV0xmxGdLQX45/TN5IBd5mQY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlb94JIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlb94JIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA40C4CEE9;
	Tue, 22 Apr 2025 13:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745327202;
	bh=OucVHQFmKmn/lEIF48B8zkvwd0aX13DHN2cV65n+hcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qlb94JICcTOm1yMv/oy8ZIXmytJSiU8JtYj4j5RUPjb8FrKjsAzQQ+vIyHml3yFXw
	 cUbXwrJCjjTLY5oz3w1Gz5dE0VQYu+KsJUGWjjVT8eH3MCbIfm0n7HCRYAA9wzjVhl
	 QTMiUiCLxv16wJ25TMl61pWS6nejN76fYz5VEENs=
Date: Tue, 22 Apr 2025 15:06:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Tsoy <alexander@tsoy.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12.y v2 2/2] wifi: ath12k: Fix invalid entry fetch in
 ath12k_dp_mon_srng_process
Message-ID: <2025042233-gurgling-shortwave-c8c6@gregkh>
References: <20250422120338.229099-1-alexander@tsoy.me>
 <20250422120338.229099-2-alexander@tsoy.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422120338.229099-2-alexander@tsoy.me>

On Tue, Apr 22, 2025 at 03:03:38PM +0300, Alexander Tsoy wrote:
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

Same problem here.
