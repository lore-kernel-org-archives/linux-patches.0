Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D44B28E0;
	Sat, 12 Sep 2026 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230665; cv=none; b=tmttao+E8mufuvgdXn4YwxLQAvIegnFYKzEQPELZW3ERsGUh0906x24plx9WCy6UGeIrtw1U2sjsHAoOgI/ufUPo0T2UMLlpKRf+9udkHXYC3Sdr2LhH3GCc8x3nnMsVwXTaxeMIoIC+1scUYa2TsIMghNsrMUlWswaC261OHr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230665; c=relaxed/simple;
	bh=8OfgQan9d43weG9nMiNubmL8fFM4yqhoIZ/K51oY1uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaoVFHHL0d9hWWsxFcLh5RJDzs9I9+UPM3EbTstdrftRq6pUNTY2sgw5Tcfan+Pvd1K2K7thKLwPoOLNovl8o19vhj4V4ejPymmlhZAjNZmXSMVTTyt4mr36GRa0hKbUba7Z4HVVR4gDQFyJr8gy6yfxne36EyI+uiq1TheddSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSRoBze3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSRoBze3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5611F000FF;
	Sat, 12 Sep 2026 16:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230664;
	bh=dgMwMSgIdDrGakTfSjXcH3Q3Qn6D/SmM/cNBKkAbzrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSRoBze3MojEm/Rpd/ghmEP6fz3Upb7AXkzgkTb2IeQ/La+5vAT/D17wPYg4K+cen
	 YnHSadzqQ+WPqlo/34i3BaIe3fI3kELSbSEVdNJeoj9CKuk5dMJlw6HYoMVYh0ZDnf
	 Ss0Dn9t4NUCz6RYZk81x4+n+GNfaZ9NPXDD6itMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0841/1191] HID: i2c-hid: Fix "(null)" output when reading report descriptor fails
Date: Sat, 12 Sep 2026 08:59:29 +0200
Message-ID: <20260912065607.147934315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ai Chao <aichao@kylinos.cn>

[ Upstream commit 8da0f0951deec9f0728ed2d9c54ded1c344b7542 ]

When i2c-hid fails to read the HID report descriptor during device
initialization, the error message prints as:

  hid (null): reading report descriptor failed

The HID device name is set in hid_add_device() after calling
hdev->ll_driver->parse(), so when i2c_hid_parse() fails and calls
hid_err(), the device name has not been set yet, resulting in "(null)"
output.

Use dev_err(&client->dev, ...) instead of hid_err(hid, ...) because
the I2C client device is fully initialized with a proper name, providing
meaningful error messages for debugging.

Before: hid (null): reading report descriptor failed
After:  i2c_hid i2c-TPD0001:00: reading report descriptor failed

Fixes: 4a200c3b9a40 ("HID: i2c-hid: introduce HID over i2c specification implementation")

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index a198b679c7902..9559c96d44b4d 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -754,7 +754,7 @@ static int i2c_hid_parse(struct hid_device *hid)
 					    ihid->hdesc.wReportDescRegister,
 					    rdesc, rsize);
 		if (ret) {
-			hid_err(hid, "reading report descriptor failed\n");
+			dev_err(&client->dev, "reading report descriptor failed\n");
 			goto out;
 		}
 	}
-- 
2.53.0



