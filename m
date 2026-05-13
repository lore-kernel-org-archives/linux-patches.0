Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFB13FF8AF;
	Wed, 13 May 2026 12:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778673602; cv=none; b=YXf5mz3GmDazhhnjROgKSffWnIYXhy/Kg9ZRh/NuvZoI69h7MJfSX8sdlrMsqe4iEGnedUqopt9DmnAKKJz5yzDvYa17P4iS1asr/3LCE42eRZelVNwJykkj15VH0CjsxWMbgc3QDibtygdKRRKtu9mMWQuzxtMAmnU6Ngcr5BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778673602; c=relaxed/simple;
	bh=rDyAK26aGOYfbUbu/ym3LaJ8PItdj1J5F9jXQrDoDHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d0UyJYZyZ3sF14vKYKgv4b37NianZM3/0axS37xqwrm7klaNiCIPHI0bL2i/+cHu0wCFiXd+6pt/mahsKadSiM3M/g3l4P2Y/+Vhv8WbMPVoATYiAh0n1TYerB0MwOtw5Y2GpwTJIOkLOIwLKoccy0bve4yfN9FjjaChuF7TeRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AM2kCJ9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AM2kCJ9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85018C2BCB7;
	Wed, 13 May 2026 12:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778673602;
	bh=rDyAK26aGOYfbUbu/ym3LaJ8PItdj1J5F9jXQrDoDHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AM2kCJ9aCJv5UF71peOdd8k39wuahLShaCiAezc9pdqtgIopvPoM+oC069HB7xFbo
	 nFuTyVL5EY3+cSxwoSYdbThhOHAZhGoC6N+w+wLZGLP8d30AAYWj27QoR49IXOetn4
	 uercAkgZImVfavrocLyeCiwkq0jNyhXYxD/sbDiU=
Date: Wed, 13 May 2026 14:00:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>, stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Vijayendra Suman <vijayendra.suman@oracle.com>
Subject: Re: [PATCH 6.12 046/206] usb: typec: tcpm: reset internal port
 states on soft reset AMS
Message-ID: <2026051351-creme-primary-89ae@gregkh>
References: <20260512173932.810559588@linuxfoundation.org>
 <20260512173933.811124271@linuxfoundation.org>
 <95aa6c6a-6ebe-4ae0-9376-63aa9fb8872c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95aa6c6a-6ebe-4ae0-9376-63aa9fb8872c@oracle.com>

