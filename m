Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517562E9759;
	Tue, 22 Jul 2025 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193741; cv=none; b=I7DhFrEY8eWtprWp4Jfrm+z2F5DfTzpiIRnw0O9O6w/JR9Jxrcxsf7zwgrI+ozN2hlPgV2Rbg/MCxybvgoyZgyqBHa4J6VOfrsiRG7mqLtfKwPqtywwkK1Jso3kYTVudezag+iiD+0y6bxmDsGyR90h/+7w052+ZZEFs84bryaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193741; c=relaxed/simple;
	bh=fvKUBFc05hQTM7si+h+iNeVv0JeGsMDJiVS6GC0+lmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=om8bntVa8wYVZXox5V98wTXRFKhg6MPfmAJbYaetIECCL7ibeRfDhC6/iUf0QPxFzRNN2qRSQp4YmLoISpeEzEbQquYK+CoorMABbfKT3T8yRxZWsu3m/fhjn15VQ7S4Y5I6VJYY1z2WJQAnNzdOF2mOYyUjlZgU5XGfGibIufI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naVTC5Pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naVTC5Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34E0C4CEF1;
	Tue, 22 Jul 2025 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193741;
	bh=fvKUBFc05hQTM7si+h+iNeVv0JeGsMDJiVS6GC0+lmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naVTC5PppNlbNeKA8LfT1ngAMDStAY/m89HeWydr8Pjwx0HalJjvZkXepYZ95x1tp
	 41uzMWEjtY21nzRSGrFvy/NOJoiUgvH5on9DQEc5YiD7BrtC5mSaePgwaZ1vjB1mXS
	 /iFBg6AsGU9qCn7JcOa53gY4byzbSLjX5d5SAs3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Breno Leitao <leitao@debian.org>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 184/187] sched/ext: Prevent update_locked_rq() calls with NULL rq
Date: Tue, 22 Jul 2025 15:45:54 +0200
Message-ID: <20250722134352.621609662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit e14fd98c6d66cb76694b12c05768e4f9e8c95664 upstream.

Avoid invoking update_locked_rq() when the runqueue (rq) pointer is NULL
in the SCX_CALL_OP and SCX_CALL_OP_RET macros.

Previously, calling update_locked_rq(NULL) with preemption enabled could
trigger the following warning:

    BUG: using __this_cpu_write() in preemptible [00000000]

This happens because __this_cpu_write() is unsafe to use in preemptible
context.

rq is NULL when an ops invoked from an unlocked context. In such cases, we
don't need to store any rq, since the value should already be NULL
(unlocked). Ensure that update_locked_rq() is only called when rq is
non-NULL, preventing calling __this_cpu_write() on preemptible context.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Fixes: 18853ba782bef ("sched_ext: Track currently locked rq")
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v6.15
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1149,7 +1149,8 @@ static inline struct rq *scx_locked_rq(v
 
 #define SCX_CALL_OP(mask, op, rq, args...)					\
 do {										\
-	update_locked_rq(rq);							\
+	if (rq)									\
+		update_locked_rq(rq);						\
 	if (mask) {								\
 		scx_kf_allow(mask);						\
 		scx_ops.op(args);						\
@@ -1157,14 +1158,16 @@ do {										\
 	} else {								\
 		scx_ops.op(args);						\
 	}									\
-	update_locked_rq(NULL);							\
+	if (rq)									\
+		update_locked_rq(NULL);						\
 } while (0)
 
 #define SCX_CALL_OP_RET(mask, op, rq, args...)					\
 ({										\
 	__typeof__(scx_ops.op(args)) __ret;					\
 										\
-	update_locked_rq(rq);							\
+	if (rq)									\
+		update_locked_rq(rq);						\
 	if (mask) {								\
 		scx_kf_allow(mask);						\
 		__ret = scx_ops.op(args);					\
@@ -1172,7 +1175,8 @@ do {										\
 	} else {								\
 		__ret = scx_ops.op(args);					\
 	}									\
-	update_locked_rq(NULL);							\
+	if (rq)									\
+		update_locked_rq(NULL);						\
 	__ret;									\
 })
 


