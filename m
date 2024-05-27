Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A4D168C4;
	Mon, 27 May 2024 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837742; cv=none; b=Kxr7OFv4DSD0qDg22KxXKzDxadCduIp3YSLIGsMz/83ISz5/IuIjmU2r53LpgfiE7SOx7bTJUFeAQ1XIyZqsZpt83Mm456kVHX4Y0T+YVF2UeHOaaeN430rA6sgG4IuIle5PdVeuBjfk0lSQCrsoyOAyUYN2siwoEk4T+yiz+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837742; c=relaxed/simple;
	bh=TxjhbMQGK2IWdrTuImzW0qPHUH0BxEc9nt+PygRqqIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/2Mut8P/M3vyONaAg6gNKCeb8NZ7G0udXD6SMkwyZWeg+ZzShLGXqVqw3yhCjfXGkroPzncFhmqKfVXxDBGykpBpaAwmVWxWHWno6y2v8kZsyDPbfpjo6eW1dycYONTzAF0re/8zciIVzv5lLevS6YTyuHmUVHPHFirC66DSQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sVc6U5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sVc6U5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598EDC2BBFC;
	Mon, 27 May 2024 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837742;
	bh=TxjhbMQGK2IWdrTuImzW0qPHUH0BxEc9nt+PygRqqIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sVc6U5KYLd2FYCDM1cpE3GE+3eI2Z+TC/NL+w4xVMm5k7eqFvNrybV0dh9/+qEVb
	 2a5DuIwk2ID56XajJWJiQdMITtw2hQy5S+8yL2CYNuWZkHdf9tcxwRkvpU95kRmCiC
	 RGMarjdIkhHA8/ezpQMVsjkmOlxnJxcz62JJlH5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 125/493] rcu: Fix buffer overflow in print_cpu_stall_info()
Date: Mon, 27 May 2024 20:52:07 +0200
Message-ID: <20240527185634.585189232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5d666428546b0..b5ec62b2d850a 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -504,7 +504,8 @@ static void print_cpu_stall_info(int cpu)
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



