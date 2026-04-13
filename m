Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D4C2472B6;
	Mon, 13 Apr 2026 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097950; cv=none; b=X0K6kEDhEKAvPNar0+tj19DW3qf0oeolK8f6E2H6LAAcRaVdzwTTNC2fseSlj/SFJYAFvJ/PY0wuSI1Vls7a03gS789ZvtdV5W0aBEdsyGSAB1GzSHvZQQ0EeJKsHCQqvRnBVnZDrcOXOS3aJyKnwh9BxfsXZDZULaTJkFJuTB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097950; c=relaxed/simple;
	bh=k4nPay9f0VxCgvFIolFKgy7x9V5cRhuhcfa8kne3ltc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KTO8rst3FcICWjTrb8EI35/v4bJu+es3KbRgP8oUDgiHAyDXlE9o8yiHRxcjLHJ99oIUpMZoxMOJ6oCmRRo7CDrQDldLuXC9qoiNj+FM3tEMd/iY4NVvrgYNEy+VDw73Jh/UiJh4xl33Ctn0dvQevYqgFKwqdvIESswPXR/BePU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvYAZt1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvYAZt1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A47CC2BCAF;
	Mon, 13 Apr 2026 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097950;
	bh=k4nPay9f0VxCgvFIolFKgy7x9V5cRhuhcfa8kne3ltc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvYAZt1U+xAB/a1QZ/+0sYj8MoF+ghr17DylvpgsVyBQZo9n0LHLJEL5jgWDo85Hr
	 gDxyWCCSXk5Mn+jI1XVT88OMijb12saGGOKyeLCzL81BBCobGYHonfV8wmLBhg3Ui3
	 WtYRcqE88fOJgQ7MJBUwWcrlFe28r3daTa9v3Z/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/570] HID: magicmouse: avoid memory leak in magicmouse_report_fixup()
Date: Mon, 13 Apr 2026 17:57:15 +0200
Message-ID: <20260413155841.887511814@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 91e8c6e601bdc1ccdf886479b6513c01c7e51c2c ]

The magicmouse_report_fixup() function was returning a
newly kmemdup()-allocated buffer, but never freeing it.

The caller of report_fixup() does not take ownership of the returned
pointer, but it *is* permitted to return a sub-portion of the input
rdesc, whose lifetime is managed by the caller.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index df5809cd4b637..2eda56779b4c4 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -934,9 +934,7 @@ static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
-		if (!rdesc)
-			return NULL;
+		rdesc = rdesc + 1;
 
 		rdesc[0] = 0x05;
 		rdesc[1] = 0x01;
-- 
2.51.0



