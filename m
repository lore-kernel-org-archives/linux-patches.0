Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3916248C8CB;
	Mon, 31 Aug 2026 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185057; cv=none; b=jxKyQszT45pGM3yfoYIycpYcMrgAkvYMywV+VBQ5wfRXY9/1ilkztK6kdMPBdTmSURnOcE8YQJiZpvN/Xet1tu4eIWyiZL1YLaklLs5tGTeoYhmFD3zNGDBKebF/repdaf+UHDM9Y+8B83Shk/v6OxHcHsORzln2QUXLoXytiyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185057; c=relaxed/simple;
	bh=nBgkftqdYAcWm4zCPjnytIGyREvfbiLFes4kPV+au9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlmynOpRqtjb0KVJEGKUGXo58Xb12P0e/qNaa/MVNiXNWZyiE4v0Czq3JqNPD91Ulo0lmyp9K/ANh+HzNmq2CTVSHSxbmOv7MfII9RB9p55JoMIQr0Suhb6r4d0XGvrv3WIaoqxc9/970RncA5vjIbE2+rZ9zYGKZkNurUEdTEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5zv23qL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5zv23qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F851F000E9;
	Mon, 31 Aug 2026 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185056;
	bh=7xOIoeyRvO8cBEn6uKmEk+48bBx8IHTyYIbBtXmnIoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5zv23qLhMFMiTxmfX+zuV+lep39dX9QUsOocenI9FUKAFITX25Sq9uP/DPYbrgpI
	 VpgzbTnACANXsCMTDgVvyaAu8vtFa6uN3ZXs5fwOL+hvHsj5vzm5MMsTDKRfhWaGab
	 LX3iNEOz0UYeT6OCgqOoSE7Q8AdVH5nPBccG16Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Sebasti=C3=A1n=20Josu=C3=A9=20Alba=20Vives?= <sebasjosue84@gmail.com>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/69] HID: ft260: validate i2c input report length
Date: Mon, 31 Aug 2026 15:35:12 +0200
Message-ID: <20260831133400.502966268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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
@@ -1068,10 +1068,22 @@ static int ft260_raw_event(struct hid_de
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


