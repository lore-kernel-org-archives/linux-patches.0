Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062826;
	b=B1RwU32CcsrwJvXlvcFpkqNHGGkAw/sHtpiQbmUWaqHAJOkq/5ALsq7fqdOfZDVdqobY
	 rENr6p2LoydqexkTqpdOSVG0Azt2VC0XsLxjH5jOrX3m57wfl8a++bLNloKq0XtG8yByx
	 +mMYRUe+/0v2vv5nEhQC6JPjP7dQ3apayJadmz6Upl4AaPBpQVMFikrb5tH1yrg+E6oMC
	 XiF2vU5sJckUrj9mQwJKLTej8CJztGYV/vlQi6rjfRWrPfAwZExePht5XI18pnfK1hwep
	 2NViBsuk426SghgmJFq80fSSSzxMEn/bYYmMje4Bv96U2n8nkaVgNz+pxZNwC0O5gNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WynZQ+H0NSUNs66FiGeYQCF2omQEP8MDqrqpi4HBT1g=;
	b=AbXCqE5RvKbeeYS0Gut6GJrCFduo8+jBwpXe93pcNmAGfFdw7jHfjd8tFDRNKW4/6R49
	 5BLC8dw0ckI8SGVXJ7Z1M+He/D+cuUdhPqK0RbNPmyclP4KPUhXTf26I1MrzmKe8Tj8y8
	 E+ff0d/poJ1khTC0Fuft22+6Fb/pd9VJ/ZWW1PWO38mbiCvAd6AT2IQwieGfLZgX8wMZw
	 5FCHYscs8S+uxnK+pJNLYF9Lx2I+wWVOd3dTrT2f1xoh9KiTzWL+JuZ0dM06YY5WW2aLf
	 eAQyJVn8bk9FIqLbxCN+hQlXHVqFadmwZL/FEwHRH0ytukH9y1OsPzO4gQ3+A6FotJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJH+n+Ap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEC9606D808;
	Sat,  7 Nov 2026 14:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJH+n+Ap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2EF1F0089F;
	Sat,  7 Nov 2026 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062826;
	bh=WynZQ+H0NSUNs66FiGeYQCF2omQEP8MDqrqpi4HBT1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJH+n+ApwFmd7kdiGbrV1HcdECfvV4c9/8AJN2cSlKyJbJBHyagBnTQvFs4kU2pS+
	 efAqPtsbg5B54Rc8KhGCJGzp+OwEHYtP5rAy6EficpWw1aSdBQYQvQn1pIPRoc5fyA
	 dqu0TqeSUtosUiG1uWiDNq4Q1VJaotxN2ZnAwQsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binwon Song <qlsdnjs236@chungbuk.ac.kr>,
	Eric Kim <seohyun.kim@outlook.kr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/869] sched/fair: Reset NUMA fault locality after scan period update
Date: Sat,  7 Nov 2026 08:46:43 -0500
Message-ID: <20261107134856.623586752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Kim <seohyun.kim@outlook.kr>

[ Upstream commit e81ee06308379a5f2ededf997bcf17551bce5db7 ]

When updating the task scan period for NUMA locality checks,
update_task_scan_period() checks whether there were no faults or failed
migration on the last scan window, at which it prolongs the scan period.

However, p->numa_faults_locality, which is used to check for migration
failure and number of faults at the previous scan window is not cleared
after changing the scan period, which unintentionally increases
numa_scan_period up to numa_scan_period_max even when there were no
migration failures or no faults at previous scan.

Fix this by jumping to the out label on early exit at this case to
ensure p->numa_faults_locality is always cleared before returning.

Closes: https://lore.kernel.org/all/20250404095354.311156-1-qlsdnjs236@chungbuk.ac.kr/
Reported-by: Binwon Song <qlsdnjs236@chungbuk.ac.kr>
Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/Message-ID:
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 67e8c2065d827..fbc277c6963c5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2794,7 +2794,7 @@ static void update_task_scan_period(struct task_struct *p,
 		p->mm->numa_next_scan = jiffies +
 			msecs_to_jiffies(p->numa_scan_period);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2838,7 +2838,10 @@ static void update_task_scan_period(struct task_struct *p,
 
 	p->numa_scan_period = clamp(p->numa_scan_period + diff,
 			task_scan_min(p), task_scan_max(p));
-	memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
+
+out:
+	memset(p->numa_faults_locality, 0,
+	       sizeof(p->numa_faults_locality));
 }
 
 /*
-- 
2.53.0



