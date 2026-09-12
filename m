Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2A638F620;
	Sat, 12 Sep 2026 19:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242797; cv=none; b=Rw3CJ3D+X+fBPSLCRzN0S79uMMo68O/r1v9dIPwz3R8BpkcUvlGa0SXgYYz7MF26irsx6FoYd5jfQrqXmVEZpxGxqWpqND79zsKbsa07OBfk+S2i+iuwS0i3qhCu4LlDeTfCdoTijKyExn32W/c8UITQpHj29CUbxO/9EUz2pjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242797; c=relaxed/simple;
	bh=4QzVYSERdlpCcnJkghzevgU94rApHzQhqdkibZ6luMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnoWzecZ5AdS+8BvSUMn5X4A62GBMOdQO7D/fkBFtxSg1++DVPfdgMOY6cVohJyXYv+HH7MY0Ci+DttS08eh8zxPbxDBb93g433S+t1OX8N0MxZkFwzL9diGWP9lwtv2KyU3PLFwuWPwYOFW46000x5qQIUuAjDgznKbGSMwOI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pZNcCOV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pZNcCOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1611B1F000FF;
	Sat, 12 Sep 2026 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242796;
	bh=jeDbzD81r5WHWyJRyPU7245+tvItB55SYQZH/x7wwKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pZNcCOVn4ykUgyMyl7caV5e+YLNTHSM8taWu6dcDiozkoNsYH3BvRnbYxnIDTyQY
	 jyTP97jWL7oRj53Z1rfLmqSXGRJZd2cj6++N9wBOkClptAlvLW0Ckd5VYGA42JfImv
	 Tq7VOkvJiW118GZSeG4U3Gt6UZbsBak66Wh8yjas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 523/798] remoteproc: Use unbounded workqueue for recovery work
Date: Sat, 12 Sep 2026 09:02:31 +0200
Message-ID: <20260912065529.121085939@linuxfoundation.org>
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

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit cab8300b5621a54aa25306ff800c27fa5a4632d7 ]

There could be a scenario when there is too much load on a core
(n number of tasks which is affined) or in a case when multiple
rproc subsystem is going for recovery, they queue their recovery
work to one core so even though subsystem are independent their
recovery will be delayed if one of the subsystem recovery work
is taking more time in completing.

If we make this queue unbounded, the recovery work could be picked
on any cpu. This patch is trying to address this.

Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1650367554-15510-1-git-send-email-quic_mojha@quicinc.com
Stable-dep-of: 74ee3b2f5767 ("remoteproc: Prevent crash handling to race with rproc_del()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index e416908745d17..e7918652217ce 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -58,6 +58,7 @@ static int rproc_release_carveout(struct rproc *rproc,
 
 /* Unique indices for remoteproc devices */
 static DEFINE_IDA(rproc_dev_index);
+static struct workqueue_struct *rproc_recovery_wq;
 
 static const char * const rproc_crash_names[] = {
 	[RPROC_MMUFAULT]	= "mmufault",
@@ -2450,8 +2451,7 @@ void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type)
 	dev_err(&rproc->dev, "crash detected in %s: type %s\n",
 		rproc->name, rproc_crash_to_string(type));
 
-	/* Have a worker handle the error; ensure system is not suspended */
-	queue_work(system_freezable_wq, &rproc->crash_handler);
+	queue_work(rproc_recovery_wq, &rproc->crash_handler);
 }
 EXPORT_SYMBOL(rproc_report_crash);
 
@@ -2496,6 +2496,13 @@ static void __exit rproc_exit_panic(void)
 
 static int __init remoteproc_init(void)
 {
+	rproc_recovery_wq = alloc_workqueue("rproc_recovery_wq",
+						WQ_UNBOUND | WQ_FREEZABLE, 0);
+	if (!rproc_recovery_wq) {
+		pr_err("remoteproc: creation of rproc_recovery_wq failed\n");
+		return -ENOMEM;
+	}
+
 	rproc_init_sysfs();
 	rproc_init_debugfs();
 	rproc_init_cdev();
@@ -2509,9 +2516,13 @@ static void __exit remoteproc_exit(void)
 {
 	ida_destroy(&rproc_dev_index);
 
+	if (!rproc_recovery_wq)
+		return;
+
 	rproc_exit_panic();
 	rproc_exit_debugfs();
 	rproc_exit_sysfs();
+	destroy_workqueue(rproc_recovery_wq);
 }
 module_exit(remoteproc_exit);
 
-- 
2.53.0



