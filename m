Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4351191476;
	Tue, 10 Sep 2024 10:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963068; cv=none; b=swspum6PMga17Rgm9rOTZgw6bPIzvWIBoek9dE+BpErzQjQgvKtd2WSMj1+I58MoiAicqR5PMmv1yPu+SmHJOxdJ3lXUcNpbpzAVNpHI0c2SJj17kWHIXTYu3xYfw2yTwfIJnVU9oL/0ZrjdnxwasSI6lKWm8Mk6VYFMPcHFrGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963068; c=relaxed/simple;
	bh=c5Xizq0BHzUpJb2WHIbr0ijK9hxcANbAHWlaHmYnK7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2H7/eNu0O5lEVdWe/N/D2V2lMvQoLJ/ZbRDJ9UjPsIxJaPEhBj7/vDYTC8fIkkg0QqSL+AAKfMsuwu0uY6k8cKK1aJPk9vSJwr02Tu/8sxrCKqRe9xLHlBOjZl8p++MZe4ZJd5DPXvcYYTgKhiJHvu3wCzy/mCNw3AkOEGbNOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPVJ5BUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPVJ5BUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109EBC4CEC3;
	Tue, 10 Sep 2024 10:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963068;
	bh=c5Xizq0BHzUpJb2WHIbr0ijK9hxcANbAHWlaHmYnK7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPVJ5BUpxW/h5Zt0PY4WVRgU6TKYpisLPpi4HYtddCe3FI8spFrKrUmeXeKwshCF+
	 v7LDEskrGGCDsD5b+b5/tdgjvg1vQVrpVG9RbkBF8Twm+WtvjXRbbCqf1FRslLLO63
	 s0xgZgqfilQWmSSvqc7kt/K5RUtMfehcVQwIV8fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/192] smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()
Date: Tue, 10 Sep 2024 11:32:11 +0200
Message-ID: <20240910092602.400857587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 63e466bb6b03..0acd433afa7b 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1262,6 +1262,7 @@ int smp_call_on_cpu(unsigned int cpu, int (*func)(void *), void *par, bool phys)
 
 	queue_work_on(cpu, system_wq, &sscs.work);
 	wait_for_completion(&sscs.done);
+	destroy_work_on_stack(&sscs.work);
 
 	return sscs.ret;
 }
-- 
2.43.0



