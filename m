Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197EA3A16A0;
	Wed,  8 Apr 2026 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672437; cv=none; b=XMhZIjvm8GVOhwka9eM5+2c19L1oIau5sLv77C2Ud7iwCheAOMzvXNGj6B0M6VTlCa0U1eG8GCvCmwJgvWGWMu//yo8ExcZwamDQEj7vbwFGAVro+STorkpaaMlOhIlh/LB/zi2kmnSxOnvj8tL+fRcOaSs/YPSbRaA/yCSfuWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672437; c=relaxed/simple;
	bh=zsLjqHaKcM8opO6GmCkwpnjLEhiljrA0vURDcQudVtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhG7N9UpVg33ksqLacXcSEwnycj+BSJZydf7rnqmtan3WP6OcP1sbEVNAbA02jRLHSOmYY5vcvpc4yIZeAFxZM4oxm+zjsprrQ2XNeH0DsTjEOlSIyAFmjeKfyio3rsBHy3zKHeQWCDydZsY77SGzR+dLJ87VPqJvCcFUh7QdBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hfat/jHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hfat/jHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A379EC19421;
	Wed,  8 Apr 2026 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672437;
	bh=zsLjqHaKcM8opO6GmCkwpnjLEhiljrA0vURDcQudVtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hfat/jHrIdzU4GXbQ1thzLdkN/7A+GFJ/5kRxMVzHBpWTZc1NUNHQvMfjzNbwuHbY
	 O7s2HMexTVAIjUUvm2nMevdJPrWTRF1fCxK5Z7cod2KAZI4J6uFfzaooO7keyExTqa
	 G3TeknZaJO5SRyWmsKVYySoBH7jJVHsl/JYdNcZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Andreas Gruenbacher" <agruenba@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 305/312] gfs2: Fix unlikely race in gdlm_put_lock
Date: Wed,  8 Apr 2026 20:03:42 +0200
Message-ID: <20260408175945.165763511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor context change fixed. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/lock_dlm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -301,11 +301,6 @@ static void gdlm_put_lock(struct gfs2_gl
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
-	/* don't want to call dlm if we've unmounted the lock protocol */
-	if (test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
-		gfs2_glock_free(gl);
-		return;
-	}
 	/* don't want to skip dlm_unlock writing the lvb when lock has one */
 
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
@@ -322,6 +317,11 @@ again:
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


