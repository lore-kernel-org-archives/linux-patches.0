Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD536FAF
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 08:45:40 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30D1AD75;
	Thu, 10 Aug 2023 01:46:16 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 899C13F59C;
	Thu, 10 Aug 2023 01:45:32 -0700 (PDT)
Date: Thu, 10 Aug 2023 09:45:29 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Jim Quinlan <james.quinlan@broadcom.com>, patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 11/92] firmware: arm_scmi: Fix chan_free cleanup on
 SMC
Message-ID: <20230810084529.53thk6dmlejbma3t@bogus>
References: <20230809103633.485906560@linuxfoundation.org>
 <20230809103633.950016368@linuxfoundation.org>
 <cf831d49-ebdc-d132-9b8e-189e9688a9f2@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf831d49-ebdc-d132-9b8e-189e9688a9f2@gmail.com>

On Wed, Aug 09, 2023 at 12:33:17PM -0700, Florian Fainelli wrote:
> On 8/9/23 03:40, Greg Kroah-Hartman wrote:
> > From: Cristian Marussi <cristian.marussi@arm.com>
> > 
> > [ Upstream commit d1ff11d7ad8704f8d615f6446041c221b2d2ec4d ]
> > 
> > SCMI transport based on SMC can optionally use an additional IRQ to
> > signal message completion. The associated interrupt handler is currently
> > allocated using devres but on shutdown the core SCMI stack will call
> > .chan_free() well before any managed cleanup is invoked by devres.
> > As a consequence, the arrival of a late reply to an in-flight pending
> > transaction could still trigger the interrupt handler well after the
> > SCMI core has cleaned up the channels, with unpleasant results.
> > 
> > Inhibit further message processing on the IRQ path by explicitly freeing
> > the IRQ inside .chan_free() callback itself.
> > 
> > Fixes: dd820ee21d5e ("firmware: arm_scmi: Augment SMC/HVC to allow optional interrupt")
> > Reported-by: Bjorn Andersson <andersson@kernel.org>
> > Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
> > Link: https://lore.kernel.org/r/20230719173533.2739319-1-cristian.marussi@arm.com
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/firmware/arm_scmi/smc.c | 17 +++++++++++------
> >   1 file changed, 11 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
> > index 4effecc3bb463..f529004f1922e 100644
> > --- a/drivers/firmware/arm_scmi/smc.c
> > +++ b/drivers/firmware/arm_scmi/smc.c
> > @@ -21,6 +21,7 @@
> >   /**
> >    * struct scmi_smc - Structure representing a SCMI smc transport
> >    *
> > + * @irq: An optional IRQ for completion
> >    * @cinfo: SCMI channel info
> >    * @shmem: Transmit/Receive shared memory area
> >    * @shmem_lock: Lock to protect access to Tx/Rx shared memory area
> > @@ -30,6 +31,7 @@
> >    */
> >   struct scmi_smc {
> > +	int irq;
> 
> For this backport to apply as-is and not define a duplicate "int irq" field
> we need to take in f716cbd33f038af87824c30e165b3b70e4c6be1e ("firmware:
> arm_scmi: Make smc transport use common completions") which did remove the
> "int irq" from struct scmi_smc.
> 
> Alternatively, we can just omit this hunk adding the "int irq" member from
> the back port.
>

There is a bit disconnect in the communication here. I didn't see Greg was
not cc-ed on the earlier email to Sasha[1]. The request to drop it was also
made here[2].

> This is a 5.15 stable kernel problem only because
> f716cbd33f038af87824c30e165b3b70e4c6be1e is in v5.18 and newer.

-- 
Regards,
Sudeep

[1] https://marc.info/?l=linux-stable-commits&m=169159392424103&w=2
(couldn't find a lore link for the above)
[2] https://lore.kernel.org/all/ZNIdrd+SQ0KjYWKA@e120937-lin/

