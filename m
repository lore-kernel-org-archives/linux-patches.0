Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8241E191F72;
	Tue, 10 Sep 2024 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963793; cv=none; b=SZZyLdBW/ydaNXt7LzCDCHPw5oGzxzS0YxFKSJZHBkmwY9GxD8Of9YO/Ob3hRi3OGh3aij+EE1bEWnp87kFQCH1NdNIDZp81YO7dKMhjVu7+yWoS20C9dNifUoTZeDizyxrWN7Stnau1IhLGTLmFTlc/fFhmBbutYxrYFtKp2t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963793; c=relaxed/simple;
	bh=nuz0/G4pGKIhvPlBIl4hMJToGekVjWTslDWJCneAfBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac9TBWaHOQq+xFxoQqzgt2Dbv1GiM0UQzGMSi5UyTDS3fBwAaInlgA0CFtwPPTXxuX3m7c1XLEz7E3Tt80NZ+FPEU96WW9Uu5NCcDJ/MJH0N6tf9LjZk8loznyWHudPuT7o8QftQ1vJdOBIGj5MT3Ae7vtjvVxWWaFUfQpI4CCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4+G3A+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4+G3A+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9F8C4CEC3;
	Tue, 10 Sep 2024 10:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963793;
	bh=nuz0/G4pGKIhvPlBIl4hMJToGekVjWTslDWJCneAfBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4+G3A+4T6IR56E9VAo6gUyJF/hC1FGpH54WGi75MrrVGXY8qCFHmlAFWtqWBs/Zr
	 X30O39wqD2iE7o1R7WvhqLwALjdqGxlppLnzBY84LEs3Q3NsflvgQWdBCZczzCOC2i
	 e2hAOm5E7ze5qSnM5xl96seYguFhDF/r5aFzBPf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/214] smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()
Date: Tue, 10 Sep 2024 11:32:53 +0200
Message-ID: <20240910092604.901123358@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 82825345432c..b60525b34ab0 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1233,6 +1233,7 @@ int smp_call_on_cpu(unsigned int cpu, int (*func)(void *), void *par, bool phys)
 
 	queue_work_on(cpu, system_wq, &sscs.work);
 	wait_for_completion(&sscs.done);
+	destroy_work_on_stack(&sscs.work);
 
 	return sscs.ret;
 }
-- 
2.43.0



