Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2823FA5FD;
	Fri,  7 Aug 2026 15:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117405; cv=none; b=KDvZZS7PS+iRpulRtCaqaFH6OFnmEzeCPEzL4glCcUlGld2vgfS0lDrA96F7HoA0ytF/iTnhwdRhFGplYNwwoebBxPqyLnTP1Gdq3U+3UJEePY4hQwCV5ml+Ao64EMqLD/mrKfvJP1kbNPtzr+Fb5nBS25AhqawD6olSR6V+mIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117405; c=relaxed/simple;
	bh=juJQ+gTecay7+m11kqF3FkPVVkOR3zRZdpty3VaXg1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDnv6cpsuhHlsFvVQ41XNaIFUiwOPddhD9wU1pku9oXISpctPEaVj8Y4jFQwumP/3unWG/SmYR4DMmazUsLtG+JIqw6P5YnOYBsMaVLsVX/gGHj3bEPXU9eVqX5sLPtFun6aJX61eIygbZB5OIWhgW2LOGJhsZFV0qpzvFQwsQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0bW3tqD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0bW3tqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6CD1F000E9;
	Fri,  7 Aug 2026 15:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117404;
	bh=q/y/haUiW/jk/3gYcnfh5pqIieM+8CgnURFGe8hdk+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0bW3tqD+E/sH5gMvJ7pYAbXJKXnTEPCMbcjMpmXeikBIDi/GSR5YmfrCAdS5y3VX
	 20bkr06/vplnyPbRSLkEWzDW9raaZJnJTLzF7nIGbPUatUA/uLxJF7bE1keY7vfXBA
	 nYDup04oZt4YELUjuDXGENuanxE7g1bGUsWxDtcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.1 263/438] ata: libata-eh: Increase STANDBY IMMEDIATE timeout
Date: Fri,  7 Aug 2026 16:37:39 +0200
Message-ID: <20260807143433.599064346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Vollrath <tactii@gmail.com>

commit 1e024d2b41ee32bc06818f7f09a3562c58842cf9 upstream.

Correct a previous change (see Fixes) which reduced the standby timeout
from 30 to 5 seconds. Increase it to 15 seconds.

I was troubleshooting an error spotted during system suspend:

    [ 1217.152867] ata1.00: Entering standby power mode
    [ 1222.322948] ata1.00: qc timeout after 5000 msecs (cmd 0xe0)
    [ 1222.324010] ata1.00: STANDBY IMMEDIATE failed (err_mask=0x4)

This drive is a Samsung 870 EVO SSD in good SMART standing, and I wasn't
aware of any reason it should be taking so long to standby. The issue is
intermittent, but I observed it sometimes taking 7 seconds to manually
standby. I assume this was interruption of background maintenance after
a power outage.

As a desktop user, I would prefer to wait the extra 2 seconds at suspend
to let the drive finish its business rather than drop the rails from
under it.

The change from 30 to 5 seconds was implicit when switching suspend
from START STOP UNIT to an internal command with no timeout table entry.
No reason was stated for the change.

Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
Cc: stable@vger.kernel.org
Signed-off-by: Matt Vollrath <tactii@gmail.com>
Assisted-by: Claude:claude-5-fable
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c |    8 ++++++++
 include/linux/libata.h  |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -106,6 +106,12 @@ static const unsigned int ata_eh_flush_t
 	UINT_MAX,
 };
 
+static const unsigned int ata_eh_standby_timeouts[] = {
+	15000,	/* Some drives may be slow to standby */
+	/* but don't hold up a suspend too long waiting for them */
+	UINT_MAX,
+};
+
 static const unsigned int ata_eh_other_timeouts[] = {
 	 5000,	/* same rationale as identify timeout */
 	10000,	/* ditto */
@@ -147,6 +153,8 @@ ata_eh_cmd_timeout_table[ATA_EH_CMD_TIME
 	  .timeouts = ata_eh_other_timeouts, },
 	{ .commands = CMDS(ATA_CMD_FLUSH, ATA_CMD_FLUSH_EXT),
 	  .timeouts = ata_eh_flush_timeouts },
+	{ .commands = CMDS(ATA_CMD_STANDBYNOW1),
+	  .timeouts = ata_eh_standby_timeouts },
 	{ .commands = CMDS(ATA_CMD_VERIFY),
 	  .timeouts = ata_eh_reset_timeouts },
 };
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -425,7 +425,7 @@ enum {
 	/* This should match the actual table size of
 	 * ata_eh_cmd_timeout_table in libata-eh.c.
 	 */
-	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 8,
+	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 9,
 
 	/* User visible DMA mask for DMA control. DO NOT renumber. */
 	ATA_DMA_MASK_ATA	= (1 << 0),	/* DMA on ATA Disk */


