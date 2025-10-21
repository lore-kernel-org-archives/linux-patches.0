Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEFF1A3029;
	Tue, 21 Oct 2025 20:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077523; cv=none; b=kKBLEKZtFuDtIdb6AuXEb8GZf1Wp+KWSutJCrp8DLwUDaAqbt4cwWo9wQhfizPcJciUhaI28F4uO0kjF7rvCJeuoKF1+bW41BS8xKLcyq6VN1CbId1GxtFquXwDIbLmLvCZp6H0Ob+V/39OLDsYpHHBk5JB3gZIb9Lu92mPYyTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077523; c=relaxed/simple;
	bh=T9OfQkoUV+PE7qNdO2gJdgL6aV9Cqtzr7INuR52sCrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWPS8jFnw1bV7V32drm+l2aYsC6s0RZg6WfBKF9CVG0mNwT7I/G1qHWSDHosFJEq+Cjbefmt/r3EErcdz+6GNdeYUKF5RncKV2Otys+h+1wu8czYAg78NksU3BTsGjvcrF+wAkI9EXU7BexaC2+k8XHROjeNb7uvagcrLY8bA6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrAhl0ML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrAhl0ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C7FC4CEF1;
	Tue, 21 Oct 2025 20:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077523;
	bh=T9OfQkoUV+PE7qNdO2gJdgL6aV9Cqtzr7INuR52sCrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrAhl0MLQMDFEa5Mw0uQplDK7vqyrBMpuKDS8el/TBtLQwWRUL7MsmTGJG4jPh6Gb
	 nkECZ3GdOEQtpJLIMPBXcSF6BKidkBifWSKQjrQg93V54qI6Mh/qYVyxXsZo8A2OW3
	 HoUatsGFXCGYfELo73qDpau90b0pmkcdkSx7i8VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=8D=A2=E5=9B=BD=E5=AE=8F?= <luguohong@xiaomi.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 130/159] HID: hid-input: only ignore 0 battery events for digitizers
Date: Tue, 21 Oct 2025 21:51:47 +0200
Message-ID: <20251021195046.276675894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 0187c08058da3e7f11b356ac27e0c427d36f33f2 ]

Commit 581c4484769e ("HID: input: map digitizer battery usage") added
handling of battery events for digitizers (typically for batteries
presented in stylii). Digitizers typically report correct battery levels
only when stylus is actively touching the surface, and in other cases
they may report battery level of 0. To avoid confusing consumers of the
battery information the code was added to filer out reports with 0
battery levels.

However there exist other kinds of devices that may legitimately report
0 battery levels. Fix this by filtering out 0-level reports only for
digitizer usages, and continue reporting them for other kinds of devices
(Smart Batteries, etc).

Reported-by: 卢国宏 <luguohong@xiaomi.com>
Fixes: 581c4484769e ("HID: input: map digitizer battery usage")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index f45f856a127fe..2c743e35c1d33 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -622,7 +622,10 @@ static void hidinput_update_battery(struct hid_device *dev, unsigned int usage,
 		return;
 	}
 
-	if (value == 0 || value < dev->battery_min || value > dev->battery_max)
+	if ((usage & HID_USAGE_PAGE) == HID_UP_DIGITIZER && value == 0)
+		return;
+
+	if (value < dev->battery_min || value > dev->battery_max)
 		return;
 
 	capacity = hidinput_scale_battery_capacity(dev, value);
-- 
2.51.0



