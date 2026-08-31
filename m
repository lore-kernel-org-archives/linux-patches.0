Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2351047F78A;
	Mon, 31 Aug 2026 14:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184836; cv=none; b=QlcXrkgLya2hUjQ4TEr4HyjzBO5cq7eG2+qea+cpJc+kCAuw5zf2lRcagVlHByg7hVvAEy8QLTaBPhz76u1bNQmcrYvQtYqxKWscKq8gUbsrRkkHRc3K+tzbIe7DPwV6BDiO0hYrMiSdIn4oOvu/L6FhqgrEiHv+G2LFmeAs7qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184836; c=relaxed/simple;
	bh=HcFnlD2ilSO9yXRX0twTHrBUEQVaTwS//wZCgWKmqj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XqxsMUlQ+I7lMlloEyWmN9JkWPRIHvsBUpazXbGUsNr/SsbA9qzlAdWlGjfbEM10g28mqH6ShAHiPGnefwyh5SEwLO6TfuqwjLiwZ2mLVRUrHHFCJad4+gzyIAo2HU3DtT9/iKBPPPnUG0VTqeYc+LJzEjP5XbBK5wF7Od1V/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgjQQeYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgjQQeYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D411F000E9;
	Mon, 31 Aug 2026 14:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184834;
	bh=3Emch37pG453YOlZOJPwxU9AeAiYqEijMc6NnR501QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgjQQeYt41BIiiZ2+ZsH7FVQ0SLg67wq8SBLLHq2hQUEWLdUC0hRjdUamraYlV+09
	 pqmdnDwGU4et5f/xIPCZxP6GXDUXRMNtYH3Az4F1Lq/wcaWKrwD89Mt0ruJvwfil9G
	 bspCSZStxsskBRQaxf1sA+k9GUT8voul78RjyOgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Sebasti=C3=A1n=20Josu=C3=A9=20Alba=20Vives?= <sebasjosue84@gmail.com>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/92] HID: ft260: validate i2c input report length
Date: Mon, 31 Aug 2026 15:34:51 +0200
Message-ID: <20260831133402.473229584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Zaidman <michael.zaidman@gmail.com>

[ Upstream commit 80c4bbb2b38513e9c3d84805fa61a0ee16d79c45 ]

Add two checks to ft260_raw_event() to prevent out-of-bounds reads
from malicious or malfunctioning devices:

First, reject reports shorter than the 2-byte header (report ID +
length fields). Without this, even accessing xfer->length on a
1-byte report is an OOB read.

Second, validate xfer->length against the actual data capacity of
the received HID report. Each I2C data report ID (0xD0 through
0xDE) defines a different report size in the HID descriptor, so the
available payload varies per report. A corrupted length field could
cause memcpy to read beyond the report buffer.

Reported-by: Sebastián Josué Alba Vives <sebasjosue84@gmail.com>
Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: bf3e39df3a39 ("HID: ft260: fix stack-use-after-return write in I2C read race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -1069,10 +1069,22 @@ static int ft260_raw_event(struct hid_de
 	struct ft260_device *dev = hid_get_drvdata(hdev);
 	struct ft260_i2c_input_report *xfer = (void *)data;
 
+	if (size < offsetof(struct ft260_i2c_input_report, data)) {
+		hid_err(hdev, "short report %d\n", size);
+		return -1;
+	}
+
 	if (xfer->report >= FT260_I2C_REPORT_MIN &&
 	    xfer->report <= FT260_I2C_REPORT_MAX) {
-		ft260_dbg("i2c resp: rep %#02x len %d\n", xfer->report,
-			  xfer->length);
+		ft260_dbg("i2c resp: rep %#02x len %d size %d\n",
+			  xfer->report, xfer->length, size);
+
+		if (xfer->length > size -
+		    offsetof(struct ft260_i2c_input_report, data)) {
+			hid_err(hdev, "report %#02x: length %d exceeds HID report size\n",
+				xfer->report, xfer->length);
+			return -1;
+		}
 
 		if ((dev->read_buf == NULL) ||
 		    (xfer->length > dev->read_len - dev->read_idx)) {


