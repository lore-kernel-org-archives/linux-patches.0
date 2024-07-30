Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A3E1A76AD;
	Tue, 30 Jul 2024 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360807; cv=none; b=Mt93vhH56cdn0XgDkXXYGgjMB30JeiWdUO8i0p7lTOTzsBgu1ByhezVjx6xpFkJTPRjjmc/qOdRI6v/TiObY1yoQ7fAucWJ0U9HLXkiCfjTA0eeTCoxLCyRKpsAJN69e2LBkpOcLaBPegK1AwnvJVK1KCj6munuyJu4kvfWdMKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360807; c=relaxed/simple;
	bh=eBiCIwa14yok1mNiSJM9KYcV7wX40Pm/4xlS0N0/hgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0fFgAUm1ClJmRMj2yV3aUYc/uG7E4rNujd3aMFKXtkKVNKzwuNUZvI53Mt6kbkmO1X8zAQjwgXNvs+Kjd7InceinRGvdPYjd7omO3Fy7+xRw2FYaq6d39uwXekXFpqR3QTfGdvNYOSdcZCIOiUx31/pji28r0/aU/R9RzKHxN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elUiutPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elUiutPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFB2C4AF0A;
	Tue, 30 Jul 2024 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360807;
	bh=eBiCIwa14yok1mNiSJM9KYcV7wX40Pm/4xlS0N0/hgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elUiutPQ1/eHzLOUmHeg3Gtyq0ZTT/PVHCNjSuLlU3pJ0Jajj2dsGfo/87F4DxW+z
	 ShLNSUWer6lAEs96OIQTnzZx2xhjzsxJGMwdZWwNyMqa9W4lIcDnZkB/Ouh4JKX70O
	 M2klLT09lIaBE18Lmronv68wYkfvaMk22IQqvEcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 798/809] s390/cpum_cf: Fix endless loop in CF_DIAG event stop
Date: Tue, 30 Jul 2024 17:51:14 +0200
Message-ID: <20240730151756.498748638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit e6ce1f12d777f6ee22b20e10ae6a771e7e6f44f5 ]

Event CF_DIAG reads out complete counter sets using stcctm
instruction. This is done at event start time when the process
starts execution and at event stop time when the process is
removed from the CPU. During removal the difference of each
counter in the counter sets is calculated and saved as raw data
in the ring buffer. This works fine unless the number of counters
in a counter set is zero. This may happen for the extended counter
set. This set is machine specific and the size of the counter
set can be zero even when extended counter set is authorized for
read access.

This case is not handled. cfdiag_diffctr() checks authorization
of the extended counter set. If true the functions assumes
the extended counter set has been saved in a data buffer. However
this is not the case, cfdiag_getctrset() does not save a counter
set with counter set size of zero. This mismatch causes an endless
loop in the counter set readout during event stop handling.

The calculation of the difference of the counters in each counter
now verifies the size of the counter set is non-zero. A counter set
with size zero is skipped.

Fixes: a029a4eab39e ("s390/cpumf: Allow concurrent access for CPU Measurement Counter Facility")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 1434642e9cba0..6968be98af117 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -556,25 +556,31 @@ static int cfdiag_diffctr(struct cpu_cf_events *cpuhw, unsigned long auth)
 	struct cf_trailer_entry *trailer_start, *trailer_stop;
 	struct cf_ctrset_entry *ctrstart, *ctrstop;
 	size_t offset = 0;
+	int i;
 
-	auth &= (1 << CPUMF_LCCTL_ENABLE_SHIFT) - 1;
-	do {
+	for (i = CPUMF_CTR_SET_BASIC; i < CPUMF_CTR_SET_MAX; ++i) {
 		ctrstart = (struct cf_ctrset_entry *)(cpuhw->start + offset);
 		ctrstop = (struct cf_ctrset_entry *)(cpuhw->stop + offset);
 
+		/* Counter set not authorized */
+		if (!(auth & cpumf_ctr_ctl[i]))
+			continue;
+		/* Counter set size zero was not saved */
+		if (!cpum_cf_read_setsize(i))
+			continue;
+
 		if (memcmp(ctrstop, ctrstart, sizeof(*ctrstop))) {
 			pr_err_once("cpum_cf_diag counter set compare error "
 				    "in set %i\n", ctrstart->set);
 			return 0;
 		}
-		auth &= ~cpumf_ctr_ctl[ctrstart->set];
 		if (ctrstart->def == CF_DIAG_CTRSET_DEF) {
 			cfdiag_diffctrset((u64 *)(ctrstart + 1),
 					  (u64 *)(ctrstop + 1), ctrstart->ctr);
 			offset += ctrstart->ctr * sizeof(u64) +
 							sizeof(*ctrstart);
 		}
-	} while (ctrstart->def && auth);
+	}
 
 	/* Save time_stamp from start of event in stop's trailer */
 	trailer_start = (struct cf_trailer_entry *)(cpuhw->start + offset);
-- 
2.43.0



