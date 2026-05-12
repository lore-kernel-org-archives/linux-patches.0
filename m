Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F358F3EDE61;
	Tue, 12 May 2026 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609267; cv=none; b=gJ2KqH+hP8aPtrjY9GwhJ2CdHBoKbX/RVi3FFm/1i1giz8xrdUwV/9Ejod+rrxfiXNaZvFgrvBPUYkp1R98hd32XYSpXaBnRGbiOh/QTiC/yAq8WUH3KnHxfq1buHLVqQql5dRvoHN2EljPTab6rkfQT3Vd+gkJyExNs+aq07eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609267; c=relaxed/simple;
	bh=5bjbHUzYQWiLvGsdA7ms52OI8Ml7ULWQylD7MhHicxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n49gvWLRr4ioZGbdmKjsytXAvbvfUISI3TWm4zOQAdk41zNhDWNvWLyGMWiolhrinuFfFmM+sVQSYfmWQVO2Zw09e6EpqSkdnv4TbxbQtyEekjtvgjz7J46m8BfZaE0m9K1AoxnTA3fcpZsFbLVZmd20uNpxENbD5JKhSaO/cyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PumzMGwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PumzMGwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C141C2BCB0;
	Tue, 12 May 2026 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609266;
	bh=5bjbHUzYQWiLvGsdA7ms52OI8Ml7ULWQylD7MhHicxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PumzMGwqku4AgG33CNEKAEyg91LrFQxd5KgOTi2NkTHJcQbUVVqOh8iVtBghKjWOG
	 G1aGZkBDE/cX7DIiDr4z++lmZmEQqc8ENcIbD6GSz3wNYMRGJ/rU758ydMHM6kye6x
	 wRJsAiwAl5D7J5CCvp884EXZDtkSkPu35poXsVfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.0 130/307] hwmon: (corsair-psu) Close HID device on probe errors
Date: Tue, 12 May 2026 19:38:45 +0200
Message-ID: <20260512173942.872047882@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 174606451fbb17db506ebaacdd5e203e57773d5f upstream.

corsairpsu_probe() opens the HID device before sending the device init
and firmware-info commands. If either command fails, the error path jumps
directly to fail_and_stop and skips hid_hw_close().

Use the existing fail_and_close label for those post-open failures so the
open count and low-level close callback are balanced before hid_hw_stop().

Fixes: d115b51e0e56 ("hwmon: add Corsair PSU HID controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/20260424135107.13720-1-mhun512@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/corsair-psu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -796,13 +796,13 @@ static int corsairpsu_probe(struct hid_d
 	ret = corsairpsu_init(priv);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to initialize device (%d)\n", ret);
-		goto fail_and_stop;
+		goto fail_and_close;
 	}
 
 	ret = corsairpsu_fwinfo(priv);
 	if (ret < 0) {
 		dev_err(&hdev->dev, "unable to query firmware (%d)\n", ret);
-		goto fail_and_stop;
+		goto fail_and_close;
 	}
 
 	corsairpsu_get_criticals(priv);


