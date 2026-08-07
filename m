Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254512FF641;
	Fri,  7 Aug 2026 14:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114160; cv=none; b=TXNixT8oDLANdpGpC7oZ120Lxo9lwHCZ6r1J+q3qups3u4ZbzPk8uTmAnL9ZzyuO22jvKcuBJRZSI5W90cCvUxg8DMKH1NgOU9x+IW7POH5D1m3N2HlIr2KAjsIIwBaGNy77R80RwJa8xdUDzIiW/QiOn//boYpoDQJOENT3z0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114160; c=relaxed/simple;
	bh=ifX5yE5d96T826BBHlxlkTe7DH+OKm0B3fW2c8Eqh/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2q3r5RyeGXASR+jbJ4HgScLHBr7CCpiS+DLb7H6JezHxFYV7J1tLbY3ycVSPyzpuEUIszJwM8ERKiRRx63adjpmYABIUShdQMZt+WrK3JTRkk0C6ELdk/j/ciVrH7YTjM21JIMDYvWLmfP/OeQOLnDEDCq2H93VA65xmtoPlis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh4yQwoD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh4yQwoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805991F000E9;
	Fri,  7 Aug 2026 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114159;
	bh=n7xHTPqSB+nXNPSx+9cW/gkPFscKh+EQzeLksA7jAQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oh4yQwoDQrLnu0MXLKNR4Y8gu9+5sGvGb+IpUGn6hJ4kAAkeCu5FJq7XwYw3t1ds8
	 nfn1A/2gwzybvDmfmO79n6/g3QaE9ecRioWPgHntjD6j/9977nrZLr7v4ym50XKPtS
	 FB9aNJFVMAtSa7uXDQTqi2MV3wdHYOH0MXfFtLOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 163/337] ata: libata-eh: Increase STANDBY IMMEDIATE timeout
Date: Fri,  7 Aug 2026 16:36:06 +0200
Message-ID: <20260807143422.085089748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -402,7 +402,7 @@ enum {
 	/* This should match the actual table size of
 	 * ata_eh_cmd_timeout_table in libata-eh.c.
 	 */
-	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 8,
+	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 9,
 
 	/*
 	 * Quirk flags: may be set by libata or controller drivers on drives.


