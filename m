Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E668C2DB7BB;
	Fri,  7 Aug 2026 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115612; cv=none; b=ZnSRq/wDshitaMOUPSEaQT7SFb6n73jjjRVIFz0zfVJgdsJooPg/McW+AiDudBtbQdzSeO7GOdDzYOHKh7I4Pebn6Dbo9nhFS9hkoaNXeOOXOMRS5ZEFARLMcgjsdxRbmtHz0CcjttbQmQyTErh25C51DNsyvXtYI7uLeIyNnR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115612; c=relaxed/simple;
	bh=ZxpfBbwU3N4uFVUfOmy3AoqTzArz4KJkBi2k1b2LtkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwyPy8AfO06DJtqeQzNe9/wk7o902lDX59qRhEvL12kPhETpB9DCIYiPtot0jWv+w6gLsRWGzWL2WrOSyCiWKr7/IiGzoqRGfSw4bYlPN9MYbjayY6ryR9cMuGLYg1f2HuKSzAT2naEL4YhDMDLkTnsN+HM5KawF2HZxfPIdd8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dP2EOawr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dP2EOawr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456AA1F00A3F;
	Fri,  7 Aug 2026 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115610;
	bh=64zXBea34Lzhsi7CB4O2+cAvpQIVFAKfFaVq0AxwqYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP2EOawrojblV6ACS90tFRLpbTHmjy9gpR9JSx2GY1bn9wbvlMfMFxhXvwEiWVYH+
	 hF5YtZvsBCpkUVHLRhTimC0WCxFFIBsLUA1Tib7Tkncq/NAgr+aXUdRVt/pGY/pMxT
	 qYcu4xD9mR1U18vweAgQKjU2EsX7U+y+6JoVdpjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.18 330/396] drm/vmwgfx: fix guest_memory_dirty bitfield clobbered as size
Date: Fri,  7 Aug 2026 16:38:10 +0200
Message-ID: <20260807143431.407703802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 83195b778f2d109a3a4f3ffaba4dce7e4cdb58aa upstream.

Two sites in vmwgfx_resource.c assign boolean literals to
res->guest_memory_size, which is an unsigned long allocation-size
field; the intended target is the adjacent res->guest_memory_dirty
bitfield.  After the assignments the field holds 0 or 1 instead of
the resource's MOB allocation size:

  - vmw_resource_release()       writes 0 (false), and
  - vmw_resource_unbind_list()   writes 1 (true).

Subsequent revalidation paths read guest_memory_size when computing
the dirty page range (vmw_bo_dirty_transfer_to_res()) and the buffer
allocation size (vmw_resource_buf_alloc()), producing zero-length
walks or wrap-around ranges that read or write past the MOB bitmap.
The dirty-tracking intent of the original code (mark the resource as
dirtied since the last sync) is also lost, since guest_memory_dirty
is never updated.

Rename both assignments to guest_memory_dirty.

Fixes: 668b206601c5 ("drm/vmwgfx: Stop using raw ttm_buffer_object's")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-2-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -136,7 +136,7 @@ static void vmw_resource_release(struct
 			val_buf.num_shared = 0;
 			res->func->unbind(res, false, &val_buf);
 		}
-		res->guest_memory_size = false;
+		res->guest_memory_dirty = false;
 		vmw_resource_mob_detach(res);
 		if (res->dirty)
 			res->func->dirty_free(res);
@@ -773,7 +773,7 @@ void vmw_resource_unbind_list(struct vmw
 		if (!WARN_ON_ONCE(!res->func->unbind))
 			(void) res->func->unbind(res, res->res_dirty, &val_buf);
 
-		res->guest_memory_size = true;
+		res->guest_memory_dirty = true;
 		res->res_dirty = false;
 		vmw_resource_mob_detach(res);
 	}


