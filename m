Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9063CAA55;
	Wed, 30 Sep 2026 19:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796254; cv=none; b=AenbcUV2JuiEJJiV7d7ZqbUtL1HQ95+fB5qs49+cKkZpqKS0ScBpKMf5YhaNALFKWQQVJoi31KHvrG+tKZ2LVsRPLqEIcuHjK4QYYYNP9sae2o4PXruVMCxAxHGA+1BmNY2qb3eUMk0EEHqAzM6MpOVXyzAZlBJQP1OsjkglOl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796254; c=relaxed/simple;
	bh=zxQiWbNq98O1qK64wteL+OpdCzwbM24mHx1zK1sKEl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOuMxVuqxlJNwPLi8M+5+1GghNEQh51U5ommQTneFGzvkj/Te+Ge5Bz91GO4RXJ6V51qjNh89CJmGS99iwxWvMmBCmcQDyVr0HL+I2uJ0ogbjczH+wqvkoQJD4d7XKGkamsh+NuokAJIc261lwuYWmXwpwJk7lsbt8zE5EcPKh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liW9i1S/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liW9i1S/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DF31F000FF;
	Wed, 30 Sep 2026 19:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796253;
	bh=so2EP+JR7PjGAmawDXYC+ImRFd12M312WKUvBgOPyB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=liW9i1S/iBpkNN0tNpGbR3m/5ZPnw+eigQw2xADf7oQHTl59uPFlp2ZgzhaOK8QnT
	 x6tcV6B/CkK23Kp5V2Pqr6lkjL9c/0DGOD+gCnkw2T0mU/wqNK/dlv8EzxY0lR+ZMj
	 MwWCOpEOPKbK04RQ6KNRxo/LjF87Nnp9MfvWP5B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 0846/1193] HID: logitech-hidpp: fix race condition when accessing stale stack pointer
Date: Wed, 30 Sep 2026 17:25:30 +0200
Message-ID: <20260930152453.033626712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Sevens <bsevens@google.com>

commit e2aaf2d3ad92ac4a8afa6b69ad4c38e7747d3d6e upstream.

The driver uses hidpp->send_receive_buf to point to a stack-allocated
buffer in the synchronous command path (__do_hidpp_send_message_sync).
However, this pointer is not cleared when the function returns.

If an event is processed (e.g. by a different thread) while the
send_mutex is held by a new command, but before that command has
updated send_receive_buf, the handler (hidpp_raw_hidpp_event) will
observe that the mutex is locked and dereference the stale pointer.

This results in an out-of-bounds access on a different thread's kernel
stack (or a NULL pointer dereference on the very first command).

Fix this by:
1. Clearing hidpp->send_receive_buf to NULL before releasing the mutex
   in the synchronous command path.
2. Moving the assignment of the local 'question' and 'answer' pointers
   inside the mutex_is_locked() block in the handler, and adding
   a NULL check before dereferencing.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-hidpp.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -304,21 +304,22 @@ static int __do_hidpp_send_message_sync(
 	if (ret) {
 		dbg_hid("__hidpp_send_report returned err: %d\n", ret);
 		memset(response, 0, sizeof(struct hidpp_report));
-		return ret;
+		goto out;
 	}
 
 	if (!wait_event_timeout(hidpp->wait, hidpp->answer_available,
 				5*HZ)) {
 		dbg_hid("%s:timeout waiting for response\n", __func__);
 		memset(response, 0, sizeof(struct hidpp_report));
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto out;
 	}
 
 	if (response->report_id == REPORT_ID_HIDPP_SHORT &&
 	    response->rap.sub_id == HIDPP_ERROR) {
 		ret = response->rap.params[1];
 		dbg_hid("%s:got hidpp error %02X\n", __func__, ret);
-		return ret;
+		goto out;
 	}
 
 	if ((response->report_id == REPORT_ID_HIDPP_LONG ||
@@ -326,10 +327,14 @@ static int __do_hidpp_send_message_sync(
 	    response->fap.feature_index == HIDPP20_ERROR) {
 		ret = response->fap.params[1];
 		dbg_hid("%s:got hidpp 2.0 error %02X\n", __func__, ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+	ret = 0;
+
+out:
+	hidpp->send_receive_buf = NULL;
+	return ret;
 }
 
 /*
@@ -3867,8 +3872,7 @@ static int hidpp_input_configured(struct
 static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 		int size)
 {
-	struct hidpp_report *question = hidpp->send_receive_buf;
-	struct hidpp_report *answer = hidpp->send_receive_buf;
+	struct hidpp_report *question, *answer;
 	struct hidpp_report *report = (struct hidpp_report *)data;
 	int ret;
 
@@ -3877,6 +3881,12 @@ static int hidpp_raw_hidpp_event(struct
 	 * previously sent command.
 	 */
 	if (unlikely(mutex_is_locked(&hidpp->send_mutex))) {
+		question = hidpp->send_receive_buf;
+		answer = hidpp->send_receive_buf;
+
+		if (!question)
+			return 0;
+
 		/*
 		 * Check for a correct hidpp20 answer or the corresponding
 		 * error


