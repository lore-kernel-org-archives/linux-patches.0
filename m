Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D6A4218A8;
	Wed,  4 Feb 2026 14:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217113; cv=none; b=XxD2h/VRPjEBwayQWcqBtk8tYDP2oZ6HL2eVPVWA4yyMaZsdaKNuNQGCYky+GaDGL9NltAdYF2EdkNDzUS7727hzKS2odpH31VmVcKBMh5vKgZ/P6QOjaqWuThhW+0Wmym/nIUrYIRscVocP05GcLk3s9xHPukT+suw5AuxA0o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217113; c=relaxed/simple;
	bh=AxvBq/tDhx19rNihNKLrGjPUjvp9H+hXgmFsIb+q09M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hyU8hfsxHxrGFAvmp1WApFsLWObGmiaBVvjIg5U8DAfnuDtxkmcfIMFNwG9YKlie4xZtzJ3CIX50oL6F1VdJzciohIH2rJ0S6IhuHyidNZVc5k6ALSr6KM9umj/egM9VRiLGsQio9rGsbU7unf6aszS5ndhYv3R6W5oHLbiAHoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLY117Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLY117Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9420FC4CEF7;
	Wed,  4 Feb 2026 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217113;
	bh=AxvBq/tDhx19rNihNKLrGjPUjvp9H+hXgmFsIb+q09M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLY117Bq2UYCOYXXGqbtLj5l2CMxpgkXDUYNUPcB/kb/ZCAKPouuwZktbDSxYr3oc
	 Vewgd5NIHp4n/R5hsihu4Of8PWkC3RDdrT2vZLHrtDi26wIKodMixtm0218EFLTwiK
	 NnfCF7F0VlEFEpIOKMe7kl5hnT+zF915pM0NullI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Jan=20H . =20Sch=C3=B6nherr?=" <jschoenh@amazon.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Fernand Sieber <sieberf@amazon.com>
Subject: [PATCH 5.15 126/206] perf/x86/intel: Do not enable BTS for guests
Date: Wed,  4 Feb 2026 15:39:17 +0100
Message-ID: <20260204143902.739105439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernand Sieber <sieberf@amazon.com>

commit 91dcfae0ff2b9b9ab03c1ec95babaceefbffb9f4 upstream.

By default when users program perf to sample branch instructions
(PERF_COUNT_HW_BRANCH_INSTRUCTIONS) with a sample period of 1, perf
interprets this as a special case and enables BTS (Branch Trace Store)
as an optimization to avoid taking an interrupt on every branch.

Since BTS doesn't virtualize, this optimization doesn't make sense when
the request originates from a guest. Add an additional check that
prevents this optimization for virtualized events (exclude_host).

Reported-by: Jan H. Schönherr <jschoenh@amazon.de>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fernand Sieber <sieberf@amazon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20251211183604.868641-1-sieberf@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/perf_event.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1286,13 +1286,22 @@ static inline bool intel_pmu_has_bts_per
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned int hw_event, bts_event;
 
-	if (event->attr.freq)
+	/*
+	 * Only use BTS for fixed rate period==1 events.
+	 */
+	if (event->attr.freq || period != 1)
+		return false;
+
+	/*
+	 * BTS doesn't virtualize.
+	 */
+	if (event->attr.exclude_host)
 		return false;
 
 	hw_event = hwc->config & INTEL_ARCH_EVENT_MASK;
 	bts_event = x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 
-	return hw_event == bts_event && period == 1;
+	return hw_event == bts_event;
 }
 
 static inline bool intel_pmu_has_bts(struct perf_event *event)


