Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD2814A4DF;
	Thu, 23 May 2024 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470160; cv=none; b=E0nOObZYwiyiSDQAvcBGYKyb7iKbxsNS2ilCMw5fVXKVivBlagh+LgC+2NuLd5BUP0ZUlwoiB4EK/MBcVVpnxVmtrOmRj4SuScbKvopjMBRr/eTx6xFrc9rYg1Tag+ovyFrmHV6IyJHytYqllV0uw1A/83JxeD5oJshetpw6e8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470160; c=relaxed/simple;
	bh=pzMwzv6sFCf/5Ejvtn6ejTxGWgM9yUjsIfnF8r+RJcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJqaYGVipx9u8Q1X8Or+zfwu3a35S+Ql7kjnqdHFgHCzJYU54F7vq//5C4n6KTa5dHyJpS2MU3r+8wUuoLD3glbuBqOoiVGwEDfa5ExJxwfOvYtLM9ltQrXcXEnQ5s5r6RN4p7WQHfMr1uAiDZJbdOP8wj8B3OSRooRi3dlRfpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xt/NVljr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xt/NVljr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8781BC2BD10;
	Thu, 23 May 2024 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470159;
	bh=pzMwzv6sFCf/5Ejvtn6ejTxGWgM9yUjsIfnF8r+RJcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xt/NVljrDYlvdp5Llmaj1a7gicCNXB4mIjkGuVaiSi1I22OLVlp+R2hGuDz/pzd1U
	 YuisREfWoOFZGB71Vq+vsb2abQNRblX4f+8+RI04mQ6zkEV67mCL69Qya7Yh/bI8ch
	 IqKGVMNUBdGXRyoGRyu/oZ8O09ixPd42bXlzel9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liuye <liu.yeC@h3c.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.4 15/16] serial: kgdboc: Fix NMI-safety problems from keyboard reset code
Date: Thu, 23 May 2024 15:12:48 +0200
Message-ID: <20240523130326.320872856@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

From: Daniel Thompson <daniel.thompson@linaro.org>

commit b2aba15ad6f908d1a620fd97f6af5620c3639742 upstream.

Currently, when kdb is compiled with keyboard support, then we will use
schedule_work() to provoke reset of the keyboard status.  Unfortunately
schedule_work() gets called from the kgdboc post-debug-exception
handler.  That risks deadlock since schedule_work() is not NMI-safe and,
even on platforms where the NMI is not directly used for debugging, the
debug trap can have NMI-like behaviour depending on where breakpoints
are placed.

Fix this by using the irq work system, which is NMI-safe, to defer the
call to schedule_work() to a point when it is safe to call.

Reported-by: Liuye <liu.yeC@h3c.com>
Closes: https://lore.kernel.org/all/20240228025602.3087748-1-liu.yeC@h3c.com/
Cc: stable@vger.kernel.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20240424-kgdboc_fix_schedule_work-v2-1-50f5a490aec5@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/kgdboc.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -19,6 +19,7 @@
 #include <linux/console.h>
 #include <linux/vt_kern.h>
 #include <linux/input.h>
+#include <linux/irq_work.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
@@ -42,6 +43,25 @@ static int			kgdb_tty_line;
 
 static struct platform_device *kgdboc_pdev;
 
+/*
+ * When we leave the debug trap handler we need to reset the keyboard status
+ * (since the original keyboard state gets partially clobbered by kdb use of
+ * the keyboard).
+ *
+ * The path to deliver the reset is somewhat circuitous.
+ *
+ * To deliver the reset we register an input handler, reset the keyboard and
+ * then deregister the input handler. However, to get this done right, we do
+ * have to carefully manage the calling context because we can only register
+ * input handlers from task context.
+ *
+ * In particular we need to trigger the action from the debug trap handler with
+ * all its NMI and/or NMI-like oddities. To solve this the kgdboc trap exit code
+ * (the "post_exception" callback) uses irq_work_queue(), which is NMI-safe, to
+ * schedule a callback from a hardirq context. From there we have to defer the
+ * work again, this time using schedule_work(), to get a callback using the
+ * system workqueue, which runs in task context.
+ */
 #ifdef CONFIG_KDB_KEYBOARD
 static int kgdboc_reset_connect(struct input_handler *handler,
 				struct input_dev *dev,
@@ -93,10 +113,17 @@ static void kgdboc_restore_input_helper(
 
 static DECLARE_WORK(kgdboc_restore_input_work, kgdboc_restore_input_helper);
 
+static void kgdboc_queue_restore_input_helper(struct irq_work *unused)
+{
+	schedule_work(&kgdboc_restore_input_work);
+}
+
+static DEFINE_IRQ_WORK(kgdboc_restore_input_irq_work, kgdboc_queue_restore_input_helper);
+
 static void kgdboc_restore_input(void)
 {
 	if (likely(system_state == SYSTEM_RUNNING))
-		schedule_work(&kgdboc_restore_input_work);
+		irq_work_queue(&kgdboc_restore_input_irq_work);
 }
 
 static int kgdboc_register_kbd(char **cptr)
@@ -127,6 +154,7 @@ static void kgdboc_unregister_kbd(void)
 			i--;
 		}
 	}
+	irq_work_sync(&kgdboc_restore_input_irq_work);
 	flush_work(&kgdboc_restore_input_work);
 }
 #else /* ! CONFIG_KDB_KEYBOARD */


