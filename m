Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17E4350D77;
	Tue,  6 Jan 2026 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722528; cv=none; b=GVIPI8jrhpAyr8u+F9X7q0ecPAnBQzFptz4dFbPsIpbhXzMeC7YWqVDOVPmtz3uYZCZPZvUupz+/HHx+FvL90+quCjQmuf3QbElxfl5mBe2f258L9k+lA1VNCuw2DRcpHHMYrBVrS1LFxXTWxzkfYzq2o6N6PzvmnOZjdx5jSHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722528; c=relaxed/simple;
	bh=p5feBldq9LIsM25ejCf+pyl1nBsMJLxeoivn80I1OGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rc2+3LgLmdTmEb1FIIgRozXMBvwdveG2hBaRMJrS8t6Gyve7Us4XhMyEl/T0Bsbdu/ruNpsoQRAnxX22Pa01hxaffh4k4y1hE1iTDzQgoBJZJ8YT1NOhCgvE7Rb6p575XN0yepxttu85yHoH1UZqHOvIAgegUyuSv0UDKQvNMi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBZAJX0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBZAJX0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BEBC116C6;
	Tue,  6 Jan 2026 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722528;
	bh=p5feBldq9LIsM25ejCf+pyl1nBsMJLxeoivn80I1OGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBZAJX0CaQMokf4sY5RdOGJbCek3LTNx3ubJ3wPGRcOSNUJbSs/bqeHh07hA/Gl9q
	 IiWkvG3XISQtDH7/Jyv1/GZjj8fGPR5uh/o4wtISThOpjAjC9tE0mwhWJK0be8Nr4h
	 8eg9N0gi6TUt4KC6nyFLy22igM00Sqr2MET/MXNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>
Subject: [PATCH 6.18 291/312] drm: Fix object leak in DRM_IOCTL_GEM_CHANGE_HANDLE
Date: Tue,  6 Jan 2026 18:06:05 +0100
Message-ID: <20260106170558.380916256@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit 630efee9493cf64ff7b9a1652978807fef385fdd upstream.

Add missing drm_gem_object_put() call when drm_gem_object_lookup()
successfully returns an object. This fixes a GEM object reference
leak that can prevent driver modules from unloading when using
prime buffers.

Fixes: 53096728b891 ("drm: Add DRM prime interface to reassign GEM handle")
Cc: <stable@vger.kernel.org> # v6.18+
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20251212134133.475218-1-karol.wachowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index f884d155a832..3b9df655e837 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -979,8 +979,10 @@ int drm_gem_change_handle_ioctl(struct drm_device *dev, void *data,
 	if (!obj)
 		return -ENOENT;
 
-	if (args->handle == args->new_handle)
-		return 0;
+	if (args->handle == args->new_handle) {
+		ret = 0;
+		goto out;
+	}
 
 	mutex_lock(&file_priv->prime.lock);
 
@@ -1012,6 +1014,8 @@ int drm_gem_change_handle_ioctl(struct drm_device *dev, void *data,
 
 out_unlock:
 	mutex_unlock(&file_priv->prime.lock);
+out:
+	drm_gem_object_put(obj);
 
 	return ret;
 }
-- 
2.52.0



