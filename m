Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EC75683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70523C433D2;
	Mon,  3 Apr 2023 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531381;
	bh=Q6P0+uha1BXkSpL/OL15E2zF9T5TBDg8AlwFy22zQ3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWEQwM4Mt4HvFNLPFZCLzdwEyryS2sY1aif+Od66YnJhoMXRdTvjLr14RuflMxuEG
	 t7Kf8p4FNGyABWP2LANlcKKS65NNG6k5JCWZI6OBMmhzy1FSAqTT7OZdmJ2q59G07M
	 n5I/Ovh838yy1tdCiiIve69IVorrJvmX5f9q3pq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 4.19 42/84] usb: chipidea: core: fix possible concurrent when switch role
Date: Mon,  3 Apr 2023 16:08:43 +0200
Message-Id: <20230403140354.829570143@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Yang <xu.yang_2@nxp.com>

commit 451b15ed138ec15bffbebb58a00ebdd884c3e659 upstream.

The user may call role_store() when driver is handling
ci_handle_id_switch() which is triggerred by otg event or power lost
event. Unfortunately, the controller may go into chaos in this case.
Fix this by protecting it with mutex lock.

Fixes: a932a8041ff9 ("usb: chipidea: core: add sysfs group")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20230317061516.2451728-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci.h   |    2 ++
 drivers/usb/chipidea/core.c |    8 +++++++-
 drivers/usb/chipidea/otg.c  |    5 ++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -202,6 +202,7 @@ struct hw_bank {
  * @in_lpm: if the core in low power mode
  * @wakeup_int: if wakeup interrupt occur
  * @rev: The revision number for controller
+ * @mutex: protect code from concorrent running when doing role switch
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -254,6 +255,7 @@ struct ci_hdrc {
 	bool				in_lpm;
 	bool				wakeup_int;
 	enum ci_revision		rev;
+	struct mutex                    mutex;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -875,8 +875,12 @@ static ssize_t role_store(struct device
 	if (role == CI_ROLE_END)
 		return -EINVAL;
 
-	if (role == ci->role)
+	mutex_lock(&ci->mutex);
+
+	if (role == ci->role) {
+		mutex_unlock(&ci->mutex);
 		return n;
+	}
 
 	pm_runtime_get_sync(dev);
 	disable_irq(ci->irq);
@@ -886,6 +890,7 @@ static ssize_t role_store(struct device
 		ci_handle_vbus_change(ci);
 	enable_irq(ci->irq);
 	pm_runtime_put_sync(dev);
+	mutex_unlock(&ci->mutex);
 
 	return (ret == 0) ? n : ret;
 }
@@ -924,6 +929,7 @@ static int ci_hdrc_probe(struct platform
 		return -ENOMEM;
 
 	spin_lock_init(&ci->lock);
+	mutex_init(&ci->mutex);
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
 	ci->imx28_write_fix = !!(ci->platdata->flags &
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -164,8 +164,10 @@ static int hw_wait_vbus_lower_bsv(struct
 
 static void ci_handle_id_switch(struct ci_hdrc *ci)
 {
-	enum ci_role role = ci_otg_role(ci);
+	enum ci_role role;
 
+	mutex_lock(&ci->mutex);
+	role = ci_otg_role(ci);
 	if (role != ci->role) {
 		dev_dbg(ci->dev, "switching from %s to %s\n",
 			ci_role(ci)->name, ci->roles[role]->name);
@@ -188,6 +190,7 @@ static void ci_handle_id_switch(struct c
 		if (role == CI_ROLE_GADGET)
 			ci_handle_vbus_change(ci);
 	}
+	mutex_unlock(&ci->mutex);
 }
 /**
  * ci_otg_work - perform otg (vbus/id) event handle


