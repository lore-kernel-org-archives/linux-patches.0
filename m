Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6B51FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E34C4339B;
	Fri,  3 Feb 2023 10:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420108;
	bh=7TB58F2YJRfwdowX6BjU2VDFV/ZoHgwBV6QbWTkAs9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jggVobb6+2ZV9FriOqZErpAZ8JauWqGnsyOlXMB0fxrBewuLHFAYuEaa+7p5voN2y
	 p+/vgU6ePp9jzIxSJVVEzWxmJGW8wonz50VMcBYV6kuW9g2PyDuudcc1B3BIYIMPOO
	 C/rL/dzbE1OPYR3TTbVwD/3Jh0dnssefhbKp85yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Steev Klimaszewski <steev@kali.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 5.4 082/134] EDAC/device: Respect any driver-supplied workqueue polling value
Date: Fri,  3 Feb 2023 11:13:07 +0100
Message-Id: <20230203101027.547238145@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit cec669ff716cc83505c77b242aecf6f7baad869d upstream.

The EDAC drivers may optionally pass the poll_msec value. Use that value
if available, else fall back to 1000ms.

  [ bp: Touchups. ]

Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Steev Klimaszewski <steev@kali.org> # Thinkpad X13s
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8540p-ride
Cc: <stable@vger.kernel.org> # 4.9
Link: https://lore.kernel.org/r/COZYL8MWN97H.MROQ391BGA09@otso
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/edac_device.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -34,6 +34,9 @@
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
 
+/* Default workqueue processing interval on this instance, in msecs */
+#define DEFAULT_POLL_INTERVAL 1000
+
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
 {
@@ -366,7 +369,7 @@ static void edac_device_workq_function(s
 	 * whole one second to save timers firing all over the period
 	 * between integral seconds
 	 */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_queue_work(&edac_dev->work, edac_dev->delay);
@@ -396,7 +399,7 @@ static void edac_device_workq_setup(stru
 	 * timers firing on sub-second basis, while they are happy
 	 * to fire together on the 1 second exactly
 	 */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_queue_work(&edac_dev->work, edac_dev->delay);
@@ -430,7 +433,7 @@ void edac_device_reset_delay_period(stru
 	edac_dev->delay	    = msecs_to_jiffies(msec);
 
 	/* See comment in edac_device_workq_setup() above */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_mod_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_mod_work(&edac_dev->work, edac_dev->delay);
@@ -472,11 +475,7 @@ int edac_device_add_device(struct edac_d
 		/* This instance is NOW RUNNING */
 		edac_dev->op_state = OP_RUNNING_POLL;
 
-		/*
-		 * enable workq processing on this instance,
-		 * default = 1000 msec
-		 */
-		edac_device_workq_setup(edac_dev, 1000);
+		edac_device_workq_setup(edac_dev, edac_dev->poll_msec ?: DEFAULT_POLL_INTERVAL);
 	} else {
 		edac_dev->op_state = OP_RUNNING_INTERRUPT;
 	}