On Wed, May 13, 2026 at 05:05:50PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 12/05/26 23:08, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Amit Sunil Dhamne <amitsd@google.com>
> > 
> > commit 2909f0d4994fb4306bf116df5ccee797791fce2c upstream.
> > 
> > Reset internal port states (such as vdm_sm_running and
> > explicit_contract) on soft reset AMS as the port needs to negotiate a
> > new contract. The consequence of leaving the states in as-is cond are as
> > follows:
> >    * port is in SRC power role and an explicit contract is negotiated
> >      with the port partner (in sink role)
> >    * port partner sends a Soft Reset AMS while VDM State Machine is
> >      running
> >    * port accepts the Soft Reset request and the port advertises src caps
> >    * port partner sends a Request message but since the explicit_contract
> >      and vdm_sm_running are true from previous negotiation, the port ends
> >      up sending Soft Reset instead of Accept msg.
> > 
> > Stub Log:
> > [  203.653942] AMS DISCOVER_IDENTITY start
> > [  203.653947] PD TX, header: 0x176f
> > [  203.655901] PD TX complete, status: 0
> > [  203.657470] PD RX, header: 0x124f [1]
> > [  203.657477] Rx VDM cmd 0xff008081 type 2 cmd 1 len 1
> > [  203.657482] AMS DISCOVER_IDENTITY finished
> > [  203.657484] cc:=4
> > [  204.155698] PD RX, header: 0x144f [1]
> > [  204.155718] Rx VDM cmd 0xeeee8001 type 0 cmd 1 len 1
> > [  204.155741] PD TX, header: 0x196f
> > [  204.157622] PD TX complete, status: 0
> > [  204.160060] PD RX, header: 0x4d [1]
> > [  204.160066] state change SRC_READY -> SOFT_RESET [rev2 SOFT_RESET_AMS]
> > [  204.160076] PD TX, header: 0x163
> > [  204.162486] PD TX complete, status: 0
> > [  204.162832] AMS SOFT_RESET_AMS finished
> > [  204.162840] cc:=4
> > [  204.162891] AMS POWER_NEGOTIATION start
> > [  204.162896] state change SOFT_RESET -> AMS_START [rev2 POWER_NEGOTIATION]
> > [  204.162908] state change AMS_START -> SRC_SEND_CAPABILITIES [rev2 POWER_NEGOTIATION]
> > [  204.162913] PD TX, header: 0x1361
> > [  204.165529] PD TX complete, status: 0
> > [  204.165571] pending state change SRC_SEND_CAPABILITIES -> SRC_SEND_CAPABILITIES_TIMEOUT @ 60 ms [rev2 POWER_NEGOTIATION]
> > [  204.166996] PD RX, header: 0x1242 [1]
> > [  204.167009] state change SRC_SEND_CAPABILITIES -> SRC_SOFT_RESET_WAIT_SNK_TX [rev2 POWER_NEGOTIATION]
> > [  204.167019] AMS POWER_NEGOTIATION finished
> > [  204.167020] cc:=4
> > [  204.167083] AMS SOFT_RESET_AMS start
> > [  204.167086] state change SRC_SOFT_RESET_WAIT_SNK_TX -> SOFT_RESET_SEND [rev2 SOFT_RESET_AMS]
> > [  204.167092] PD TX, header: 0x16d
> > [  204.168824] PD TX complete, status: 0
> > [  204.168854] pending state change SOFT_RESET_SEND -> HARD_RESET_SEND @ 60 ms [rev2 SOFT_RESET_AMS]
> > [  204.171876] PD RX, header: 0x43 [1]
> > [  204.171879] AMS SOFT_RESET_AMS finished
> > 
> > This causes COMMON.PROC.PD.11.2 check failure for
> > TEST.PD.VDM.SRC.2_Rev2Src test on the PD compliance tester.
> > 
> > Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
> > Fixes: 8d3a0578ad1a ("usb: typec: tcpm: Respond Wait if VDM state machine is running")
> > Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
> > Cc: stable <stable@kernel.org>
> > Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
> > Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Link: https://patch.msgid.link/20260414-fix-soft-reset-v1-1-01d7cb9764e2@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/usb/typec/tcpm/tcpm.c |    2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > --- a/drivers/usb/typec/tcpm/tcpm.c
> > +++ b/drivers/usb/typec/tcpm/tcpm.c
> > @@ -5614,6 +5614,8 @@ static void run_state_machine(struct tcp
> >   	case VCONN_SWAP_ACCEPT:
> >   		tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> > +		port->vdm_sm_running = false;
> > +		port->explicit_contract = false;
> 
> 
> I have run an AI assisted backport review and it spotted an issue: I
> have taken a look and the issues goes like:
> 
> Upstream commit adds it here:
> 
>         /* Soft_Reset states */
>         case SOFT_RESET:
>                 port->message_id = 0;
>                 port->rx_msgid = -1;
>                 /* remove existing capabilities */
>                 tcpm_partner_source_caps_reset(port);
>                 tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> +               port->vdm_sm_running = false;
> +               port->explicit_contract = false;
>                 tcpm_ams_finish(port);
>                 if (port->pwr_role == TYPEC_SOURCE) {
>                         port->upcoming_state = SRC_SEND_CAPABILITIES;
>                         tcpm_ams_start(port, POWER_NEGOTIATION);
>                 } else {
> 
> downstream backport adds the reset in other case:
> 
> 
>         case VCONN_SWAP_ACCEPT:
>                 tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> +               port->vdm_sm_running = false;
> +               port->explicit_contract = false;
>                 tcpm_ams_finish(port);
>                 tcpm_set_state(port, VCONN_SWAP_START, 0);
>                 break;
> 
> I think we need to rework on this backport, so I think for the time being we
> should drop this backport.

Wow, patch fuzz got it wrong, good catch!

I'll drop this from all queues now.

greg k-h
