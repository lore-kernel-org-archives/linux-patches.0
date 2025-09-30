Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE63074BB;
	Tue, 30 Sep 2025 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245964; cv=none; b=CrqnL1UAvxDCL0QKDzb3rZlC7I7tsa3UleeKq0ZKNbIpftLrkCtxbw3XqbLiujXNCPji+LTKRIrGL2UUBCL0iTFn5jY6SMn3HyWD9zRToKivKHXGfYnKFIQOBq1ly999NL1fmjsIq0rzRdz0ARdrXtwTJ8JvzU8fa+bFCi9EaUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245964; c=relaxed/simple;
	bh=KHnartRliE9v56hxSjVTpSva5mwOa1gOu3CVeLzH+gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL6cZ5cnYGjx+YsFyLBTtzYU9Hfdd1dgZYwSJps/iS7UpSz0IYpcCZqo576qnl0Iogr7rkWE4ACNzdrVWLkIVqMX8+6uZHP4pATXM+PR5kYnCEYL1t1g7OJJPJHeNsxUE1JE2TnecSPljDEaYUPR7uOOzi+/Xz/g5P0/y7VOC7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWzWgZdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWzWgZdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD04EC4CEF0;
	Tue, 30 Sep 2025 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245964;
	bh=KHnartRliE9v56hxSjVTpSva5mwOa1gOu3CVeLzH+gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWzWgZdRiRuH/YU3pGOr9QjGyHuHM/RTTqdr0KhU/k4r2M9gJYM9V97/EqCIod2Oi
	 gOG61Yj7CpydmDAmiRtjKyVAENsB/JsS7bLoQKHUKcACKhv9a/jlplxcPFX/5Yws6L
	 nzxTUUq2bHs8WTx/bz/FdL9TidIe1pOxTOxC4CM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/89] HID: multitouch: support getting the tip state from HID_DG_TOUCH fields in Apple Touch Bar
Date: Tue, 30 Sep 2025 16:47:25 +0200
Message-ID: <20250930143822.336923936@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit e0976a61a543b5e03bc0d08030a0ea036ee3751d ]

In Apple Touch Bar, the tip state is contained in fields with the
HID_DG_TOUCH usage. This feature is gated by a quirk in order to
prevent breaking other devices, see commit c2ef8f21ea8f
("HID: multitouch: add support for trackpads").

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index be2bbce25b3df..39a8c6619876b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -819,6 +819,17 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 
 			MT_STORE_FIELD(confidence_state);
 			return 1;
+		case HID_DG_TOUCH:
+			/*
+			 * Legacy devices use TIPSWITCH and not TOUCH.
+			 * One special case here is of the Apple Touch Bars.
+			 * In these devices, the tip state is contained in
+			 * fields with the HID_DG_TOUCH usage.
+			 * Let's just ignore this field for other devices.
+			 */
+			if (!(cls->quirks & MT_QUIRK_APPLE_TOUCHBAR))
+				return -1;
+			fallthrough;
 		case HID_DG_TIPSWITCH:
 			if (field->application != HID_GD_SYSTEM_MULTIAXIS)
 				input_set_capability(hi->input,
@@ -889,10 +900,6 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTMAX:
 			/* contact max are global to the report */
 			return -1;
-		case HID_DG_TOUCH:
-			/* Legacy devices use TIPSWITCH and not TOUCH.
-			 * Let's just ignore this field. */
-			return -1;
 		}
 		/* let hid-input decide for the others */
 		return 0;
-- 
2.51.0



