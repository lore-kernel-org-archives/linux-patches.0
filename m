Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDAE502D53;
	Thu, 17 Sep 2026 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668176; cv=none; b=YPPEcgmppa6RtatFJkvqbbzGxJ/v91xoXTnmNWg029iU2l5Xfsqpc9j2KdHEJCExFLkzo/AzglR9pXX+JJIXrVf7Qdid31pCjHzpRsI4gIEMJVWBS3/Ow6aj5bwlAjdHfSUSRWsT5ld3xYhkgTOVwCkLrBIb7fM+rrMsYe74eoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668176; c=relaxed/simple;
	bh=htjd3JYUzLCca+c8P5dFB2CAhUEbUJbybaB8BntxT9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owfiXcVyRDAX4Z4cjEMy39uk8IrAdR1V/azRou14ZTiFZoYKYPYNNn+xM73aHmrsPhTKKoV4dMtfa6maL+CvTvFtZQQlCT3iTbAPW5HxLfO+soH6frDtzxSB66ui7sI3yf7INk2dKGXVEttl3p/vYSEwUlZ3GJTyg5NGI4qj9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNu958Ik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNu958Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525621F000FF;
	Thu, 17 Sep 2026 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668174;
	bh=DXaGo92HYR+NhYhpGSaPdOucTHl5RNaaS/4mjgP1SVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNu958Ik9QeZspphIwPVXqxb/wqF9JSGLmz3NHcTVB+V1BBTFm+PbQp30Q/vjOcnW
	 3sdnY3sTCji6mAVrvTc1/aROxBS/2AeRGvX2n5UCmWnwKpRhqk9Blh39yxc1TwCnwO
	 x0t3gIPJW9fXeQ+dzQaobhBcY+9WtW+mqDZIuy2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <jiajie.lee@starlabs.sg>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0339/1102] perf: Fix addr_filter_ranges lifetime
Date: Thu, 17 Sep 2026 16:04:42 +0100
Message-ID: <20260917151548.146812159@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e62d4192e593630f355094adc467058a05bdc935 ]

Lee Jia Jie reported that since event::addr_filter_ranges is used
under RCU, it should be RCU freed.

Reported-by: Lee Jia Jie <jiajie.lee@starlabs.sg>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 40e82ab016d94..806bec5d0761a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5124,6 +5124,7 @@ static void free_event_rcu(struct rcu_head *head)
 	if (event->ns)
 		put_pid_ns(event->ns);
 	perf_event_free_filter(event);
+	kfree(event->addr_filter_ranges);
 	kmem_cache_free(perf_event_cache, event);
 }
 
@@ -5336,8 +5337,6 @@ static void __free_event(struct perf_event *event)
 	if (event->attach_state & PERF_ATTACH_CALLCHAIN)
 		put_callchain_buffers();
 
-	kfree(event->addr_filter_ranges);
-
 	if (event->attach_state & PERF_ATTACH_EXCLUSIVE)
 		exclusive_event_destroy(event);
 
-- 
2.53.0



