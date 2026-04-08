Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A50331A44;
	Wed,  8 Apr 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673495; cv=none; b=tigNt51ukHWc3+gzC9r0PRrB8cfdbnmecniULeduvtnO70pEkOigWhNbaxv0Xrqy4RTmEGZ/Y2qX1tp5T7yncKeDIr4J78hBUnhMvQL6tah1P7q0w7qxHisNcBW34OCJ59ugv2vQNijFOsdKm63WH7gkRGrdWiQDfWRxWcp/oi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673495; c=relaxed/simple;
	bh=P+/mMy44R6r9kKZBwA0E3zSkuLt4z/TrEOfGaTUqa2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RevjCnzJE43gIKKb4keD6UWyUFNY/qvmoP/9tEmRCNqm+Ol58kv9Z4LpjJp2FrDMELM/2z5dPKgXQX2Y6af4m/6n/WIt3LzaQH4MdpHP8XQWSvSwcEYeUFAJWgLei4unnGRZl9bjgq1+jTjNw2cFRBNqtYH5Vy4a+cp2sR2FRvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTpnjEKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTpnjEKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA81C19421;
	Wed,  8 Apr 2026 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673495;
	bh=P+/mMy44R6r9kKZBwA0E3zSkuLt4z/TrEOfGaTUqa2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTpnjEKH19tyO1oBnroN4wTShx9n6jcrqa+HHJo6Cq06ynr9AbpZF9NPd2Inoc6lm
	 8hfSFmThh1ET6/+jrQvo9CJBe2Md9YNCgUnFZ5oahzjqEeTJiQ258CzyhjBnQ45+6m
	 8rnQpzGtD8Nv/IN6mI9HMl4DuwMbBAh0MQcp8pOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 222/277] s390/cpum_sf: Cap sampling rate to prevent lsctl exception
Date: Wed,  8 Apr 2026 20:03:27 +0200
Message-ID: <20260408175942.146069581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

commit 57ad0d4a00f5d3e80f33ba2da8d560c73d83dc22 upstream.

commit fcc43a7e294f ("s390/configs: Set HZ=1000") changed the interrupt
frequency of the system. On machines with heavy load and many perf event
overflows, this might lead to an exception. Dmesg displays these entries:
  [112.242542] cpum_sf: Loading sampling controls failed: op 1 err -22
One line per CPU online.

The root cause is the CPU Measurement sampling facility overflow
adjustment. Whenever an overflow (too much samples per tick) occurs, the
sampling rate is adjusted and increased. This was done without observing
the maximum sampling rate limit. When the current sampling interval is
higher than the maximum sampling rate limit, the lsctl instruction raises
an exception. The error messages is the result of such an exception.
Observe the upper limit when the new sampling rate is recalculated.

Cc: stable@vger.kernel.org
Fixes: 39d4a501a9ef ("s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_sf.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1169,6 +1169,7 @@ static void hw_collect_samples(struct pe
 static void hw_perf_event_update(struct perf_event *event, int flush_all)
 {
 	unsigned long long event_overflow, sampl_overflow, num_sdb;
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hw_perf_event *hwc = &event->hw;
 	union hws_trailer_header prev, new;
 	struct hws_trailer_entry *te;
@@ -1248,8 +1249,11 @@ static void hw_perf_event_update(struct
 	 * are dropped.
 	 * Slightly increase the interval to avoid hitting this limit.
 	 */
-	if (event_overflow)
+	if (event_overflow) {
 		SAMPL_RATE(hwc) += DIV_ROUND_UP(SAMPL_RATE(hwc), 10);
+		if (SAMPL_RATE(hwc) > cpuhw->qsi.max_sampl_rate)
+			SAMPL_RATE(hwc) = cpuhw->qsi.max_sampl_rate;
+	}
 }
 
 static inline unsigned long aux_sdb_index(struct aux_buffer *aux,


