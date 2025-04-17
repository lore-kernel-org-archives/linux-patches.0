Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC132566DE;
	Thu, 17 Apr 2025 18:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913061; cv=none; b=ufGP9oz6ijEfK73hrWs1mY83k1eau3Ex3v7XMHnzH0ydXUlmclXSjVutrwYuL02dLpJxZI6s0TrX5MaX57RsC53udDJ00hIEbPlOtDWAKsdZNvpmFhaOctJZCax67yLb89RSXXekyxmZDpG24lsa00UVWv10tIQ5AVb0EBDLZ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913061; c=relaxed/simple;
	bh=/M6p9/60PYxWf9Y+xYrkHEXEFm2ITCbXN6Mz613w/o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vk3O0cuC0/Y/RoPXNkf9kdopkwndM6CQOvt9dB8VuTNu5W3SIPnnm65Fy35rpW4k1CvJCfZQ0ud6P+80lXAL+MvnKG2ISbxaqqecS1Kr/aVw76oorPvpdYnNoXwNys6LEGFQM8MAZJ1Ek77k3dPHpCanlR/VO7p450JgoUhWdUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eUjodB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eUjodB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B533C4CEE4;
	Thu, 17 Apr 2025 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913061;
	bh=/M6p9/60PYxWf9Y+xYrkHEXEFm2ITCbXN6Mz613w/o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eUjodB8MDCIyswT9bZdYI5mWDLTzwdqbcpHgoZo5zVLHyI29gvjdw8AE/LHEjrkE
	 qyMDN5+oQZdV/CjwBcUEslJq8MRL8ASnvyGi32uCxz+e6bsmR56GWHORQqUjQAykGk
	 EYncRZyU/dQmuX57RwoFUaKVL5oY2OY7Y+f1/7hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 214/449] HID: pidff: Compute INFINITE value instead of using hardcoded 0xffff
Date: Thu, 17 Apr 2025 19:48:22 +0200
Message-ID: <20250417175126.592685569@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 1a575044d516972a1d036d54c0180b9085e21dc6 ]

As per USB PID standard:
INFINITE - Referrers to the maximum value of a range. i.e. if in an 8
bit unsigned field the value of 255 would indicate INFINITE.

Detecting 0xffff (U16_MAX) is still important as we MIGHT get this value
as infinite from some native software as 0 was never actually defined
in Linux' FF api as the infinite value. I'm working on it though.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 74b033a4ac1b8..a614438e43bd8 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -283,8 +283,9 @@ static void pidff_set_duration(struct pidff_usage *usage, u16 duration)
 	if (duration == FF_INFINITE)
 		duration = PID_INFINITE;
 
+	/* PID defines INFINITE as the max possible value for duration field */
 	if (duration == PID_INFINITE) {
-		usage->value[0] = PID_INFINITE;
+		usage->value[0] = (1U << usage->field->report_size) - 1;
 		return;
 	}
 
-- 
2.39.5



