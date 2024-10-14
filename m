Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217871A28C;
	Mon, 14 Oct 2024 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916569; cv=none; b=FgLgZJcj3Hwl0dedc5k32p0UBdjf3STLMaz9ymmXglwFyiBz/32J7MjrCg4Ch0xJ7M/vKNK4h+pPf3sdLIO2Gdpr6YJ/5RiHe2o1FkKH1d3z+CF4lHh3vMJCWBuSN1RiKQWG5dXM9gStWwXH0EoScEGWDsa545SBObnzsomA//0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916569; c=relaxed/simple;
	bh=DTQhO/4o1ceMK+uoG142RSmvSFRfZh0spaGJ7U76cqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYuO1exyL94KSOKCnKcNLI6e8YMV3/NszCjolXC+4BPK+ZOuHhnNEMtKxUby2ifyF/Fsocn1WMY64UpsfY2wg8CqrLFHXb22flpaCSBXc6F16BkubR9RKL9tRIpsEOTMS7+l9KMEHKUvcbfpOST6OXykWVqLb5i9OMmvNTbTX1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16z/hpOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16z/hpOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3F4C4CEC3;
	Mon, 14 Oct 2024 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916568;
	bh=DTQhO/4o1ceMK+uoG142RSmvSFRfZh0spaGJ7U76cqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16z/hpODwIWGxZmbPExcDk/o/JR2zQHkXBP+rtcc17frXVQtTL6k6oWY1q9O6g2FT
	 fD2WWZg4lTENmgTX89DTnX2zsUdsS6FpkHWBepM8Y56HtJhzX1y7wZM4UKQPi6gBu3
	 Q7zxzAUBzfhCGRy1qmEkLefURiWWxPVlKXKzzy0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonatan Maman <Ymaman@Nvidia.com>,
	Gal Shalom <GalShalom@Nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.11 202/214] nouveau/dmem: Fix vulnerability in migrate_to_ram upon copy error
Date: Mon, 14 Oct 2024 16:21:05 +0200
Message-ID: <20241014141052.859117128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonatan Maman <Ymaman@Nvidia.com>

commit 835745a377a4519decd1a36d6b926e369b3033e2 upstream.

The `nouveau_dmem_copy_one` function ensures that the copy push command is
sent to the device firmware but does not track whether it was executed
successfully.

In the case of a copy error (e.g., firmware or hardware failure), the
copy push command will be sent via the firmware channel, and
`nouveau_dmem_copy_one` will likely report success, leading to the
`migrate_to_ram` function returning a dirty HIGH_USER page to the user.

This can result in a security vulnerability, as a HIGH_USER page that may
contain sensitive or corrupted data could be returned to the user.

To prevent this vulnerability, we allocate a zero page. Thus, in case of
an error, a non-dirty (zero) page will be returned to the user.

Fixes: 5be73b690875 ("drm/nouveau/dmem: device memory helpers for SVM")
Signed-off-by: Yonatan Maman <Ymaman@Nvidia.com>
Co-developed-by: Gal Shalom <GalShalom@Nvidia.com>
Signed-off-by: Gal Shalom <GalShalom@Nvidia.com>
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008115943.990286-3-ymaman@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -193,7 +193,7 @@ static vm_fault_t nouveau_dmem_migrate_t
 	if (!spage || !(src & MIGRATE_PFN_MIGRATE))
 		goto done;
 
-	dpage = alloc_page_vma(GFP_HIGHUSER, vmf->vma, vmf->address);
+	dpage = alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vmf->vma, vmf->address);
 	if (!dpage)
 		goto done;
 


