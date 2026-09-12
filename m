Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DBA34E774;
	Sat, 12 Sep 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225454; cv=none; b=lkMgqx6UkyU/q4KMBnw+Pnfv302Hn5cYYNCjWWvG6jPgt66TXpSZ+O8RiF6ORoRldI9wC/G8DaZ+LmUng5EMKv/T+6SC5SWbownekJaL/vbqf/L90t6iVtEhgaa5lyD0u2LgarVcPRw1d6/dG2NZRCsXTeA5xvTwohUc1YK/ss0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225454; c=relaxed/simple;
	bh=W0Y7dN5nTriAWAYBCR09BM3bVDcJeLW8Xg+KRnyHBe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJrMTaZrXHLAmvISIGVTbTv2M47ESBBy5X5LYsl8n1FEcJsrSn/ScscyfNOMFyOPMDzOkLI0l8337IcwfwVNiFShw+ENivC+tQaEJi8f6dBuHFGlcs566m9tWSJp+y9jLx5B5oTiB9HzPP0rDCj+3Dknno7151+/NrmM6yCsB3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8mHFclc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8mHFclc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF921F000FF;
	Sat, 12 Sep 2026 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225453;
	bh=lE/GRxWWJ9173y0vveUJG0cCuA07U+1ZKpDqnu4esak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8mHFclcjrmT9JeRn31VmXe0+vBxDWuOSgkuhrRDXgjrXn/DhpWi/nuC36PeW34FB
	 CzwoWpcbq8ie/OpGJlRlmfEpFL6v29scGQuQiBje4JQ0DIORzDPKHuLGIiHY1Mg5P9
	 pzSpnIxewboJO0KECXHGvZUiw/koXfnsNadwATfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1201/1424] xenbus: Unregister reboot notifier on init failure
Date: Sat, 12 Sep 2026 09:00:33 +0200
Message-ID: <20260912065634.181462119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f84c87ee28395..6b1cc94efe2cf 100644
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



