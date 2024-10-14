Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFD61AB536;
	Mon, 14 Oct 2024 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916403; cv=none; b=pLlGLvOmxI15JHUxOPDu67+n1UK9altBdRITgUgkNtlac7YL6mKUgMfQXfDyMVM7raHRcmhs43eTo85Y3Ag+sHIfIZYQqmdZWnWyZHWe6wBywTMzMscaex3DEe4LATgR8FXJY4jGOpxkhTe4r+gH2gwXcGpdr0/cDjI4IxRatuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916403; c=relaxed/simple;
	bh=SVZd1AaTDsHeezNRtNnU+5pTjUWmys1LNUxcusNIemA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gvmy9l7CC7vjaUzEhpaQCYuhApIwd29pF1wTy8GyN0vp/J5wbWt04bDDhrT+Kngn4z5X92oiCV2x38tXt3meY534jDzwpFWCZLzWGRZEt4EXGBq4WBaTXa7TL6Bkx6Qdoz48yVmD2ux4YnbEPcbg9qAbjuLAR+wVeXYi6qk2iXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rB5XNzi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rB5XNzi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BFFC4CED1;
	Mon, 14 Oct 2024 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916403;
	bh=SVZd1AaTDsHeezNRtNnU+5pTjUWmys1LNUxcusNIemA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rB5XNzi7QZMXwLgVbMe0mLGetiXM2DWU57V03kfK/9M39JbflctJ2b2ZmlS6VVyGg
	 DWrJl3CohP0WaukoFXa2WlUMZFaFZkaC4+oWfsZd68GgCUizfliUaLsKf7n0PGPoj8
	 zJu02WqckiQf2a8LY+bdNONzUWNmj/Q08g9a8xD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <bbrezillon@kernel.org>,
	"Juan A. Suarez Romero" <jasuarez@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.11 174/214] drm/vc4: Stop the active perfmon before being destroyed
Date: Mon, 14 Oct 2024 16:20:37 +0200
Message-ID: <20241014141051.769836883@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 0b2ad4f6f2bec74a5287d96cb2325a5e11706f22 upstream.

Upon closing the file descriptor, the active performance monitor is not
stopped. Although all perfmons are destroyed in `vc4_perfmon_close_file()`,
the active performance monitor's pointer (`vc4->active_perfmon`) is still
retained.

If we open a new file descriptor and submit a few jobs with performance
monitors, the driver will attempt to stop the active performance monitor
using the stale pointer in `vc4->active_perfmon`. However, this pointer
is no longer valid because the previous process has already terminated,
and all performance monitors associated with it have been destroyed and
freed.

To fix this, when the active performance monitor belongs to a given
process, explicitly stop it before destroying and freeing it.

Cc: stable@vger.kernel.org # v4.17+
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Juan A. Suarez Romero <jasuarez@igalia.com>
Fixes: 65101d8c9108 ("drm/vc4: Expose performance counters to userspace")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Juan A. Suarez <jasuarez@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241004123817.890016-2-mcanal@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_perfmon.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_perfmon.c
+++ b/drivers/gpu/drm/vc4/vc4_perfmon.c
@@ -116,6 +116,11 @@ void vc4_perfmon_open_file(struct vc4_fi
 static int vc4_perfmon_idr_del(int id, void *elem, void *data)
 {
 	struct vc4_perfmon *perfmon = elem;
+	struct vc4_dev *vc4 = (struct vc4_dev *)data;
+
+	/* If the active perfmon is being destroyed, stop it first */
+	if (perfmon == vc4->active_perfmon)
+		vc4_perfmon_stop(vc4, perfmon, false);
 
 	vc4_perfmon_put(perfmon);
 
@@ -130,7 +135,7 @@ void vc4_perfmon_close_file(struct vc4_f
 		return;
 
 	mutex_lock(&vc4file->perfmon.lock);
-	idr_for_each(&vc4file->perfmon.idr, vc4_perfmon_idr_del, NULL);
+	idr_for_each(&vc4file->perfmon.idr, vc4_perfmon_idr_del, vc4);
 	idr_destroy(&vc4file->perfmon.idr);
 	mutex_unlock(&vc4file->perfmon.lock);
 	mutex_destroy(&vc4file->perfmon.lock);


