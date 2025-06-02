Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDCE238174;
	Mon,  2 Jun 2025 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876322; cv=none; b=IlKGj3Y9Mxx/6tQLp4E9iiYm6mttKpPPQY9bDTHJ7pgnpkLqs380pFdYkRpoHxabhUQNnVAtvMOBgv36vkkpC76me8DsPP1R6cvvotrkTzwOF6o1Iw25Fk2a+8oY229N0QXFNUgcdGtnfJumP3OUT3ZAPrcNugOUtuufkM88O9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876322; c=relaxed/simple;
	bh=e6TY47S3WGY4cjWbM6ts5r/5RZhzOE8EYpbUSGD1SD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc7/g54m95QBM4TudMYAuvfrj8aq8Pn7h+NoN1oj6d5Wz3Xw76hBo+RiAR2kMVql6bPWpacl5A8LBRXb5atxXN5IWAm+gRaInCqdT+RmpJI/iTSGBXiZHdQlY6LmzIu9/tin8tQsL/fYurZPWSw6Dq5D8cVwIpMf9hGEQgbkyck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o799uT8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o799uT8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC5CC4CEEB;
	Mon,  2 Jun 2025 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876321;
	bh=e6TY47S3WGY4cjWbM6ts5r/5RZhzOE8EYpbUSGD1SD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o799uT8jggVZMOYtkscFr4DHWFFB4Shep0482y7P51CC+FgkGT/Wikqk/wLODGIQO
	 whOtm4U/NaUWOeyoQe2p30c49j2YVJUMbzah+SqLSjHjn2sCoYhCua4XjHrzsLYoTC
	 ZsUCpgTgv4wajqZgmX9CbS9+Ck1awOW20qgiI25c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/207] rcu: fix header guard for rcu_all_qs()
Date: Mon,  2 Jun 2025 15:48:32 +0200
Message-ID: <20250602134304.207840999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankur Arora <ankur.a.arora@oracle.com>

[ Upstream commit ad6b5b73ff565e88aca7a7d1286788d80c97ba71 ]

rcu_all_qs() is defined for !CONFIG_PREEMPT_RCU but the declaration
is conditioned on CONFIG_PREEMPTION.

With CONFIG_PREEMPT_LAZY, CONFIG_PREEMPTION=y does not imply
CONFIG_PREEMPT_RCU=y.

Decouple the two.

Cc: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcutree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 53209d6694001..3828ff8a2f9c9 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -66,7 +66,7 @@ extern int rcu_scheduler_active __read_mostly;
 void rcu_end_inkernel_boot(void);
 bool rcu_inkernel_boot_has_ended(void);
 bool rcu_is_watching(void);
-#ifndef CONFIG_PREEMPTION
+#ifndef CONFIG_PREEMPT_RCU
 void rcu_all_qs(void);
 #endif
 
-- 
2.39.5



