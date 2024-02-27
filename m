Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC9914037E;
	Tue, 27 Feb 2024 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044086; cv=none; b=b57S8ec0K+ex80KPzGxGwLiFuS4Qqy6ikkkFJq47CeCuzQCp1gKGfKWNhHnGHyecP/TH7eo69MZHTLqEUNkVaywcbSb8EtMN0DkptE0JfXZjkDdYd1Co9D697f3n9mtq0CCVk49ZZbHu4QTJ7z+KTlICRrUcCYAcAEtr1om+IVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044086; c=relaxed/simple;
	bh=Esla4w9WcOmp7MCGilRoPp9+ZsUa5VH09ex34GAOnK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9DXrz6epTim+GsKYx8j+LHDa4hKTglncrk2wKEr8irlRz/kg0WEqRk6Hq8QMgyj5JpGQOsJ6QKsHdfWkqyzBctFz2C3hX7OIefxpgt9ofgStlSQ4SB07ez1ybGTOaQzj48xpL0Wretp89jpUY2gifFtriIuhUZ4uUE75wujhkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbbYFU9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbbYFU9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42228C433C7;
	Tue, 27 Feb 2024 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044086;
	bh=Esla4w9WcOmp7MCGilRoPp9+ZsUa5VH09ex34GAOnK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbbYFU9LrPZ1a8b0NggYcO8NXUwmNIw52Ot8fHSPUZVWWPm7bSMnbDTipSmPOUvrl
	 dG2YoBw6e7Ed2txjwfy3HuBFuH6NIspn/ToWmEtHHX3dKH6484s0sV9NQLzYqWFScg
	 nCYq0cCJyXsR6t1Sr4NjKMSzROdZyGvOwxdtwSr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Goldman <adamg@pobox.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/122] firewire: core: send bus reset promptly on gap count error
Date: Tue, 27 Feb 2024 14:26:41 +0100
Message-ID: <20240227131600.019239440@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 7ed4380009e96d9e9c605e12822e987b35b05648 ]

If we are bus manager and the bus has inconsistent gap counts, send a
bus reset immediately instead of trying to read the root node's config
ROM first. Otherwise, we could spend a lot of time trying to read the
config ROM but never succeeding.

This eliminates a 50+ second delay before the FireWire bus is usable after
a newly connected device is powered on in certain circumstances.

The delay occurs if a gap count inconsistency occurs, we are not the root
node, and we become bus manager. One scenario that causes this is with a TI
XIO2213B OHCI, the first time a Sony DSR-25 is powered on after being
connected to the FireWire cable. In this configuration, the Linux box will
not receive the initial PHY configuration packet sent by the DSR-25 as IRM,
resulting in the DSR-25 having a gap count of 44 while the Linux box has a
gap count of 63.

FireWire devices have a gap count parameter, which is set to 63 on power-up
and can be changed with a PHY configuration packet. This determines the
duration of the subaction and arbitration gaps. For reliable communication,
all nodes on a FireWire bus must have the same gap count.

A node may have zero or more of the following roles: root node, bus manager
(BM), isochronous resource manager (IRM), and cycle master. Unless a root
node was forced with a PHY configuration packet, any node might become root
node after a bus reset. Only the root node can become cycle master. If the
root node is not cycle master capable, the BM or IRM should force a change
of root node.

After a bus reset, each node sends a self-ID packet, which contains its
current gap count. A single bus reset does not change the gap count, but
two bus resets in a row will set the gap count to 63. Because a consistent
gap count is required for reliable communication, IEEE 1394a-2000 requires
that the bus manager generate a bus reset if it detects that the gap count
is inconsistent.

When the gap count is inconsistent, build_tree() will notice this after the
self identification process. It will set card->gap_count to the invalid
value 0. If we become bus master, this will force bm_work() to send a bus
reset when it performs gap count optimization.

After a bus reset, there is no bus manager. We will almost always try to
become bus manager. Once we become bus manager, we will first determine
whether the root node is cycle master capable. Then, we will determine if
the gap count should be changed. If either the root node or the gap count
should be changed, we will generate a bus reset.

To determine if the root node is cycle master capable, we read its
configuration ROM. bm_work() will wait until we have finished trying to
read the configuration ROM.

However, an inconsistent gap count can make this take a long time.
read_config_rom() will read the first few quadlets from the config ROM. Due
to the gap count inconsistency, eventually one of the reads will time out.
When read_config_rom() fails, fw_device_init() calls it again until
MAX_RETRIES is reached. This takes 50+ seconds.

Once we give up trying to read the configuration ROM, bm_work() will wake
up, assume that the root node is not cycle master capable, and do a bus
reset. Hopefully, this will resolve the gap count inconsistency.

This change makes bm_work() check for an inconsistent gap count before
waiting for the root node's configuration ROM. If the gap count is
inconsistent, bm_work() will immediately do a bus reset. This eliminates
the 50+ second delay and rapidly brings the bus to a working state.

I considered that if the gap count is inconsistent, a PHY configuration
packet might not be successful, so it could be desirable to skip the PHY
configuration packet before the bus reset in this case. However, IEEE
1394a-2000 and IEEE 1394-2008 say that the bus manager may transmit a PHY
configuration packet before a bus reset when correcting a gap count error.
Since the standard endorses this, I decided it's safe to retain the PHY
configuration packet transmission.

Normally, after a topology change, we will reset the bus a maximum of 5
times to change the root node and perform gap count optimization. However,
if there is a gap count inconsistency, we must always generate a bus reset.
Otherwise the gap count inconsistency will persist and communication will
be unreliable. For that reason, if there is a gap count inconstency, we
generate a bus reset even if we already reached the 5 reset limit.

Signed-off-by: Adam Goldman <adamg@pobox.com>
Reference: https://sourceforge.net/p/linux1394/mailman/message/58727806/
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-card.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index f3b3953cac834..be195ba834632 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -429,7 +429,23 @@ static void bm_work(struct work_struct *work)
 	 */
 	card->bm_generation = generation;
 
-	if (root_device == NULL) {
+	if (card->gap_count == 0) {
+		/*
+		 * If self IDs have inconsistent gap counts, do a
+		 * bus reset ASAP. The config rom read might never
+		 * complete, so don't wait for it. However, still
+		 * send a PHY configuration packet prior to the
+		 * bus reset. The PHY configuration packet might
+		 * fail, but 1394-2008 8.4.5.2 explicitly permits
+		 * it in this case, so it should be safe to try.
+		 */
+		new_root_id = local_id;
+		/*
+		 * We must always send a bus reset if the gap count
+		 * is inconsistent, so bypass the 5-reset limit.
+		 */
+		card->bm_retries = 0;
+	} else if (root_device == NULL) {
 		/*
 		 * Either link_on is false, or we failed to read the
 		 * config rom.  In either case, pick another root.
-- 
2.43.0



