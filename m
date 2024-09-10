Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE1146444;
	Tue, 10 Sep 2024 10:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964382; cv=none; b=DfuE5yvn+KcUgv+PKZ6M0RjLDnPoKaSYBjAAaoJPRmSrdviYtIWvgsgYCmE07VcrsyehhZSw52/d5GvdxMEwioXRGJVSTzvwr3gafZIv5uUtn8pfLE4gGJThG0UE2AJbbMBdCIdWcxwKxIrAijsQJ+Kr25ueC1sFSKNbQQIFkd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964382; c=relaxed/simple;
	bh=ymDXVLKQCOrqer94bUifh5jfcbA9hBNgygrtS4PxVq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogvcOnrk9MVkvBDcbsP/eMZkjF3RGCiTIN+s2QhadweVhyhZcu8agbIBYeKupR4DuLT8JvY6B/vQUUbuEeJo6d2jrQ3idabxJtgvUC5k69ZuSEj02dSShB6tjhkTnht+DgSu8shOBQ4aILQGpCb962IDC0ax2hYB8PeohCv8n4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeqsI6Ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeqsI6Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1806C4CEC3;
	Tue, 10 Sep 2024 10:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964382;
	bh=ymDXVLKQCOrqer94bUifh5jfcbA9hBNgygrtS4PxVq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeqsI6Ge+pFi7lGlEPel2rbNRYFtjf2GpiqB8a0IydTGhNe1gsEV2siXw9+xkq3dC
	 qaVfGP2a0i0wuoETUb0G4Z3z6zhD0dVuA8rlequmCBnRpTMAn7Tw4P1hPP4yYigRL6
	 XQ6ri0d/Be8vbyPIZwuCholcCimz2UIVdFJcQ+Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/269] smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()
Date: Tue, 10 Sep 2024 11:32:31 +0200
Message-ID: <20240910092614.009855695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 695eb13a276d..3eeffeaf5450 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1119,6 +1119,7 @@ int smp_call_on_cpu(unsigned int cpu, int (*func)(void *), void *par, bool phys)
 
 	queue_work_on(cpu, system_wq, &sscs.work);
 	wait_for_completion(&sscs.done);
+	destroy_work_on_stack(&sscs.work);
 
 	return sscs.ret;
 }
-- 
2.43.0



