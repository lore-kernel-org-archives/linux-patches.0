Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68EC33EB1D;
	Tue, 26 Aug 2025 11:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208002; cv=none; b=sbuY6YJw6q/6ypjEmpBJhD1K3628mAeKuY5vp0bqr8s1TdWjvpAt8031ZCrXWpVD5P1DhsNqUK89H2AW21cMR75fqCBBug5cW0fnj42LX27MD3PJcOMkCxeBJ0KasnX/po6ChaM0hlsaMgKICCNS0LLJZgXvDXeAnOwY4A/HQ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208002; c=relaxed/simple;
	bh=9mNnpEqprpM9JRP4SBEnSEB68385xm1ualEqVfzzk2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhbjDtDeCImnv3P0ZCiq4xGdp1oqguPBWfT3mJ7yA1CWB8dGWVWcWbhup1P5Rr3RkKGlshnwVXOSWUWwid0PZVuOOtCB5KCwmXh7LsGoB92CSB8hbiR04q1GSn5AIBedAWBZ42e92Orgg2WGSMTz7Lyaq9CdwLYpaLAKwnKbvsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rw8xlHwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rw8xlHwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F91C116B1;
	Tue, 26 Aug 2025 11:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208002;
	bh=9mNnpEqprpM9JRP4SBEnSEB68385xm1ualEqVfzzk2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rw8xlHwrEOzwIUi0drltnaWnOlaaJn2v9+tI2/tVxUjyiXblMIjA/K9BrcZpNP++I
	 gZabs3HZD1ry0CwS1Da5YnrhN+z0ZedLCtSFeXVDyHGr1PeSBu8xYxd/hMuMQofgXQ
	 YAoCMHw+/YC5iu7nl3TYdaqvzAU49cQ9f313fnLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 400/457] bnxt_en: Fix lockdep warning during rmmod
Date: Tue, 26 Aug 2025 13:11:24 +0200
Message-ID: <20250826110947.179868746@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 4611d88a37cfc18cbabc6978aaf7325d1ae3f53a ]

The commit under the Fixes tag added a netdev_assert_locked() in
bnxt_free_ntp_fltrs().  The lock should be held during normal run-time
but the assert will be triggered (see below) during bnxt_remove_one()
which should not need the lock.  The netdev is already unregistered by
then.  Fix it by calling netdev_assert_locked_or_invisible() which will
not assert if the netdev is unregistered.

WARNING: CPU: 5 PID: 2241 at ./include/net/netdev_lock.h:17 bnxt_free_ntp_fltrs+0xf8/0x100 [bnxt_en]
Modules linked in: rpcrdma rdma_cm iw_cm ib_cm configfs ib_core bnxt_en(-) bridge stp llc x86_pkg_temp_thermal xfs tg3 [last unloaded: bnxt_re]
CPU: 5 UID: 0 PID: 2241 Comm: rmmod Tainted: G S      W           6.16.0 #2 PREEMPT(voluntary)
Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.4.3 01/17/2017
RIP: 0010:bnxt_free_ntp_fltrs+0xf8/0x100 [bnxt_en]
Code: 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 8b 47 60 be ff ff ff ff 48 8d b8 28 0c 00 00 e8 d0 cf 41 c3 85 c0 0f 85 2e ff ff ff <0f> 0b e9 27 ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffa92082387da0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff9e5b593d8000 RCX: 0000000000000001
RDX: 0000000000000001 RSI: ffffffff83dc9a70 RDI: ffffffff83e1a1cf
RBP: ffff9e5b593d8c80 R08: 0000000000000000 R09: ffffffff8373a2b3
R10: 000000008100009f R11: 0000000000000001 R12: 0000000000000001
R13: ffffffffc01c4478 R14: dead000000000122 R15: dead000000000100
FS:  00007f3a8a52c740(0000) GS:ffff9e631ad1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bb289419c8 CR3: 000000011274e001 CR4: 00000000003706f0
Call Trace:
 <TASK>
 bnxt_remove_one+0x57/0x180 [bnxt_en]
 pci_device_remove+0x39/0xc0
 device_release_driver_internal+0xa5/0x130
 driver_detach+0x42/0x90
 bus_remove_driver+0x61/0xc0
 pci_unregister_driver+0x38/0x90
 bnxt_exit+0xc/0x7d0 [bnxt_en]

Fixes: 004b5008016a ("eth: bnxt: remove most dependencies on RTNL")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250816183850.4125033-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 25681c2343fb..ec8752c298e6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5325,7 +5325,7 @@ static void bnxt_free_ntp_fltrs(struct bnxt *bp, bool all)
 {
 	int i;
 
-	netdev_assert_locked(bp->dev);
+	netdev_assert_locked_or_invisible(bp->dev);
 
 	/* Under netdev instance lock and all our NAPIs have been disabled.
 	 * It's safe to delete the hash table.
-- 
2.50.1



