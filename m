Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272A212C46D;
	Tue, 30 Apr 2024 10:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473955; cv=none; b=LBDTNTarjIDi7kSrkk04rNm54cUmeKr+GnDzkeXxBbLGgoQgQkfGZShw8ggWHPm7Z0hD6bzjw4r0jmY7emPIuioOycNp63oLHbSmqS6tQNot+pS3anTgfBs2sGVNPluzW8/7zKSI8nye3e5mA9dmZCojgjWtWQc4lq8Lk7oIrEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473955; c=relaxed/simple;
	bh=6q4YuXVWY1uR/Re224ukMBVCosPBIMczk58ozihi0mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2tFeefS4vGWb7Ke85TxIatQydBOc+AiL/ZuMqGd7WaOr8Tdu6lYmyTxMPrVDkHfJ90d7AqOP6QUZJ9qIgvzADR9ZPl/UwT3gvUmocs0/bzFuJvoJEDRsper+MlcYPE3wHZ+oWKMQ+6Hi3H+K/ftbbWlNHf7bKtcQSrugahOlwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ng9K+Hi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ng9K+Hi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44D5C2BBFC;
	Tue, 30 Apr 2024 10:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473955;
	bh=6q4YuXVWY1uR/Re224ukMBVCosPBIMczk58ozihi0mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ng9K+Hi9Lz6ZO6YGv7fwJ+AjIHB4VQT7ehMKAl0TdyYeaewM2UPCx456YhJmChLQw
	 oRIeJjtVucPtbdyqyObBxqIlby7Ig+9BTSx8EkRlOP44QKCOrJJslkokNO+eJLhZry
	 E447I4tBsBEmcI36EqnUFCU9hhu96WXqol6yEnUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaraslau Furman <yaro330@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 005/228] HID: logitech-dj: allow mice to use all types of reports
Date: Tue, 30 Apr 2024 12:36:23 +0200
Message-ID: <20240430103103.968985923@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e6a8b6d8eab70..3c3c497b6b911 100644
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



