Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2267137A498;
	Thu, 20 Aug 2026 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238803; cv=none; b=R1EB6DC3Xu5z4/355E9Q/lqQnd3VdKCUSSm+Pyjq+KK7pT5glUrC3zS7yUiuGe6PV2WROZruimq22LsUkApB/x5ef00L9dcgzHaVLRt/d74Qfn1m5AZTAZ3/1YSnuoePotuhOVOLozXi1mSU4cJGceCnTFD2zmAtIPFbZLIANms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238803; c=relaxed/simple;
	bh=t5g6avh16AGLcCWt7ruwO8IcOMG4ZrHVUNaC589AkrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o55EKU2LKiGlj04YQqwKQFDtKifZOvMwfLo9DG9E3y4SSdgqzfqwR7BvWjfCOildYp4KNhU4tyTXj/bA+RdiJ1tRAHlX5/jQURl8pCan36EhK5btbpd9oS6dudNd7ZvYrqi/ecVCrXLXzDQ+RCtOmDdYlZZV0Ay9c90b1nhBcPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekzR3fg0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekzR3fg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B75C1F000E9;
	Thu, 20 Aug 2026 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238802;
	bh=fb7iWwChUUP8vgtmZ5H7JXbKobwxl2u0A0o+HiT5AFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekzR3fg0YCCXsuSZ90W4Q2fLku7UzmF1QJAd+yaWbq6OSILhD61YRhwalnuQObnW2
	 Y6KSvYls1NOLww6b1IKXNMDG0md+Lyt0ncWG/XQcbuivso0SXhthVtn6/GEoJFjxep
	 VMHfu9wrJrlE9y5yuXSKhXI4TP6qvD8rTlaEsVWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 047/217] Input: hynitron_cstxxx - validate touch count and finger IDs
Date: Thu, 20 Aug 2026 16:53:35 +0200
Message-ID: <20260820145239.039801707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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


