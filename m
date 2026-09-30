Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFF6502D5A;
	Wed, 30 Sep 2026 18:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792246; cv=none; b=WWixRENHarVlT3daUTZoDVy/RfUsE3i/KeRJy+R3/orbQIHaVTWXho/NnT9MwgcOdORH/efE1amuk6Mqa+2iqfXxFi2BELYyY6lT6YzMyL066tpJKZY8N3cWxGVige9eAwIxU263TGihCsmGcCYkebCMWVJwW1noR5y36t1lMDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792246; c=relaxed/simple;
	bh=Xv1bnAwACu43SHV9ftGJHgiNnMa2WJ1guU9O+AFjtVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8LRTv9eo9QH8ILNSD/M5+bY62iWVwVN5wPl+Roj9sslBqsfH7YT9D/xLTrtueaT45UCt0EpoUIQozCQhbgbaU75tPSKRyW1qZabhSxR75Ldj+iJvQFfiz22hzBhOF7wqidb7DExgwVYfETKOTOP3OmfFK5Lu6N0JYbJ9uospOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0c4dw2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0c4dw2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FD81F000FF;
	Wed, 30 Sep 2026 18:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792245;
	bh=v8+b1nfREkRTkqIJFahXisEj0tpVLp5Zf/qw+R6RB6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0c4dw2nWUH9aFIapKfPYY4SNK27nx6O70ovQEbdSsL4fX/QIDOu7PngtQWKNZH8T
	 9AoOZvw4G2Nqv/zaCLUKl3FK6zwyFYYOxLaAD5ubHPGnFHlsTMbY3WJugkjImYGXkP
	 iHXj7hJd7nCozdsqZMuQ+ti/9/Puh4xDoZGhhJGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 586/752] HID: logitech-hidpp: fix race condition when accessing stale stack pointer
Date: Wed, 30 Sep 2026 17:27:36 +0200
Message-ID: <20260930152410.971987991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 495d486f54034..163245bbcbed1 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -311,6 +311,7 @@ static int hidpp_send_message_sync(struct hidpp_device *hidpp,
 	}
 
 exit:
+	hidpp->send_receive_buf = NULL;
 	mutex_unlock(&hidpp->send_mutex);
 	return ret;
 
@@ -3572,8 +3573,7 @@ static int hidpp_input_configured(struct hid_device *hdev,
 static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 		int size)
 {
-	struct hidpp_report *question = hidpp->send_receive_buf;
-	struct hidpp_report *answer = hidpp->send_receive_buf;
+	struct hidpp_report *question, *answer;
 	struct hidpp_report *report = (struct hidpp_report *)data;
 	int ret;
 
@@ -3582,6 +3582,12 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
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



