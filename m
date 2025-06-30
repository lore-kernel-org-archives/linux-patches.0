Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8983242923;
	Mon, 30 Jun 2025 21:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317267; cv=none; b=qcLg9p3O1xPGRa7AYur5OH2hEzEs0FxPHWdNBiY15KjZc4FlwU2D6unMwKxti68IKXdvHJtrX4DwVRQWtReT27ijvL/hOu6krsMnJ4NY0eq5obCYB1a/jL465Ye98G/L7Gd2I6lK235nrJxVwFmHbFytlo4Um8aa0sYtq2Y1+kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317267; c=relaxed/simple;
	bh=xjNBpiOCq+Mv68jIpZbd9U8iAO5Zre/13Ee31ndIhZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YhfwV8sjT1PgKKFfur0E4aP5KzUNV7g+vAqg/yYahtigh2CW2TCyjdKnJiagLP1XfIGb3BUOhz1s3qhYvyyeS2Tyip6PCmuOAFKMVC+YPLiZANrYPpzGAnDl7rsbCTn6IAu3KYvufRLvUU4m/Muf849zfV53Xpnm+znfaVNv3zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X59pw/G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X59pw/G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E1CC4CEE3;
	Mon, 30 Jun 2025 21:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317267;
	bh=xjNBpiOCq+Mv68jIpZbd9U8iAO5Zre/13Ee31ndIhZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X59pw/G8twz7WgNMkEmPyxODYuayUWlTTAibIYgDiN7mTZXO2aXCykhXk7CjJkDXj
	 Te4h26AGiGAQ/ZqmxQ6Y2W0CK7jxaw0zphQCk/T4DZh1MN+YzIh+040p57UQRNQ1gY
	 v4/AP3PlyyqZ5R0VHPV5Q8P8mp2bFaCvFWcuhPOdmOVq6d4whinXW7Yy3I1mRWvARz
	 ADMUzHfjpqFpU6SZ8a1ea9+kmUc+peQGAXTbZdl0wnr2/iPrw82PmeuZ+nJcYHqntH
	 YjPbLG3axtQlgrnjWc9Tr0zzRhTZWZNfaLIwOCT6hpeLq86ajwUWw36vdzIQRonCoF
	 4g2HxV4Zcit4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Pitre <npitre@baylibre.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@kernel.org,
	kees@kernel.org,
	tglx@linutronix.de,
	aha310510@gmail.com,
	gnoack@google.com
Subject: [PATCH AUTOSEL 6.6 11/14] vt: add missing notification when switching back to text mode
Date: Mon, 30 Jun 2025 16:46:36 -0400
Message-Id: <20250630204639.1358777-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204639.1358777-1-sashal@kernel.org>
References: <20250630204639.1358777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.95
Content-Transfer-Encoding: 8bit

From: Nicolas Pitre <npitre@baylibre.com>

[ Upstream commit ff78538e07fa284ce08cbbcb0730daa91ed16722 ]

Programs using poll() on /dev/vcsa to be notified when VT changes occur
were missing one case: the switch from gfx to text mode.

Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://lore.kernel.org/r/9o5ro928-0pp4-05rq-70p4-ro385n21n723@onlyvoer.pbz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real bug affecting userspace programs**: The commit
   addresses a missing notification that prevents programs using
   `poll()` on `/dev/vcsa` from being properly notified when the VT
   switches from graphics mode back to text mode. This is a functional
   regression that breaks userspace applications monitoring VT state
   changes.

2. **The fix is minimal and low-risk**: The change adds only a single
   line - `notify_update(vc);` - in the `do_unblank_screen()` function.
   This follows an established pattern where `notify_update()` is called
   after VT state changes to notify userspace watchers.

3. **Consistent with existing code patterns**: Looking at the codebase,
   `notify_update()` is already called in similar contexts throughout
   vt.c. For example, in `vc_do_resize()`, we see:
  ```c
  vt_event_post(VT_EVENT_RESIZE, vc->vc_num, vc->vc_num);
  notify_update(vc);
  ```
  The same pattern should apply when unblanking the screen.

4. **Similar commits were backported**: The historical commits provided
   show that previous fixes adding or correcting `notify_update()` calls
   were marked for stable backporting (all three YES examples had `Cc:
   stable@vger.kernel.org`). These commits fixed similar issues where
   userspace poll() notifications were missing.

5. **Clear symptom and fix**: The bug has a clear symptom (missing
   notifications when switching from graphics to text mode) and a
   straightforward fix that directly addresses the root cause. The
   `leaving_gfx` parameter in `do_unblank_screen()` specifically
   indicates this transition scenario.

6. **No architectural changes**: This is purely a bug fix that restores
   expected behavior without introducing new features or changing the
   architecture of the VT subsystem.

The commit meets all the criteria for stable backporting: it fixes an
important bug affecting userspace, the fix is minimal and contained, and
it follows established patterns for similar fixes that were previously
backported.

 drivers/tty/vt/vt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 6bd1a7785e888..6897bfc3dafbd 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4392,6 +4392,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5

