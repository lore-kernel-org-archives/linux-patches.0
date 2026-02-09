Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C70837756C;
	Mon,  9 Feb 2026 14:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647316; cv=none; b=HTSTAhWcT2wZxadjgqT0CzjnyrwPjo1yl3XttkYRXH6qcbuZpYU6D8eLGgYR2Sgb16khKXsSOoeAtjwksFR2B+NptvbqEjFDQYbfRPSyuRjYWT3TYOE7EFSFp/BO2FcwfSbjKW6PnJIFoWdHD09fS2fqriJjOjReAACkwTx2e38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647316; c=relaxed/simple;
	bh=g9NwYOeoX/aCesVi4yDya4LskAd2fY7FUr9hYGJb3CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c34eQYTGhKXpAN9NeN4zpyatRTLrS8fmWruHzXZqCPuW8KPvWpl1XyYg0zBWofby5Q8MVql3XFdkjetdVpThtqwzPQwwdnyrfRWNfMqyar/q5m2iFMnR7AWzNToY/NUZEq7csmABIunqYx16fzA6yMnNlFbDgFLw3AX8AQBJksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUaPvcpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUaPvcpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E87EC116C6;
	Mon,  9 Feb 2026 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647315;
	bh=g9NwYOeoX/aCesVi4yDya4LskAd2fY7FUr9hYGJb3CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUaPvcptePLhPusF4L9fpWTZnYfJ9MHifvzX367TssrLX1Z/EYT5cCoonVKXzGRO8
	 u/MjffNPqKT4L1Gee4cD3gZHpm46ZymGq44EXpygG7LHbeVHuF1PCGPN7ab4oGSiZL
	 tQDwJJLuBb5/jMPd9eq9vBeRbIgbJ3lohDcU5Ix4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	DaytonCL <artem749507@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/175] HID: multitouch: add MT_QUIRK_STICKY_FINGERS to MT_CLS_VTL
Date: Mon,  9 Feb 2026 15:22:17 +0100
Message-ID: <20260209142322.761192979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaytonCL <artem749507@gmail.com>

[ Upstream commit ff3f234ff1dcd6d626a989151db067a1b7f0f215 ]

Some VTL-class touchpads (e.g. TOPS0102:00 35CC:0104) intermittently
fail to release a finger contact. A previous slot remains logically
active, accompanied by stale BTN_TOOL_DOUBLETAP state, causing
gestures to stay latched and resulting in stuck two-finger
scrolling and false right-clicks.

Apply MT_QUIRK_STICKY_FINGERS to handle the unreleased contact correctly.

Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/1225
Suggested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Tested-by: DaytonCL <artem749507@gmail.com>
Signed-off-by: DaytonCL <artem749507@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 179dc316b4b51..a0c1ad5acb670 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -393,6 +393,7 @@ static const struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_VTL,
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
 			MT_QUIRK_FORCE_GET_FEATURE,
 	},
 	{ .name = MT_CLS_GOOGLE,
-- 
2.51.0



