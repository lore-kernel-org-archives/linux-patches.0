Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688FF11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE9CC433C8;
	Mon, 11 Sep 2023 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443946;
	bh=IknDzujTlU5asqd1ghx3DAdUuFZfoB5KnDSGmz5EXQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxmkaJ0ZVYhnW3y9l50DBixFMEheI+4zbD6LueRqkJQuG5uWdWqc3kE/0AbSU8/KE
	 GlZ01RUf6bGzXGSxbt4FBr7ytNwdQVKokxXlmGmaqCu3y5PIgQnz1Zf3uXAaDjfUL2
	 HM/g8OyIc3aepOxfDhZ7caOD/mRPcNsqwgPwgnAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zhang <zheng.zhang@email.ucr.edu>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 549/737] media: cec: core: add adap_nb_transmit_canceled() callback
Date: Mon, 11 Sep 2023 15:46:48 +0200
Message-ID: <20230911134705.894585957@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit da53c36ddd3f118a525a04faa8c47ca471e6c467 ]

A potential deadlock was found by Zheng Zhang with a local syzkaller
instance.

The problem is that when a non-blocking CEC transmit is canceled by calling
cec_data_cancel, that in turn can call the high-level received() driver
callback, which can call cec_transmit_msg() to transmit a new message.

The cec_data_cancel() function is called with the adap->lock mutex held,
and cec_transmit_msg() tries to take that same lock.

The root cause is that the received() callback can either be used to pass
on a received message (and then adap->lock is not held), or to report a
canceled transmit (and then adap->lock is held).

This is confusing, so create a new low-level adap_nb_transmit_canceled
callback that reports back that a non-blocking transmit was canceled.

And the received() callback is only called when a message is received,
as was the case before commit f9d0ecbf56f4 ("media: cec: correctly pass
on reply results") complicated matters.

Reported-by: Zheng Zhang <zheng.zhang@email.ucr.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: f9d0ecbf56f4 ("media: cec: correctly pass on reply results")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 4 ++--
 include/media/cec.h               | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 241b1621b197c..a9b73fb33888d 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -385,8 +385,8 @@ static void cec_data_cancel(struct cec_data *data, u8 tx_status, u8 rx_status)
 	cec_queue_msg_monitor(adap, &data->msg, 1);
 
 	if (!data->blocking && data->msg.sequence)
-		/* Allow drivers to process the message first */
-		call_op(adap, received, &data->msg);
+		/* Allow drivers to react to a canceled transmit */
+		call_void_op(adap, adap_nb_transmit_canceled, &data->msg);
 
 	cec_data_completed(data);
 }
diff --git a/include/media/cec.h b/include/media/cec.h
index abee41ae02d0e..6556cc161dc0a 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -121,14 +121,16 @@ struct cec_adap_ops {
 	void (*adap_configured)(struct cec_adapter *adap, bool configured);
 	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 			     u32 signal_free_time, struct cec_msg *msg);
+	void (*adap_nb_transmit_canceled)(struct cec_adapter *adap,
+					  const struct cec_msg *msg);
 	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
 	void (*adap_free)(struct cec_adapter *adap);
 
-	/* Error injection callbacks */
+	/* Error injection callbacks, called without adap->lock held */
 	int (*error_inj_show)(struct cec_adapter *adap, struct seq_file *sf);
 	bool (*error_inj_parse_line)(struct cec_adapter *adap, char *line);
 
-	/* High-level CEC message callback */
+	/* High-level CEC message callback, called without adap->lock held */
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
 };
 
-- 
2.40.1



