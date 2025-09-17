Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FEC3397D8;
	Wed, 17 Sep 2025 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114001; cv=none; b=uofvOIaUQeaahiiaEqR6YfRcc/E0AvjGJEYbdSQnHWaek8/b9oN4ef8A9PkU+GLOQmCVB67xD99a1iCqwNZpSnSN2w6ZvJOk+A1LP9JBVWfKLmpaqWuxRrQYdr5An0j+s2aBl1ojJ4yljUJocd3gbYnHC5GGKA9ywaQtccoGlI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114001; c=relaxed/simple;
	bh=mwlvTRO+OcE+I5cg0b2s3AumzOX4/NaS4Pm3iShg3nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmKetB0XQZlTu0Sg5D7xxaQMfF6DIScJYhX0DmcqLdljYMcCfgmUmeX9hCPyeidxV9536kdIUPJjb1/FUa9eQNaPLQVq3U/OzA4OgCHyK4ZR5+GLhGesYKbMCC5lDCJveUsmcMjUE7m8vosBW9/kgLyXiX+zxctor7VMNZNa81w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JdBmH0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JdBmH0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D88C4CEF0;
	Wed, 17 Sep 2025 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114000;
	bh=mwlvTRO+OcE+I5cg0b2s3AumzOX4/NaS4Pm3iShg3nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JdBmH0RTdE3r8IyuCmtVOBpokxE5pZVELZ7ztjYml7SYggoDqorrVsXRYQkdfvS3
	 KwXf3oLblhnKiiYKiTfRfx7Rnqjy3lQsxMxqLgjNHf1MsSLUnWkE/rQS47N2v99FRm
	 rLVKk89YIE9ASkr0JF6OAOTVnukN8GmSY0RR5zqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/78] s390/cpum_cf: Deny all sampling events by counter PMU
Date: Wed, 17 Sep 2025 14:34:38 +0200
Message-ID: <20250917123329.987957002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 28fa80fd69fa0..77d36a1981325 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -459,8 +459,6 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 		break;
 
 	case PERF_TYPE_HARDWARE:
-		if (is_sampling_event(event))	/* No sampling support */
-			return -ENOENT;
 		ev = attr->config;
 		if (!attr->exclude_user && attr->exclude_kernel) {
 			/*
@@ -554,6 +552,8 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 	unsigned int type = event->attr.type;
 	int err;
 
+	if (is_sampling_event(event))	/* No sampling support */
+		return err;
 	if (type == PERF_TYPE_HARDWARE || type == PERF_TYPE_RAW)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
-- 
2.51.0



