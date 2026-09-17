Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577C84E325C;
	Thu, 17 Sep 2026 18:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668817; cv=none; b=UyISJK3HVzIRJ7O6EBbM+9u2SjgF6WM1sifONKLLAkBl4IEJcsKhVmf5e/WdsoUw648J+Q4AR9zpQBsqjTqUKfZoNykMe2v1m19/A02nJuaeNuZ+3RFYS4FWhf0qCV7ypSc2FmnXclSixp0R5iCdkTUv4Bnzn2aPTPy+ioFEh9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668817; c=relaxed/simple;
	bh=/J5PJk3X6Q9b0EIyCysSKec5YTWa79MAh6oK2xE1LlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rK/3y8Hb4d++aOvWxoe+U1aqK0PjILkgM63wXYb/TLuZ09oPhx3jgfxQzCG5RBG2Ugfb6qkvN6KjjtE+auUIiREXAHlP1L3gF71ez5eCihKcxukAkOrcJnbiLeuPP6Qt5jLvW6GlKCtmlO12lfMgFIQLtE/TO5/BLy6ePwUUCrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1gIR1WO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1gIR1WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE96F1F00893;
	Thu, 17 Sep 2026 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668815;
	bh=e8JEuv3bY0CZ72dq1pLPHzmeCD5e47P6MiwKW3bk2CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1gIR1WOeE5i3R+a+aOYFu+p/VB/K9bANdCSkaWikBxTyTPJzgttsCUsH/hQj+HHg
	 DqbXNPbqDG2y511zPpjJf0WowoIc9wyF/0+dX8NoXkNt+hadoui3G/8ip9Y10Lbrxm
	 +uJ+1iG3/pqwuBTafw5rHJnvIjUroT5eBkd/NhLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Xu <stitch@zju.edu.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0549/1102] workqueue: reject watchdog thresholds that overflow jiffies
Date: Thu, 17 Sep 2026 16:08:12 +0100
Message-ID: <20260917151553.619084041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Xu <stitch@zju.edu.cn>

[ Upstream commit 068c35b5d0546c8625b3d7c61910f73775cf1216 ]

The watchdog threshold is supplied in seconds but is multiplied by HZ
before being used as a jiffies interval. Reject values that exceed
MAX_JIFFY_OFFSET / HZ so the multiplication cannot wrap and the
time_after() comparisons remain within their supported range.

The check is performed before changing the threshold or watchdog timer.
Zero remains the value used to disable the watchdog.

Fixes: 82607adcf9cdf ("workqueue: implement lockup detector")
Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 16888739ed834..376a988658b3b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7705,6 +7705,9 @@ static int wq_watchdog_param_set_thresh(const char *val,
 	if (ret)
 		return ret;
 
+	if (thresh > MAX_JIFFY_OFFSET / HZ)
+		return -ERANGE;
+
 	if (system_percpu_wq)
 		wq_watchdog_set_thresh(thresh);
 	else
-- 
2.53.0



