Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1887123D7E8;
	Tue, 21 Oct 2025 20:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076958; cv=none; b=qDeMqf7CatFdC0Ad9lxMDooYGgyW+fHGyReUNVZlY8KuvPQf1AgEBzbfSGFxgH+T0eK7ZXhk+AX3oLpIFHjQDPqjqhWnKkOp+lJT2X+blRXpyCkd6XhR3ozxF6iD6lB/ksDgBvT/NOShYDE/CoVVwZ6OQ2GGNl5wG0wVhZwr4tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076958; c=relaxed/simple;
	bh=DPjpwP3behx68LLK2WJFNOvKNcgZkP5eVxp256JU+WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2AupopgtN9x/U3cHKX0yujljR+eolSGK501ev3dBGdKIHBeJ8p9hpm4wF02/f9LD+YX8WG3TELUaQCEWVax20URxVzwmB3ANohP7/ZwgNV7BWPeCqBM7OvYNK9LeB08/GZr0QsI02B+2gsih8inxpzcBCCk5oqtmOqsspn4AFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzLGfAxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzLGfAxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2EEC4CEF1;
	Tue, 21 Oct 2025 20:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076958;
	bh=DPjpwP3behx68LLK2WJFNOvKNcgZkP5eVxp256JU+WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzLGfAxKKD0PbsCqvxJF0eKAfw5qJ0pOSb/Bry94vchGI51GRax1Ft3PMgfqc0XSa
	 YezijPuBK93i7KuroLnEV1Z+oBzSv5bjsN0ZN5W9I/sJP4Dm/XLz9FL6IRiSoZxZfU
	 td+uSEtcrFzSiL8JGAV6XRV6BX3YYNXl7R48p3bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=8D=A2=E5=9B=BD=E5=AE=8F?= <luguohong@xiaomi.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/136] HID: hid-input: only ignore 0 battery events for digitizers
Date: Tue, 21 Oct 2025 21:51:17 +0200
Message-ID: <20251021195038.103321653@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f5c217ac4bfaa..f073d5621050a 100644
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



