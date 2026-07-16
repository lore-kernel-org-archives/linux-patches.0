Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DDD41DEC3;
	Thu, 16 Jul 2026 13:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209663; cv=none; b=gi00/8gMeSrqx2Xvm4mv+ThbcXMcAMayJRSAn8dHh8Lh0SBOsDwynx0YhRnjps10N/GjwGBZuJf7C3zcgnQXUoo6rSufQzwYXSCBonKgeQ+zER3g0E036ESnGLn1iRC2FXahJyJiJ6UsL2C9ewjfjnHkUc51TqFu5EEV6xVKwlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209663; c=relaxed/simple;
	bh=vph4r6MbRT3RZQ5cERO94AozrZuXhKvqOr2bX/D6dkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj3lj04ewff41ScYMeiloMYiTUUz/iwiPEeDqrHRx8TVolvWECWjpZBa9Qurk2STML0tD4iwLvMOBfcJLszckfCEqMRJ0aFWUN0U6+Ee5ZaYiTjxjduZjxK2MKrbTdCvWQ9aPjCa5m1FH/P++DaxWOAQCRdwEtpFs5w2JdEorrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvLuV4nQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvLuV4nQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD3A1F00A3A;
	Thu, 16 Jul 2026 13:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209657;
	bh=hUFOfeEID5jmn4RpiJXbxF/lQlA/tfFs7M+8wi0t/jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvLuV4nQiQDgowJnTYRWCKlugHb0yRFdSQeoJ52djAxRdtxAweqaKF3kxB5iLzSHS
	 jqwcTIDOjvl8eJZUNUz4PFkea6DXahZHQs/VdE250KQ+LIDlGbgNbwmQq9UVJq5ejU
	 UWZxP9P+UbdV46DsWD9K4dCxg9cD4GhYWyw0xjPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jinmo Yang <jinmo44.yang@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.1 270/518] HID: wacom: fix slab-out-of-bounds write in wacom_wac_queue_insert
Date: Thu, 16 Jul 2026 15:28:58 +0200
Message-ID: <20260716133053.723077812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinmo Yang <jinmo44.yang@gmail.com>

commit 6b3014ec0e9a390ca563030b2d7689921f0daef5 upstream.

wacom_wac_queue_insert() calls kfifo_skip() in a loop when the kfifo
doesn't have enough space for the incoming report. If the kfifo is
empty, kfifo_skip() reads stale data left in the kmalloc'd buffer
via __kfifo_peek_n() and interprets it as a record length, advancing
fifo->out by that garbage value. This corrupts the internal kfifo
state, causing kfifo_unused() to return a value much larger than the
actual buffer size, which bypasses __kfifo_in_r()'s guard:

  if (len + recsize > kfifo_unused(fifo))
      return 0;

kfifo_copy_in() then performs an out-of-bounds memcpy, writing up to
3842 bytes past the 256-byte buffer.

Add a !kfifo_is_empty() condition to the while loop so kfifo_skip()
is never called on an empty fifo, and check the return value of
kfifo_in() to reject reports that are too large for the fifo.

Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Fixes: 5e013ad20689 ("HID: wacom: Remove static WACOM_PKGLEN_MAX limit")
Cc: stable@vger.kernel.org
Signed-off-by: Jinmo Yang <jinmo44.yang@gmail.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -54,7 +54,7 @@ static void wacom_wac_queue_insert(struc
 {
 	bool warned = false;
 
-	while (kfifo_avail(fifo) < size) {
+	while (kfifo_avail(fifo) < size && !kfifo_is_empty(fifo)) {
 		if (!warned)
 			hid_warn(hdev, "%s: kfifo has filled, starting to drop events\n", __func__);
 		warned = true;
@@ -62,7 +62,9 @@ static void wacom_wac_queue_insert(struc
 		kfifo_skip(fifo);
 	}
 
-	kfifo_in(fifo, raw_data, size);
+	if (!kfifo_in(fifo, raw_data, size))
+		hid_warn_ratelimited(hdev, "%s: report is too large (%d)\n",
+				     __func__, size);
 }
 
 static void wacom_wac_queue_flush(struct hid_device *hdev,


