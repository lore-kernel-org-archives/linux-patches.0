Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5A72F5E;
	Tue, 12 Aug 2025 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021873; cv=none; b=bU0YnYsDdHs1u9pYYtjN5O8XoauYw9+2nTtJPPWNTvof6W5NlzSOJ0feHg0y2ArK3Ofp4EQElnlCANVMmPb6+623le5E1pvczOYJykWzn+ciuVpqbZue0rSFKd+mxhf8SuK+9P0MtyypwDsw0a3KJtA1Rg1oKPccb1Ojcx8yh5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021873; c=relaxed/simple;
	bh=1CEmesvveaDn/BdtPnNyelFhwzBU9urvi+xctiIYGeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSm3GjmfyoSTBuVYbhNBOemXp7Cjpm13NlTJAk8NEkvq7QTEJFWi0uhbeTLhtiOWYpkmZgwee5GQVTfCsbOVHaSSMzYIu8QBSUmRjkQdECj18jw71mFXkfq8uD0PWrx9VRhKu3ep9as5QB9toek8Lcvjc0k6MhFX5Mo0waVMeg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWDnKugi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWDnKugi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDE8C4CEF0;
	Tue, 12 Aug 2025 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021873;
	bh=1CEmesvveaDn/BdtPnNyelFhwzBU9urvi+xctiIYGeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWDnKugi0quJ0GLB86p2DUC3ISn+ohZO4Z/UV/Giuk+0ykSSVzU0747KpBFq2qxo6
	 aAGs2y5uMtTcVkqhfXasKATOEq0Gj1zLEtGcPiLW31qjmKhNHIaoT8taPHts0PrxU5
	 4GYsLQ1uu+EVKHOLR5mDk+CS1rjGnsjEWXr2vbJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Berman <quic_eberman@quicinc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Abhijeet Dharmapurikar <quic_adharmap@quicinc.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH 6.6 250/262] freezer,sched: Do not restore saved_state of a thawed task
Date: Tue, 12 Aug 2025 19:30:38 +0200
Message-ID: <20250812173003.799461995@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Elliot Berman <quic_eberman@quicinc.com>

commit 23ab79e8e469e2605beec2e3ccb40d19c68dd2e0 upstream.

It is possible for a task to be thawed multiple times when mixing the
*legacy* cgroup freezer and system-wide freezer. To do this, freeze the
cgroup, do system-wide freeze/thaw, then thaw the cgroup. When this
happens, then a stale saved_state can be written to the task's state
and cause task to hang indefinitely. Fix this by only trying to thaw
tasks that are actually frozen.

This change also has the marginal benefit avoiding unnecessary
wake_up_state(p, TASK_FROZEN) if we know the task is already thawed.
There is not possibility of time-of-compare/time-of-use race when we skip
the wake_up_state because entering/exiting TASK_FROZEN is guarded by
freezer_lock.

Fixes: 8f0eed4a78a8 ("freezer,sched: Use saved_state to reduce some spurious wakeups")
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Abhijeet Dharmapurikar <quic_adharmap@quicinc.com>
Link: https://lore.kernel.org/r/20231120-freezer-state-multiple-thaws-v1-1-f2e1dd7ce5a2@quicinc.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/freezer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -201,7 +201,7 @@ void __thaw_task(struct task_struct *p)
 	if (WARN_ON_ONCE(freezing(p)))
 		goto unlock;
 
-	if (task_call_func(p, __restore_freezer_state, NULL))
+	if (!frozen(p) || task_call_func(p, __restore_freezer_state, NULL))
 		goto unlock;
 
 	wake_up_state(p, TASK_FROZEN);


