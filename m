Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226AC1FA16B
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 05:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740116383; cv=none; b=UJoYos2IUmJk03Xi7D33ijn1MaKY2UnZf2+7U4obIOwiuynJpnnKsHfXwyE8K18ZWUCqHZct2zBza6sQIaj7TaNtrkRqNnUC2lb3fJ2x3uKz1A3WJB/MFwTBVnJ+lHTklDM3G+QhnIfzpI1oaRgHKpAZEihjNU11dsRCmqAim7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740116383; c=relaxed/simple;
	bh=7ZM+c2zuBfdGO8aEbv7BYuuVzor3LCTYBVCAGRztN8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwmxXrPS4tSW8kEyTiXYPtrL9UJvK0BFy5K7J+xRlZHAcb+fqp+aYYxbkFw1B/QUo79XHykf46gz01fX7om0uIgSytNbnmJpIREYDlKmmZkeU1FOyj6B8Amr4MKD8JF6yLVcizckBJ71CAtK3PZYAODF+ImcRiAUJoO1I0KR6qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=pf7SQ3Yu; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="pf7SQ3Yu"
Received: from [100.79.233.240] (unknown [4.194.122.144])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9D91C204E591;
	Thu, 20 Feb 2025 21:39:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9D91C204E591
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1740116379;
	bh=g5tF/a5zfSi/oP/pYxV+nmAsJIg7jZEBEZsOiqaUpI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pf7SQ3Yu+walwh8pB7WqcWKbMB2lL9m2brwPnBfYyHs2hOhXbY1M/SpUYZbKTnFEJ
	 tItduWSbjIFn23XuR5tfluNKQS9bmXzEDBo4oQ6LwZ9H2e029qYc+vt9v1QpbMquof
	 AEas7mRgxPv2llANzLhhicYQPJSZrQcKOk8l8ndM=
Message-ID: <7278b63c-4858-418b-8ca2-c0fd50f215c8@linux.microsoft.com>
Date: Fri, 21 Feb 2025 11:09:32 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 085/274] Drivers: hv: vmbus: Wait for boot-time
 offers during boot and resume
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, John Starks <jostarks@microsoft.com>,
 Easwar Hariharan <eahariha@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>, Wei Liu <wei.liu@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082612.949436698@linuxfoundation.org>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <20250219082612.949436698@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/19/2025 1:55 PM, Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Naman Jain <namjain@linux.microsoft.com>
