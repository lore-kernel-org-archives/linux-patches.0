Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B10E390C8A;
	Sat, 12 Sep 2026 19:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242951; cv=none; b=PDuYUgJ/HnVYtS68j0l5OgMBa2KQrD8MDjTEFzSn3Ak0/2zn9DX8svzb+Qh9hVLCLbtyngGw//0i51O7yf4UPunP5HHt8RgTikN4CvD8nK5EGjhjLWWNoxUQJxML0o+L9ODbdSHiJ9mbIUXp1yZv2dgBqkOE6MVxxHq4GLhk2ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242951; c=relaxed/simple;
	bh=shu/WAxekepR3mVmLQAd1VmNAvMTwzuitDNmhjHB32Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8KY9ytG7605WNsY4YDjoVZcc9UtYI42y/VTgxh8xkSW/BPZPhgvXXRB0z6Pteq1zp1SXnZRJLviuEZpd5ijuK/9z3Jnpw5p/0iUx0dTxdZBJTJHj+QP4tAoy3YPtrvcss10J7oeHS4LGNForhre7q7+IseHO12c/D9AF0dzZyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8FfqiKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8FfqiKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50371F000FF;
	Sat, 12 Sep 2026 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242950;
	bh=75RDpYO71UbOKUeCnYA7Ip/3pwM9jhgwf6KgMCA2ssY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8FfqiKdz5hTFNXtOWqJ2a60J83tv6VA3pjHRqh8CFw1oOUEQWGn569r5B+HZPMRw
	 PnT9O6vEyHYD5QRHjYlwhJr3uMgjW3Va0i2JlDgUk/JAV5fshlRXUcyFs3Lxzh3Qjq
	 SKjPifPPKbISFo/OImcGiYpVbSsPuFnPzkLw3YRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 584/798] HID: i2c-hid: Fix "(null)" output when reading report descriptor fails
Date: Sat, 12 Sep 2026 09:03:32 +0200
Message-ID: <20260912065530.511933638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f60e24559f94c..8a8fcccfb7e49 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -752,7 +752,7 @@ static int i2c_hid_parse(struct hid_device *hid)
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



