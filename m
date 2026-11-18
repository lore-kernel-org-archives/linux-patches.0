Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018488;
	b=DBjx79D8NtlhJExrhH2MNCXCRyA1D7RBA98dh7jfoirV1jZK/VaXAvAv8GmTGwRVYAbO
	 qwNhohAzOnEMOPZdWzqFxuspSqcNiITJgC7V8KPygM/S1TBaLLojWGzP442GPkIieOmus
	 aZA/XQVjDcugYuSSHEI+ug9lJk7L6mVD0mh7C9YyOtohkw5W84rPWoBtE4nF5Bp9RDXLm
	 OECoOAUawUaaICD1E6P+2EaP3XmOL+j9483Y+zC7+kt9tUycxCriRaRoDH/Wo/lQA/Gd6
	 K2l6Gs1wbiAQLLmTFra4o/mKHjlxZUHc9fgMH5kcoJ/InZMsrMLwUDcY4kdglJ4zTTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cO81+nVK3m6wGk58AYVxPjIGfiOXFYFFFpRoSM2swUA=;
	b=lm81vHICxcRd4pwdG537ezyOEaM9j1E3lzJ6o77dJ8Rfdkhfo9Fpw0mQDGQD/ycnfY8c
	 s1QalAv5Y1khg8rZrnCTiJgUhlA8kUyUA0MTmBXaF4hl+YQJQ9hkDXTSmFIv0cj7+iYWN
	 QCW8GxwAzUxyM9E1zS7Tds7/YPB9p49VwkFWKDBsSI8FrAriIJ88qwCTn2p+X9lB31SU7
	 mZ3tpRG4lyyQP/p6g6vyjjotnyY3XFey+oS7l4h8YlsH//l+Gs8sNBSLFE5cUau+KtDAC
	 MEWWpQ6k1BXN/SVizGEMxtSMTV6l8M/Wy/6t35cE8dLtQ6/VxjaCP12pThq9YWOYkJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKc7ReaD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F63606A31C;
	Wed, 18 Nov 2026 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKc7ReaD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D811F000C4;
	Wed, 18 Nov 2026 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018488;
	bh=cO81+nVK3m6wGk58AYVxPjIGfiOXFYFFFpRoSM2swUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKc7ReaDtKEoxDXllhhPo76NnIAs9g/4qYyer3VqDpO47Qz/tylKi5ompXxjp2hrT
	 jA90oWCbT3KRrIRYLuQYpf8IGyKO4FZDNbmIKQetszihtDZ+768XwC24DufV6ysn+7
	 iUt+fOHGkmWPpoJM4izo9lXjMo3IRlZyhg+A6acs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1256/2651] perf/cxl: Dont share the overflow interrupt, and keep it pinned
Date: Wed, 18 Nov 2026 15:41:36 +0100
Message-ID: <20261118150333.196663494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit b899fd3487b0d4066d60ebcf5b73e77c9617de54 ]

The PMU pins its overflow interrupt to info->on_cpu in the hotplug
callbacks, but requests it with only IRQF_SHARED | IRQF_NO_THREAD. Without
IRQF_NOBALANCING, irqbalance or a userspace smp_affinity write can move it
elsewhere, and cxl_pmu_irq() then runs local64_cmpxchg() and local64_add()
on hwc->prev_count and event->count at the same time as the managing CPU.
local64_t is only atomic against same-CPU access, so the counts corrupt.

The flag alone does not fix that while the line is shared. __setup_irq()
only acts on it for the first action on a line, and a co-owner has no
reason to want our affinity - it would keep taking the interrupt wherever
its own points, running our handler on the wrong CPU.

Drop IRQF_SHARED and add IRQF_NOBALANCING. The spec only recommends a
distinct Interrupt Message Number per CPMU instance (CXL r4.0 8.2.7.1.1),
so a device may put several on one vector, or share with the mailbox or
event log. Such a device now loses a PMU rather than silently miscounting -
and only the PMU, since the preceding patch adds the CPMUs after the event
configuration.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index e9628bc88c78a..71fef71bcf94b 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -895,7 +895,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 
 	overflowed = readq(base + CXL_PMU_OVERFLOW_REG);
 
-	/* Interrupt may be shared, so maybe it isn't ours */
+	/* Nothing overflowed, so the device did not raise this */
 	if (!overflowed)
 		return IRQ_NONE;
 
@@ -998,7 +998,14 @@ static int cxl_pmu_probe(struct device *dev)
 	if (!irq_name)
 		return -ENOMEM;
 
-	rc = devm_request_irq(dev, irq, cxl_pmu_irq, IRQF_SHARED | IRQF_NO_THREAD,
+	/*
+	 * The handler must run on info->on_cpu, so the interrupt cannot be
+	 * shared - IRQF_NOBALANCING is only honoured for the first action on a
+	 * line, and a co-owner would keep taking the interrupt wherever its own
+	 * affinity points.
+	 */
+	rc = devm_request_irq(dev, irq, cxl_pmu_irq,
+			      IRQF_NO_THREAD | IRQF_NOBALANCING,
 			      irq_name, info);
 	if (rc)
 		return rc;
-- 
2.53.0



