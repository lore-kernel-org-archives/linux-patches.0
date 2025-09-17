Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A374D1E7C2D;
	Wed, 17 Sep 2025 12:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113837; cv=none; b=ZbJak7x0jMjT6wOHvr4zLb2WAEoeecSH7NYoMF0PbtWQWCtl34nHVDZuGBYxuWbHnvz8ZHJ0OYoFyEQY7zIySjFEK+B5gOSSL+10Vd/mBKOJ9gJHkqZ/PrzP7iQbmdTO5/SJnbJXMj+QZt0DGg4zvTEqH+o00WPRlY79vwh/tFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113837; c=relaxed/simple;
	bh=wv3nffoZGS2L3oTn3X/IEnCZHxQRk/BqwEL7Mc50qms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRe9qtdRseMfQzi9dUlQ46B/qKH+a82eUoJBNqAAm0Hc/VJqFEBiMJ65ODd8h/U7cLI07jZHA/nsjfngyG4DBcHY7oOdoTaGBr0BTkpbDS8B9g3djt4KidoeSU4z9mphnuqFb89mA5QYSqyJIMVC63DWs3pA95JUb9T1DD28vZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7nrN07v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7nrN07v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D57CC4CEF0;
	Wed, 17 Sep 2025 12:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113837;
	bh=wv3nffoZGS2L3oTn3X/IEnCZHxQRk/BqwEL7Mc50qms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7nrN07v6rEePm3OtEC/DlKa09X3XyvmLiNhkpNA66lZ70Kafm037CmKOafPLW/Hr
	 6GFR4acgkLGaQdPpS0d96kjDCjfl1hR4L/NVY/ChEuHT+lTVAhAC2lGkKUz73lepz9
	 WyJ+lGLD9UqE3CyB2O46OUzYWnkKOeV6z8J0/JgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/101] s390/cpum_cf: Deny all sampling events by counter PMU
Date: Wed, 17 Sep 2025 14:34:06 +0200
Message-ID: <20250917123337.418992026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit ce971233242b5391d99442271f3ca096fb49818d ]

Deny all sampling event by the CPUMF counter facility device driver
and return -ENOENT. This return value is used to try other PMUs.
Up to now events for type PERF_TYPE_HARDWARE were not tested for
sampling and returned later on -EOPNOTSUPP. This ends the search
for alternative PMUs. Change that behavior and try other PMUs
instead.

Fixes: 613a41b0d16e ("s390/cpum_cf: Reject request for sampling in event initialization")
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 65a66df5bb865..771e1cb17540d 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -757,8 +757,6 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 		break;
 
 	case PERF_TYPE_HARDWARE:
-		if (is_sampling_event(event))	/* No sampling support */
-			return -ENOENT;
 		ev = attr->config;
 		if (!attr->exclude_user && attr->exclude_kernel) {
 			/*
@@ -856,6 +854,8 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 	unsigned int type = event->attr.type;
 	int err;
 
+	if (is_sampling_event(event))	/* No sampling support */
+		return err;
 	if (type == PERF_TYPE_HARDWARE || type == PERF_TYPE_RAW)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
-- 
2.51.0



