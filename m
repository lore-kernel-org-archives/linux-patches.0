Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E945D27F4F5;
	Mon, 13 Apr 2026 16:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097948; cv=none; b=jvKjnAONl1T9BZeqs+ial6dmPU86RowQlnsTpCohHhcAAfZzTZdjcJbjnF9gxWRTojb05ad+9W2agOrDMBHwz0qu1djOtcCp+9Frd6LsLJ+ysi73BwNj4DpBX6M3Y2eWaAxxe2uU+CL7gJz3QKSnPGkjn5iktYtQB9ZoSM/+wgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097948; c=relaxed/simple;
	bh=YixC41BMEgOl2HLfCwetbAQz6ppEP9Rd98ae6+Zwu0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwLZy7sIz3P+PhSzOMiOfuEm36GPj1kUfk2dB9Kvm/K8i23cyy/6BptGurQ5BdlbQopdXc1K1BRgkVJOA2iUXewImH2uNtvEQpuGmjpBnvKC72Y9kxBKHB1uTSte6HVN88WriB4vAFwHqHr2RbP0jfruHoIWHfy7xCRTlBuWBoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYJ18V6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYJ18V6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFC3C2BCAF;
	Mon, 13 Apr 2026 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097947;
	bh=YixC41BMEgOl2HLfCwetbAQz6ppEP9Rd98ae6+Zwu0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYJ18V6mX4T+6A3yv0eW5aGvqnOvh8jUQ/4C+B+KsJLG3ItF0wlA/I/4/VKi5eKpx
	 5Pw4lgODrkkPOYhLnF9R4+5g6lNJcdCA+H/RPr3rUfKjhTSoexb1yKVVU1sQqaugAo
	 EQxuspY4VYp8EAppJ8DntKq9HUxEy7L9Qn0kvtiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Lehmann <lehmanju@devpi.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/570] HID: magicmouse: fix battery reporting for Apple Magic Trackpad 2
Date: Mon, 13 Apr 2026 17:57:14 +0200
Message-ID: <20260413155841.850170870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec7b4f7b3d8c9..df5809cd4b637 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -930,7 +930,7 @@ static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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



