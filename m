Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BD044B69C;
	Tue, 16 Jun 2026 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624647; cv=none; b=Av9To8f9xCJE9j5S7cPhz3y9uH89EQAOiE1rgTcytBuTxmxHSXmK9OB4bWJGYCkNqq3mClxRywLfTbJ73NZ5oKnbaddr6ZqxsqDqEdqEPK/MXPvLJWs74VRLalTGb9kATD2HJWLVRBYjs53MYmRe7ngs+S6wZg6+5zBGXQMZ4xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624647; c=relaxed/simple;
	bh=cEHv62TTmX6BYPZvr86/AxkKfUPGSgxr/uGxCpHE8kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=odzT12ezhCNPdEBPvXCMd5697kUINYv6zei3cHsIoWwEWh2Oxy5ZhEIMDskStyVNjXuHJyQyz06xTKyMjw0Yk5U3HGtPllc1iaKIX1ra3YSuRPQVU29qb4FCfiyapEyoSI1IEfBsvURt136LDoITVfwkN4MGmR4QYu3ROCGFRtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruxWGAUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruxWGAUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998171F00A3A;
	Tue, 16 Jun 2026 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624646;
	bh=+HU6ggIJw3+eked7ueR0tdROojlLTa4oaNtKNEq+6Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruxWGAUlY9d+5pBs5bASkMonDbB+pha+FnnsOv/G+na0178wOSl2b5ruEA/WxAnC/
	 BiSiagUyhX6dFRJ+QGrGxvkCvR6ezrhBmTVrIG8vww3LQS2x/1QW76Habq4jVzwBNx
	 xw406Ux/wAo6JWT8qztlQMhLgk7hnxTpPT8M0dXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 7.0 341/378] drm/v3d: Fix global performance monitor reference counting
Date: Tue, 16 Jun 2026 20:29:32 +0530
Message-ID: <20260616145128.132866801@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 6bf7e2affc6e62da7add393d7f352d4040f5bc27 upstream.

In the SET_GLOBAL ioctl, v3d_perfmon_find() bumps the reference count on
the perfmon it returns, but v3d_perfmon_set_global_ioctl() and
v3d_perfmon_delete() fail to release that reference on several paths:

  1. v3d_perfmon_set_global_ioctl() leaks the reference on its error
     paths.

  2. CLEAR_GLOBAL leaks both the find reference and the reference
     previously stashed in v3d->global_perfmon by the SET_GLOBAL ioctl
     that configured it.

  3. Destroying a perfmon that is the current global perfmon leaks the
     reference stashed by the SET_GLOBAL ioctl.

Release each of these references explicitly.

Cc: stable@vger.kernel.org
Fixes: c6eabbab359c ("drm/v3d: Add DRM_IOCTL_V3D_PERFMON_SET_GLOBAL")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260531-v3d-perfmon-lifetime-v2-1-60ed4485a203@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_perfmon.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/v3d/v3d_perfmon.c
+++ b/drivers/gpu/drm/v3d/v3d_perfmon.c
@@ -313,8 +313,11 @@ static int v3d_perfmon_idr_del(int id, v
 	if (perfmon == v3d->active_perfmon)
 		v3d_perfmon_stop(v3d, perfmon, false);
 
-	/* If the global perfmon is being destroyed, set it to NULL */
-	cmpxchg(&v3d->global_perfmon, perfmon, NULL);
+	/* If the global perfmon is being destroyed, clean it and release
+	 * the reference stashed in v3d_perfmon_set_global_ioctl().
+	 */
+	if (cmpxchg(&v3d->global_perfmon, perfmon, NULL) == perfmon)
+		v3d_perfmon_put(perfmon);
 
 	v3d_perfmon_put(perfmon);
 
@@ -480,16 +483,27 @@ int v3d_perfmon_set_global_ioctl(struct
 
 	/* If the request is to clear the global performance monitor */
 	if (req->flags & DRM_V3D_PERFMON_CLEAR_GLOBAL) {
-		if (!v3d->global_perfmon)
+		struct v3d_perfmon *old;
+
+		/* DRM_V3D_PERFMON_CLEAR_GLOBAL doesn't check if
+		 * v3d->global_perfmon == perfmon. Therefore, there
+		 * is no need to keep perfmon's reference.
+		 */
+		v3d_perfmon_put(perfmon);
+
+		old = xchg(&v3d->global_perfmon, NULL);
+		if (!old)
 			return -EINVAL;
 
-		xchg(&v3d->global_perfmon, NULL);
+		v3d_perfmon_put(old);
 
 		return 0;
 	}
 
-	if (cmpxchg(&v3d->global_perfmon, NULL, perfmon))
+	if (cmpxchg(&v3d->global_perfmon, NULL, perfmon)) {
+		v3d_perfmon_put(perfmon);
 		return -EBUSY;
+	}
 
 	return 0;
 }


