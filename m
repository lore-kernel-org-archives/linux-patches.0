Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7B143C76;
	Thu, 11 Apr 2024 10:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831249; cv=none; b=esQmL8jwzLq4T5A99qJRP4qLcGqoVNv+G6YoQBoXDjlmNwXx+YGIgRo5S0AmnkmloNLiqQetY9faxj6zmlY2pB/XPr2Y9/f4OhlWkKzqJj+sj0GBex4Uglia739Uu10RjTfv6J/Pl7emyIAhFDDhoaHP1eBBXnxwfaKalx4RGK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831249; c=relaxed/simple;
	bh=goXadW0BbhRBXptCMOUxktLRXTBs1HwWQLHzZ1bsjqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3N/DEXgMeXRYQsQwFS7o7Fx21mewpFzNFztIdLRWACOkYnD73tflSHHHtIUy8TUGaiLvwaoOKaacDTGJeFTfGV3LI9iG4Nxf6JrW0K6RK+cxooE3YR1rrhtLPJ5bEQJyvxxeb7a230+q7FeELi1w/odcSxOMnykikYGk6kdnq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaNvbb4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaNvbb4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5812C433F1;
	Thu, 11 Apr 2024 10:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831249;
	bh=goXadW0BbhRBXptCMOUxktLRXTBs1HwWQLHzZ1bsjqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaNvbb4VjnWSl0cHwKphF4K0t6fr2VEAs0x1na7ysliLufhqf+J2dfIP0tzYHC/JU
	 V5LLzpF2pR6/7GMPpKpQgSPPgi0p1OZGcdJ0dm+EMcHueh56mmpqximzim82Oipzvu
	 rh5pTLK1SrC1funBwnlWo+La0oH36RqHqmKlEv5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/114] rcu-tasks: Repair RCU Tasks Trace quiescence check
Date: Thu, 11 Apr 2024 11:56:24 +0200
Message-ID: <20240411095418.607356530@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 2eb52fa8900e642b3b5054c4bf9776089d2a935f ]

The context-switch-time check for RCU Tasks Trace quiescence expects
current->trc_reader_special.b.need_qs to be zero, and if so, updates
it to TRC_NEED_QS_CHECKED.  This is backwards, because if this value
is zero, there is no RCU Tasks Trace grace period in flight, an thus
no need for a quiescent state.  Instead, when a grace period starts,
this field is set to TRC_NEED_QS.

This commit therefore changes the check from zero to TRC_NEED_QS.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9ad656b28847f..6466c2f792923 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -189,9 +189,9 @@ void rcu_tasks_trace_qs_blkd(struct task_struct *t);
 	do {									\
 		int ___rttq_nesting = READ_ONCE((t)->trc_reader_nesting);	\
 										\
-		if (likely(!READ_ONCE((t)->trc_reader_special.b.need_qs)) &&	\
+		if (unlikely(READ_ONCE((t)->trc_reader_special.b.need_qs) == TRC_NEED_QS) &&	\
 		    likely(!___rttq_nesting)) {					\
-			rcu_trc_cmpxchg_need_qs((t), 0,	TRC_NEED_QS_CHECKED);	\
+			rcu_trc_cmpxchg_need_qs((t), TRC_NEED_QS, TRC_NEED_QS_CHECKED);	\
 		} else if (___rttq_nesting && ___rttq_nesting != INT_MIN &&	\
 			   !READ_ONCE((t)->trc_reader_special.b.blocked)) {	\
 			rcu_tasks_trace_qs_blkd(t);				\
-- 
2.43.0



