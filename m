Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686998486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34D5C433C1;
	Thu, 27 Oct 2022 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889899;
	bh=7mS6AogrB3Auz6vKpRRYMVdGMqLsw0W/0pjha5JNdx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/m+XOQZwudthHeknoNZnTsgcyGyOEAvjMN3SDTJe7ZgJB8q1aibhptpBigqvrw3k
	 SKh68rEdz3x+8E4K5DkRPPmLwwxaFQZlJrqC/O/4dm8y15+BXjBtZGUpcwQp3RY/MF
	 TTtHj91rtUvymmisUmuyWnGhEogq97WZoD/+tELw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nulo <git@nulo.in>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 41/94] HID: magicmouse: Do not set BTN_MOUSE on double report
Date: Thu, 27 Oct 2022 18:54:43 +0200
Message-Id: <20221027165058.787427305@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit bb5f0c855dcfc893ae5ed90e4c646bde9e4498bf ]

Under certain conditions the Magic Trackpad can group 2 reports in a
single packet. The packet is split and the raw event function is
invoked recursively for each part.

However, after processing each part, the BTN_MOUSE status is updated,
sending multiple click events. [1]

Return after processing double reports to avoid this issue.

Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/811  # [1]
Fixes: a462230e16ac ("HID: magicmouse: enable Magic Trackpad support")
Reported-by: Nulo <git@nulo.in>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221009182747.90730-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 664a624a363d..c9c968d4b36a 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -480,7 +480,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);
-		break;
+		return 0;
 	default:
 		return 0;
 	}
-- 
2.35.1



