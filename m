Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAFF1A6192;
	Tue, 30 Jul 2024 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358948; cv=none; b=R5RCbMolvI+MAbAOe8P1rfLci1jVPl8Z8w9wn+uu6pif000XybLIVNMvMVp9AjZAT0XN4zS5tm3bqFpKc6ka3NE7Z1ckZyTFcz6xKja8LksgQBJT8rpOUcUzqbIpxJavJrILSpE73GpWhur8EqZ6zNPWkL2XMXUhIP+UXTSW7yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358948; c=relaxed/simple;
	bh=4xwP4fk8ptiU/sbiqxIGcEvi+KSwT3A3xySWuOAC4Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj5COxvqiMMF9iJM9kW/XFaS+/4wWZnxYCMj8eh82z+Okzvyt21QBuADZLaQJB9Wtu0hSNBRdg+vTyRF/7J1n7gZ+cR2ZQLhUh5zWIZBjSVe+pfvNKg4Fx6UVr2ZmIHDYiBeHzOg1PwJmCU9WrGFax21tu8C7c8PnT6xufiHY1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DyDoQnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DyDoQnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B75C32782;
	Tue, 30 Jul 2024 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358947;
	bh=4xwP4fk8ptiU/sbiqxIGcEvi+KSwT3A3xySWuOAC4Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DyDoQnZqlxdadJycs9n2aCLKgJfVcJkMySa1JoRd7JZVJl6l8LOAirX829RE0gRf
	 8IffLx2zbZuVYhUhedqPW6XHIlEhMHRNnPOPQd2uB4xghYInlyVaoCCj/8ei+QmgHH
	 FIFPNBZ0HqbHoQo+WKxEEDX+NLD+gXXPDrL8oiIg=
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
Subject: [PATCH 6.1 436/440] s390/cpum_cf: Fix endless loop in CF_DIAG event stop
Date: Tue, 30 Jul 2024 17:51:09 +0200
Message-ID: <20240730151632.803572481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 28fa80fd69fa0..3b7fbc14aa4a4 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -213,25 +213,31 @@ static int cfdiag_diffctr(struct cpu_cf_events *cpuhw, unsigned long auth)
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



