Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D724E4CE;
	Wed,  7 May 2025 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644346; cv=none; b=u+zBGznxrylxDHDotI+VQaUBQIGA90Wwi437rSGWmJCAtJ8re+iwaQVB+2I7fvod9qU8g9P1etp9Qn4OS1iT/bsARk/skiBSlfgi+RqfJDIV8Ij147NNbcSxJPyd/xC+AYNYhVjEYU/sEdlf7sX4cqYGy8zo+SCpiD8Y+JFo3Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644346; c=relaxed/simple;
	bh=x7TECmERLVyk2pT4nmg21HalTzwDS4iW8MIBbJHGOfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozbOie4Z2J0EtGUoQifvgosm1zbid7dyYUt8ipCyhYhNd0SAGw+kGTHO+27KHRnapNr7JoFH/cHqOPqiwPDsG51XrSRXR/rmQHnLGM7NPgIfDx10K1tK9A8VPr9badHu2KeGm/Dthq5FcC7t8H6K1UKCOQ0Lw7B6q/BZEog4zJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNTOPvXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNTOPvXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD127C4CEE2;
	Wed,  7 May 2025 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644346;
	bh=x7TECmERLVyk2pT4nmg21HalTzwDS4iW8MIBbJHGOfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNTOPvXnuJ8weKhGZjXXiKqxQiLn79+Nk4Oc6HoWuUgddFGnEmLB0bfFxz+hsehAL
	 tX6kb6ir1seBAVCK3kpbKyO5qjByVwV18JkNyJNJaQEQHWtelfb3iIhdUqDQBXpr1D
	 io0vo7JwijmRgDaj5l4h6/82lVyGwtas+j5tMbo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Subject: [PATCH 6.12 014/164] drm/fdinfo: Protect against driver unbind
Date: Wed,  7 May 2025 20:38:19 +0200
Message-ID: <20250507183821.420982821@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 5b1834d6202f86180e451ad1a2a8a193a1da18fc upstream.

If we unbind a driver from the PCI device with an active DRM client,
subsequent read of the fdinfo data associated with the file descriptor in
question will not end well.

Protect the path with a drm_dev_enter/exit() pair.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: 3f09a0cd4ea3 ("drm: Add common fdinfo helper")
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250418162512.72324-1-tvrtko.ursulin@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_file.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -938,6 +938,10 @@ void drm_show_fdinfo(struct seq_file *m,
 	struct drm_file *file = f->private_data;
 	struct drm_device *dev = file->minor->dev;
 	struct drm_printer p = drm_seq_file_printer(m);
+	int idx;
+
+	if (!drm_dev_enter(dev, &idx))
+		return;
 
 	drm_printf(&p, "drm-driver:\t%s\n", dev->driver->name);
 	drm_printf(&p, "drm-client-id:\t%llu\n", file->client_id);
@@ -952,6 +956,8 @@ void drm_show_fdinfo(struct seq_file *m,
 
 	if (dev->driver->show_fdinfo)
 		dev->driver->show_fdinfo(&p, file);
+
+	drm_dev_exit(idx);
 }
 EXPORT_SYMBOL(drm_show_fdinfo);
 


