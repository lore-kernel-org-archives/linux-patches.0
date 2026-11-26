Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704677;
	b=tCg5mclSyA+3bFphSW80OqScTNOMiwlpV7Yp8Jujry3h7pFFZ3fgVthgqmndBkfJ52T5
	 X8//VmltTEqUXpkhSIXW/7g1jJkAWz0MFfaZO85uWoZqvfF7cC+JJAACGzRaOxJxmWMVn
	 EULN6BFT4PAhS4uDiGCho1WOpGZJ/GnL9xt+L5Ox7Y/tVDEN7QhvGM/81C1KBFCU0/bRa
	 G/lxsQk9G2fyQwtdVdH5EW9CghhDXVzmdDw3rhOBopy5oS0a/JJlGZ50iflsmNd3dClyM
	 vRgpEXHLFcFjol/9K2buGRw4q9hMNlhp0GA1SvwVmEfXDc5+rW+rdUBilYmRy9G/2ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XA49V0sIqK1dQEMblUKVkgURCkkb/S2t1ldE3K0jAFU=;
	b=wnNqsSDsdtxk+/HWyAAslHLVOv4RQjMTuFRb5VCCLq3GAk/uxBWD3BYdlANl0JkacUFL
	 CXV2D/5XyJcqasob66cDRhWqc5hjeEEgp+BN5u9T5saA2C9ia/I2IWSTKUIgPp9FpTYBk
	 V2pbOjWP+wzUb4egh6kZbiOC9M9yjLE2Ggb52kfLQb35Qs07xueDItno6bBftma3wb24o
	 INWR/DAhQNVRu2Tts/dpnsqNBXb0fXQvzX/64xvDXUrMKiPhRBZjzFml2eD5OFPoD+Xk7
	 BGPZYXFFn7/zWOpylypS4/0qVzdJfiwadYT+aULSndghQS6BeHoF5xpZJaoofu2yz5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mp5nySJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE67606A31C;
	Thu, 26 Nov 2026 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mp5nySJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE01F000C4;
	Thu, 26 Nov 2026 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704676;
	bh=XA49V0sIqK1dQEMblUKVkgURCkkb/S2t1ldE3K0jAFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mp5nySJhn80NaNRAbn+c6Tkb+tzC5YkGBnxdl2BJe7DOSOJC5uwA4BOnoLXOzNmVe
	 wTue0nEkzVJN+RPsQtVHRPItFtTJ4NUxSjvN/qFsv5sgmK6aYzkhfH2rmqr/Rn8FRD
	 Z2nstgz925QMfjH4Ar6uetLxiFP5joMb9++gJ/9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 207/265] dm zoned: back off when reclaim cannot make progress
Date: Thu, 26 Nov 2026 15:38:57 +0100
Message-ID: <20261126143619.673450658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyrylo Biryuk <illofspeed@gmail.com>

commit 9bb1d14877f4929be17f7fdbeb4cfdf5025d464b upstream.

When a reclaim pass cannot make progress, dmz_reclaim_work() still ends
with dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
keeps returning true, the work is queued again with no delay and the
worker spins on the same failing pass. This patch handles two such
cases:

  - dmz_do_reclaim() fails with -ENOSPC because no free zone is
    available to copy the data into, for example on a target without
    cache zones that has no free sequential zone left. The next patch
    also makes this the expected result when an idle target with cache
    zones has random zones but no free sequential zone.
  - dmz_do_reclaim() finds no zone it can lock for reclaim and returns
    -EBUSY. Since commit 90a9b8693f1b ("dm zoned: reclaim random zones
    when idle"), dmz_should_reclaim() returns true on an idle target
    whenever the total number of random (and cache) zones is non-zero,
    whether or not any of them holds data. Each pass then also runs
    dmz_check_dev(), which checks every device for media events (a TEST
    UNIT READY on SCSI disks).

The -EBUSY loop lasts as long as the target stays idle; it ends when a
pass finishes while the target is busy and has enough free zones. On
three 27 TB host-managed SATA drives used as md RAID5 members (7.2.10
with the module built out of tree, all random zones free, target idle
for 300 seconds, kprobes attached, two other drives on the controller
being zero-filled), each member's SCSI device counted about 108,000
requests per second with the stock module and the system used about
915 s of CPU time, against about 46 s with this series. libata completes
TEST UNIT READY in software, so these counters do not measure commands
sent to the drives; the cost is CPU time.

When a pass fails with -ENOSPC or -EBUSY, retrying at once is unlikely
to make progress: re-arm the idle poll instead, so that reclaim is
retried after DMZ_IDLE_PERIOD unless a zone allocation or a "reclaim"
message queues it earlier. On a busy target, zone allocations can
restart reclaim immediately when free space is low enough to require
reclaim. Re-arming also keeps the poll running after a complete idle
drain. The poll can still stop after a pass that ends while reclaim is
not needed; that is unchanged.

Skip the device check for these two results: they normally mean that
there is no zone to copy into or no zone to reclaim, not that a device
failed, and the I/O paths check the devices themselves. Use
queue_delayed_work() so that work an allocation has already queued is
not postponed.

A pass that fails with an I/O error, for example on an unreadable block
of a device that stays online, is still retried at once while the
target is idle; this patch does not change that.

Tested on 7.4-rc1 with this patch and the next one, on three emulated
host-managed drives (scsi_debug, 1 GiB, 32 MiB zones) each under
dm-zoned as md RAID5 members, all random zones free and the target idle
for 300 seconds. With the stock module each member's SCSI device counted
about 70.2 million requests and the reclaim workers used 726 s of CPU.
With this series: 75 requests per member, 30 passes per worker (one per
DMZ_IDLE_PERIOD) and 0.08 s of CPU. Data written during the tests read
back with matching checksums, and no kernel warnings were logged.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Fixes: 90a9b8693f1b ("dm zoned: reclaim random zones when idle")
Cc: stable@vger.kernel.org
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-zoned-reclaim.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -539,6 +539,16 @@ static void dmz_reclaim_work(struct work
 		dmz_nr_rnd_zones(zmd, zrc->dev_idx));
 
 	ret = dmz_do_reclaim(zrc);
+	if (ret == -ENOSPC || ret == -EBUSY) {
+		/*
+		 * No zone to copy into (-ENOSPC) or no zone to reclaim
+		 * (-EBUSY): retrying at once cannot make progress and would
+		 * spin. Poll again after the idle period instead, without
+		 * postponing work that an allocation has already queued.
+		 */
+		queue_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
+		return;
+	}
 	if (ret && ret != -EINTR) {
 		if (!dmz_check_dev(zmd))
 			return;


