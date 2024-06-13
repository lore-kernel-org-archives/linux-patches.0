Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1F143861;
	Thu, 13 Jun 2024 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281545; cv=none; b=Z+texx1eLw7efhTg3ltSVV55knT5YfzSDyeyWbd+ZHKvZ5Oz/0kCoLRECAoJPgx4xNn0csIQdFvJNYh532clfjd2a0k8dwgyoKvryNY6bXJt+d1vxnDI4Y/QG4TdcmkPwPDn5dAGsy3nj1tHOY4Wx1is6U6sqOX75HU+Ovm7cYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281545; c=relaxed/simple;
	bh=x876JyfMDwrcxP87hIjUVbHZItOEGXn7JsX2PIcZVuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2Oa/ds/FsCP8+laGajGQh+8a+SaMy0SXDp8HJmOkBdSXbYzSKxP7V6qeEAwBrKMGnRVeFnRoBSdmlB3MP+Xos0J1YCWbE9TzDZv0i1ooUUwFWZoXJ7SoVbEIpAcyjQxeR6a4goFfvUjiwOuIz7MKnimcKXJp3u9mVFsgQxk1zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF36S+7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF36S+7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FEEC2BBFC;
	Thu, 13 Jun 2024 12:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281545;
	bh=x876JyfMDwrcxP87hIjUVbHZItOEGXn7JsX2PIcZVuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF36S+7OrMOmm2s6ccKYHRvUnrVcDhyRZzP3m6dx90vIU2MkmrGM77vKff2h5anyu
	 9bofWoP5ZxN2WXTT8+Horm19d/Sh8UGIf/KVTgtXhmhNLUvXLMdGBb/FwmnXX4jOBv
	 +mSfFxXBbF01B86clQvYBGEfba7okotOdIz5cGeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zhang <zheng.zhang@email.ucr.edu>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 264/317] media: cec: core: add adap_nb_transmit_canceled() callback
Date: Thu, 13 Jun 2024 13:34:42 +0200
Message-ID: <20240613113257.758975088@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit da53c36ddd3f118a525a04faa8c47ca471e6c467 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-adap.c |    4 ++--
 include/media/cec.h               |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -397,8 +397,8 @@ static void cec_data_cancel(struct cec_d
 	cec_queue_msg_monitor(adap, &data->msg, 1);
 
 	if (!data->blocking && data->msg.sequence)
-		/* Allow drivers to process the message first */
-		call_op(adap, received, &data->msg);
+		/* Allow drivers to react to a canceled transmit */
+		call_void_op(adap, adap_nb_transmit_canceled, &data->msg);
 
 	cec_data_completed(data);
 }
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -120,14 +120,16 @@ struct cec_adap_ops {
 	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
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
 


