Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3583A2E39;
	Sat, 12 Sep 2026 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243405; cv=none; b=tohG5DC/CTE2SeLNwTusWThxdwn5iugjtLGXFassuJJloLFdDdK2WLTaP4hTkg3r0QT7LAKIAjlU8YzTMnf3wli9XctwAQHoRtDw+1csjq0M2HY4Obz3MDj9S5Ka58U9NKcRHB8AJRUgHmLo5ObGsi/AkKErMTK1VuAfv6jvGNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243405; c=relaxed/simple;
	bh=yUrB2xBjJFzzHMs8Yk5spjA2E9aZes9CwY9Fni6WQrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7uTHUm8GmqgjUIYdGRp7I5ZGJgc5QQwhBg/N3E+R20ymGGJiuIOhlc3+zHrdMQQP4AuIjmla6oQEwHKcc1m3P4oqzg9fZ4SeZotnL/1fD/PVAIZBzl6tjKBhy+dhYXgSRlKbBEBk7qRGlQhGCunSmXZBVtCXcDlMIT5GWXE0ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taL1sQb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taL1sQb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1672E1F000FF;
	Sat, 12 Sep 2026 20:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243404;
	bh=q7l/YhL2O3k8JyGJDsrwu8Ws8NmCbxa90e1drR57ik8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taL1sQb6XumZVOyeRctD8Pl11EZ7npXaU1qERqm+QjaSzmM+QNKuGqbI+KdG6DwaP
	 IaXB9GIS0baVrzPpFKAMqzmjuoaPUmHy0bX3eINOy6xv6hNd2eUnZi0vxI5Kq6YHyh
	 2WBp0hye7zHT/R7z50MAJFIzPOVV3YB1Z+6YiiG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 701/798] xenbus: Unregister reboot notifier on init failure
Date: Sat, 12 Sep 2026 09:05:29 +0200
Message-ID: <20260912065533.160226330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



