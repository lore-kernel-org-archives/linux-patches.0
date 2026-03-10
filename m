Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70855248F73;
	Tue, 10 Mar 2026 11:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141057; cv=none; b=qfpuBvs30g8h0d6W+uY3/SJyG6Sx88Moym6xWx92tG28fbYo2ysxabUV1imBIBZ/nFlF/Ip6MWijue5NRpWMHv3sp+5oK+Ntq69b9XTYLl1is3IN3c32sYnxsDReWnUCxwUsBVr+WT9RYt+NPGfNh2wWGuhhaFv/gzpMhMqmoKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141057; c=relaxed/simple;
	bh=xzYXpLVX5kyMIHQC8CiTfnYREh5HgrtyqkPEsj+4cxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LLtWKIbF6WYWFee0QNV1kz4eQvE1HX6IhzjMe26rn9MHapppIJ6Uv/6oRD/bTla7eIMwMar1sNJlOK/ojRObE6jvZYki2XFI9JCQWuY1phMmRaFI4uuC/a6+DFWhcJ0oQzxeQ462v9LxZz0mUngzTvNTvvtk/tD7vFkhN70SdMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yu4gnvra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yu4gnvra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84021C2BC86;
	Tue, 10 Mar 2026 11:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141057;
	bh=xzYXpLVX5kyMIHQC8CiTfnYREh5HgrtyqkPEsj+4cxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yu4gnvraAN5RwpXKhYLrvZgUp5qNJxeToSNrlqeH4vF7gdjKbUR0Fmhk7rRbdFqzc
	 g2pJydJ24batQ7kWpWScjgMi3M+UfiwgU3N99ra7Grid+YMIO2JkFvDM5oM8UWB9tC
	 iwPBLwvXF5BEpOGimpQbuaU+5nCDblia6Cc6GXmpZb2EcSJGdmqDx73lGzopN0RsU8
	 qQ5VL17AgJ/zZi78inSsMKvvLha+BrNuviPu64B89VUHVv9gJGT7Dc8NG+PPhIJiIl
	 hEX6JxA8CkMj128/SdOUAVXkEu/CDu0BXtM8h+grsazxue/xu4rvy1i6vxuRp6O8mA
	 lppkwMPPsLjoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 056/311] drm/client: Do not destroy NULL modes
Date: Tue, 10 Mar 2026 07:01:43 -0400
Message-ID: <22890d972e698c289c0f193d2f78961b124e686a.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jonathan Cavitt <jonathan.cavitt@intel.com>

[ Upstream commit c601fd5414315fc515f746b499110e46272e7243 ]

'modes' in drm_client_modeset_probe may fail to kcalloc.  If this
occurs, we jump to 'out', calling modes_destroy on it, which
dereferences it.  This may result in a NULL pointer dereference in the
error case.  Prevent that.

Fixes: 3039cc0c0653 ("drm/client: Make copies of modes")
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260224221227.69126-2-jonathan.cavitt@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client_modeset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
index fc4caf7da5fcd..4a72f323e83e3 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -930,7 +930,8 @@ int drm_client_modeset_probe(struct drm_client_dev *client, unsigned int width,
 	mutex_unlock(&client->modeset_mutex);
 out:
 	kfree(crtcs);
-	modes_destroy(dev, modes, connector_count);
+	if (modes)
+		modes_destroy(dev, modes, connector_count);
 	kfree(modes);
 	kfree(offsets);
 	kfree(enabled);
-- 
2.51.0

