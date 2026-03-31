Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54206402BA9;
	Tue, 31 Mar 2026 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974755; cv=none; b=KExFN3i5Q34UoZxTMwd/IQo7UGgMpJBkDrkETq9vwG/RIfsZrXfYLA38bMMdHFRU3XhSwY7lez3QQH09rGNbKfOsmsTyYPdJ7iF6wX7kz3xGyBwXRCyDL8WZR43ivUboQpWZvVEuhb4O2eQTGGGhDxQnEqalxncNfoDw7bfOjzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974755; c=relaxed/simple;
	bh=Zs/svvlra95U611TAMqOllW6jlItYEAoyX0HWhs+I1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twvrr83kMIuQt1VOTYq579U0NevNj9a4prioIPc2Vp568I9OIFAhiTJKgjsF7EtlvjwdEOZA3BI4ZkqOLMwUO2QhqJfSyiTzAAQ8DkXNCgUQrv0kxO9Ypl8JEWfGtM9+ii/eAhzNcR92DGaq3ESJlQLCen3H8NkxhmYMUQDTFg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLEFIY64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLEFIY64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9EFC19423;
	Tue, 31 Mar 2026 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974755;
	bh=Zs/svvlra95U611TAMqOllW6jlItYEAoyX0HWhs+I1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLEFIY64p5kbmkf1hLPlaeEHLvGBn6VVFS8GlIvfi6IVJHqVPMRU2hgKVWLhvF7bo
	 Zfn1su4spUw3NHAXUdMlGhO1/RThTUAW1mVtSudnKKBaEr1s/6CGp27gaHKPaYM2xI
	 K8caFZexQxlB3+J3LzH0WcE4loa42Bbzwio8KhAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Lehmann <lehmanju@devpi.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 032/342] HID: magicmouse: fix battery reporting for Apple Magic Trackpad 2
Date: Tue, 31 Mar 2026 18:17:45 +0200
Message-ID: <20260331161800.090392455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Lehmann <lehmanju@devpi.de>

[ Upstream commit 5f3518d77419255f8b12bb23c8ec22acbeb6bc5b ]

Battery reporting does not work for the Apple Magic Trackpad 2 if it is
connected via USB. The current hid descriptor fixup code checks for a
hid descriptor length of exactly 83 bytes. If the hid descriptor is
larger, which is the case for newer apple mice, the fixup is not
applied.

This fix checks for hid descriptor sizes greater/equal 83 bytes which
applies the fixup for newer devices as well.

Signed-off-by: Julius Lehmann <lehmanju@devpi.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 91f621ceb924b..f4cf29c2e8330 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -990,7 +990,7 @@ static const __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	 */
 	if ((is_usb_magicmouse2(hdev->vendor, hdev->product) ||
 	     is_usb_magictrackpad2(hdev->vendor, hdev->product)) &&
-	    *rsize == 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
+	    *rsize >= 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-- 
2.51.0



