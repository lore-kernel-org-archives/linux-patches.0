Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403B27B328;
	Tue, 30 Sep 2025 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245491; cv=none; b=bbKEks0Q4MOXr7Wb9rcuFWU5NqLYXkqV2x1YOLNkajEYQuQ2dtQaxl8toULHuYeYEnIV++3Dx8kWeTPoqDr9U4l3fMLRyBqTYXD26djpL+ru6kj9/TlHZ9qYTHg0TcKFNKMyScrAG4FF6dIl2XcLn7MIhckNlDmrfVPvK7n/DOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245491; c=relaxed/simple;
	bh=wmrFloTB65uWCWG+AX6D48EoEOQ61Q90TI+akZC0y3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1hKCz3CSSd7TXuNgk/zkvEJoZ3q3iUPjXnetxdDFWz327+zt39dzvXxTvwG3E8/jK/GwD2NEi0jgea7UOWSpd1RXTIwugnAmgi50qYGBxy/BEyN4JvvKhFgP2da/9WeVHhALiQHwaRnBP/dFdJKwENrG8VSPBGRbDAK9nwmfYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjI9othN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjI9othN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2945C4CEF0;
	Tue, 30 Sep 2025 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245491;
	bh=wmrFloTB65uWCWG+AX6D48EoEOQ61Q90TI+akZC0y3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjI9othNPi4V1kCJvEnC8RNx5sTUC3HrJ1nC1V8GaWaxruGWgr30Ui/Mnr3mdXU6Z
	 y944cjyH9iKttNh7ZdFd4Eop5WsSoDmI5Oov+f5r4jBv1LyZZsImZVr34GCTlHMUwG
	 I9SU/Qm3k9IZo25FPmryG9v/cKSBXqPMO/7jZB7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/73] HID: multitouch: take cls->maxcontacts into account for Apple Touch Bar even without a HID_DG_CONTACTMAX field
Date: Tue, 30 Sep 2025 16:47:13 +0200
Message-ID: <20250930143820.948254301@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit 7dfe48bdc9d38db46283f2e0281bc1626277b8bf ]

In Apple Touch Bar, the HID_DG_CONTACTMAX is not present, but the maximum
contact count is still greater than the default. Add quirks for the same.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d0b2e866dadaf..8e9f71e69dd8c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1322,6 +1322,13 @@ static int mt_touch_input_configured(struct hid_device *hdev,
 	struct input_dev *input = hi->input;
 	int ret;
 
+	/*
+	 * HID_DG_CONTACTMAX field is not present on Apple Touch Bars,
+	 * but the maximum contact count is greater than the default.
+	 */
+	if (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR && cls->maxcontacts)
+		td->maxcontacts = cls->maxcontacts;
+
 	if (!td->maxcontacts)
 		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
 
-- 
2.51.0



