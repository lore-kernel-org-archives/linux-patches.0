Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A922238AC8A;
	Sat, 12 Sep 2026 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242573; cv=none; b=OPlJgZmrOCE/+NJqylmSK/lXoKCCkFYAfzZ2so+MJBSccQMBNnisaLEB4xnKG18cSONhZuYazPn7k328hTvTkqpieNXeYtgzgA2o6H00IsTvAiYOqYDjuLvbEXHWxpUeq2JH7lXXkAqRRCMIZbMTWMESj78z6AajcVWPP49LaVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242573; c=relaxed/simple;
	bh=zhsOsVO+EF6ZAXneqa4JTZmsrmGoivfWSpjcOHEDAgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqlB/0qzWNO+HQOmPMFdXMJ5mJH2KIJembQsc+U3+CTjeERrGjukEKdHjJk8yHq883ZWIWjg/AK7250rgHLY54eJ8bQT76GHam8nbj5YKwMAutIFc3zkbS/7MB952hc68mpnhOUzxdQZO0bTWMHL8V5wXJpNSOqIspsoQ5++cXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BER5Q62+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BER5Q62+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2041F000FF;
	Sat, 12 Sep 2026 19:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242572;
	bh=IX6KkOYRMggYYoNv65U/LFK94zhRxPgwABuMekErGbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BER5Q62+IzqJedAzxk83SbsqI2jNbdVI0Va9QIqINEIaZPIWRKBEc4uxl/9fLjI3k
	 vD4ze05W29+11k4vCsAS+hbTR8FS6rnQ2PN/f7VLkXdrR/Er2Vhwws8eb9RO7kOlcp
	 vfo+C0TntAjPCbkqifWN6PGCTdEAI+gHGHqv14gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 451/798] gpu: host1x: Fix offset calculation in trace_write_gather
Date: Sat, 12 Sep 2026 09:01:19 +0200
Message-ID: <20260912065527.478216128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit eb896850964d3dfce291b4fdff9c2d42d85e564b ]

When a gather longer than 2*TRACE_MAX_LENGTH (256) words is traced
through host1x_cdma_push_gather, the reported BO offset drifts from
the third iteration onward.

Fix the calculation by properly calculating the value on each loop
rather than accumulating.

In reality, gathers tend to be pretty short so this is unlikely to
ever have been observed.

Fixes: b40d02bf96e0 ("gpu: host1x: Use struct host1x_bo pointers in traces")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-3-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/channel_hw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
index 5eaa29d171c9d..8b438734047b1 100644
--- a/drivers/gpu/host1x/hw/channel_hw.c
+++ b/drivers/gpu/host1x/hw/channel_hw.c
@@ -36,10 +36,9 @@ static void trace_write_gather(struct host1x_cdma *cdma, struct host1x_bo *bo,
 		for (i = 0; i < words; i += TRACE_MAX_LENGTH) {
 			u32 num_words = min(words - i, TRACE_MAX_LENGTH);
 
-			offset += i * sizeof(u32);
-
 			trace_host1x_cdma_push_gather(dev_name(dev), bo,
-						      num_words, offset,
+						      num_words,
+						      offset + i * sizeof(u32),
 						      mem);
 		}
 
-- 
2.53.0



