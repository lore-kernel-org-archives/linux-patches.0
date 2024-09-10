Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A96189F58;
	Tue, 10 Sep 2024 09:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961234; cv=none; b=do7pM4+oZC2hHUGy4C+hMKbsBgXG3vxyRrHPlQFx14d6kNLkjrBHvkM0/ppSWwlyLJQ5NDdkCidpJvfq3CG44kAKbNiXuf+KUBmEY6XCZVRJ8bP2IiB6JIGCyeJaI7KbNJgRSaqdMbR11QTu+Nbk9sWfmWY9THfSdWUp6QBuWlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961234; c=relaxed/simple;
	bh=ESeYBlBx5OMZrgO05KVHeyUgPR2PizemwXCwQjLQHto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huNXnCaBjwrXkafLfibwrPEhq1LpxF95k+6W1j/sik1axY6HLWeq0HuuPDen47K3ma1N5EMPZ1kJMoyBZ5k/Kzizaw0wduX2cjT5w9HpWH5QGUnFPY1oK9GFYoxZ/jjuoT6myQ3WI/dJuCjstL3wkt3s8VtulnZ3Ve6VEXE7MF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P99Gfx4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P99Gfx4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084A4C4CEC3;
	Tue, 10 Sep 2024 09:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961234;
	bh=ESeYBlBx5OMZrgO05KVHeyUgPR2PizemwXCwQjLQHto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P99Gfx4+pdlEsd9bsd+XkCciKmKvHol3MISypQviWQBTirM0ghTg+Zgs6W6CpwmV6
	 wBNczn3uyQ6J2CSZHf1FVJcWm1g/6a0f599TZfUkWxLI5WEtoN5ariadx/TUZ+Y2re
	 8gNNsXWrLSSm6gCiCoABC3N/X9PrZAqM3FHeu76Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 62/96] smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()
Date: Tue, 10 Sep 2024 11:32:04 +0200
Message-ID: <20240910092544.268782907@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 77aeb1b685f9db73d276bad4bb30d48505a6fd23 ]

For CONFIG_DEBUG_OBJECTS_WORK=y kernels sscs.work defined by
INIT_WORK_ONSTACK() is initialized by debug_object_init_on_stack() for
the debug check in __init_work() to work correctly.

But this lacks the counterpart to remove the tracked object from debug
objects again, which will cause a debug object warning once the stack is
freed.

Add the missing destroy_work_on_stack() invocation to cure that.

[ tglx: Massaged changelog ]

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20240704065213.13559-1-qiang.zhang1211@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/smp.c b/kernel/smp.c
index 9fa2fe6c0c05..c5f333258ecf 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -791,6 +791,7 @@ int smp_call_on_cpu(unsigned int cpu, int (*func)(void *), void *par, bool phys)
 
 	queue_work_on(cpu, system_wq, &sscs.work);
 	wait_for_completion(&sscs.done);
+	destroy_work_on_stack(&sscs.work);
 
 	return sscs.ret;
 }
-- 
2.43.0



