Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A92551120F;
	Wed, 30 Sep 2026 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783660; cv=none; b=QhtJVnYiiQ/AliO0VmReCeBVSW1jfW2j7etGA3/5WxTOC9GkbtR5agSqk/3VYgpfoolTueKiNjXm4LwaeDblYGBQ0GZ0X/F9EuNFTl0MYYy1kzuIDYM22X0oblfSZ7Qv9NRPbxw+hwAVA4W9HRX4kQ3Sc9kmPH90gQ2J/0b8kBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783660; c=relaxed/simple;
	bh=P0t5NnT1lCBOtS/+qskqQ2NsKS7GQE+GMEoCkxKb6uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RaYnEFAENC9b37WW0uSUH1gXXqz4JNUTVLqSG5zp14UoR12UzLCCSPJh0p8H0tjzb/E0+KdzEfJaDooFZl9JJlVBs2Y3OfvH5EzoEK/1WPoBOsvwc77G9aVlN74ZauJbfxyt4ihkZi0vZp+j0G1joN5aAUatnSNejfLe74/R1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exMM+RD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exMM+RD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA331F000FF;
	Wed, 30 Sep 2026 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783656;
	bh=nQz0lxx1nBeHR4KKje2iEe9UOOomOBj9foE7EVHV6Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exMM+RD3XpJEaQ8MZf7+4u9fWZMrEwlwtOeXvO8+xyCx1z5RNfd1sZsW+k/WWjWAa
	 k9NWYzcEj+Q6/57+D4wb7nCc28j5yxqWkriDMzXSjnBz/i1f9+DNRwxLcZpKZA4EM5
	 3kqoialv9aaDS0x/Mq+TkJO5cnPq/4MtIYWEEYWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 476/595] HID: logitech-hidpp: fix race condition when accessing stale stack pointer
Date: Wed, 30 Sep 2026 17:26:09 +0200
Message-ID: <20260930152357.921378935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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

Fixes: 2f31c5252910 ("HID: Introduce hidpp, a module to handle Logitech hid++ devices")
Cc: stable@vger.kernel.org
Signed-off-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Clear hidpp->send_receive_buf at exit label in hidpp_send_message_sync()
      as __do_hidpp_send_message_sync() was split out later in 60165ab774cb]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 8b05aad21970c..2333a24c9df12 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -306,6 +306,7 @@ static int hidpp_send_message_sync(struct hidpp_device *hidpp,
 	}
 
 exit:
+	hidpp->send_receive_buf = NULL;
 	mutex_unlock(&hidpp->send_mutex);
 	return ret;
 
@@ -3308,8 +3309,7 @@ static int hidpp_input_configured(struct hid_device *hdev,
 static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 		int size)
 {
-	struct hidpp_report *question = hidpp->send_receive_buf;
-	struct hidpp_report *answer = hidpp->send_receive_buf;
+	struct hidpp_report *question, *answer;
 	struct hidpp_report *report = (struct hidpp_report *)data;
 	int ret;
 
@@ -3318,6 +3318,12 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
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
-- 
2.53.0



