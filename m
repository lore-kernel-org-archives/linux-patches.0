Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FA87C0B2;
	Mon,  8 Apr 2024 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583259; cv=none; b=O0mo+fkjmmgr+LXEz4RuV032PwKxD3kXAOebh/XDzvMIbhxWqVeXzRU8pS+QW5yimG/c6rSMjp7IW+69kyi/MltAS4v2k+xeClMfxz5Pdl1k88HeDkwCYaOz2+NLVzg6HtJ9PEZ6pPKrcGu+L4ZSVMBAZ9kg3FnoccaZMXIM2Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583259; c=relaxed/simple;
	bh=79IiVutarEA1J029/bLwq2FbwXNE7FSfg3qo3CTMJV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSVFLu2TEXNogTv0sFxnbbAIkX4phMZTEz4rLukycG92Xt9kde14EHMaEnSwFAXyNykOMumcfcMMeEnfcxyfL840c1JaAQo7rcdTKyrd29epSdoDsSVwVEgUSPNBEyRN/eYmQ/HTJ1DfWeTCDAYeHiONgu4g5nVjHBU9kuMxNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6Nrts2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6Nrts2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859E3C433C7;
	Mon,  8 Apr 2024 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583258;
	bh=79IiVutarEA1J029/bLwq2FbwXNE7FSfg3qo3CTMJV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6Nrts2ii4hg9f76AsiEds8Eggp24ZnB3Hf/5rIZKa65sl02za20Rjhe1KrC7hXPF
	 G2XnTox9n9l1VSoPI1+ZWNjCdBLkoOfYYx2v2fsYR2jGW/cjByxsj8ZSNKH4N3jkzX
	 Dah685//p7S5vrHehEjsXXX8DZ1oyrbCAQguThCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Behr <dbehr@chromium.org>,
	Rob Clark <robdclark@chromium.org>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 157/273] drm/prime: Unbreak virtgpu dma-buf export
Date: Mon,  8 Apr 2024 14:57:12 +0200
Message-ID: <20240408125314.150074277@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit a4ec240f6b7c21cf846d10017c3ce423a0eae92c ]

virtgpu "vram" GEM objects do not implement obj->get_sg_table().  But
they also don't use drm_gem_map_dma_buf().  In fact they may not even
have guest visible pages.  But it is perfectly fine to export and share
with other virtual devices.

Reported-by: Dominik Behr <dbehr@chromium.org>
Fixes: 207395da5a97 ("drm/prime: reject DMA-BUF attach when get_sg_table is missing")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20240322214801.319975-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_prime.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 7352bde299d54..03bd3c7bd0dc2 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -582,7 +582,12 @@ int drm_gem_map_attach(struct dma_buf *dma_buf,
 {
 	struct drm_gem_object *obj = dma_buf->priv;
 
-	if (!obj->funcs->get_sg_table)
+	/*
+	 * drm_gem_map_dma_buf() requires obj->get_sg_table(), but drivers
+	 * that implement their own ->map_dma_buf() do not.
+	 */
+	if (dma_buf->ops->map_dma_buf == drm_gem_map_dma_buf &&
+	    !obj->funcs->get_sg_table)
 		return -ENOSYS;
 
 	return drm_gem_pin(obj);
-- 
2.43.0



