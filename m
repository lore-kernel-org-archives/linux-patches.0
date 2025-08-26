Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3575F2343BE;
	Tue, 26 Aug 2025 12:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212852; cv=none; b=pOqaT536arzspyvBIZYVOoWGyoUBjp4vrpNoqvCUqEboEIrrLg3bWM9z7iibhCIpTYjBdruvXeIxTRCtCVqYQgH3hPrJoawdxj+i2fen0La65GybV8PVhY3SYLu6NqJTZvWWR8dTv4pwTYucs1IOo4ltJP+UwKkgtGHx6bf3VTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212852; c=relaxed/simple;
	bh=CWc2XSQzua8A1zIdxJQyReZOyu2DAEVaCdrad6qIC68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrZBJZjOoK+cuS9XAYyIUZrTo66x6bS/QczAOJLtxGevSQxv2NxzdEM7UfRdAhMg5VzT38LkQ3419rcFkY1HwllhmWFxWpVGxweVSf+CE6kZ11MADpuS85o4hNxtkfji9RpL3BuglR+VktFMzCqg0EgUWkjKxmW8qIeVoJ+UuGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oijLSyzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oijLSyzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73A7C4CEF4;
	Tue, 26 Aug 2025 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212852;
	bh=CWc2XSQzua8A1zIdxJQyReZOyu2DAEVaCdrad6qIC68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oijLSyzv1SfoasWtpGDPTIUkcz+mLZ5Ble1FKppDuy9oIfB5wNWKozO9UEfcDNHgs
	 oVsFRBGjcah1+Q9XPY/L1G5bxgVf+TUGCxT3NQqaOZJMDQsaRbr7OuAiCHII8sT1TU
	 zhex1ghMfeo74aenMmqzeVzyha0Kz6dnUy49azRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/587] cpufreq: Exit governor when failed to start old governor
Date: Tue, 26 Aug 2025 13:04:04 +0200
Message-ID: <20250826110955.358416384@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 0ae204405095abfbc2d694ee0fbb49bcbbe55c57 ]

Detect the result of starting old governor in cpufreq_set_policy(). If it
fails, exit the governor and clear policy->governor.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-5-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cc98d8cf5433..6ee1767ba08f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2701,10 +2701,12 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	pr_debug("starting governor %s failed\n", policy->governor->name);
 	if (old_gov) {
 		policy->governor = old_gov;
-		if (cpufreq_init_governor(policy))
+		if (cpufreq_init_governor(policy)) {
 			policy->governor = NULL;
-		else
-			cpufreq_start_governor(policy);
+		} else if (cpufreq_start_governor(policy)) {
+			cpufreq_exit_governor(policy);
+			policy->governor = NULL;
+		}
 	}
 
 	return ret;
-- 
2.39.5



