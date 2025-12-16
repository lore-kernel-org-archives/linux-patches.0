Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEB5346A05;
	Tue, 16 Dec 2025 11:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885084; cv=none; b=iESVMtW8bWGWK6uLumli+cAGBy9VU2UEqVL5wUMHmXS9tyb+FHvV6l2RpNopiWCmxJ2z2i5pyvbbK6DdGOCOJ3oauYDyeryGVVQFOv1fyNjEYKTcCwmY7AuAVc2DQyvIwyN9qR6CnyzBPsifwlNMSSt386xT0uFqq3dJXmflAXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885084; c=relaxed/simple;
	bh=uXP2Ife2trYHhahUO6yNVRsPaieTehWxNSyQkRjWlo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJBX04/F3uYHmgSxwm4Np7rRYtSvjXzeYgMJ8f97c3UK63+EkAvx9OyNGTSQ3c8dvJQj9m5UI8yWuf9O4RKQw/FLBJMPRcgbiq3booyKESEkE4AQcIjegV4Fp+OuPGp97t8DS1WZ1w8075d2AoOLrK4TtWvcXT5WEjWRHAqjSp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZNoenmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZNoenmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF3CC4CEF1;
	Tue, 16 Dec 2025 11:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885084;
	bh=uXP2Ife2trYHhahUO6yNVRsPaieTehWxNSyQkRjWlo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZNoenmpEdlfyiPqvgurxBh+VRYKkrIrr22+ZlV8U9+cRIxLQTp+m9UOj+fw+mkVv
	 bM8PdsicGuReboXHJ0wK1zKNRygtbERwobrBM4NIVHJeRAhR0dHUkgm45ORVfQM4nr
	 H+Ve8DusPbyByAiN/i/6zVozj26mn3nO4e7Agnc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mavroudis Chatzilazaridis <mavchatz@protonmail.com>,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 026/507] HID: logitech-hidpp: Do not assume FAP in hidpp_send_message_sync()
Date: Tue, 16 Dec 2025 12:07:47 +0100
Message-ID: <20251216111346.484127410@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>

[ Upstream commit aba7963544d47d82cdf36602a6678a093af0299d ]

Currently, hidpp_send_message_sync() retries sending the message when the
device returns a busy error code, specifically HIDPP20_ERROR_BUSY, which
has a different meaning under RAP. This ends up being a problem because
this function is used for both FAP and RAP messages.

This issue is not noticeable on older receivers with unreachable devices
since they return HIDPP_ERROR_RESOURCE_ERROR (0x09), which is not equal to
HIDPP20_ERROR_BUSY (0x08).

However, newer receivers return HIDPP_ERROR_UNKNOWN_DEVICE (0x08) which
happens to equal to HIDPP20_ERROR_BUSY, causing unnecessary retries when
the device is not actually busy.

This is resolved by checking if the error response is FAP or RAP and
picking the respective ERROR_BUSY code.

Fixes: 60165ab774cb ("HID: logitech-hidpp: rework one more time the retries attempts")
Signed-off-by: Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
Tested-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 5e763de4b94fd..a88f2e5f791c6 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -352,10 +352,15 @@ static int hidpp_send_message_sync(struct hidpp_device *hidpp,
 
 	do {
 		ret = __do_hidpp_send_message_sync(hidpp, message, response);
-		if (ret != HIDPP20_ERROR_BUSY)
+		if (response->report_id == REPORT_ID_HIDPP_SHORT &&
+		    ret != HIDPP_ERROR_BUSY)
+			break;
+		if ((response->report_id == REPORT_ID_HIDPP_LONG ||
+		     response->report_id == REPORT_ID_HIDPP_VERY_LONG) &&
+		    ret != HIDPP20_ERROR_BUSY)
 			break;
 
-		dbg_hid("%s:got busy hidpp 2.0 error %02X, retrying\n", __func__, ret);
+		dbg_hid("%s:got busy hidpp error %02X, retrying\n", __func__, ret);
 	} while (--max_retries);
 
 	mutex_unlock(&hidpp->send_mutex);
-- 
2.51.0



