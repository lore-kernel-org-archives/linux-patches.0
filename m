Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B631F3B97;
	Mon, 30 Jun 2025 20:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317161; cv=none; b=BN2zAuVpujnDz2wsOeVGLcrlp1srFlWRNx5Rsp7su72mdPFp8/f9A4aN1ylyF6LNZ0mjk93OC8RQWNKbTqT8blc8oc6Wz+Yt4+Ov/J9ak1exg1v86QQLbSpGoPqfhHzpSknme2Z75MGTZcTropR90USeADP/kQSBsnKYjVjrbJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317161; c=relaxed/simple;
	bh=yLjU96EOG6xoc9IO/0PWKIKh4+wuFkh7rGtMSVFAiD4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OInKaGgYpGX255Xz6QijsERvGPLtxQuekyBs7MgE26EJCOOMBahce02xZIb/hA7a3wZ7ssoqz6JNK2ctEBBCUepaQKsDVU/9mBB0qUEwZZa2zSEOxnhwfRuUmGkFzHUVEp8SNs/OZTr2YvZAFyMmUv4uYBUhVv5oobYWFn27i08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1T5NXr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1T5NXr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E19C4CEE3;
	Mon, 30 Jun 2025 20:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317159;
	bh=yLjU96EOG6xoc9IO/0PWKIKh4+wuFkh7rGtMSVFAiD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1T5NXr4YglnIQ8RlMF82WHuDGtwr/2TETH87Rrdgsfojj3/HMWAVwffbpu+g4W8U
	 U75L/d0B/bd0RQAqRcvFey0e38OqfQajozasmpUVzcWkj4mGlUpIl/B+C40f+kRzuo
	 rHoolXLPYtxjCW9+11VssO+l01siAjaeV6LuZhAVaQv+RFD6SKR0ONW06UhHhAVVfg
	 AzJ9jNH1VqRm5DLN0XtqdwkZttS7QE3qhAuDrFhq1ODQ6uoRaMk7u6JZ+QEuq/XvWL
	 eWZ3nSYO73w42RLolrabQQ1Txjq3Vi3GTtJBB3jEirkvDyqKZv8OJt8qDLRa52Wqx2
	 VCVa+i+PS94vA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Pitre <npitre@baylibre.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	aha310510@gmail.com,
	tglx@linutronix.de,
	kees@kernel.org,
	gnoack@google.com
Subject: [PATCH AUTOSEL 6.15 18/23] vt: add missing notification when switching back to text mode
Date: Mon, 30 Jun 2025 16:44:23 -0400
Message-Id: <20250630204429.1357695-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204429.1357695-1-sashal@kernel.org>
References: <20250630204429.1357695-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.4
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
index f5642b3038e4d..ed5bbf704a7d1 100644
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