> 
> [ Upstream commit 113386ca981c3997db6b83272c7ecf47456aeddb ]
> 
> Channel offers are requested during VMBus initialization and resume from
> hibernation. Add support to wait for all boot-time channel offers to
> be delivered and processed before returning from vmbus_request_offers.
> 
> This is in analogy to a PCI bus not returning from probe until it has
> scanned all devices on the bus.
> 
> Without this, user mode can race with VMBus initialization and miss
> channel offers. User mode has no way to work around this other than
> sleeping for a while, since there is no way to know when VMBus has
> finished processing boot-time offers.
> 
> With this added functionality, remove earlier logic which keeps track
> of count of offered channels post resume from hibernation. Once all
> offers delivered message is received, no further boot-time offers are
> going to be received. Consequently, logic to prevent suspend from
> happening after previous resume had missing offers, is also removed.
> 
> Co-developed-by: John Starks <jostarks@microsoft.com>
> Signed-off-by: John Starks <jostarks@microsoft.com>
> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
> Reviewed-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
> Reviewed-by: Michael Kelley <mhklinux@outlook.com>
> Link: https://lore.kernel.org/r/20250102130712.1661-2-namjain@linux.microsoft.com
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Message-ID: <20250102130712.1661-2-namjain@linux.microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/hv/channel_mgmt.c | 61 +++++++++++++++++++++++++++++----------
>   drivers/hv/connection.c   |  4 +--
>   drivers/hv/hyperv_vmbus.h | 14 ++-------
>   drivers/hv/vmbus_drv.c    | 16 ----------
>   4 files changed, 51 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 3c6011a48dabe..6e084c2074141 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -944,16 +944,6 @@ void vmbus_initiate_unload(bool crash)
>   		vmbus_wait_for_unload();
>   }
>   
> -static void check_ready_for_resume_event(void)
> -{
> -	/*
> -	 * If all the old primary channels have been fixed up, then it's safe
> -	 * to resume.
> -	 */
> -	if (atomic_dec_and_test(&vmbus_connection.nr_chan_fixup_on_resume))
> -		complete(&vmbus_connection.ready_for_resume_event);
> -}
> -
>   static void vmbus_setup_channel_state(struct vmbus_channel *channel,
>   				      struct vmbus_channel_offer_channel *offer)
>   {
> @@ -1109,8 +1099,6 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
>   
>   		/* Add the channel back to the array of channels. */
>   		vmbus_channel_map_relid(oldchannel);
> -		check_ready_for_resume_event();
> -
>   		mutex_unlock(&vmbus_connection.channel_mutex);
>   		return;
>   	}
> @@ -1296,13 +1284,28 @@ EXPORT_SYMBOL_GPL(vmbus_hvsock_device_unregister);
>   
>   /*
>    * vmbus_onoffers_delivered -
> - * This is invoked when all offers have been delivered.
> + * The CHANNELMSG_ALLOFFERS_DELIVERED message arrives after all
> + * boot-time offers are delivered. A boot-time offer is for the primary
> + * channel for any virtual hardware configured in the VM at the time it boots.
> + * Boot-time offers include offers for physical devices assigned to the VM
> + * via Hyper-V's Discrete Device Assignment (DDA) functionality that are
> + * handled as virtual PCI devices in Linux (e.g., NVMe devices and GPUs).
> + * Boot-time offers do not include offers for VMBus sub-channels. Because
> + * devices can be hot-added to the VM after it is booted, additional channel
> + * offers that aren't boot-time offers can be received at any time after the
> + * all-offers-delivered message.
>    *
> - * Nothing to do here.
> + * SR-IOV NIC Virtual Functions (VFs) assigned to a VM are not considered
> + * to be assigned to the VM at boot-time, and offers for VFs may occur after
> + * the all-offers-delivered message. VFs are optional accelerators to the
> + * synthetic VMBus NIC and are effectively hot-added only after the VMBus
> + * NIC channel is opened (once it knows the guest can support it, via the
> + * sriov bit in the netvsc protocol).
>    */
>   static void vmbus_onoffers_delivered(
>   			struct vmbus_channel_message_header *hdr)
>   {
> +	complete(&vmbus_connection.all_offers_delivered_event);
>   }
>   
>   /*
> @@ -1578,7 +1581,8 @@ void vmbus_onmessage(struct vmbus_channel_message_header *hdr)
>   }
>   
>   /*
> - * vmbus_request_offers - Send a request to get all our pending offers.
> + * vmbus_request_offers - Send a request to get all our pending offers
> + * and wait for all boot-time offers to arrive.
>    */
>   int vmbus_request_offers(void)
>   {
> @@ -1596,6 +1600,10 @@ int vmbus_request_offers(void)
>   
>   	msg->msgtype = CHANNELMSG_REQUESTOFFERS;
>   
> +	/*
> +	 * This REQUESTOFFERS message will result in the host sending an all
> +	 * offers delivered message after all the boot-time offers are sent.
> +	 */
>   	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_message_header),
>   			     true);
>   
> @@ -1607,6 +1615,29 @@ int vmbus_request_offers(void)
>   		goto cleanup;
>   	}
>   
> +	/*
> +	 * Wait for the host to send all boot-time offers.
> +	 * Keeping it as a best-effort mechanism, where a warning is
> +	 * printed if a timeout occurs, and execution is resumed.
> +	 */
> +	if (!wait_for_completion_timeout(&vmbus_connection.all_offers_delivered_event,
> +					 secs_to_jiffies(60))) {
> +		pr_warn("timed out waiting for all boot-time offers to be delivered.\n");
> +	}
> +
> +	/*
> +	 * Flush handling of offer messages (which may initiate work on
> +	 * other work queues).
> +	 */
> +	flush_workqueue(vmbus_connection.work_queue);
> +
> +	/*
> +	 * Flush workqueue for processing the incoming offers. Subchannel
> +	 * offers and their processing can happen later, so there is no need to
> +	 * flush that workqueue here.
> +	 */
> +	flush_workqueue(vmbus_connection.handle_primary_chan_wq);
> +
>   cleanup:
>   	kfree(msginfo);
>   
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index f001ae880e1db..8351360bba161 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -34,8 +34,8 @@ struct vmbus_connection vmbus_connection = {
>   
>   	.ready_for_suspend_event = COMPLETION_INITIALIZER(
>   				  vmbus_connection.ready_for_suspend_event),
> -	.ready_for_resume_event	= COMPLETION_INITIALIZER(
> -				  vmbus_connection.ready_for_resume_event),
> +	.all_offers_delivered_event = COMPLETION_INITIALIZER(
> +				  vmbus_connection.all_offers_delivered_event),
>   };
>   EXPORT_SYMBOL_GPL(vmbus_connection);
>   
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 52cb744b4d7fd..e4058af987316 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -287,18 +287,10 @@ struct vmbus_connection {
>   	struct completion ready_for_suspend_event;
>   
>   	/*
> -	 * The number of primary channels that should be "fixed up"
> -	 * upon resume: these channels are re-offered upon resume, and some
> -	 * fields of the channel offers (i.e. child_relid and connection_id)
> -	 * can change, so the old offermsg must be fixed up, before the resume
> -	 * callbacks of the VSC drivers start to further touch the channels.
> +	 * Completed once the host has offered all boot-time channels.
> +	 * Note that some channels may still be under process on a workqueue.
>   	 */
> -	atomic_t nr_chan_fixup_on_resume;
> -	/*
> -	 * vmbus_bus_resume() waits for "nr_chan_fixup_on_resume" to
> -	 * drop to zero.
> -	 */
> -	struct completion ready_for_resume_event;
> +	struct completion all_offers_delivered_event;
>   };
>   
>   
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 2892b8da20a5e..bf5608a740561 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -2427,11 +2427,6 @@ static int vmbus_bus_suspend(struct device *dev)
>   	if (atomic_read(&vmbus_connection.nr_chan_close_on_suspend) > 0)
>   		wait_for_completion(&vmbus_connection.ready_for_suspend_event);
>   
> -	if (atomic_read(&vmbus_connection.nr_chan_fixup_on_resume) != 0) {
> -		pr_err("Can not suspend due to a previous failed resuming\n");
> -		return -EBUSY;
> -	}
> -
>   	mutex_lock(&vmbus_connection.channel_mutex);
>   
>   	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
> @@ -2456,17 +2451,12 @@ static int vmbus_bus_suspend(struct device *dev)
>   			pr_err("Sub-channel not deleted!\n");
>   			WARN_ON_ONCE(1);
>   		}
> -
> -		atomic_inc(&vmbus_connection.nr_chan_fixup_on_resume);
>   	}
>   
>   	mutex_unlock(&vmbus_connection.channel_mutex);
>   
>   	vmbus_initiate_unload(false);
>   
> -	/* Reset the event for the next resume. */
> -	reinit_completion(&vmbus_connection.ready_for_resume_event);
> -
>   	return 0;
>   }
>   
> @@ -2502,14 +2492,8 @@ static int vmbus_bus_resume(struct device *dev)
>   	if (ret != 0)
>   		return ret;
>   
> -	WARN_ON(atomic_read(&vmbus_connection.nr_chan_fixup_on_resume) == 0);
> -
>   	vmbus_request_offers();
>   
> -	if (wait_for_completion_timeout(
> -		&vmbus_connection.ready_for_resume_event, secs_to_jiffies(10)) == 0)
> -		pr_err("Some vmbus device is missing after suspending?\n");
> -
>   	/* Reset the event for the next suspend. */
>   	reinit_completion(&vmbus_connection.ready_for_suspend_event);
>   


Hi,
Thanks for porting this.
While we are picking this patch, it would be good to have the other
patch, which was part of the same series, picked as well. Reason being, with
this patch alone, we won't get any prints for missing offers. Patch 2/2
of the series adds those prints back.

commit	fcf5203e289ca0ef75a18ce74a9eb716f7f1f569 (patch)

Series: 
https://lore.kernel.org/all/20250102130712.1661-3-namjain@linux.microsoft.com/

Regards,
Naman

