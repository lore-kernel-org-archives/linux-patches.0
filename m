Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075FD30B53F;
	Mon, 13 Apr 2026 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097185; cv=none; b=T/AcS75ZPhEk4Wk/adOmN9r8FRuyCknvtVwvbSyK0/JaLDg1a0QK+6gnjFeQEPfZuT31feHuobgNZB6Ton3343yw0DQFUUy9yGaJzw1MAk6Re5yEW3RFb/zK7rSygGRwnsDR3edroCtqOxZLA8dCJ1mqNIE26qYH/IdE0bjLg0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097185; c=relaxed/simple;
	bh=yUDHluQa83fTCOKpsDnPpefv6fFwI8VrNvCmyjTWeDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs9Dz81QMYPp9lG7Xl6A42CMvfgCLCGi0LhR/kb8FQj2Tm1DT6B3Cvlz8729x4XdpsiVKUQctGuTtske4xDpS4iUrLnXjdMXQcJXRMHrxcZC3NIbKVRxU/7kCowKLnkRvUIGK6Fjopabv5801KFbJKPaXqRTxc31z7PlynhYhGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhZa4D2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhZa4D2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91844C2BCAF;
	Mon, 13 Apr 2026 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097184;
	bh=yUDHluQa83fTCOKpsDnPpefv6fFwI8VrNvCmyjTWeDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhZa4D2GFPMEPATeQn1bh9WnLzwrHC9cXlmtn5nM5AeqvC/P3Maoseo8L3HwI/hwz
	 scy8Ay5+9AO7acjS9UGMdBikv4TSvbRkj9r05Lptg/UE+wwtn5Z0c2DoF6Pzwy4Fzv
	 eGyi8FmhorGc1wROjF2SQZ5DsMPBuo92OM+K24nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/570] fbcon: check return value of con2fb_acquire_newinfo()
Date: Mon, 13 Apr 2026 17:52:49 +0200
Message-ID: <20260413155831.855179664@linuxfoundation.org>
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

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 011a0502801c8536f64141a2b61362c14f456544 ]

If fbcon_open() fails when called from con2fb_acquire_newinfo() then
info->fbcon_par pointer remains NULL which is later dereferenced.

Add check for return value of the function con2fb_acquire_newinfo() to
avoid it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d1baa4ffa677 ("fbcon: set_con2fb_map fixes")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 0039441f3769b..f4584681fa43d 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1008,7 +1008,8 @@ static void fbcon_init(struct vc_data *vc, bool init)
 		return;
 
 	if (!info->fbcon_par)
-		con2fb_acquire_newinfo(vc, info, vc->vc_num);
+		if (con2fb_acquire_newinfo(vc, info, vc->vc_num))
+			return;
 
 	/* If we are not the first console on this
 	   fb, copy the font from that console */
-- 
2.51.0



