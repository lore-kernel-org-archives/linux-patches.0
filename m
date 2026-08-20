Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1F37BE7A;
	Thu, 20 Aug 2026 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238194; cv=none; b=UcEgIWnRW9ojK7lHki8UiMglxzqlEW1FbkxZUnkFNb6LuvhdJsl9Zo9pNQWt8ONIkF/0CQGYHCj8y8XWiglWdOZ5z4PjGCY3epTRGTGJOBBMzXjO+nY5WpX1WyXsj9dbZHXS9zEQlAIk1WbGgPWC3PpRj2TRiA3vN/4KYc7JVSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238194; c=relaxed/simple;
	bh=J81FEn1BbNMyPG33diJX3lFvwgLyJD0T1av/EtSa5/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9XoH8oJuFRfdzM+Ys3/3PbtgWAvJQEJ4ROmoTqp1GD+nnR5+e2g7VQhaDwL6IQQd8TwqZTtmZK96gcWt2h7B7/+KjbRjtBJ80GOFWzwg2IYdg/dXjW8YVqvz4/gzlDDqVghon/NuGkZSE8LFf97L8C4f9PXSraEo604iJMmZ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/Z61H05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/Z61H05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4C41F000E9;
	Thu, 20 Aug 2026 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238193;
	bh=8D6maMpGkmIMOmzYGFcrjV5GJlD+birCBIrYxV1Tyg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/Z61H05lcNnHvjdQycedRjK/Ml4aI13OfnrrdHtt9+egHRTpZEr8kW/QD/Zt5sIF
	 JRcJmN27qnADkfYCqMwHcSEhj/8CxEDzrf2TC4nHIi+XdYqaH9gn+QDnV2yJXjRaRX
	 WfzTDn5Uh6dEO1bkrPixsl7nNEvjdlp0j7g52UT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 024/228] fbdev: clear fb_info->mode before deleting a videomode
Date: Thu, 20 Aug 2026 16:52:46 +0200
Message-ID: <20260820145245.195014871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melbin K Mathew <mlbnkm1@gmail.com>

commit 95e647d2a5304a8fd11f1ba3c8502de700650131 upstream.

fb_set_var() can delete a mode from info->modelist when userspace
passes FB_ACTIVATE_INV_MODE through FBIOPUT_VSCREENINFO. The code
checks that the mode being deleted is not the current info->var and
that fbcon is not using it, but it does not check fb_info->mode.

fb_info->mode may still point into the modelist entry being deleted.
If the entry is freed, later mode sysfs reads through show_mode() can
dereference a stale pointer.

Clear fb_info->mode before calling fb_delete_videomode() when it
matches the mode being removed.

Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 2f1c56e5a7a2..c8aa163b0ecf 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -246,8 +246,11 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 		ret = fb_mode_is_equal(&mode1, &mode2);
 		if (!ret) {
 			ret = fbcon_mode_deleted(info, &mode1);
-			if (!ret)
+			if (!ret) {
+				if (info->mode && fb_mode_is_equal(info->mode, &mode1))
+					info->mode = NULL;
 				fb_delete_videomode(&mode1, &info->modelist);
+			}
 		}
 
 		return ret ? -EINVAL : 0;
-- 
2.55.0



