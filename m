Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2101170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90777C433C8;
	Mon, 11 Sep 2023 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441830;
	bh=Yxcyd3ItiVqUcgnYjKbLNffm35bshZuSw5zClTa+OX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/zxSvO4XIYhKsKn+e6V5qeHw7lxtWouca3zrZe9mUvrREhBiw0xxMjR9Vb9tyjNo
	 r6KO55ZxXqWBgC8i53O+mqBDchTojq8fh7SWuFwGOZ950Tt3LYvcm10MwsB+cLMQIA
	 uNXsVudn/4k9q2yARtB6iAUIbobMVoDi/i5b4sN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 525/739] media: cec: core: add adap_unconfigured() callback
Date: Mon, 11 Sep 2023 15:45:24 +0200
Message-ID: <20230911134705.775077059@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 948a77aaecf202f722cf2264025f9987e5bd5c26 ]

The adap_configured() callback was called with the adap->lock mutex
held if the 'configured' argument was false, and without the adap->lock
mutex held if that argument was true.

That was very confusing, and so split this up in a adap_unconfigured()
callback and a high-level configured() callback.

This also makes it easier to understand when the mutex is held: all
low-level adap_* callbacks are called with the mutex held. All other
callbacks are called without that mutex held.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: f1b57164305d ("media: cec: add optional adap_configured callback")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 4 ++--
 include/media/cec.h               | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index a9b73fb33888d..09ca83c233299 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1348,7 +1348,7 @@ static void cec_adap_unconfigure(struct cec_adapter *adap)
 	cec_flush(adap);
 	wake_up_interruptible(&adap->kthread_waitq);
 	cec_post_state_event(adap);
-	call_void_op(adap, adap_configured, false);
+	call_void_op(adap, adap_unconfigured);
 }
 
 /*
@@ -1539,7 +1539,7 @@ static int cec_config_thread_func(void *arg)
 	adap->kthread_config = NULL;
 	complete(&adap->config_completion);
 	mutex_unlock(&adap->lock);
-	call_void_op(adap, adap_configured, true);
+	call_void_op(adap, configured);
 	return 0;
 
 unconfigure:
diff --git a/include/media/cec.h b/include/media/cec.h
index 6556cc161dc0a..9c007f83569aa 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -113,12 +113,12 @@ struct cec_fh {
 #define CEC_FREE_TIME_TO_USEC(ft)		((ft) * 2400)
 
 struct cec_adap_ops {
-	/* Low-level callbacks */
+	/* Low-level callbacks, called with adap->lock held */
 	int (*adap_enable)(struct cec_adapter *adap, bool enable);
 	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
 	int (*adap_monitor_pin_enable)(struct cec_adapter *adap, bool enable);
 	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
-	void (*adap_configured)(struct cec_adapter *adap, bool configured);
+	void (*adap_unconfigured)(struct cec_adapter *adap);
 	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 			     u32 signal_free_time, struct cec_msg *msg);
 	void (*adap_nb_transmit_canceled)(struct cec_adapter *adap,
@@ -131,6 +131,7 @@ struct cec_adap_ops {
 	bool (*error_inj_parse_line)(struct cec_adapter *adap, char *line);
 
 	/* High-level CEC message callback, called without adap->lock held */
+	void (*configured)(struct cec_adapter *adap);
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
 };
 
-- 
2.40.1



