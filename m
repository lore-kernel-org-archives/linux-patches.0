Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560692233B;
	Thu,  6 Jun 2024 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683163; cv=none; b=gqr9sbeBhE+Citkw3/9dIi6govPkYsibpqHlt0s47A/q5kK6AMDsRQKcCYCjsjgafwk3xODbpPmF7XtWnK7n6XmteMdp8Fq1xhQut21on/wzoHXf/PGAN/9IoKRkkBzqZGM23QW1Ei0z5qOyDAU2MmxLCvDZm8rHyVcgIPhzaoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683163; c=relaxed/simple;
	bh=ZVsWEtoFJ8HDIamHypFMPVEfXFlCsbJHZlAzUR/5yOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/a8fXlQIvB0iNOHkPKjyveogGfUFrh6pdqpjLsG43/jGDTxzEqxp/ht0cl9ZRZD59/sE8WqsNbrVbicbmw3NBZfLxlxjJOkT06gHqiOf0GwADrL38cUzKsginkopcsKYzvE8mvjg9l2gHNdjVKBe+25+giF/D2n0AhtCqnh8Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaigrUz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaigrUz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D37C2BD10;
	Thu,  6 Jun 2024 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683163;
	bh=ZVsWEtoFJ8HDIamHypFMPVEfXFlCsbJHZlAzUR/5yOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaigrUz7UtOZ7O2rS3Drd3Ew23TfCqGzF8nxs70tySzKqV/YjYyjl01NTeeSPlMa1
	 chm4UPtsg8w2hY6FVGr9N0ioudKQUmlAhkZDkff89D/pNBlO4UcPwVH/uI1VOy+Y1w
	 4mLmcpRaa/KvJlRwsMen+KMRucL4MOkG4YYUwqN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/744] rcu: Fix buffer overflow in print_cpu_stall_info()
Date: Thu,  6 Jun 2024 15:56:19 +0200
Message-ID: <20240606131735.825798135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Nikita Kiryushin <kiryushin@ancud.ru>

[ Upstream commit 3758f7d9917bd7ef0482c4184c0ad673b4c4e069 ]

The rcuc-starvation output from print_cpu_stall_info() might overflow the
buffer if there is a huge difference in jiffies difference.  The situation
might seem improbable, but computers sometimes get very confused about
time, which can result in full-sized integers, and, in this case,
buffer overflow.

Also, the unsigned jiffies difference is printed using %ld, which is
normally for signed integers.  This is intentional for debugging purposes,
but it is not obvious from the code.

This commit therefore changes sprintf() to snprintf() and adds a
clarifying comment about intention of %ld format.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 245a62982502 ("rcu: Dump rcuc kthread status for CPUs not reporting quiescent state")
Signed-off-by: Nikita Kiryushin <kiryushin@ancud.ru>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_stall.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index e09f4f624261e..11a1fac3a5898 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -503,7 +503,8 @@ static void print_cpu_stall_info(int cpu)
 			rcu_dynticks_in_eqs(rcu_dynticks_snap(cpu));
 	rcuc_starved = rcu_is_rcuc_kthread_starving(rdp, &j);
 	if (rcuc_starved)
-		sprintf(buf, " rcuc=%ld jiffies(starved)", j);
+		// Print signed value, as negative values indicate a probable bug.
+		snprintf(buf, sizeof(buf), " rcuc=%ld jiffies(starved)", j);
 	pr_err("\t%d-%c%c%c%c: (%lu %s) idle=%04x/%ld/%#lx softirq=%u/%u fqs=%ld%s%s\n",
 	       cpu,
 	       "O."[!!cpu_online(cpu)],
-- 
2.43.0



