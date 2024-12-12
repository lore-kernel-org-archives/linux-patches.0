Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279F22A807;
	Thu, 12 Dec 2024 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021523; cv=none; b=iiHgJSSYJwfynRAySd8lMqq5nTnLOMNEZc/163LkpUP7P07c4G+muF69m4F+Ckq7UqL2WVU91M5W+cZLLdmIKgsF8xc+ICfUtW8rjVc0ban9U9f63qXlPFn+D5mi5y1IGvwVlz6o+USwwQ8wcq41xf+PXykra27ROldDbEyXK1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021523; c=relaxed/simple;
	bh=dCwBoF/JvVoaWyl0On4q9IEO+WlDd1hVKy0v5/Yo8v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gId49iFkcvNsTs9C5QTFgGt6wkNPNLhjH2yCN0WBHV15f/3HE4a/mv9gXELBmqz4C4YzTJTJmRBkBGhnBwS4Mp9OXJ0Xd2PnjJwKfMNHKH70aAUTCM+R3lyqqk3AEyElFgAzvJgdtZdkbQC8PWAtbE81sA+nG+9zQKPKXKX5+OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvwxTDZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvwxTDZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA96C4CED0;
	Thu, 12 Dec 2024 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021523;
	bh=dCwBoF/JvVoaWyl0On4q9IEO+WlDd1hVKy0v5/Yo8v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvwxTDZApTMSRKWue2UyIzO+c794j9pXwiAoLuSNZN4LGXdy5KmkmhNXv3vj2KGnn
	 TETFUAkC7TWzIg9BnzrzDdV3prvDfR3sxr4i6pR1zOC4dSRBIW5yUAy0WHDqtwJ/vN
	 QXzptYPVX5YAWwucF9DyopDQCo7VHm0hTvBNI8j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"zack.rusin@broadcom.com, thomas.hellstrom@linux.intel.com, christian.koenig@amd.com, ray.huang@amd.com, airlied@gmail.com, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, vasavi.sirnapalli@broadcom.com, Ye Li" <ye.li@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Ye Li <ye.li@broadcom.com>
Subject: [PATCH 6.1 762/772] drm/ttm: Print the memory decryption status just once
Date: Thu, 12 Dec 2024 16:01:47 +0100
Message-ID: <20241212144421.429793574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit 27906e5d78248b19bcdfdae72049338c828897bb upstream.

Stop printing the TT memory decryption status info each time tt is created
and instead print it just once.

Reduces the spam in the system logs when running guests with SEV enabled.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 71ce046327cf ("drm/ttm: Make sure the mapped tt pages are decrypted when needed")
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v5.14+
Link: https://patchwork.freedesktop.org/patch/msgid/20240408155605.1398631-1-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ye Li <ye.li@broadcom.com>
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_tt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -90,7 +90,7 @@ int ttm_tt_create(struct ttm_buffer_obje
 	 */
 	if (bdev->pool.use_dma_alloc && cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
 		page_flags |= TTM_TT_FLAG_DECRYPTED;
-		drm_info(ddev, "TT memory decryption enabled.");
+		drm_info_once(ddev, "TT memory decryption enabled.");
 	}
 
 	bo->ttm = bdev->funcs->ttm_tt_create(bo, page_flags);


