Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A263B3BE9;
	Sat, 12 Sep 2026 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240360; cv=none; b=N1/pmH/maayqBbnkdo40F6wpDJVU+3/qpVYV9viE9f9pyHr7NRhSaynDxpWZRC/CFmv4CrB+n35YiGTduDDdZ79yfr7vOFn0INNu+JYuk8FAyiWEYNcf/qIVMmamvdc3v9bmkUnndEj0GTrpUGBnDPBfc/ieQCYdiQupXB25hnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240360; c=relaxed/simple;
	bh=07I15dW1Tw6gFSMWDdJGAH+6eud8SIBhfT1juoW9LKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ky3GwmEw1NBsqvjpOur8Djm+KRL+nbASQf6hqdja2c0VVB/9guuWLbKDE2Vk81kfBhiIDD0cm9UwuE9ulD5sLjzzeDd12H1Ui+aLRgsC6yOLHa22JddePTn3kcMNOvTrLL89WDFBH7KMkWGvBUMJCSGttm39VQ8a6z/zV2XHg8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyTN+MyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyTN+MyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D418E1F000FF;
	Sat, 12 Sep 2026 19:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240358;
	bh=y53Lme68a7FM6c1iqUBY3zM2MBRqTTD2bbdGEPbmAjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyTN+MyE6LfBvNrWExRuPUWd3JfFcg5G0c2lPF1EaZIFA59wbjPP9ANfkn6aWtNfc
	 OIRmpv/4CddoDQnLtFX9UELWKkEdP9xuFOkxAISuOL+9UPFiRhnlUeAbbJdGxQBMM4
	 i7O8Z+zE8MXADa373lTK5kd1BpVn/oAR41FBDtjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 815/935] xenbus: Unregister reboot notifier on init failure
Date: Sat, 12 Sep 2026 09:04:05 +0200
Message-ID: <20260912065545.526765629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



