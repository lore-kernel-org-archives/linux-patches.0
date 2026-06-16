Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912FC379EFC;
	Tue, 16 Jun 2026 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626438; cv=none; b=JN+GayM82mY+Eh8z71F6mVqpO5gO/6TLFhthSoygBeLRXKi2XthcSVKhk+DZ9ViBwkDqTf4U+EvkOGSBF/M87t3EMwXM3U7cfsxbwQXIFufgtdnKPGQxtttzBoe1T4mZ6Zt+j4W7R05tpMSMBI/NGOLY1ZX7kmsLtzxjRaWfGlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626438; c=relaxed/simple;
	bh=8CksO32J4Atcytf3xa8vy1A5pp3XOTr/OysRwXcyEhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyI8E1mtt5JrKlsHk9rGLSWqdF9hdvffxs7EHgvIP0DSTo9Fzy35MCkEJIdNyclvEpv80UwYjM/4SI32qVD5vzQcjACY+jF/wPX+bBhQ14mNPmN7q5h+t5jX5yf8wxYRPsgSXZpzm1uYQYIiBFYnHneDlf8sM+1HJ7H+HngumT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bx5rvANm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bx5rvANm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABF21F000E9;
	Tue, 16 Jun 2026 16:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626437;
	bh=cM7rZUUiMrpWFbQ5QzPEVWcxqVqaZhZX5PN4+aP1C+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bx5rvANmqu276MryqNSySjcf6jiXCBCYw9kGW8Ko/a+iIly9Hv8S7o3bbgJD8hGhR
	 VNIoL3DOPl451tZRjx8KQSbzZdkXGxegxHDeXLaZ5OaO0Es1Iu6wy+/8eSVIT3KHAE
	 y364UyLJK2IxU/jo/KSdGx7S3HJyNKbuPxkFH/NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.18 288/325] drm/v3d: Fix global performance monitor reference counting
Date: Tue, 16 Jun 2026 20:31:24 +0530
Message-ID: <20260616145113.126515018@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -481,16 +484,27 @@ int v3d_perfmon_set_global_ioctl(struct
 
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


