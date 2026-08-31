Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A353F4AFE1C;
	Mon, 31 Aug 2026 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184195; cv=none; b=KzPGAlLbz/M3QsiLzxPV4+uZ8JVAgiJyfi2qvv/N6SEcPWb2+0/yA2F6FuwW21mh4hYelRadLZzxu2UsDI3And360jkA0V9f+/qFXqwHTjkLLUYpRT1j8Rr+FvZtfbmCTIBwKBTmKFC449ZTGBgxN0XpyDXnhgcyGwHnXVEn8BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184195; c=relaxed/simple;
	bh=JVnYyBp7jh2M0ZIfNDPm8ckP3StYWcHyhAambBfXjag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjB5/VbUPRwd0h6FzwNdl3QNwwnML1L7yFBKJ5kGsDTnA8zouqvtEzW149eF7Zn4UVzM3jOziIDFRSKjGF7SsMvjXEzoGJOv+/ilWa/GD4pQi56p+on+LFU6+xEkiu15Ijr3b7satVz/Vz7HCxor3oQUh44EloZLv/DGC8zxmic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRsHPtn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRsHPtn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12141F000E9;
	Mon, 31 Aug 2026 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184193;
	bh=0lFuMdWR5XHe8gXlgbZXzZI4BupV7B/BKeTLXe/kZdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRsHPtn5L+Ym0JOyozs9GmVwLgdZkOaacvvTcUC6vTYOoIRCznD2Rzq+0iquUrI29
	 2lS1KqERSMzEx326qt5zGSjDUQev67Y4aPFXuaMy4k4k2imfoptLx4dCO0q6Z5DjGv
	 aoyoTeY8aWUDIxNTCUIkZap+jq7KCG1FgtaOyNQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 07/99] HID: uhid: convert to hid_safe_input_report()
Date: Mon, 31 Aug 2026 15:33:36 +0200
Message-ID: <20260831133400.150475343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 63a694c51bf120a37550890b8e7736b4888985e9 upstream.

Commit 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing
bogus memset()"), added a check in hid_report_raw_event() to reject
reports if the received data size is smaller than expected. This was
intended to prevent OOB errors by no longer allowing zeroing-out of
shorter reports due to the lack of buffer size information.

However, this leads to regressions in hid_report_raw_event(), where
shorter than expected reports are rejected, even though their buffers
are sufficiently large to be zero-padded.

To solve this issue, Benjamin introduced a safer alternative in commit
206342541fc8 ("HID: core: introduce hid_safe_input_report()"), which
forwards the buffer size and allows hid_report_raw_event() to safely
zero-pad the data.

Convert uhid to use hid_safe_input_report() and pass UHID_DATA_MAX as
the buffer size. This prevents the reported regressions [1], allowing
hid core to zero-pad the shorter reports safely as expected.

Cc: stable@vger.kernel.org
Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/ [1]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/uhid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 21a70420151e4..d16667207b9f9 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -595,8 +595,8 @@ static int uhid_dev_input(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data,
-			 min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
@@ -606,8 +606,8 @@ static int uhid_dev_input2(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data,
-			 min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
-- 
2.53.0



