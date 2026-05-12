Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74113EDE68;
	Tue, 12 May 2026 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609223; cv=none; b=bft5LodO0Q/tKDaarMceCXzcRN8TfRnBYag02oUEUZ8Rdp0O+MMgPNgQHAiR1AHhgdIox3JJQonR8Fd3JDRATH4jks5Wc+ivZchOaiz09otgzeZ7xYOpHhcNNWlv1aUhvPpHOqSznAR0T509EOLwS5PU1ZYWy19em4wwHxaCojE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609223; c=relaxed/simple;
	bh=OF6aZdluqDOBB9hXJzpXJ44pldrtpIr8zL09yusxy6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6KcXyOXHNfTclgL5Wt84t0b3caNgakSs1cTrJCuIkJTncBnlHULWUXWmuVMkAPjWJMxZdSY+VGR2G0NYrxFhZmrx/ufNLbRgoVjnPDcxLxch5T37s5WYNSb19GnhYFGAboNEdFOeXZlBJoUMfM9uiQ6C4M2ifIEYy/sI7IAjg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBFrXBa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBFrXBa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E10DC2BCB0;
	Tue, 12 May 2026 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609223;
	bh=OF6aZdluqDOBB9hXJzpXJ44pldrtpIr8zL09yusxy6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBFrXBa2vSFi887S/k3r9ILWmGJdAEBGOnnh6IkzAv2cgDB9tPMtysMBdWlJvxBEv
	 u7KuDeugEkJkEF4SB65DAAMeqmNpLYHKqMF8HrzJlKdPCLTyhrPqP5WFUkp/CJKd+3
	 bjhRd3ZbwCyZwGbFPlTuCfWioSErrGpWBH8iAPJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yametsu <yam3tsu@gmail.com>,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 7.0 110/307] accel/ivpu: Disallow re-exporting imported GEM objects
Date: Tue, 12 May 2026 19:38:25 +0200
Message-ID: <20260512173942.445935254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit 7dd57d7a6350770dfc283287125c409e995200e0 upstream.

Prevent re-exporting of imported GEM buffers by adding a custom
prime_handle_to_fd callback that checks if the object is imported
and returns -EOPNOTSUPP if so.

Re-exporting imported GEM buffers causes loss of buffer flags settings,
leading to incorrect device access and data corruption.

Reported-by: Yametsu <yam3tsu@gmail.com>
Fixes: 57557964b582 ("accel/ivpu: Add support for userptr buffer objects")
Reviewed-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -460,6 +460,26 @@ static const struct file_operations ivpu
 #endif
 };
 
+static int ivpu_gem_prime_handle_to_fd(struct drm_device *dev, struct drm_file *file_priv,
+				       u32 handle, u32 flags, int *prime_fd)
+{
+	struct drm_gem_object *obj;
+
+	obj = drm_gem_object_lookup(file_priv, handle);
+	if (!obj)
+		return -ENOENT;
+
+	if (drm_gem_is_imported(obj)) {
+		/* Do not allow re-exporting */
+		drm_gem_object_put(obj);
+		return -EOPNOTSUPP;
+	}
+
+	drm_gem_object_put(obj);
+
+	return drm_gem_prime_handle_to_fd(dev, file_priv, handle, flags, prime_fd);
+}
+
 static const struct drm_driver driver = {
 	.driver_features = DRIVER_GEM | DRIVER_COMPUTE_ACCEL,
 
@@ -468,6 +488,7 @@ static const struct drm_driver driver =
 
 	.gem_create_object = ivpu_gem_create_object,
 	.gem_prime_import = ivpu_gem_prime_import,
+	.prime_handle_to_fd = ivpu_gem_prime_handle_to_fd,
 
 	.ioctls = ivpu_drm_ioctls,
 	.num_ioctls = ARRAY_SIZE(ivpu_drm_ioctls),


