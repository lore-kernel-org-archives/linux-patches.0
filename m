Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973D82451C8;
	Tue, 29 Apr 2025 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949755; cv=none; b=r8GEDkt1u6JrHORWFJWD239qpNEZTHWr+zcqaIq/d2vg1XJABFrMo6IF9Bf288BQuqy8C+CRh2bX9ZHy3Hb9Wv45CBMZOpF5tGgAyuOAPngztTM/2m3GTAvfMbrwSj0IRJjHLgpRg4vuAppCzCOFYrgLw8+PxhA2TciD8i4Qu1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949755; c=relaxed/simple;
	bh=zZvwqLDzUrZ52hhsf4YZFSGriqgwTqNSeMSomOHJVZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cmtk9SGbCqSxA+8f1L67SYHvI/kLt34pED9AWIKj/p2RdaMivV6NpekmC45oVQ2lL+rED3IByH/Qr3Uz8SAjugWLX6gH1W5XIoqHlrz++MDWRKphaUkISeeYQjRwxCvBq6FGQiLmub3Rcb+4zigEGHpuXKgdQ/Njklm8IvFCynQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACOr467R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACOr467R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D58C4CEE3;
	Tue, 29 Apr 2025 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949755;
	bh=zZvwqLDzUrZ52hhsf4YZFSGriqgwTqNSeMSomOHJVZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACOr467RpFdjQdXWXbDbmQAN6YXpTkPvptk8HdpB2mBt5GtvEtqSIx8mYUhdMAg49
	 5aT7Ocy3wFNXW7ZVs/tL4ymAVLWvh8G5wKCxrQ5Maatz36uHlwjQcxdKpQdQq+1ZIg
	 TzfBnzwxWE/91evVUVCzDYBPoZXGUVaOOS+PKP9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/167] cpufreq: cppc: Fix invalid return value in .get() callback
Date: Tue, 29 Apr 2025 18:42:34 +0200
Message-ID: <20250429161053.619912259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 2b8e6b58889c672e1ae3601d9b2b070be4dc2fbc ]

Returning a negative error code in a function with an unsigned
return type is a pretty bad idea. It is probably worse when the
justification for the change is "our static analisys tool found it".

Fixes: cf7de25878a1 ("cppc_cpufreq: Fix possible null pointer dereference")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 12fc07ed3502b..cfa2e3f0e56bd 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -749,7 +749,7 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 	int ret;
 
 	if (!policy)
-		return -ENODEV;
+		return 0;
 
 	cpu_data = policy->driver_data;
 
-- 
2.39.5



