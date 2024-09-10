Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D080718787E;
	Tue, 10 Sep 2024 10:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962582; cv=none; b=pVSS/joFeOrEmc1NNrObqRhsuNUReohajR+5w9GSx56YhQDckK26kctalc6grhvi9lHK8fkWO2XUQXwMJYyrTbuUw1befgw7Irn8aTa3TblXyaSp4V3eYBcSFDVDKtU1H+Vt9uAbLjofRi6x/ddtkNma8YXBH0qoaZogPdmvpLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962582; c=relaxed/simple;
	bh=YzR+n4RjazWTYJsaniI+2enOG3d2rWKhp9AQEJcnFBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNs3j0+NIJQ5cYgPz9OQZrDoZRFHTgBsjH8n7a7xLDS1NTHO5rU5C8vuP9IrB8IQAjvtptYnD9h95XprQEl5w6FdGofOygD5ZDap8GYdYl1lJhlnQN2edeNOZjKzn+B2fW3WSNjCiyU+R1zaJU+FM4ObYsoIBVquK4HV2DRu2ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vu6rbdKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vu6rbdKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55884C4CECE;
	Tue, 10 Sep 2024 10:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962582;
	bh=YzR+n4RjazWTYJsaniI+2enOG3d2rWKhp9AQEJcnFBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vu6rbdKKyMv09B96rSNqdaEoKpsS8CtmQYE+nQ9tUilQGMhWY59m/7eEESmwPXWnB
	 +iZ7u/IFNO89s35Q+dq2vxa4eMHoftp3XcDDo84YpZEAlhClgsg9gJm3PeNMPuWiZe
	 P737LU8FdAIMpKFdoV6QQLdH9AWoG6+6fzHXhuHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/121] smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()
Date: Tue, 10 Sep 2024 11:32:37 +0200
Message-ID: <20240910092549.797451149@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index be65b76cb803..76de88dc1699 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -813,6 +813,7 @@ int smp_call_on_cpu(unsigned int cpu, int (*func)(void *), void *par, bool phys)
 
 	queue_work_on(cpu, system_wq, &sscs.work);
 	wait_for_completion(&sscs.done);
+	destroy_work_on_stack(&sscs.work);
 
 	return sscs.ret;
 }
-- 
2.43.0



