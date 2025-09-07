Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CC84315A;
	Sun,  7 Sep 2025 20:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277790; cv=none; b=XplfacgUV62Kxu+rMpigNYljJoJ4uxlhnkjzHPkYqHA1q4d2Dmu8rZHmJo23o6IOaig+mS3AfAHuTZo0MBiivopFie+kauEOY+3nGDhtSy9LNq0Zij/p4+m6ogc63Q35rcwK/i1TWEZvZhGtABio/sskwDr9e7bjSCyNUVt/gJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277790; c=relaxed/simple;
	bh=KX3nbM39NPj5WSYM/mG/vqfy3MsDs/Aif/xN8HsOA2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6EmqAEmM6+EHd6GsUxFdeFVjzH+oKS371IU+043dd5hrhHh3tq5LSm2m6Qgvp3rDTVJ58vuEY2pWvfwcH+SNNvXxD8601s/LGsglAdtVEULr6E+yRd4yRhUW8BiMbFEfjczSrxz1VL5yl8Lzh5LuMk1J3FUiEZoyadn4mqgDak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvvGkgPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvvGkgPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A93C4CEF0;
	Sun,  7 Sep 2025 20:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277790;
	bh=KX3nbM39NPj5WSYM/mG/vqfy3MsDs/Aif/xN8HsOA2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvvGkgPwlN0+SvnTFXSxQa5r4sNfs0e+Ii1SUzYUHXXqGBNqCgFF67g1O7v7qo6QS
	 sKRttqvwQpYgo+x0ZWNfPIWJAcQdxyQ+/YXKv6CiSxvgkDpA3QwgSwxI7aGusS/E/E
	 JdxWNn19ZpuZU5+2he/vsYa/rmVVXEB0gwq8ahuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.16 125/183] drm/xe: Fix incorrect migration of backed-up object to VRAM
Date: Sun,  7 Sep 2025 21:59:12 +0200
Message-ID: <20250907195618.760629865@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 379b3c983fc0257c183052278832ac68e3ccd33b upstream.

If an object is backed up to shmem it is incorrectly identified
as not having valid data by the move code. This means moving
to VRAM skips the -EMULTIHOP step and the bo is cleared. This
causes all sorts of weird behaviour on DGFX if an already evicted
object is targeted by the shrinker.

Fix this by using ttm_tt_is_swapped() to identify backed-up
objects.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5996
Fixes: 00c8efc3180f ("drm/xe: Add a shrinker for xe bos")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250828134837.5709-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit 1047bd82794a1eab64d643f196d09171ce983f44)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -803,8 +803,7 @@ static int xe_bo_move(struct ttm_buffer_
 		return ret;
 	}
 
-	tt_has_data = ttm && (ttm_tt_is_populated(ttm) ||
-			      (ttm->page_flags & TTM_TT_FLAG_SWAPPED));
+	tt_has_data = ttm && (ttm_tt_is_populated(ttm) || ttm_tt_is_swapped(ttm));
 
 	move_lacks_source = !old_mem || (handle_system_ccs ? (!bo->ccs_cleared) :
 					 (!mem_type_is_vram(old_mem_type) && !tt_has_data));


