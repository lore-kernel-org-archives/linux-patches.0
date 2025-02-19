Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE771BEF71;
	Wed, 19 Feb 2025 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955360; cv=none; b=pV0YIhE37cPKVsJzzW3GBNPdfOv1Fawzv/+V4AITZhAtJ0Zzda0yysJy2diVSrm4okOj0BROtjjPPdUEIssjpRpbVc7gJBp9+d3D95bd+lMCjWaQ5YG3pKpy1Ucud5uVnMQ1omJjRBM9fJ5WixsWK/ruzFXoZ5RHAtRgJjW7rwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955360; c=relaxed/simple;
	bh=CF/DoEJIR7QmCjweckZ1R/mAam3gNqZgd354MtDtkFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GY/lskGjv5T6ZiPxd4BloM07bjJ26TBKYNv0kcloGhaoioRVFVWPevqo3IzPUohU+roUSeN6YabHTP/41mA1TRrRrcNMPFMa8PPNAlxZnaHWbbWXJMbptMToYNhtBDxTAaytN8cumGSJSgnkOaovNosgJat7rUn6TWIyHrLoOKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwTMuh22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwTMuh22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C365C4CED1;
	Wed, 19 Feb 2025 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955360;
	bh=CF/DoEJIR7QmCjweckZ1R/mAam3gNqZgd354MtDtkFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwTMuh22n9YupSSHw2ryzMOy30mWcijwrvQfj1QTEJa2EOOsbJEfFf6owDcRHD2Cn
	 8nBRGoqldQkVSjzS5CoE4Lw3rv4QZ2lf/m1sQwYZK1N2Cs9sJhHD+qmKXgRmxzXu0P
	 Pdbn/eg5jjeWqQ/vskNvL26TJ630v/uzJedLeM0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.12 212/230] drm/v3d: Stop active perfmon if it is being destroyed
Date: Wed, 19 Feb 2025 09:28:49 +0100
Message-ID: <20250219082609.986365568@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -384,6 +384,7 @@ int v3d_perfmon_destroy_ioctl(struct drm
 {
 	struct v3d_file_priv *v3d_priv = file_priv->driver_priv;
 	struct drm_v3d_perfmon_destroy *req = data;
+	struct v3d_dev *v3d = v3d_priv->v3d;
 	struct v3d_perfmon *perfmon;
 
 	mutex_lock(&v3d_priv->perfmon.lock);
@@ -393,6 +394,10 @@ int v3d_perfmon_destroy_ioctl(struct drm
 	if (!perfmon)
 		return -EINVAL;
 
+	/* If the active perfmon is being destroyed, stop it first */
+	if (perfmon == v3d->active_perfmon)
+		v3d_perfmon_stop(v3d, perfmon, false);
+
 	v3d_perfmon_put(perfmon);
 
 	return 0;


