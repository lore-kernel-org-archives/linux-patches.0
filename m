Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B63524C;
	Tue, 22 Apr 2025 07:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745307663; cv=none; b=dWxjkhg0/afB3Ct4tYHhZUAXzr3Zag1PL4FmtrTny3Aydlq6Jxf9IHwD0UKM6UqlZdlGgEydrnodSfO/aPbrHdey5uqBfkY+5JLmUEGxLK/+7ADOLRVmaD2Efsgj3ZZgGAGEgnsq9YLB0Nv5/IN1vk3JVM5PmgXkOVuOUxukOFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745307663; c=relaxed/simple;
	bh=F3TRD5v50yXWVoNys5H0+QhAINkINJl/uKCxw2/XgYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mm8Ngr3Lmem44HlJJIq2cDmgTaZ3BmgCyPZFnMxwvjiA5TuwzrRCPTT0h6KsfVNxRtdx1N7+5MK09PTy5lKAJtl/dAi7hATLe8okexWdpKdv7VbY9v44hy2MgC/j0EBp18gAwziT866sDuI7ZRcyoZEvCAOYEdFOxeHp3BsfGC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nxd4oxlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nxd4oxlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8C0C4CEF0;
	Tue, 22 Apr 2025 07:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745307662;
	bh=F3TRD5v50yXWVoNys5H0+QhAINkINJl/uKCxw2/XgYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nxd4oxlxVouJq7hi9VvjDdvSQbiIX/XGw/uwIkuoN6olV6Ah0fhHqBx7sQLWWEnDW
	 OqD0ECy2eHgBYk0zvG3kLDq6vMDmIfh5HtlKMyVB7NzTMdPwsFH9H6Wg5eH25eJAJx
	 1z22ar0gwQks/FJKaA+ir3VY0fgh+26AQkCKZg/w=
Date: Tue, 22 Apr 2025 09:40:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Tsoy <alexander@tsoy.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 085/393] wifi: ath12k: Fix invalid entry fetch in
 ath12k_dp_mon_srng_process
Message-ID: <2025042239-pancreas-swiftness-c137@gregkh>
References: <20250417175107.546547190@linuxfoundation.org>
 <20250417175111.019326590@linuxfoundation.org>
 <4fed086db630ff37ceb9caf9094b74467ef5d0bd.camel@tsoy.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fed086db630ff37ceb9caf9094b74467ef5d0bd.camel@tsoy.me>

On Mon, Apr 21, 2025 at 12:42:08AM +0300, Alexander Tsoy wrote:
> В Чт, 17/04/2025 в 19:48 +0200, Greg Kroah-Hartman пишет:
> > 6.12-stable review patch.  If anyone has any objections, please let
> > me know.
> > 
> > ------------------
> > 
> > From: P Praneesh <quic_ppranees@quicinc.com>
> > 
> > [ Upstream commit 63fdc4509bcf483e79548de6bc08bf3c8e504bb3 ]
> > 
> > Currently, ath12k_dp_mon_srng_process uses
> > ath12k_hal_srng_src_get_next_entry
> > to fetch the next entry from the destination ring. This is incorrect
> > because
> > ath12k_hal_srng_src_get_next_entry is intended for source rings, not
> > destination
> > rings. This leads to invalid entry fetches, causing potential data
> > corruption or
> > crashes due to accessing incorrect memory locations. This happens
> > because the
> > source ring and destination ring have different handling mechanisms
> > and using
> > the wrong function results in incorrect pointer arithmetic and ring
> > management.
> > 
> > To fix this issue, replace the call to
> > ath12k_hal_srng_src_get_next_entry with
> > ath12k_hal_srng_dst_get_next_entry in ath12k_dp_mon_srng_process.
> > This ensures
> > that the correct function is used for fetching entries from the
> > destination
> > ring, preventing invalid memory accesses.
> > 
> > Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-
> > 1
> > Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-
> > QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> > 
> > Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
> > Link:
> > https://patch.msgid.link/20241223060132.3506372-7-quic_ppranees@quicinc.com
> > Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/wireless/ath/ath12k/dp_mon.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c
> > b/drivers/net/wireless/ath/ath12k/dp_mon.c
> > index 5c6749bc4039d..1706ec27eb9c0 100644
> > --- a/drivers/net/wireless/ath/ath12k/dp_mon.c
> > +++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
> > @@ -2533,7 +2533,7 @@ int ath12k_dp_mon_rx_process_stats(struct
> 
> Hello!
> 
> I think this is incorrect backport. ath12k_dp_mon_srng_process() should
> be patched.

Can you send a fix-up path for this?

thanks,

greg k-h
