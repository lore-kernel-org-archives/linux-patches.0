Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174AE53A3BF;
	Wed, 23 Sep 2026 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174790; cv=none; b=Y+wP4KGBi+qoBaFkh1wNjBb8czcX2ifa84PcWC2rsQOxEHF5z5fHb2585SXXsxMhzB7pAcdsz+qe5Wjqj23P4H3Jx+AoUS6zEsN4XBOY0OvFCYbhoZm+4QaYE5ErGkhnlEca6cY8wkbiwgBtqhRSOdfTiDD/5wAp4uEfkTzoPsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174790; c=relaxed/simple;
	bh=Dgp/y7qyENxnl6RISqTPS4y2iuAIibPof7pcBWuXW5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WS0x/5OYGUAbNVCOO/ar1Nu4GIbSFfAZhmNTA8CERAgOqecW8qQ3n4EeKV/3XDPNhnNX7KLFI/B+HJJjfaHhM0QdC5M/pD/iT/6G0s+9qgON72FeHZ1VU3KXVcJ/fiYbGkfq3c4tdQoqDOQ6FteNYT5AuP5UZdyI6u8hsarMffY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3dIfUHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3dIfUHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8DA1F00898;
	Wed, 23 Sep 2026 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174789;
	bh=5y2cxLGaznh82KF96nico5ZqY3aYKxUKxZJEIY9qk5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3dIfUHIqGj/Mypk3pk+cx4XvtZpB40tVMTxjwjmeNon5AMOKXSPQHA6aneNXss5e
	 rCdL0rPQquEbLblPZOMBIEIwnykYwE+6GA/Wc7NQOC9QHQHV3bhBRhv1SVn7hkQqFN
	 T5BufgD0zWEs4EMY8C0dTdhLEdSYt0sTXgv9frCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 226/398] HID: logitech-hidpp: fix race condition when accessing stale stack pointer
Date: Wed, 23 Sep 2026 16:05:00 +0200
Message-ID: <20260923140649.279803454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -305,21 +305,22 @@ static int __do_hidpp_send_message_sync(
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
@@ -327,10 +328,14 @@ static int __do_hidpp_send_message_sync(
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
@@ -3838,8 +3843,7 @@ static int hidpp_input_configured(struct
 static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 		int size)
 {
-	struct hidpp_report *question = hidpp->send_receive_buf;
-	struct hidpp_report *answer = hidpp->send_receive_buf;
+	struct hidpp_report *question, *answer;
 	struct hidpp_report *report = (struct hidpp_report *)data;
 	int ret;
 	int last_online;
@@ -3849,6 +3853,12 @@ static int hidpp_raw_hidpp_event(struct
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


