Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430617592;
	Tue, 30 Apr 2024 11:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476371; cv=none; b=k/+txDYx1ENnbb3ebz6U5p9KlSAZhEC9DI9rRQciErbhgKXnHEe2S8FTHHz2AaG0CMZUcX+TjvJfHxTc/5OI7E7FscBqRERMaLPB1FtShgIXz9zw0bzOs7DnR3ZaJ/HBEFDCjEChTH7zZzDXhvINiVSxufxeCbEMl71Soxx+ETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476371; c=relaxed/simple;
	bh=a8EQbjAysnnsi3ig9OXGoWNfp4ICHdFFgiFbHIZXjHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnFHIcsBzZvbhDz5H/qhhf+6vZIrzNT27oWL/wY8TfucAQDHgZF77fJ+vnVq2VMGuhyNxJnkuPrlGKWE/aLVCnozDDSD00LXZF+0iKlyR2AuXMb9lu/ysIyOhsVfig2Undjgv/0qlxJ+QUxw7Xoqbe9dOWyKWqXwrMUZM54cDH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPrUOf65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPrUOf65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B926BC4AF18;
	Tue, 30 Apr 2024 11:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476371;
	bh=a8EQbjAysnnsi3ig9OXGoWNfp4ICHdFFgiFbHIZXjHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPrUOf65VCgszFdnlIv1ysAFhrUKCXSS2mWlb9kaERt+BvzUwqeN4b7yT1Yrgzqko
	 O6taW2e86P8zcS2Em8cqWqkDNeXOQzFfwoBTUJPpRsExEAWykkOcLFg4oHynhiqBbE
	 e2VsAs38EQf3CoyB75MfO5bnHc8aChKbpPfCwhwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaraslau Furman <yaro330@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/110] HID: logitech-dj: allow mice to use all types of reports
Date: Tue, 30 Apr 2024 12:39:33 +0200
Message-ID: <20240430103047.698129902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yaraslau Furman <yaro330@gmail.com>

[ Upstream commit 21f28a7eb78dea6c59be6b0a5e0b47bf3d25fcbb ]

You can bind whatever action you want to the mouse's reprogrammable
buttons using Windows application. Allow Linux to receive multimedia keycodes.

Fixes: 3ed224e273ac ("HID: logitech-dj: Fix 064d:c52f receiver support")
Signed-off-by: Yaraslau Furman <yaro330@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 08768e5accedc..57697605b2e24 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -965,9 +965,7 @@ static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
 		}
 		break;
 	case REPORT_TYPE_MOUSE:
-		workitem->reports_supported |= STD_MOUSE | HIDPP;
-		if (djrcv_dev->type == recvr_type_mouse_only)
-			workitem->reports_supported |= MULTIMEDIA;
+		workitem->reports_supported |= STD_MOUSE | HIDPP | MULTIMEDIA;
 		break;
 	}
 }
-- 
2.43.0



