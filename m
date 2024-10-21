Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588ED1F4FA3;
	Mon, 21 Oct 2024 10:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507316; cv=none; b=X6UvVnaeFXkXutoQ0n+I3QjGOhgnrhAG8Ky97ExXMWFjTVgZT9v+1Uj7/uJ9SknpYM34uIzxpI+Y8ca0HFJQWiOGyaVvKdRpZE9AG0qHRCBoo41eKb923PXSB9bn1FPoo5qav8xKgvpxnJR59rUToZyXCd4P+KzDVAonx/Q1xsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507316; c=relaxed/simple;
	bh=qspK7hCPLXW+pwQYd8wngaaqTnlSINgfSqbWAZMt84k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TGu+ermVytB0G7F5Q1qmOZTuTg6VYiqOnuaZs4k80JkXUo8Dj/qli8i334S6EDCLVFMUz/Z9mkEco/asMYAVh0TI68nJD9L2G7BQCXikCsqqM0WPx36q+1Tm3YG0tjtYnAktdvqR972oR5Sh0l2BZLnbYtZ2hJ6tIeim2veymo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsA4YmaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsA4YmaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6101CC4CEC3;
	Mon, 21 Oct 2024 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507315;
	bh=qspK7hCPLXW+pwQYd8wngaaqTnlSINgfSqbWAZMt84k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsA4YmaIaoZquBxBhLktwuknfKshPRtAhzhecxyFHbcRnXpN0ygGchOGSSSCjRmjd
	 bt4tqbjrdRlui1+Oiy4+vet0U8pB9RMGYuNcE04ROGvRYKd5Pndy1HNzLhKNAUH0kM
	 VwnST+YnFTZBNkBRwbSoHCd31quCnp0Fv7oEaCGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
	Eric Anholt <eric@anholt.net>,
	Rob Herring <robh@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	"Wachowski, Karol" <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 6.1 37/91] drm/shmem-helper: Fix BUG_ON() on mmap(PROT_WRITE, MAP_PRIVATE)
Date: Mon, 21 Oct 2024 12:24:51 +0200
Message-ID: <20241021102251.270257207@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wachowski, Karol <karol.wachowski@intel.com>

commit 39bc27bd688066a63e56f7f64ad34fae03fbe3b8 upstream.

Lack of check for copy-on-write (COW) mapping in drm_gem_shmem_mmap
allows users to call mmap with PROT_WRITE and MAP_PRIVATE flag
causing a kernel panic due to BUG_ON in vmf_insert_pfn_prot:
BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));

Return -EINVAL early if COW mapping is detected.

This bug affects all drm drivers using default shmem helpers.
It can be reproduced by this simple example:
void *ptr = mmap(0, size, PROT_WRITE, MAP_PRIVATE, fd, mmap_offset);
ptr[0] = 0;

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Rob Herring <robh@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Wachowski, Karol <karol.wachowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20240520100514.925681-1-jacek.lawrynowicz@linux.intel.com
[ Sherry: bp to fix CVE-2024-39497, ignore context change due to missing
  commit 21aa27ddc582 ("drm/shmem-helper: Switch to reservation lock")  ]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -638,6 +638,9 @@ int drm_gem_shmem_mmap(struct drm_gem_sh
 		return ret;
 	}
 
+	if (is_cow_mapping(vma->vm_flags))
+		return -EINVAL;
+
 	ret = drm_gem_shmem_get_pages(shmem);
 	if (ret)
 		return ret;


