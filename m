Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCEE429CCA;
	Thu, 16 Jul 2026 14:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211009; cv=none; b=dU7JUOpvD8PocZEkNQ7oqrz0TJkcbgnRqWUETlCt+K3wNFOeqq80U1rg421KSkrfPioUF6GFR0VDPOlYqzICxeKzKorXOZsMeHUmMTcjs92YNH2F868tc8OrciO8KulBBIQ/gTFHERqd9iyO/8RIC99a1zbDfyT0JsrMaNGnVeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211009; c=relaxed/simple;
	bh=x/R6k1KC+PdhauR6TBewqI3+GdofsG1yKWtScmP3yEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7y5MeRuwiLNH7VVQYuU8BeIcf/neJt8xzYn3aHV9rH4lXUMlznV4ztCTfepjIoDqReqeNxf+pFj8qcNW1icJTSNkW9viLx7qCK6rfoigs+FJ8dCilQigu52vlHmiQOqLhyZBH907w7JjdSqJfARXNv45iJB05uVRSuVpJu4eYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JP1BR/jV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP1BR/jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828101F00A3E;
	Thu, 16 Jul 2026 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211007;
	bh=QgQpZLztM3eiXDFCXUSD2Huo3n5y2T1zfaIhOqyebJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JP1BR/jVbv9bPrL0/NIGOFDmFgVCb7EF3iBPSuhxd6e5OxrCP8W4itB0CgICeqlch
	 EttZ57ogw862N/hEqIs/b5lVHOmm58brQaq7xBdV7xWMe8b7/5rQZ18h6hUevz4AYZ
	 TyVDeeZ8PG2ZqwzY98FWVDCINt6WTdJYPz7oOc/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jinmo Yang <jinmo44.yang@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 263/480] HID: wacom: fix slab-out-of-bounds write in wacom_wac_queue_insert
Date: Thu, 16 Jul 2026 15:30:10 +0200
Message-ID: <20260716133050.507457674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


