Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20523EB0F5;
	Tue, 16 Jun 2026 18:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636346; cv=none; b=dO9z/s68bV5Qt8AVxU0Nem9pFQoGHNWQ9b7CCtIifzninFOFZNCgnFMhlfmoncGhs9ICQSSGVK89G9zykrfsGIADBdG7hmRX6zF7Co5OSQAGm9EALDNF9hjZ5LWrqoYWtsn/v/54XgyI2Q2IP6/9+DmqcSLDzHaEeDt1aRvoWUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636346; c=relaxed/simple;
	bh=KyJeOS0nfXTp0iqLLDX6Kj45iLYjeOf8eFz3PPQP4T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjR4dM7ReNr5GmcRIG8d/z+loKsvHkF5CHmGNp9vMvwQBxeLAV3TU2hxxmkY8w80INY+dIzSUVzq0Ww0Nls9RfFCaFEMU2sI6v5eirsFCpypdZg8Gwoi8myaIikcfC7oAmtB10cin3f/2cFbJdLBsc5sdMJmrKpb5x4couioQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsrB0ZT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsrB0ZT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDC81F000E9;
	Tue, 16 Jun 2026 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636345;
	bh=kDJTha8DsM3gr5RG8qGaYFvsWAdGr8VmrqJ/9NMtw9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsrB0ZT7ulQxyRTt8PPDpMpfhlXC0rtQBpwUBuF3Ca7KJB83xVqH/+KZYdB86vI+/
	 pW23bn5a8rVdNUdZNGI2NQJT+u5pvRn2madgJFFAGY06m2UHW0rved3T1jM+TXswja
	 iCLoyZSJBIJZ0Flozfi4UJqVzWqda0F/pcCyoQp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/342] drm/nouveau: fix u32 overflow in pushbuf reloc bounds check
Date: Tue, 16 Jun 2026 20:28:38 +0530
Message-ID: <20260616145058.541117504@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 2fc87d37be1b730a149b035f9375fdb8cc5333a5 ]

nouveau_gem_pushbuf_reloc_apply() validates each relocation with

    if (r->reloc_bo_offset + 4 > nvbo->bo.base.size)

but reloc_bo_offset is __u32 (uapi/drm/nouveau_drm.h) and the integer
literal 4 promotes to unsigned int, so the addition is performed in 32
bits and wraps before the comparison against the size_t bo size.

Cast to u64 so the addition happens in 64-bit arithmetic.

Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Reported-by: Anthropic
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_t1000
Fixes: a1606a9596e5 ("drm/nouveau: new gem pushbuf interface, bump to 0.0.16")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Add Fixes: tag. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
[ Kept 5.10's `nvbo->bo.mem.num_pages << PAGE_SHIFT` instead of upstream's `nvbo->bo.base.size` accessor. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -618,7 +618,7 @@ nouveau_gem_pushbuf_reloc_apply(struct n
 		}
 		nvbo = (void *)(unsigned long)bo[r->reloc_bo_index].user_priv;
 
-		if (unlikely(r->reloc_bo_offset + 4 >
+		if (unlikely((u64)r->reloc_bo_offset + 4 >
 			     nvbo->bo.mem.num_pages << PAGE_SHIFT)) {
 			NV_PRINTK(err, cli, "reloc outside of bo\n");
 			ret = -EINVAL;


