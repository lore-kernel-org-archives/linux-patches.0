Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD0C31A812;
	Wed, 17 Sep 2025 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113286; cv=none; b=H/Zjv5R1MjI6BgHIGv/6nfxQTh5VEnwoH1fckF5KNBeysZN8zrXfp57JANCL2cgKzr1lU/lHcNwN6K/dy38YhWp2DlgP/ePcN1M4OdcL3/xaEnaWbCpghwodwBes2AwVrN8SQ2FeBs9UAg4Rxz45TOhCWkzjGSwikeVbeGb2nKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113286; c=relaxed/simple;
	bh=p5Lvkzc29n2cbQfepdPz9KN1mXq23Jtk+qCM1/kEb/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HALhsQq/sdg61Eor2ROdOkn7kvIQNwN5xACtf5jclpbGNEq+gXZdsEoaI76LJtBPR2/f+Vci1apXNsNdF9SP9F+RV3j/UsFlulCRJqb4+HKHWsuAhJK5GxGlOJZLEiIZs7f9vp835UCO5+HS2Ao5h6hToGwOa4pU3Ec0m586i5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siPL3Cu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siPL3Cu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D58EC4CEF0;
	Wed, 17 Sep 2025 12:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113285;
	bh=p5Lvkzc29n2cbQfepdPz9KN1mXq23Jtk+qCM1/kEb/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siPL3Cu+5+AgBwx4B3c6+5+b3wmcsCgJ6xIRY7td4leo7vOOzbSLKLQVmmYjTJeMy
	 cwm2EycHzoI30v2Y6L9GjZVjKKXSoIGr1WicDRNXdrmxYNDRxIGDaIFAqsGgsHFZ29
	 +q4+DiS1cHVz/dJAhfxxpjj7GHbmCZu5UENZb9DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/140] s390/pai: Deny all events not handled by this PMU
Date: Wed, 17 Sep 2025 14:33:32 +0200
Message-ID: <20250917123345.286052132@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 85941afd2c404247e583c827fae0a45da1c1d92c ]

Each PAI PMU device driver returns -EINVAL when an event is out of
its accepted range. This return value aborts the search for an
alternative PMU device driver to handle this event.
Change the return value to -ENOENT. This return value is used to
try other PMUs instead.  This makes the PMUs more robust when
the sequence of PMU device driver initialization changes (at boot time)
or by using modules.

Fixes: 39d62336f5c12 ("s390/pai: add support for cryptography counters")
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 4 ++--
 arch/s390/kernel/perf_pai_ext.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 10725f5a6f0fd..11200880a96c1 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -286,10 +286,10 @@ static int paicrypt_event_init(struct perf_event *event)
 	/* PAI crypto PMU registered as PERF_TYPE_RAW, check event type */
 	if (a->type != PERF_TYPE_RAW && event->pmu->type != a->type)
 		return -ENOENT;
-	/* PAI crypto event must be in valid range */
+	/* PAI crypto event must be in valid range, try others if not */
 	if (a->config < PAI_CRYPTO_BASE ||
 	    a->config > PAI_CRYPTO_BASE + paicrypt_cnt)
-		return -EINVAL;
+		return -ENOENT;
 	/* Allow only CRYPTO_ALL for sampling */
 	if (a->sample_period && a->config != PAI_CRYPTO_BASE)
 		return -EINVAL;
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index a8f0bad99cf04..28398e313b58d 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -266,7 +266,7 @@ static int paiext_event_valid(struct perf_event *event)
 		event->hw.config_base = offsetof(struct paiext_cb, acc);
 		return 0;
 	}
-	return -EINVAL;
+	return -ENOENT;
 }
 
 /* Might be called on different CPU than the one the event is intended for. */
-- 
2.51.0



