Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438F51DB148;
	Thu, 17 Apr 2025 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915619; cv=none; b=jpEbQ687SpyUe2u1qIl16zivIhBVQl+i/dFEvOMPT9WkrMHG7Ivx8rE3Yl+fkE7vcAoPg9c2iRmUmDHk9sZBY5YkAOrMUD2K3AbI2HOiAVCxv28+7OI9tNDX2Y0u+kLi94VXcnAYGHG5m1IR06QSD6tNjvJDo6j3YMB8y1dfYFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915619; c=relaxed/simple;
	bh=lg4zXMjiOIROoZ8JRHYyUk/cMFQjqhm3np76Y36/Wc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FQy2gVvSXMFhrNiCkLbeuQGZDJHU/AtI7fTalQ3blqISsgmo0gKXs2TUCY5FaRZBzDntSxqtJwWtijSwKSM+5ufv5eEcwOzEiVY1cof32fP+Ty/Y4cghEuaEPbOoNPJfeKfI0gWyhai0Oo/b/eMNHdPZ5szC42vJFsUrM/kPV58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8IRdisV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8IRdisV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CF4C4CEE7;
	Thu, 17 Apr 2025 18:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915619;
	bh=lg4zXMjiOIROoZ8JRHYyUk/cMFQjqhm3np76Y36/Wc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8IRdisV15Q1k+FApofVbnFIaqJwCl9k7XmFVFmQtasb6uZahp3NFNpH0H5rsxlm5
	 7kq19VF2UiwYf9KTpKt1L+d1ML+ShpMEZoDIVOLMhaZNOAp0KTEpyJ7z/QPg/G0pWX
	 xUaLjAwbJR2Enp96WnRvj5pPFzWE07hPZtDL58pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/393] HID: pidff: Compute INFINITE value instead of using hardcoded 0xffff
Date: Thu, 17 Apr 2025 19:49:53 +0200
Message-ID: <20250417175114.994970462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



