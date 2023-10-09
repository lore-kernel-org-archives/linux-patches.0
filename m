Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691B03419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfIK3h7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E62C433C8;
	Mon,  9 Oct 2023 13:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859576;
	bh=ksmN2IyMBwJbFiKdeUTvJ94LN4pJ5Qf7pw+7PVRwMMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfIK3h7qXlea/5jf/9Q0vfZynIvr4U3+fvTKt6/5jtp5919rLeuQvGfhNMt4A7Edn
	 bMkTzO5eO8e1fTxdvcnpy6DXXAi+GHf5a2027sBnECtwbUtFiKblTjqiqM+Pid64ts
	 CihaId/YhG/6D7nEN+l9pT/S7RmVn8PtIPU6wdrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/91] ata: libata-eh: do not clear ATA_PFLAG_EH_PENDING in ata_eh_reset()
Date: Mon,  9 Oct 2023 15:06:10 +0200
Message-ID: <20231009130112.849830018@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit 80cc944eca4f0baa9c381d0706f3160e491437f2 ]

ata_scsi_port_error_handler() starts off by clearing ATA_PFLAG_EH_PENDING,
before calling ap->ops->error_handler() (without holding the ap->lock).

If an error IRQ is received while ap->ops->error_handler() is running,
the irq handler will set ATA_PFLAG_EH_PENDING.

Once ap->ops->error_handler() returns, ata_scsi_port_error_handler()
checks if ATA_PFLAG_EH_PENDING is set, and if it is, another iteration
of ATA EH is performed.

The problem is that ATA_PFLAG_EH_PENDING is not only cleared by
ata_scsi_port_error_handler(), it is also cleared by ata_eh_reset().

ata_eh_reset() is called by ap->ops->error_handler(). This additional
clearing done by ata_eh_reset() breaks the whole retry logic in
ata_scsi_port_error_handler(). Thus, if an error IRQ is received while
ap->ops->error_handler() is running, the port will currently remain
frozen and will never get re-enabled.

The additional clearing in ata_eh_reset() was introduced in commit
1e641060c4b5 ("libata: clear eh_info on reset completion").

Looking at the original error report:
https://marc.info/?l=linux-ide&m=124765325828495&w=2

We can see the following happening:
[    1.074659] ata3: XXX port freeze
[    1.074700] ata3: XXX hardresetting link, stopping engine
[    1.074746] ata3: XXX flipping SControl

[    1.411471] ata3: XXX irq_stat=400040 CONN|PHY
[    1.411475] ata3: XXX port freeze

[    1.420049] ata3: XXX starting engine
[    1.420096] ata3: XXX rc=0, class=1
[    1.420142] ata3: XXX clearing IRQs for thawing
[    1.420188] ata3: XXX port thawed
[    1.420234] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)

We are not supposed to be able to receive an error IRQ while the port is
frozen (PxIE is set to 0, i.e. all IRQs for the port are disabled).

AHCI 1.3.1 section 10.7.1.1 First Tier (IS Register) states:
"Each bit location can be thought of as reporting a '1' if the virtual
"interrupt line" for that port is indicating it wishes to generate an
interrupt. That is, if a port has one or more interrupt status bit set,
and the enables for those status bits are set, then this bit shall be set."

Additionally, AHCI state P:ComInit clearly shows that the state machine
will only jump to P:ComInitSetIS (which sets IS.IPS(x) to '1'), if PxIE.PCE
is set to '1'. In our case, PxIE is set to 0, so IS.IPS(x) won't get set.

So IS.IPS(x) only gets set if PxIS and PxIE is set.

AHCI 1.3.1 section 10.7.1.1 First Tier (IS Register) also states:
"The bits in this register are read/write clear. It is set by the level of
the virtual interrupt line being a set, and cleared by a write of '1' from
the software."

So if IS.IPS(x) is set, you need to explicitly clear it by writing a 1 to
IS.IPS(x) for that port.

Since PxIE is cleared, the only way to get an interrupt while the port is
frozen, is if IS.IPS(x) is set, and the only way IS.IPS(x) can be set when
the port is frozen, is if it was set before the port was frozen.

However, since commit 737dd811a3db ("ata: libahci: clear pending interrupt
status"), we clear both PxIS and IS.IPS(x) after freezing the port, but
before the COMRESET, so the problem that commit 1e641060c4b5 ("libata:
clear eh_info on reset completion") fixed can no longer happen.

Thus, revert commit 1e641060c4b5 ("libata: clear eh_info on reset
completion"), so that the retry logic in ata_scsi_port_error_handler()
works once again. (The retry logic is still needed, since we can still
get an error IRQ _after_ the port has been thawed, but before
ata_scsi_port_error_handler() takes the ap->lock in order to check
if ATA_PFLAG_EH_PENDING is set.)

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index fcc3d7985762a..73a4dd37d04ae 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2922,18 +2922,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			postreset(slave, classes);
 	}
 
-	/*
-	 * Some controllers can't be frozen very well and may set spurious
-	 * error conditions during reset.  Clear accumulated error
-	 * information and re-thaw the port if frozen.  As reset is the
-	 * final recovery action and we cross check link onlineness against
-	 * device classification later, no hotplug event is lost by this.
-	 */
+	/* clear cached SError */
 	spin_lock_irqsave(link->ap->lock, flags);
-	memset(&link->eh_info, 0, sizeof(link->eh_info));
+	link->eh_info.serror = 0;
 	if (slave)
-		memset(&slave->eh_info, 0, sizeof(link->eh_info));
-	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
+		slave->eh_info.serror = 0;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
 	if (ap->pflags & ATA_PFLAG_FROZEN)
-- 
2.40.1



