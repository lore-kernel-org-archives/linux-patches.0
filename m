Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644133E346;
	Sat, 12 Sep 2026 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224577; cv=none; b=GoV5BdWz2u8cB7asElbbVtocFFu73lA9MJypBQJ2H+hivbqn+Bzsli2f++EJbQmcz3zLqKSMMmr7Gbars2s8NvOUElA4MQg90gozCHNpv85+Y0bk4mkcELSk8xoa4OsCqhhJGLp37tw4ytJ3jC/5dDlJH508SYXpMTprMDm4ZSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224577; c=relaxed/simple;
	bh=Mzb6IrLNVrWtY0l0SG91Tl1w1EWEYn10EI2HKum3Nes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKT/Tmm+T3Gk6jcpjCsHHThaEOfKZbPguKhO+qPlyzLuG6mmFi8QN2t+S9FAQy1gQaDIl68KGYw/ET/yU5RTJkTmAMQcxviJc0SUVZT2HnXjLmqclsgC7BnQldWkbUkbsqlpFrMdMojmPjTI+8E+nqjeR8v4bwEn9DK8xWCWllw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uig0O/6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uig0O/6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0606A1F000FF;
	Sat, 12 Sep 2026 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224576;
	bh=GUxSvBiJ/JFdxk4Ww1JYCotYKOB8Rfyil4tVUqIQWdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uig0O/6xWmpLNkKv7sJfksAubHUK1kxPvf8yinMyEQkrIqq7p3AL60Ho3HecuvxjL
	 R7aY36OzuXxPSGLQBsvzVdFmPB2O3jUcjDRdwopG2EbGhjshVL9XKtKRkhVt0aMaEp
	 2snlU1i5B33agrZdrR6kDfyStqRguRhOwNqa8+Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenny Levinsen <kl@kl.wtf>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1021/1424] HID: i2c-hid: Revert to await reset ACK before reading report descriptor
Date: Sat, 12 Sep 2026 08:57:33 +0200
Message-ID: <20260912065630.175044869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenny Levinsen <kl@kl.wtf>

[ Upstream commit ea36bf1827462e4a52365bf8e3f7d1712c5d9600 ]

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
Stable-dep-of: 8da0f0951dee ("HID: i2c-hid: Fix "(null)" output when reading report descriptor fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 22e6795cdaff7..aa71388852099 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -732,12 +732,15 @@ static int i2c_hid_parse(struct hid_device *hid)
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
@@ -747,11 +750,8 @@ static int i2c_hid_parse(struct hid_device *hid)
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
 
@@ -760,23 +760,10 @@ static int i2c_hid_parse(struct hid_device *hid)
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
2.53.0



