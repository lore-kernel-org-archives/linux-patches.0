Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65A183CD4;
	Mon, 12 Aug 2024 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480366; cv=none; b=ujMZ18ICqtm15XET9RtGCkoHw62/BIBVHuRCru7NFeb5ljbqfHFGrwa50YE1codNFudzA3EMiwHneJgsuBlP1JuTfoqLb3qGcSDJCynK48VXbTZubbkyNEJcktttKW+1/jsuoC6xz6T9At8pgGbUFiQv22hX56WcChtNpty4WLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480366; c=relaxed/simple;
	bh=P84OWrvw1PfAeOjNKAhazx9sOBRw1FC47su4J/nKcA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCfoKVhNTUQrsdVZ1k+YtHVuY4IAGhUh+rGmJpxKvHFZ8YU3WxhosMKF4abJ7JqJXkChA6HO9Ih1BMz0+WztXiR8dpalJ02ZyCzf6464xNvcigpminO0uJd6VK0Fs+tTVUtSJy8etIyEuqsco5ipAizGxhY1kar1RvwbC7O+r2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbkVLOCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbkVLOCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7508C32782;
	Mon, 12 Aug 2024 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480366;
	bh=P84OWrvw1PfAeOjNKAhazx9sOBRw1FC47su4J/nKcA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbkVLOCvsO6lX54WshtVWP3zOdeQGNMA2FnStb5Yq1wW5Y3nAzK0V84pDHFUegXsY
	 aZP0js4o5iClhUdXoFNR6sccWCVyGClxtQ3dXdbbM8yIqgBKNK6W+q+lIOEaDhj0mq
	 Gw/BWshkPx8G3jdqDMIYcYPBKxZ6WQceAXX83b8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.10 175/263] drm/i915/gem: Adjust vma offset for framebuffer mmap offset
Date: Mon, 12 Aug 2024 18:02:56 +0200
Message-ID: <20240812160153.248771045@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

commit 1ac5167b3a90c9820daa64cc65e319b2d958d686 upstream.

When mapping a framebuffer object, the virtual memory area (VMA)
offset ('vm_pgoff') should be adjusted by the start of the
'vma_node' associated with the object. This ensures that the VMA
offset is correctly aligned with the corresponding offset within
the GGTT aperture.

Increment vm_pgoff by the start of the vma_node with the offset=
provided by the user.

Suggested-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v4.9+
[Joonas: Add Cc: stable]
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240802083850.103694-2-andi.shyti@linux.intel.com
(cherry picked from commit 60a2066c50058086510c91f404eb582029650970)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -1125,6 +1125,8 @@ int i915_gem_fb_mmap(struct drm_i915_gem
 		mmo = mmap_offset_attach(obj, mmap_type, NULL);
 		if (IS_ERR(mmo))
 			return PTR_ERR(mmo);
+
+		vma->vm_pgoff += drm_vma_node_start(&mmo->vma_node);
 	}
 
 	/*


