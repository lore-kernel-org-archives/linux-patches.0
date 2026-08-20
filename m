Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1416547D47A;
	Thu, 20 Aug 2026 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243948; cv=none; b=lYGCQ5NdYDj1r2mbpTpoXeHrid7xra6gxc4KJk1c3XvZXqCp0rOH9M6o3vZLvie/hftJR+moKYFAVwYYO7r6o9kEEPEKsIesNbHeeb2XeitDI4z4I506/EZwj03CTIemqPs7Z1BfAqlO6An2nv6b3niDHeIoMzbToJnJxwMHNTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243948; c=relaxed/simple;
	bh=dJg1W/ADL5Bk5/4WBQYwIvW7UblJ/ZCgJtvWq/WksEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cZBblIUubm9caUAFO6tkzje89CkewzBJLqA8KOCKJzETIjZzIAOWSuLgsBeVHd+ZJbd6cJAAbzmv8gPEqU7JBV9IGkRpeOn7W/bcYyiLyV3ifYHIe1s0xrVQyqRPdzF2Philg33NxOXUtDXItbkvGWxzW10NR8apHv5eA150Kw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgngTlO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgngTlO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F39A1F00A3E;
	Thu, 20 Aug 2026 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243946;
	bh=DAc7CKnwLgwTBtBU2YOis/qO5/DlKX0ddE1Ekkh8UAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgngTlO33/rk/Fc2mIheiPj/cBGTYq8VU31GQCiVQR+C5Ke6MEs3qebgmLl+Kp/79
	 9d/xYq1mnHNI7LSZFUgQE5K+hokobC1AlhJbKPp+Q5VL5/utnAs3BBX+ZM0Kefs/kU
	 CtkT1R4sT+8S2wgqUFSImR8mqYoeNEWR6VUkpdZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.15 270/272] drm/vmwgfx: Reserve fence slots on buffer objects in cotables
Date: Thu, 20 Aug 2026 16:57:34 +0200
Message-ID: <20260820145239.735649741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zackr@vmware.com>

commit 544ccad739251b21dfa1e7f4b57aa9ea50d2d0f1 upstream.

The buffer objects created by cotables were missing fence reservations.
They are created from vmw_validation_res_validate which makes them miss
the ttm_eu_reserve_buffers which is called from vmw_validation_bo_reserve.

Cotables are the only resources which create a buffer object in the
create callback so make sure the code also reserves the slots.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Co-developed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: c8d4c18bfbc4 ("dma-buf/drivers: make reserving a shared slot mandatory v4")
Link: https://patchwork.freedesktop.org/patch/msgid/20220422161342.1142584-1-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cotable.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cotable.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cotable.c
@@ -482,6 +482,10 @@ static int vmw_cotable_resize(struct vmw
 	vmw_bo_unreference(&old_buf);
 	res->id = vcotbl->type;
 
+	ret = dma_resv_reserve_fences(bo->base.resv, 1);
+	if (unlikely(ret))
+		goto out_wait;
+
 	/* Release the pin acquired in vmw_bo_init */
 	ttm_bo_unpin(bo);
 


