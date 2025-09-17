Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AF931A7E0;
	Wed, 17 Sep 2025 12:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113289; cv=none; b=rGpGdUC+snSjzvaMdN4qNzoOVAghVExh3rxTz9RLAQiBpHFksWW4c375hmCmHFVU3PBalpZ8CF3a4Vm97fIW+2ajCwwkw8bsU/y+Y3TV+NW30XIaUenKzy+0N+B/G3uPokyjfQhafFpKsSCnKTQ+q8t2tvfV9+5wbAbQUYsN9ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113289; c=relaxed/simple;
	bh=K/4MTja3ojOOavg9TYQIddIFt/c5p0EAo7mF8zCFl94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIWG2pNjiDEpRoU3FrkB6EBL40/efXpEPPB5oBRFLqZAbR4YgWyLx8YJ5szBIpdJUSAJkAJS/bGpj51xNe5fGpgzViNeUpw3cz6Ors2in8rGfwBRJ24e+OQ+s+NRCnISa+9TD8N19de7pn/GCdXff29c557PpKgaCa2bQMdnCIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hf4TxZmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hf4TxZmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6125C4CEF0;
	Wed, 17 Sep 2025 12:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113289;
	bh=K/4MTja3ojOOavg9TYQIddIFt/c5p0EAo7mF8zCFl94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hf4TxZmppNcwwZJboXL4jemL3qShzpUPfjbZiCCMXQlXJ+cNG85Nu77MALQ1ApnRN
	 btaHyFmYdtdn7yQX6MEANP4f7qCtR1MbrYbyifsvXLBvH/gEW0095n7oLblgWFsoyr
	 /cDut1lDbagyENatBc5PkKQjHvCY94ZR5F642P3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/140] s390/cpum_cf: Deny all sampling events by counter PMU
Date: Wed, 17 Sep 2025 14:33:33 +0200
Message-ID: <20250917123345.308422165@linuxfoundation.org>
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
index 6d6b057b562fd..b017db3344cb5 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -761,8 +761,6 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 		break;
 
 	case PERF_TYPE_HARDWARE:
-		if (is_sampling_event(event))	/* No sampling support */
-			return -ENOENT;
 		ev = attr->config;
 		if (!attr->exclude_user && attr->exclude_kernel) {
 			/*
@@ -860,6 +858,8 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 	unsigned int type = event->attr.type;
 	int err = -ENOENT;
 
+	if (is_sampling_event(event))	/* No sampling support */
+		return err;
 	if (type == PERF_TYPE_HARDWARE || type == PERF_TYPE_RAW)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
-- 
2.51.0



