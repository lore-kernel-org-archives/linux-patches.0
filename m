Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581013F788A;
	Sat, 12 Sep 2026 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231435; cv=none; b=r4ry61lo3TI8zGv5caJiack9/FlXN55xlxjHDF+e2hQ3tykLuAR4/LlPMttop4eRyLOPgM1toP2e+zq6XJNJnre+eHcapOQ1ubBx3pSuHZrnQqsuq55RCvrqH1i0Y1+ucwlK6WxNVY4JKK7HYAQMuK3dS24kfC8LknBdqZ9DJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231435; c=relaxed/simple;
	bh=5wf//T8vis/D6Evc3+NKK4vWlAAiwiq9Cx+OvPCb508=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyvDEb5V4mk3n5m1CJbutVYyPMRwVIlrS/GqYPAwalasqDK/LOsdiEZBRAfUWhsWPp1qCUfPUlJrekXRI9wH0+C59ZWVfWritGHlqew+jBJg2NJ/75AeqaeQPaLIME6nTONsFWLcdgecfwi2XWNFGCgSu8/M13CZBNzwlne0iIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTcp4Die; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTcp4Die"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A941F000FF;
	Sat, 12 Sep 2026 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231434;
	bh=xwBJjgzagZwnKC6lxq9Q1GghZEV5yBECdhFDes4l2n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTcp4DierIgeCCYwhqAaAhfW2kkctTdFFXOxgiAg+B2WRkNJytPFH4lET8IcLNeZ8
	 peOdpDRUKy51NE4En2HX8VgxyXqub6/l1kOHcc+cnYeZ8QMbf1G/9A+J9cPO7IhGoj
	 kSfou3HX9jgUS45h6GNi2SmInAG1ie5esk7wwwnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0997/1191] xenbus: Unregister reboot notifier on init failure
Date: Sat, 12 Sep 2026 09:02:05 +0200
Message-ID: <20260912065610.593448604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit d330fb86a7170f845123ae82d95df440fad9b707 ]

xs_init() registers xs_reboot_nb before initializing XenStore
communications and starting xenwatch. If either operation fails, the
notifier remains registered and a later initialization attempt can hit a
duplicate registration.

Check the notifier registration result and unregister it on every
subsequent failure path.

Fixes: fd8aa9095a95 ("xen: optimize xenbus driver for multiple concurrent xenstore accesses")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260807032326.940377-1-dbgh9129@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_xs.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index a4dd92719e7ae..d59bc4f5169af 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -952,19 +952,27 @@ int xs_init(void)
 	int err;
 	struct task_struct *task;
 
-	register_reboot_notifier(&xs_reboot_nb);
+	err = register_reboot_notifier(&xs_reboot_nb);
+	if (err)
+		return err;
 
 	/* Initialize the shared memory rings to talk to xenstored */
 	err = xb_init_comms();
 	if (err)
-		return err;
+		goto err_unregister_reboot_notifier;
 
 	task = kthread_run(xenwatch_thread, NULL, "xenwatch");
-	if (IS_ERR(task))
-		return PTR_ERR(task);
+	if (IS_ERR(task)) {
+		err = PTR_ERR(task);
+		goto err_unregister_reboot_notifier;
+	}
 
 	/* shutdown watches for kexec boot */
 	xs_reset_watches();
 
 	return 0;
+
+err_unregister_reboot_notifier:
+	unregister_reboot_notifier(&xs_reboot_nb);
+	return err;
 }
-- 
2.53.0



