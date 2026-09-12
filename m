Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DB448E0F5;
	Sat, 12 Sep 2026 19:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239683; cv=none; b=jeIzV5F1RzVM93/A1UwDEr4w3RxOSDgrtvJD5tYx0UvM07sfTrOxXG1zQGhRN7BASa9qXHA3afJdme+0tlUbSgJyXQAuNU8j9FOoWZV0AM+aqfRvh31cahPIpzG7fSt/rfZpSOSOs+yPoPHTRjTerDhzXQzNtPIBtTFdJvhUZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239683; c=relaxed/simple;
	bh=mooPPurRcjYu12zGyMNmoCP7UIzx35dm4UeyqOboa4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnelKh2OzRjs5ryCQEKZPkEWPN+YWbmfRKlIKuwYzkv7WvNIBaiHJKSrjs8/Atq1yFdm6LHU/fe3X5+JXogU2FZmhhsuXfj4P2JnYdmy3c+NS01Q9t02Hm8UwkHdTiekxNxpIpNFXRvADGc7t5Zbf4DOlKhp/2eKUgR29rAwHYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezRRdV4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezRRdV4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA121F00893;
	Sat, 12 Sep 2026 19:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239677;
	bh=WII+H1U5CVzMl9TJHjO8dvDkJd3BKBEkJ1yus4aPGf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezRRdV4Gd2wBCqPeIIBrzHrbt36XNBA85kHULUP8NxA3u9T3CKnmk0lN78zeHKu3t
	 BWEhn0mOeKHpdh9OG1QLkqslbLMtkSye0dKuqUNsl0UEd8RLkL924+I5BYOWgUAEjJ
	 6DOqEgmc3tkdupvys6OvHl/cHh0sWYuAuOFXjRaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 676/935] HID: i2c-hid: Fix "(null)" output when reading report descriptor fails
Date: Sat, 12 Sep 2026 09:01:46 +0200
Message-ID: <20260912065542.346300297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 69831b5b0a19e..6edfbfab55d3f 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -747,7 +747,7 @@ static int i2c_hid_parse(struct hid_device *hid)
 		ret = i2c_hid_command(client, &hid_report_descr_cmd,
 				      rdesc, rsize);
 		if (ret) {
-			hid_err(hid, "reading report descriptor failed\n");
+			dev_err(&client->dev, "reading report descriptor failed\n");
 			goto out;
 		}
 	}
-- 
2.53.0



