Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210472;
	b=u+nXUcX11yVCb0Ea2lcHeBJ1OURDfe1RbHo5l3opmIE3JIbBQbXVRNXhBfoXLTNGIH79
	 YJwB0SH745A8oeISFBtNM0KhCjdPa1TAftxXb2h+44QNFdjh9dF25DAveX70rcRFkx8KA
	 B1DER/daVNHUso6ypMtCaE4+YFCnqMAoiGQF250NaseQKhlzT543eKnpW6T7tubu7yXSx
	 EnSaVqHhSc79ZAZ8GC5SenqE13bHe68vhG+aubscsuQJci/FVWXe0CxN9nxlKTTQT3R3X
	 iHlvoPhRwNZEAaOy7+gV6UDK4oLoYV/ggKtlYvKSZj7hznNs+2wWjmXXK5GpqXGqRNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MSuYhvMRFvUt19A2QM7KJkaX8MFxWfTi3nXCKW1s918=;
	b=LxjkgF0jkD1OtwmD9Mfignpnpe6HMLAlfQf7/Y7vACrdZvsfHNnxFesFu4gQxtegBRKw
	 3AG6k5Po8rCZvcUdMerhH8l7AhRTi1Q6dZKy6KYpcalLU+c4Lx89iy6ACdtj4mxXhfOA9
	 Fx5D/UVvin/deTHwf+zkjzy0uk3rDfVU3mv/X2/cLgvcT3s2G7Ww3WIrrpC37OAHiNn1C
	 UoIr1BGCu8cXUdoOWVqtTa/sEoqnru0v/rWyb5iJ46WgCUPFqDqYWfu1yYBoA96lhiMXJ
	 5jHvD6kaDPAMQYKufd13A71KmVAa5wpXJRdo+rxcyrApeGZpA3sSaa65yW5cTW4BsfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNLU0Mqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A27E606A31A;
	Wed, 28 Oct 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNLU0Mqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BB91F01825;
	Wed, 28 Oct 2026 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210471;
	bh=MSuYhvMRFvUt19A2QM7KJkaX8MFxWfTi3nXCKW1s918=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNLU0MqwVJXJrn+oUpv50xv00EFi6fZS13rNTlXy+QCuqgREtr3KW87a/V5mohQG7
	 ANzofWMiqi7E9NHGZIh9l9y4osPpxE9XRAe3m4Mf2yQKbRNoIa4q5Xcctdkqy7CN1c
	 uR+07ADW3Jnl7MVs4Amsy2AZnbE2rTJZbNyfbBFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/571] nouveau/gem: reserve the bo in the info ioctl around the vma lookup
Date: Wed, 28 Oct 2026 17:52:36 +0100
Message-ID: <20261028170008.242341995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 5e17160d41d92823f3379c1982e1369680c5ce4d ]

In the non-uvmm path, there could be a race between the info lookup
finding the vma, and the gem close path closing the vma leading
to a use-after-free.

Spotted with the help of Opus 4.6.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Fixes: e758a3111914 ("drm/nouveau: fixup gem_info ioctl to return client-specific bo virtual")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260612020658.3176270-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
[ adapted VMM and UVMM handling to the legacy direct VMM selection and condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index a112a8eba2b8f..7a5751496fedf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -277,11 +277,20 @@ nouveau_gem_info(struct drm_file *file_priv, struct drm_gem_object *gem,
 		rep->domain = NOUVEAU_GEM_DOMAIN_VRAM;
 	rep->offset = nvbo->offset;
 	if (vmm->vmm.object.oclass >= NVIF_CLASS_VMM_NV50) {
+		int ret;
+
+		ret = ttm_bo_reserve(&nvbo->bo, false, false, NULL);
+		if (ret)
+			return ret;
+
 		vma = nouveau_vma_find(nvbo, vmm);
-		if (!vma)
+		if (!vma) {
+			ttm_bo_unreserve(&nvbo->bo);
 			return -EINVAL;
+		}
 
 		rep->offset = vma->addr;
+		ttm_bo_unreserve(&nvbo->bo);
 	}
 
 	rep->size = nvbo->bo.base.size;
-- 
2.53.0



