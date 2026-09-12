Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C293A221F26;
	Sat, 12 Sep 2026 11:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211134; cv=none; b=CsLS98qEGcNBPARMpXsYx+mOMbV066jezcls8c7BTN9he3fbN+zD0ESZ6GfG/Dt/26VVT0MQbuAP4HE0v1ECK70XJUhVHiSe31wzpIYljyofO7HZbpOGnBbYeFBUjn9RljGCH1blhmABcO6nI4x3O7QpEX4jNHnyhSb+8L1sjo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211134; c=relaxed/simple;
	bh=zIfO7Miv0TuTN5hssonztSnG1XmctHaFPG+NVg6bnI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LK1NkSfIn2enaVVyEvsStgCRpxv/jwsyX7X8H0CDFX+2DplcDx+3l3UV2kDQO0eb1DgSLXcVkhuIo0FWxXP6z5YAdmjptHw10ceFz4hONDUStQXz9duBtNPhcWebsEpaF+o0jKf1vodJ7effN31tivbKfMFoSrfjxhoR5s3lZds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUL29/NA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUL29/NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A3D1F000FF;
	Sat, 12 Sep 2026 11:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211133;
	bh=3Ibq8IlD9hDTCut9R612u1lhlNTUn4v3MDb8WAScPFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUL29/NAPMthxQcD48fjJFHg6l4zEYSAraOV5xaa6VCkUUw7b7sgg6Gcrrv1W/H3W
	 uHt7lAHbnD0+r0WReOpHVshz52I4SY3WwpxJtORIrDcKaywFZVn1WxnvcoRe92fyya
	 Y6OmKXj8Ao5a0pDl+NCFzBXrWAak1c+B3ZuxqCKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1168/1518] xenbus: Unregister reboot notifier on init failure
Date: Sat, 12 Sep 2026 08:55:37 +0200
Message-ID: <20260912065649.887278963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 528682bf0c7f2..f312b9a57d971 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -912,19 +912,27 @@ int xs_init(void)
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



