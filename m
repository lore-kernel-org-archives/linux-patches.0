Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB2828E0;
	Sat, 12 Sep 2026 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230670; cv=none; b=gWW4RVLeOm/T1cN9t8U8drj7XmKpsBcIk+ePckirg1jyBtLLRRTaCw7udb+cVwxfw5bN2OW3w2owyjOIcDgkUEJHEn6RneYxMG7OPcdVyWl4F+X/44m6lSzb1PA1X3ZwazwlK7vUVfDAbCIqCC2nPGgJXSUjAHce7WLOkWJdAVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230670; c=relaxed/simple;
	bh=3D2+fYOc0CuLAdSaxPhp5LmePVMgN9nLMuhEWcQmmh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7PKOMMggYsJzLdmsmqhGvbLcIyW749w7lHtflhAwDr3fqrkTKcaBJfFdOVkiXrzILmwJTLhH1Etyi4vtqZETTF+FdUk86wPfA4Ubhn1GqSa6yXQ/++ZHxfiRQ2vEv0f3L1PO+TslL4unatymh+8Ay4Oz5f4yXu5WjiqYlkvvik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cssTVqkP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cssTVqkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2232A1F000FF;
	Sat, 12 Sep 2026 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230669;
	bh=Gdk67MhZTm+EfKdgRcSVmhVCEjJxU2dAcSccB5wKikg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cssTVqkPABnwvYBM+Iq/BPgk09tenGBz69pEc4uOwXhsoBb/6CTcJFbwRiC3xUuoW
	 D2+9sg7LQc96ezh/zPQ4fYPHDqDQDK/TMHJAosr+s8BRxtvOJiDH5/tZ1Tn5PaZ/eK
	 5ykw94GWF6kgbEFqKw7Zz7SFRyRdHCOgKw+3shgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiancheng Huang <jchuang@seu.edu.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0842/1191] HID: lg4ff: validate report length before fixed offsets
Date: Sat, 12 Sep 2026 08:59:30 +0200
Message-ID: <20260912065607.170307086@linuxfoundation.org>
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

From: Jiancheng Huang <jchuang@seu.edu.cn>

[ Upstream commit be00988cce4ed44db1e61231d0ab71a64bab44cd ]

lg4ff_raw_event() rewrites fixed report offsets when combined pedals are
enabled. It currently assumes that each product report contains every
source and destination byte used by the rewrite.

Return without rewriting a short report before each product-specific
access. Apply the same bound to the computed offset path.

Fixes: c832f86effbc ("HID: hid-logitech: Add combined pedal support Logitech wheels")
Signed-off-by: Jiancheng Huang <jchuang@seu.edu.cn>
Assisted-by: Codex:gpt-5.6-luna
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lg4ff.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index e3fcf1353fb3b..71f168eff29b1 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -336,6 +336,8 @@ int lg4ff_raw_event(struct hid_device *hdev, struct hid_report *report,
 	if (entry->wdata.combine) {
 		switch (entry->wdata.product_id) {
 		case USB_DEVICE_ID_LOGITECH_WHEEL:
+			if (size < 7)
+				return 0;
 			rd[5] = rd[3];
 			rd[6] = 0x7F;
 			return 1;
@@ -343,10 +345,14 @@ int lg4ff_raw_event(struct hid_device *hdev, struct hid_report *report,
 		case USB_DEVICE_ID_LOGITECH_WINGMAN_FFG:
 		case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL:
 		case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2:
+			if (size < 6)
+				return 0;
 			rd[4] = rd[3];
 			rd[5] = 0x7F;
 			return 1;
 		case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
+			if (size < 7)
+				return 0;
 			rd[5] = rd[4];
 			rd[6] = 0x7F;
 			return 1;
@@ -366,6 +372,8 @@ int lg4ff_raw_event(struct hid_device *hdev, struct hid_report *report,
 		}
 
 		/* Compute a combined axis when wheel does not supply it */
+		if (size <= offset + 1)
+			return 0;
 		rd[offset] = (0xFF + rd[offset] - rd[offset+1]) >> 1;
 		rd[offset+1] = 0x7F;
 		return 1;
-- 
2.53.0



