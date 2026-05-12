Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE08385D69;
	Tue, 12 May 2026 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607926; cv=none; b=dLj1sxoyJCceGQqnA3SUduDwrk5ygQ/m8u7JIE5DhhOec+FiLI+RPXdOvdrwruMaqw+bB05XG63I6uilF3mFH7fqNZquqWVpwdAI3h4A5gHnaJLsRaMBArWPaffuICdw797ZFr3BgeX2sBCdiS4U1JQeZMoqRLxDYYR5JByfzx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607926; c=relaxed/simple;
	bh=gRr8PjKBuzIT4lfrze00QPUOYFtF4iXt0/BymI3kFc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/MR26UpHDzvTwpCbwEi8FFIwE/065UPKNK7k6s4h630izMy39zAxkRUWA+wC5YInfWzEqhNmAM8VOiAHsMwLPjgbaSxJzrXlHQTE8AV2Lbrv9W52cb7uFNvtcwhdDqOa61GzLSd/ArQmPM4c8TNiBkPNNubIBVCpPg9fMPv0YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kt5u0u6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kt5u0u6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AB5C2BCF5;
	Tue, 12 May 2026 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607926;
	bh=gRr8PjKBuzIT4lfrze00QPUOYFtF4iXt0/BymI3kFc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kt5u0u6nEDPa2XXqg9hF4/GeOYPyvOINLgKSgsU1ztNzrkI4+56kgRFu2RZ4qw3Ll
	 CK3Xbd8mSGRm0HShvsiTbfoig08dZErXkzpK2lG7rSewgAlzEaI5ItMSaZorGFV9CK
	 WTxs0mHc7LrmKnaWusI0XNfRDBEihGjZ6BiZ8cqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 088/206] hwmon: (corsair-psu) Close HID device on probe errors
Date: Tue, 12 May 2026 19:39:00 +0200
Message-ID: <20260512173934.719571579@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -805,13 +805,13 @@ static int corsairpsu_probe(struct hid_d
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


