Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5341D12E9;
	Fri,  8 Nov 2024 07:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731051328; cv=none; b=fHjdjn8kz6SuBSBzeUo7P9Ejn+B/yUC7vKsT8V6CdJ2TrKLYS8v07KIbYqxBdOFh2MWrdPn/dJEJrLaAqs27+4zTGu1zVBiKJMU8EAoZvAxhigiCwchGQzaqvdHH6zr9lXbjSAdR5SFY3dlzi1nddhPuTFhwsxuMRxEW1a/FBTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731051328; c=relaxed/simple;
	bh=JFPQHfMfRHmJuaiD5Io50N6l60lWhMea8yWRnZhrYFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUs0uwQeVuqYA2CC2c/h22w7tMe2HQp3oL2oGXp49mdStrv9fjLvfF42EJAV0ox0fTl677YGQ/hr73U2JeQAQWARQBMYPPpPuF/L8Y9XiVSlhxQ1nYVUTnpfWQmKsvb59edybo8iCPfMWE4yytnf+avGm7Z6Vk1ylANJ0MIKbn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPrbu+2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPrbu+2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB60CC4CECE;
	Fri,  8 Nov 2024 07:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731051327;
	bh=JFPQHfMfRHmJuaiD5Io50N6l60lWhMea8yWRnZhrYFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QPrbu+2ZxtxlsEHyCJezxqzzAWCr1cb44XjndpumsCKCjuxR11QRA29j2FSx+/LTd
	 3oEV3i9KVoTzWhkM7J7Uh3tzxpexWf8W7Bk14cwsq15gYdbTagJDkuwH9Cicilel3h
	 Hy7ONNLqSNdMEl1WWtILAPEBZuh7QGxdzs9f2OMk=
Date: Fri, 8 Nov 2024 08:35:07 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Yuying Ma <yuma@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Bezdeka <florian.bezdeka@siemens.com>
Subject: Re: [PATCH 6.11 030/245] igb: Disable threaded IRQ for igb_msix_other
Message-ID: <2024110856-mandolin-unbutton-110e@gregkh>
References: <20241106120319.234238499@linuxfoundation.org>
 <20241106120319.970840571@linuxfoundation.org>
 <358ba32f-99f6-4a60-a25f-922a9b2273d2@siemens.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <358ba32f-99f6-4a60-a25f-922a9b2273d2@siemens.com>

On Fri, Nov 08, 2024 at 08:01:12AM +0100, Jan Kiszka wrote:
> On 06.11.24 13:01, Greg Kroah-Hartman wrote:
> > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Wander Lairson Costa <wander@redhat.com>
> > 
> > [ Upstream commit 338c4d3902feb5be49bfda530a72c7ab860e2c9f ]
> > 
> > During testing of SR-IOV, Red Hat QE encountered an issue where the
> > ip link up command intermittently fails for the igbvf interfaces when
> > using the PREEMPT_RT variant. Investigation revealed that
> > e1000_write_posted_mbx returns an error due to the lack of an ACK
> > from e1000_poll_for_ack.
> > 
> > The underlying issue arises from the fact that IRQs are threaded by
> > default under PREEMPT_RT. While the exact hardware details are not
> > available, it appears that the IRQ handled by igb_msix_other must
> > be processed before e1000_poll_for_ack times out. However,
> > e1000_write_posted_mbx is called with preemption disabled, leading
> > to a scenario where the IRQ is serviced only after the failure of
> > e1000_write_posted_mbx.
> > 
> > To resolve this, we set IRQF_NO_THREAD for the affected interrupt,
> > ensuring that the kernel handles it immediately, thereby preventing
> > the aforementioned error.
> > 
> > Reproducer:
> > 
> >     #!/bin/bash
> > 
> >     # echo 2 > /sys/class/net/ens14f0/device/sriov_numvfs
> >     ipaddr_vlan=3
> >     nic_test=ens14f0
> >     vf=${nic_test}v0
> > 
> >     while true; do
> > 	    ip link set ${nic_test} mtu 1500
> > 	    ip link set ${vf} mtu 1500
> > 	    ip link set $vf up
> > 	    ip link set ${nic_test} vf 0 vlan ${ipaddr_vlan}
> > 	    ip addr add 172.30.${ipaddr_vlan}.1/24 dev ${vf}
> > 	    ip addr add 2021:db8:${ipaddr_vlan}::1/64 dev ${vf}
> > 	    if ! ip link show $vf | grep 'state UP'; then
> > 		    echo 'Error found'
> > 		    break
> > 	    fi
> > 	    ip link set $vf down
> >     done
> > 
> > Signed-off-by: Wander Lairson Costa <wander@redhat.com>
> > Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
> > Reported-by: Yuying Ma <yuma@redhat.com>
> > Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> > Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > Reviewed-by: Simon Horman <horms@kernel.org>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > index f1d0881687233..b83df5f94b1f5 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -907,7 +907,7 @@ static int igb_request_msix(struct igb_adapter *adapter)
> >  	int i, err = 0, vector = 0, free_vector = 0;
> >  
> >  	err = request_irq(adapter->msix_entries[vector].vector,
> > -			  igb_msix_other, 0, netdev->name, adapter);
> > +			  igb_msix_other, IRQF_NO_THREAD, netdev->name, adapter);
> >  	if (err)
> >  		goto err_out;
> >  
> 
> This is scheduled for being reverted upstream [1]. Please drop from all 
> stable queues.

Now dropped from all of them, thanks.

greg k-h
