Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6CB3876A3;
	Tue, 10 Mar 2026 11:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141916; cv=none; b=JNGx3XZadIgUVmfE8MtllTSwaPW64Zo1/fbCMaGVBSas0wUlJ7Y9VMeqeZiRJQFpH+V7YNhnRPJiuxPv5SfOcQ2/x5YuzmzcGCaBkKEVBP7EdnI/X/Z8FCzG1CFDBzEjuZRRsiuOLklRktzB33OPYnV0/9XLGboVsA1IVSOKlnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141916; c=relaxed/simple;
	bh=wnnTIpP2xgT8QfksgPWFF4X5cTl+pBsaGxrye/5acyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVegOGjfBHLilqDEOVuzf3CIBK0v3zH3PDXSUQArc6IYAqK0Z5myLHI4K0svejyF8CAHwRUmX77ySqKMwfFaIWG+EQbHWUw0UJ4Le/u5HXu4k7H+RnglsTrSGWs768qxyK6Q/iwyiBc0y7S8NMl374UAJy1m+IweE+Jq70LAQX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwq689C9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwq689C9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C66C19423;
	Tue, 10 Mar 2026 11:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141916;
	bh=wnnTIpP2xgT8QfksgPWFF4X5cTl+pBsaGxrye/5acyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwq689C91/eyyWMY6C4hnV8ofelDp4EOST5muhjeHrf9wlqX6F2kUEJ8ygzTX40i3
	 5UtwK7x99EPL13c0F8a/aIJtoJWCB0UL0O3z6LDMAWo+HNNlkAC6S0IzocY6xmF8ph
	 lWogWa6I8PmajQ5pjLQMuo5pIOdbVysDT9oOvdTBH9doUfcgafG2MFZjDWy5MStiTc
	 TFBfhnbJO8BdC8VG8dSJWCrYBHedXF4mx+tlgoDNVoX0ACGjpC/Q163NKD0BrKpNsw
	 9WadDBXPoRLR5kYRt3/qBlpL5o1mr738oeHMoiedcpOkYiginI1x/uD4iTJZrV3c+F
	 EAlHgiMPp6muA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/314] drm/client: Do not destroy NULL modes
Date: Tue, 10 Mar 2026 07:14:58 -0400
Message-ID: <c3c672bef2f48c609b5fac7002697bc115210b79.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 9c2c3b0c8c470..eaf71c9ecf136 100644
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

