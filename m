Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18A825B0AA;
	Thu, 20 Aug 2026 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239441; cv=none; b=TLdBxTNicJfJTr15Th0gehPowPYb6qzz9umvx1ChRQmwhiDToV12psle62LOeh7y0aV12NukXLeecqDWC+EnI6ZaVixwHJfB5CW7WegBb7MV8SqtLnQUDkbZGrqBKruHn4qM4+6ACVUu/CCyg4+9ttgszmau5W3JplQOXWOU/Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239441; c=relaxed/simple;
	bh=2O4rfojucrI+kFya63Rv6OjinoNKvGchBBTtlbzeVWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuIJwDMedLjOTIcx237xT6qgkg6bLaXnRU/GuHOcyB70Nu080VNnwzFpuS9EktHgcXoqKCBXkxmDnRd20KnUqtHIU0RrSQYg7SpftwD8VcrTx6frEJqdb2f8mFbVV9cVOfNgbtokBk8jxBDn06oWOO7rNWEucV1MtYFH9UrfwZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QEdPeei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QEdPeei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C8D1F000E9;
	Thu, 20 Aug 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239439;
	bh=rlKUQA+8tyxKQOzxXvZHLBq++VDMu3vqgtWi6uwsepA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QEdPeei2leglnmDnzSePT6D+sEcOFwolkHDUD407jR330SJfcvfr52/f1GVNBSlb
	 yljki2sY6DZA6/C4CBV4mzVgZCRcEYiGaARXLG0h3hCUHAx6qhHxAzwrWMg8eQURpB
	 OsvG6v3Tm44+iCf/6XgGAB5JmEN2fMb08ywsUYpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 049/220] Input: hynitron_cstxxx - validate touch count and finger IDs
Date: Thu, 20 Aug 2026 16:53:59 +0200
Message-ID: <20260820145224.964447921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

commit 27f380ef0e1d3de3cde114e02d33f9320ce3a5a6 upstream.

The driver allocates max_touch_num input slots, which are indexed from
zero through max_touch_num - 1. The current check allows a finger ID
equal to max_touch_num to reach cst3xx_report_contact(). While the input
core ignores out-of-range slot indices, reporting touch data without a
valid slot change corrupts the touch state of the previously active slot.

The touch count is read from the controller's report and is used to
index the fixed-size report buffer without first checking its range.
Reject counts larger than the supported number of touch slots before
checking the trailing byte or parsing touch data.

Reject finger IDs equal to or greater than max_touch_num, and return
immediately when an invalid finger ID is encountered so that corrupt
touch frames are discarded instead of reporting partial contact state.

The V821 Avaota F1 board configures the vendor driver with one touch
slot, so finger ID 1 is already invalid on that device.

Fixes: 66603243f528 ("Input: add driver for Hynitron cstxxx touchscreens")
Signed-off-by: Jianing Li <m13940358460@163.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260804031339.2379-1-m13940358460@163.com
Assisted-by: Antigravity:gemini-3.6-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/hynitron_cstxxx.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/input/touchscreen/hynitron_cstxxx.c
+++ b/drivers/input/touchscreen/hynitron_cstxxx.c
@@ -313,6 +313,12 @@ static void cst3xx_touch_report(struct i
 		return;
 
 	touch_cnt = buf[5] & CST3XX_TOUCH_COUNT_MASK;
+	if (touch_cnt > ts_data->chip->max_touch_num) {
+		dev_err(&client->dev, "cst3xx invalid touch count (%d vs %d max)\n",
+			touch_cnt, ts_data->chip->max_touch_num);
+		return;
+	}
+
 	/*
 	 * Check the check bit of the last touch slot. The check bit is
 	 * always present after touch point 1 for valid data, and then
@@ -335,9 +341,10 @@ static void cst3xx_touch_report(struct i
 		finger_id = (buf[idx] >> 4) & 0x0f;
 
 		/* Sanity check we don't have more fingers than we expect */
-		if (ts_data->chip->max_touch_num < finger_id) {
-			dev_err(&client->dev, "cst3xx touch read failure\n");
-			break;
+		if (finger_id >= ts_data->chip->max_touch_num) {
+			dev_err(&client->dev,
+				"cst3xx invalid finger id %d\n", finger_id);
+			return;
 		}
 
 		/* sw value of 0 means no touch, 0x03 means touch */


