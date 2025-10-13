Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E6B30C365;
	Mon, 13 Oct 2025 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368834; cv=none; b=ELF/E9FygauaGGdw7hXSAtrI5xIQBrD7TC+vy7qpeqVgxZIZ6dXCt/9rjQCvDT6xqz+y0kfoqU4QO+GbDlf0iQRQoXLYfdlwRZp/hUulXke/NLP0N9ZwJEmbbZeSDpU27U7Okowne5eMD93H6CKrA8KULvlvmdUu5KU600PNJcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368834; c=relaxed/simple;
	bh=eXIAg6Il2/1inf5eKNflVbBtP/fx93NF6JmxWUtRwUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlKi+GyIShdMWFNX30RSNps7bcRFZ8z0Cyjm+s3OtzHWxq6NVlRDb+RkPC/3h+/5WSxSkvZVLJDN0J17d7++3jZgr2b83Fz7T7sM2apO6ttF/16gwYUCYpsovr27LVXmPITLk87aQRZxJO//0bu0QKM5rVApkGVWl4vUSv7qtoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7ixcOaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7ixcOaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A78C116B1;
	Mon, 13 Oct 2025 15:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368834;
	bh=eXIAg6Il2/1inf5eKNflVbBtP/fx93NF6JmxWUtRwUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7ixcOaIvjHQ43USSAPzzKoF+2s3tBmlLwnYI8qCUo5epjG3Pqcpnx4idljt2ZHf5
	 YnQra4n052bnoP0cHfNPsDwgs3BuvXIn6sS0zbKEMSB3YJL+UF5Mdlplk0Fta/kYSi
	 59ggGG/Nwtqcoy2muyC00oJLuPt/cEK1jgs6YCaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 018/563] gfs2: do_xmote cleanup
Date: Mon, 13 Oct 2025 16:37:59 +0200
Message-ID: <20251013144411.950515486@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2309a01351e56446f43c89e200d643647d47e739 ]

Check for asynchronous completion and clear the GLF_PENDING_REPLY flag
earlier in do_xmote().  This will make future changes more readable.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Stable-dep-of: 6ab26555c9ff ("gfs2: Add proper lockspace locking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 68e943e13dd53..54c011ff00ddc 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -794,6 +794,12 @@ __acquires(&gl->gl_lockref.lock)
 		ret = ls->ls_ops->lm_lock(gl, target, lck_flags);
 		spin_lock(&gl->gl_lockref.lock);
 
+		if (!ret) {
+			/* The operation will be completed asynchronously. */
+			return;
+		}
+		clear_bit(GLF_PENDING_REPLY, &gl->gl_flags);
+
 		if (ret == -EINVAL && gl->gl_target == LM_ST_UNLOCKED &&
 		    target == LM_ST_UNLOCKED &&
 		    test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
@@ -801,14 +807,10 @@ __acquires(&gl->gl_lockref.lock)
 			 * The lockspace has been released and the lock has
 			 * been unlocked implicitly.
 			 */
-		} else if (ret) {
+		} else {
 			fs_err(sdp, "lm_lock ret %d\n", ret);
 			target = gl->gl_state | LM_OUT_ERROR;
-		} else {
-			/* The operation will be completed asynchronously. */
-			return;
 		}
-		clear_bit(GLF_PENDING_REPLY, &gl->gl_flags);
 	}
 
 	/* Complete the operation now. */
-- 
2.51.0



