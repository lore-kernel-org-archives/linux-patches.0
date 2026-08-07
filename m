Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969DE471436;
	Fri,  7 Aug 2026 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116343; cv=none; b=O5gNMF+Qwh/BBOASlwlKpNWZXIeIY32DFRfdAwSJ37EoOuh3M/+bx6/r9beTPT4cOSQzHAT0LH/0/Ef37hnneC8g09pAK10HHgSMtkzrfdoloHr3H4ye2gtIsc7qTb5TLnrQJ4PRaOfoFjYsPF2bw51RYBW4BZdYV0SJV32BfMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116343; c=relaxed/simple;
	bh=lg3FshKNjHpeBUHqUo9KkA7JdxJvvW4Q3cbVTKcVoD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjZlbrcj45oDc8T2ZbGD6XmSD3orwvH2HwoyO6xyNGwc6lBx6ewAPCmPcloTP2QXwQdJZmycNFkH5ba7JHtX5bsBu82lY9KdNtgBCcFjMOd4TjgtDEW/5aubrG9ktnIuw+nbLT0OmJXFnDy9Kj7OxoTdqCG5LKVZiAVJXp2ANFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDPc6OP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDPc6OP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CE21F000E9;
	Fri,  7 Aug 2026 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116342;
	bh=14REIidWFLox2KfgYOdbJ53TJxVbU6CC5+rXNBoKDmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDPc6OP5Xsag/F1pWl2/n3re5eAICh3NM+0IqtvELt0qeKkw7f3j1lmIkMm4xgtcz
	 6++eiaO+0EVXgIxymeUSWx+ry0b062FRQreQ/veKUzTTnwN6WqPrDs8aWTBpgJHBKn
	 +XGCPvoTViEQzunM1qiWrMcggjxNUpnzofn363fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.6 197/261] drm/vmwgfx: fix guest_memory_dirty bitfield clobbered as size
Date: Fri,  7 Aug 2026 16:39:14 +0200
Message-ID: <20260807143419.618717874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,7 +134,7 @@ static void vmw_resource_release(struct
 			val_buf.num_shared = 0;
 			res->func->unbind(res, false, &val_buf);
 		}
-		res->guest_memory_size = false;
+		res->guest_memory_dirty = false;
 		vmw_resource_mob_detach(res);
 		if (res->dirty)
 			res->func->dirty_free(res);
@@ -764,7 +764,7 @@ void vmw_resource_unbind_list(struct vmw
 		if (!WARN_ON_ONCE(!res->func->unbind))
 			(void) res->func->unbind(res, res->res_dirty, &val_buf);
 
-		res->guest_memory_size = true;
+		res->guest_memory_dirty = true;
 		res->res_dirty = false;
 		vmw_resource_mob_detach(res);
 	}


