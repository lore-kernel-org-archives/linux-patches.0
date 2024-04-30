Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC1112C549;
	Tue, 30 Apr 2024 10:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474437; cv=none; b=FAtlNSQBKhoOBqyCx/UmrSrcpgUWZyZ2Z8SRpYmzPaux2HX6+ZUSQ6SAlhq4CIsI3uS9xyLaf9kTp8lgBkJDeAkaUkS0q0iGT1MaF9gCrY8FJxAtCqyw7D9wd9heSuF64f2GOo9x73atWVXdPbn4Q/Cc4BWPT+pJBMW4lZx/hQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474437; c=relaxed/simple;
	bh=c81V8q9JKrbV7u2R6DWFPum6OB3c5FvM4N7JkcaX7SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fld3nkSFBET55MpnV/j8muIjzsB/mc3Jj7ngqZkqRFkYO5Ngmkw1MBcG/6r3e9WURf4Ng5kKhgppuftZUVHgSo2ReTEFZBrLZ0+is0Q+WQnPnuxeAsRRYO7jvWnNg6I1auschPdJffP4HPi3wj+GkO/OYlLHe1qT44MKt2sLhxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTNceiTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTNceiTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC25C2BBFC;
	Tue, 30 Apr 2024 10:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474437;
	bh=c81V8q9JKrbV7u2R6DWFPum6OB3c5FvM4N7JkcaX7SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTNceiTk5XDR/rI0FKXAmgsjjkWV0sNH3svxis04m9kXTVLNvIJ86a9Dlk9PozboZ
	 nMlV8BWe4CuKGdkG8L8V1mRu7KtAZHf/JJEErqaBQz1REONLsoQ8M1fdMzll3JH177
	 vwUR0eestkg1YR5mEhgeB1ysCo8FxlzWZ8i++Cao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenny Levinsen <kl@kl.wtf>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.8 157/228] HID: i2c-hid: Revert to await reset ACK before reading report descriptor
Date: Tue, 30 Apr 2024 12:38:55 +0200
Message-ID: <20240430103108.336349432@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenny Levinsen <kl@kl.wtf>

commit ea36bf1827462e4a52365bf8e3f7d1712c5d9600 upstream.

In af93a167eda9, i2c_hid_parse was changed to continue with reading the
report descriptor before waiting for reset to be acknowledged.

This has lead to two regressions:

1. We fail to handle reset acknowledgment if it happens while reading
   the report descriptor. The transfer sets I2C_HID_READ_PENDING, which
   causes the IRQ handler to return without doing anything.

   This affects both a Wacom touchscreen and a Sensel touchpad.

2. On a Sensel touchpad, reading the report descriptor this quickly
   after reset results in all zeroes or partial zeroes.

The issues were observed on the Lenovo Thinkpad Z16 Gen 2.

The change in question was made based on a Microsoft article[0] stating
that Windows 8 *may* read the report descriptor in parallel with
awaiting reset acknowledgment, intended as a slight reset performance
optimization. Perhaps they only do this if reset is not completing
quickly enough for their tastes?

As the code is not currently ready to read registers in parallel with a
pending reset acknowledgment, and as reading quickly breaks the report
descriptor on the Sensel touchpad, revert to waiting for reset
acknowledgment before proceeding to read the report descriptor.

[0]: https://learn.microsoft.com/en-us/windows-hardware/drivers/hid/plug-and-play-support-and-power-management

Fixes: af93a167eda9 ("HID: i2c-hid: Move i2c_hid_finish_hwreset() to after reading the report-descriptor")
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2271136
Cc: stable@vger.kernel.org
Signed-off-by: Kenny Levinsen <kl@kl.wtf>
Link: https://lore.kernel.org/r/20240331182440.14477-1-kl@kl.wtf
[hdegoede@redhat.com Drop no longer necessary abort_reset error exit path]
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 1c86c97688e9..d965382196c6 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -726,12 +726,15 @@ static int i2c_hid_parse(struct hid_device *hid)
 	mutex_lock(&ihid->reset_lock);
 	do {
 		ret = i2c_hid_start_hwreset(ihid);
-		if (ret)
+		if (ret == 0)
+			ret = i2c_hid_finish_hwreset(ihid);
+		else
 			msleep(1000);
 	} while (tries-- > 0 && ret);
+	mutex_unlock(&ihid->reset_lock);
 
 	if (ret)
-		goto abort_reset;
+		return ret;
 
 	use_override = i2c_hid_get_dmi_hid_report_desc_override(client->name,
 								&rsize);
@@ -741,11 +744,8 @@ static int i2c_hid_parse(struct hid_device *hid)
 		i2c_hid_dbg(ihid, "Using a HID report descriptor override\n");
 	} else {
 		rdesc = kzalloc(rsize, GFP_KERNEL);
-
-		if (!rdesc) {
-			ret = -ENOMEM;
-			goto abort_reset;
-		}
+		if (!rdesc)
+			return -ENOMEM;
 
 		i2c_hid_dbg(ihid, "asking HID report descriptor\n");
 
@@ -754,23 +754,10 @@ static int i2c_hid_parse(struct hid_device *hid)
 					    rdesc, rsize);
 		if (ret) {
 			hid_err(hid, "reading report descriptor failed\n");
-			goto abort_reset;
+			goto out;
 		}
 	}
 
-	/*
-	 * Windows directly reads the report-descriptor after sending reset
-	 * and then waits for resets completion afterwards. Some touchpads
-	 * actually wait for the report-descriptor to be read before signalling
-	 * reset completion.
-	 */
-	ret = i2c_hid_finish_hwreset(ihid);
-abort_reset:
-	clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
-	mutex_unlock(&ihid->reset_lock);
-	if (ret)
-		goto out;
-
 	i2c_hid_dbg(ihid, "Report Descriptor: %*ph\n", rsize, rdesc);
 
 	ret = hid_parse_report(hid, rdesc, rsize);
-- 
2.44.0



