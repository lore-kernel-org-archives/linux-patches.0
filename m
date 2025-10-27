Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B2630E0C0;
	Mon, 27 Oct 2025 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592792; cv=none; b=N0lJbhSQzCbUR9qWCSJD/2p6pwSd3UfKX9/7T0DBq9vP1zbhAQ40DxalauESR8Gcyi+/Ok2GKO4z8h0h/1lUeomojg8s5COet2ia6BgF0fVXvzM0WMXH8Wj+IZzDigssU/56NVoCAFcPMpgGkWkuRuWYQXQk8CKiu2nxfAK9oag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592792; c=relaxed/simple;
	bh=eCwOg9QlfF1O7Ydl+P8xcU4OJz457qRHsrFB02UU+3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZtJVRN3Ij00Myxa2IVbr+J7keoXSo58rNXuJQUAVvgirvgYY9jFf2Ol3N6cEg6ZB2dld7dzA9lMGpMCxanWJ2KoumrwM7ib7VnM5Khqgl3Zy6xx/5+abg8EL1+TvKYXLx2jbv/KEmuUodh9PHh7MmO6pOuUq0ibTzRzcxbJQb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaM3Ut8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaM3Ut8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34398C116D0;
	Mon, 27 Oct 2025 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592792;
	bh=eCwOg9QlfF1O7Ydl+P8xcU4OJz457qRHsrFB02UU+3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaM3Ut8xiV48p8Fr0OM2xk7Hfqz0aSzXatQcwKKF8GJDL1dU7sAYs/M0IIi3JFuG6
	 CwLjzyPv59xx6QBC3ldvoRK3NXgkIgSysOCBH2tUD8jAHLyTelck6co9gUUVhLKFEg
	 a6NeOUyGo85tu1bFMkgqyDq9GqcKInA4NodViRCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/117] gfs2: Fix unlikely race in gdlm_put_lock
Date: Mon, 27 Oct 2025 19:35:40 +0100
Message-ID: <20251027183454.327240375@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 28c4d9bc0708956c1a736a9e49fee71b65deee81 ]

In gdlm_put_lock(), there is a small window of time in which the
DFL_UNMOUNT flag has been set but the lockspace hasn't been released,
yet.  In that window, dlm may still call gdlm_ast() and gdlm_bast().
To prevent it from dereferencing freed glock objects, only free the
glock if the lockspace has actually been released.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lock_dlm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 9e27dd8bef88d..38ea69ca2303d 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -321,12 +321,6 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
-	/* don't want to call dlm if we've unmounted the lock protocol */
-	if (test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
-		gfs2_glock_free(gl);
-		return;
-	}
-
 	/*
 	 * When the lockspace is released, all remaining glocks will be
 	 * unlocked automatically.  This is more efficient than unlocking them
@@ -348,6 +342,11 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 		goto again;
 	}
 
+	if (error == -ENODEV) {
+		gfs2_glock_free(gl);
+		return;
+	}
+
 	if (error) {
 		fs_err(sdp, "gdlm_unlock %x,%llx err=%d\n",
 		       gl->gl_name.ln_type,
-- 
2.51.0



