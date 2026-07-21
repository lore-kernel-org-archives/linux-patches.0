Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093C13909A9;
	Tue, 21 Jul 2026 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658247; cv=none; b=PAYiXVW2iVj8EB7e5A5N8Ti3I7aqk/RWLjvXuIIrRCbZPEpqXq2aBocsLaGXSCP+boxkR1Bfk3YZ2Q1UbgSOBQQbtZUQuKPDkCnjkisABSniA6p2OPVXejemd4SQVUYw7f6ETkGgylnzBX73GdK6KOGrbUqdCs7s/jeyoecb+Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658247; c=relaxed/simple;
	bh=qXUaJqXCMtUUEAH+VWkSVERYBqmESEKvyVvX8fo3Afg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaNkRAoz2Oriau6eqhhHsBy6R63/I9lc5bdgBy9+F4SGTrQO8Awyiuxd93nEel0uuTQbky2suVGCBa6ey8phN5B9pFkhmzJcOKXSxAx543M9Ey8d4MVPX3zFX1Q3fluq4bEWaLWZ/fqnK5qM7xOQjoWyP05wYkSybQVYwyBeSrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLGGTxbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLGGTxbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4221F000E9;
	Tue, 21 Jul 2026 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658245;
	bh=rayQBOE54Go6d/2ClfK7bdUoPomv0sKBp2FOFEpkA/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLGGTxbS8UKQPAzG15m3a5UW7TOtQBS9h2HxtGXjhNbpZUh2YDPO7XmQwd+unDkkm
	 C0QQLdzmaF5TCNe/Ov/xcJD8d5Zs9Vq67vacoRKAa6zT/gGoceljZnAeVp38WR8kH3
	 YnehZTHEDX8KJCMZ/Zealk6kzaub0p1PMp26yR6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karuna Ramkumar <rkaruna@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1028/1611] ata: libata-scsi: limit simulated SCSI command copy to response length
Date: Tue, 21 Jul 2026 17:19:04 +0200
Message-ID: <20260721152538.520182640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karuna Ramkumar <rkaruna@google.com>

[ Upstream commit cd64be0ecd399fa2b1ab60b3aaf2b2b744243467 ]

The function ata_scsi_rbuf_fill() is used to copy the response of
emulated SCSI commands from ata_scsi_rbuf to the SCSI command's
scatterlist.

Currently, sg_copy_from_buffer() is called with the size argument
set to ATA_SCSI_RBUF_SIZE (2048 bytes). Since ata_scsi_rbuf is
zeroed out before the simulation actor is invoked, copying the
full buffer size causes the remainder of the SCSI command's
transfer buffer (beyond the actual response length 'len') to be
overwritten with zeroes. This clobbers any pre-existing sentinel
values or data in the caller's buffer tail, even though the
correct residual count is reported via scsi_set_resid().

Fix this by passing the actual response length 'len' as the copy
size to sg_copy_from_buffer(), ensuring that the tail of the
caller's buffer remains untouched. Also, add a defensive check
to ensure that the actor does not return a length exceeding the
static buffer capacity. If this occurs, trigger a WARN_ON(),
fail the command with an aborted command error, and return
immediately without copying any data.

The fix was tested by invoking an SCSI SG_IO INQUIRY on
an ATA disk on vanilla build, and build with the fix. Confirmed
that the input buffer's tail end remains unmodified with the fix.

Fixes: 5251ae224d8d ("ata: libata-scsi: Return residual for emulated SCSI commands")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Karuna Ramkumar <rkaruna@google.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c7d2addf348743..46ef1ef6f81282 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1930,8 +1930,13 @@ static void ata_scsi_rbuf_fill(struct ata_device *dev, struct scsi_cmnd *cmd,
 	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
 	len = actor(dev, cmd, ata_scsi_rbuf);
 	if (len) {
+		if (WARN_ON(len > ATA_SCSI_RBUF_SIZE)) {
+			ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
+			spin_unlock_irqrestore(&ata_scsi_rbuf_lock, flags);
+			return;
+		}
 		sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
-				    ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
+				    ata_scsi_rbuf, len);
 		cmd->result = SAM_STAT_GOOD;
 		if (scsi_bufflen(cmd) > len)
 			scsi_set_resid(cmd, scsi_bufflen(cmd) - len);
-- 
2.53.0



