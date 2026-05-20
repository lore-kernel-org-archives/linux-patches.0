Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C846F3D8129;
	Wed, 20 May 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294412; cv=none; b=B5j4lBarEb+xTO0YQ5hWaEBRDJqXnk4ZCbTifPfDRGCyXMjUK2yIJDMrok5nso2OyNQj8wAVNrvX7K5NXY3ac8XQ5Qd0up1NVxxcGFLfjuNeFrtu53S8F8Moe4x7sSoQt6ctm2eoJEMcRmMrXvqhanBO5GHBvpF+XFkprWEhj9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294412; c=relaxed/simple;
	bh=DqD20gJ/Xbx2EyiwdPBYUSKcaEPYGg0yzp9B+4ywyjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YICX4/I/DbzGiDajI3ZSUK8p3apZcsxvicYq5oSaLNlRJsUlX10LFXi+y9/R79vF6snPnw9bMGog3ZgIyK+QRVzza6LRwZ6SbQntPwv3X4t5+ecPnKXMpYzuDPn8MFlzvRFvXZan/ALfaTPg1ovaIodMmgSbylniLy8/du+MgxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J56qTALk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J56qTALk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389181F000E9;
	Wed, 20 May 2026 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294410;
	bh=iDa633heG+mJ5zXX2bhl9uIIwJ81+xVnEK6XYZRC4zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J56qTALklmWWERyohnJ5Y/binQxJjY6bT7McF04gbSzwJBl8MoO2uGdxLAzMC2pXK
	 V6SkUs9LQJOkrD+AMnp+RS6oD/gNmGbddjbkEG8SN7gbAQjekwzgUl9XoCAr/aUdet
	 fnfNc0eg5lERVoncbGillvofocW7OaYQV5/mpNAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0029/1146] devres: fix missing node debug info in devm_krealloc()
Date: Wed, 20 May 2026 18:04:39 +0200
Message-ID: <20260520162149.042666703@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f813ec9e84b4d0ca81ec1da94ab07bfb4a29266c ]

Fix missing call to set_node_dbginfo() for new devres nodes created by
devm_krealloc().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260202235210.55176-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 171750c1f6918..ce519b98a1898 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -940,6 +940,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!new_dr)
 		return NULL;
 
+	set_node_dbginfo(&new_dr->node, "devm_krealloc_release", new_size);
+
 	/*
 	 * The spinlock protects the linked list against concurrent
 	 * modifications but not the resource itself.
-- 
2.53.0



