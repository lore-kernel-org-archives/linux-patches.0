Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED5C3AD536;
	Mon, 23 Mar 2026 13:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274389; cv=none; b=L8SniBwrTj2hTtQ7LrpZ7ZGCekHfTonqLPxX1Zh74gq+TENUA5FwRj2OM1gLLLCNRBMT57WupZ+r9j82dJcSZ3sTJJN4p3t0QZCXD+AHoxWmyfQ6pbn4HabqTyzPqwJlnGw3XXJrxMHYKMz1qJPi9IdTEwiz488x7rTzRCDjk8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274389; c=relaxed/simple;
	bh=+CHolI0OoLHZYDLufhHM5SNrDl3HwUgcGhgXG0Fngac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbwBJDZZ3WNUIfkMouMR8auAnEl08yRu1HZu+REPuFLL+wfSWwdRgiRgoXDVRqA3aRQZPcoCdOknY9j+dVhfVNdrC6Fl+53j/vrnPK4fdusfhOOrXmGmr+rxjg8UtBq+FwNpxf5HFUtCZrYL/2WJKtaNALzClAvD4ATX1QgTDes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2N8x75LR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2N8x75LR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A514DC2BCB6;
	Mon, 23 Mar 2026 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274389;
	bh=+CHolI0OoLHZYDLufhHM5SNrDl3HwUgcGhgXG0Fngac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2N8x75LR5HjX8X2SaFhO2KaBYa98EdQdmX0BHHBA545j5amGq1luLqq3hcm9BiabJ
	 kQ+Up8lWxx/0JJ99L3v1nqdfX8YPFhyNOi3hAmp2wpJkKgrEA9M5AAWcmg3w5LsdSi
	 hBBHziu7NE/pkjJwnL6op2clazma7xWupSz8rvR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 201/220] arm_mpam: Fix null pointer dereference when restoring bandwidth counters
Date: Mon, 23 Mar 2026 14:46:18 +0100
Message-ID: <20260323134510.923477284@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 4ad79c874e53ebb7fe3b8ae7ac6c858a2121f415 ]

When an MSC supporting memory bandwidth monitoring is brought offline and
then online, mpam_restore_mbwu_state() calls __ris_msmon_read() via ipi to
restore the configuration of the bandwidth counters. It doesn't care about
the value read, mbwu_arg.val, and doesn't set it leading to a null pointer
dereference when __ris_msmon_read() adds to it. This results in a kernel
oops with a call trace such as:

Call trace:
__ris_msmon_read+0x19c/0x64c (P)
mpam_restore_mbwu_state+0xa0/0xe8
smp_call_on_cpu_callback+0x1c/0x38
process_one_work+0x154/0x4b4
worker_thread+0x188/0x310
kthread+0x11c/0x130
ret_from_fork+0x10/0x20

Provide a local variable for val to avoid __ris_msmon_read() dereferencing
a null pointer when adding to val.

Fixes: 41e8a14950e1 ("arm_mpam: Track bandwidth counter state for power management")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index b495d52918681..41fe421171813 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1428,6 +1428,7 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 static int mpam_restore_mbwu_state(void *_ris)
 {
 	int i;
+	u64 val;
 	struct mon_read mwbu_arg;
 	struct mpam_msc_ris *ris = _ris;
 	struct mpam_class *class = ris->vmsc->comp->class;
@@ -1437,6 +1438,7 @@ static int mpam_restore_mbwu_state(void *_ris)
 			mwbu_arg.ris = ris;
 			mwbu_arg.ctx = &ris->mbwu_state[i].cfg;
 			mwbu_arg.type = mpam_msmon_choose_counter(class);
+			mwbu_arg.val = &val;
 
 			__ris_msmon_read(&mwbu_arg);
 		}
-- 
2.51.0



