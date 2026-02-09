Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BDF27CCF2;
	Mon,  9 Feb 2026 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648418; cv=none; b=i72fuIjG1SQEadWZLpkwxYdEiNjZWTLS0VFIAOquPCemL6x02OSYGqy3kpVBiRrWRXR6dGIPq5yvrIMQBgZfDO5S04uLbSJMcd5MOS5dCon8NX8s2rnAjLn1e8PI4EB8vDkIqAg0S++ygGXI/7tJVobeTeyevJlalvAUKmJAPUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648418; c=relaxed/simple;
	bh=Rxoh2ROfi97rk3fxtyd800ktE5YLYrpCxV1LICzgBis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOjagITjaFfQTvdccT1loxyhLauAcylL+x9eHN4KkFwCa9kiZQ/FKEh9mKrn6iXxd6OFJ/EFakEFlOoqThN5pMo3XzIhD2c1Dsk8IdObtBnrdj5vhHFFgnJvRfU1lTw748LsRwR010z5PoOqCyQ4BAMtpIjFEzrCcf7J5zfugow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvnjM9hJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvnjM9hJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A198C116C6;
	Mon,  9 Feb 2026 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648418;
	bh=Rxoh2ROfi97rk3fxtyd800ktE5YLYrpCxV1LICzgBis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvnjM9hJ7wWzfRCF5JlzSHnSLaKP9IT9/F1Z2q6pE0xtGFunF+jrpd2sKuH8RH+GI
	 pO71OEs/k2S8IZ65wBgozzbSrMvaZF+EaCp3gMTD4dfIMZrW2Sxe7kWqYAwdxGkcC/
	 +5MicB2U6jGNcO5RTPIx6yWJ50nZqa3MUoeCkdw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	DaytonCL <artem749507@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/86] HID: multitouch: add MT_QUIRK_STICKY_FINGERS to MT_CLS_VTL
Date: Mon,  9 Feb 2026 15:23:55 +0100
Message-ID: <20260209142305.941832012@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b9e67b408a4b9..6d9a85c5fc409 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -379,6 +379,7 @@ static const struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_VTL,
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
 			MT_QUIRK_FORCE_GET_FEATURE,
 	},
 	{ .name = MT_CLS_GOOGLE,
-- 
2.51.0



