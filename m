Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846B033CFD;
	Fri, 24 Nov 2023 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7T/Pueg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100B3C433C8;
	Fri, 24 Nov 2023 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852067;
	bh=XMyofrKp2IppO5b0faSf+iuxe3RMcP6CxRlzLTNwPt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7T/PuegpX/WbxQwr5HJLi0vZOOat6OtfTTXt4d10SFp919E+dt6EDto7L5fAVeAw
	 anNmhEUQe5535Pa/qpORlzghXneHIfx6RHIw0Du1SsumK21mkeImGOvHH+8o5fEEg8
	 uo6m76ngKjGbvMrPk1YSsWqrU+k0bfm4dQSXQ+9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 207/372] parisc/power: Add power soft-off when running on qemu
Date: Fri, 24 Nov 2023 17:49:54 +0000
Message-ID: <20231124172017.365827055@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit d0c219472980d15f5cbc5c8aec736848bda3f235 upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/power.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -197,6 +197,14 @@ static struct notifier_block parisc_pani
 	.priority	= INT_MAX,
 };
 
+/* qemu soft power-off function */
+static int qemu_power_off(struct sys_off_data *data)
+{
+	/* this turns the system off via SeaBIOS */
+	*(int *)data->cb_data = 0;
+	pdc_soft_power_button(1);
+	return NOTIFY_DONE;
+}
 
 static int __init power_init(void)
 {
@@ -226,7 +234,13 @@ static int __init power_init(void)
 				soft_power_reg);
 	}
 
-	power_task = kthread_run(kpowerswd, (void*)soft_power_reg, KTHREAD_NAME);
+	power_task = NULL;
+	if (running_on_qemu && soft_power_reg)
+		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF, SYS_OFF_PRIO_DEFAULT,
+					qemu_power_off, (void *)soft_power_reg);
+	else
+		power_task = kthread_run(kpowerswd, (void*)soft_power_reg,
+					KTHREAD_NAME);
 	if (IS_ERR(power_task)) {
 		printk(KERN_ERR DRIVER_NAME ": thread creation failed.  Driver not loaded.\n");
 		pdc_soft_power_button(0);


