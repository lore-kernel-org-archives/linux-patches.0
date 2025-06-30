Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F11242923;
	Mon, 30 Jun 2025 21:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317222; cv=none; b=mfwS4cSmB9ombRbcdEi+26X1O3l/EGy/NL1g9a/ElnprrLb9pHmeaH1E61to7DrrHa0fcI8/d4LvlQgBrtATWCmdJpigV0ByC3C5AlF+b40Ot9abp4JbEw5M1NrwjdpXCtiaNXUoWy6kub7mVMZFCwrbPqxWXdv+eDfke2I1+ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317222; c=relaxed/simple;
	bh=tnnawT7u9CrmsJD2S/+iu+DIDoKAVCHqixEtZFyRts4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u2l0Z5cjWhH9RalvURgEwHMYonk7WABtTsnx+kPhumx2nrcjcpuz1v+y0c7EEF6MaDMNBCaA8XizPcDToCVjTjGYvQl9dMTr0mlNMDgZKXJ8N6cuqryzskeabKIzUduhaossKB81G/9svq+ymJIlT9k4giqZnaltOgX6nSt7EWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVXMX0r5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVXMX0r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F29C4CEEB;
	Mon, 30 Jun 2025 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317222;
	bh=tnnawT7u9CrmsJD2S/+iu+DIDoKAVCHqixEtZFyRts4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVXMX0r5wHJsMtVBnmOyqwfbxKA/zFOSAtLuz+7xK+ws8PMiJRkQyeJejX6Ab6NFB
	 /BPoIrmKETLPLoeGst84fjHmn25WFkdjeFqolgZfdXBUKUQeqGNiw2rrnCCNODn2uV
	 PMHwfVJNRJWd0gSvla02OObjszRgbrFLeVN26iwcWtqijZ3ZVAUr0+0dULmjDpULKg
	 imgxFd3Ihq1oK/J+KljLD1ScAs0Z71P5WNFLYa2GcKLFAyieKCiacSRLVKSMSpZFVM
	 Tyqj5dKqYzRyp8cgjzA2hSe9O8wAFZIf7Lzmk/Ppu63SuqtIij7JDoc3Gxt9rwcPSQ
	 QiLwWFBcFkUng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Pitre <npitre@baylibre.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	gnoack@google.com,
	tglx@linutronix.de,
	kees@kernel.org,
	aha310510@gmail.com
Subject: [PATCH AUTOSEL 6.12 16/21] vt: add missing notification when switching back to text mode
Date: Mon, 30 Jun 2025 16:45:31 -0400
Message-Id: <20250630204536.1358327-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204536.1358327-1-sashal@kernel.org>
References: <20250630204536.1358327-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.35
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
index be5564ed8c018..5b09ce71345b6 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4566,6 +4566,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5

