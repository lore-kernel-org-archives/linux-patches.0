Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F481158862;
	Wed, 19 Feb 2025 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957595; cv=none; b=Fxpq8LSVBMp7R2L6c7T2YKHRyXLLtiMubDTP0jGAB9IBLB44TNLzWESfjGOY2ZsZJs5T89XNSJdluj+qzsoc2FDvZW7zeTJ0SXD0vXxCL7kjtMsfjMVhSjYJRb6gjzeJ+0qi4438eKryUiNgdwakcYfFCclm3zWkNPRrMuCibHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957595; c=relaxed/simple;
	bh=XW4wtEkd1ibvMWzbryKoIMnOEYF5PM8cFl5yRaAr5dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXCMwUPnENNDt9/jk95TZSzslu+kXEhsPVHLrB2/dwoZnw57Au1jyFd0vhscRDUQNP723yy+8ganQW3r9lhPTBy4vj3sLKhOws5asnGIUJ3mURAMmbXwtAVS8Q0+rrzCDRlclWoQetKa1XcTpMYDddGf23z/rkOdYlo2DUrZI8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrI0v+6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrI0v+6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF348C4CEE6;
	Wed, 19 Feb 2025 09:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957595;
	bh=XW4wtEkd1ibvMWzbryKoIMnOEYF5PM8cFl5yRaAr5dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrI0v+6krqbb8/g7/vY9cdAJnA/+FCgJVxmjy5I/DIOGtuAmp3YSSrixttwLEmQJt
	 tNa1hBGNYEEqEilqGxL7R/bjerHAijtlHZXdhUFtPgtfVqAfJmvbAo5eTnmLzcyGw7
	 m+TydIa7wgjWQfjDOjFdlan8ttLbv2yaq6CrYG60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.1 558/578] drm/v3d: Stop active perfmon if it is being destroyed
Date: Wed, 19 Feb 2025 09:29:22 +0100
Message-ID: <20250219082714.904910484@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Gmeiner <cgmeiner@igalia.com>

commit 21f1435b1e6b012a07c42f36b206d2b66fc8f13b upstream.

If the active performance monitor (`v3d->active_perfmon`) is being
destroyed, stop it first. Currently, the active perfmon is not
stopped during destruction, leaving the `v3d->active_perfmon` pointer
stale. This can lead to undefined behavior and instability.

This patch ensures that the active perfmon is stopped before being
destroyed, aligning with the behavior introduced in commit
7d1fd3638ee3 ("drm/v3d: Stop the active perfmon before being destroyed").

Cc: stable@vger.kernel.org # v5.15+
Fixes: 26a4dc29b74a ("drm/v3d: Expose performance counters to userspace")
Signed-off-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241118221948.1758130-1-christian.gmeiner@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_perfmon.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_perfmon.c
+++ b/drivers/gpu/drm/v3d/v3d_perfmon.c
@@ -175,6 +175,7 @@ int v3d_perfmon_destroy_ioctl(struct drm
 {
 	struct v3d_file_priv *v3d_priv = file_priv->driver_priv;
 	struct drm_v3d_perfmon_destroy *req = data;
+	struct v3d_dev *v3d = v3d_priv->v3d;
 	struct v3d_perfmon *perfmon;
 
 	mutex_lock(&v3d_priv->perfmon.lock);
@@ -184,6 +185,10 @@ int v3d_perfmon_destroy_ioctl(struct drm
 	if (!perfmon)
 		return -EINVAL;
 
+	/* If the active perfmon is being destroyed, stop it first */
+	if (perfmon == v3d->active_perfmon)
+		v3d_perfmon_stop(v3d, perfmon, false);
+
 	v3d_perfmon_put(perfmon);
 
 	return 0;


