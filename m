Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AD51DE4EF;
	Sat, 12 Sep 2026 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222146; cv=none; b=jl7fjiPAh4LIthEZhwXq+BMhdc5Ovm0iItgI3AMbXMmQu0IBjPSfl8CQP50LcwN6Bl+5/lQQaKdwN7tuTStH+tUR5gC5+XU7Xv/fqcKHto9gSEeYGvf6fYdLGQEXnB00SWj9/AKPyNryGz26FgXYH9SlURdgRZtW7VWimOQzvXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222146; c=relaxed/simple;
	bh=5hfG4DsWkb9/ahMdx7iT2ZoWXnzyRYFp9td7/kn7jm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFIkqacraXyV06L4kNGpROEXIfxtAFhEG6m6nUqXu/epzjEgqZDwOfTJKs+0WGXuvBHlAaNTRFjUu4zYtRMIT8NJnsPsveFB4V4q0e/ZZ3H4Lx9Cru2aJFDra5669I47o+J0WZikDDOu68/TztGbbMg716h/phd3MIKw2ZUvV8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYdS7dky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYdS7dky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECEA1F000FF;
	Sat, 12 Sep 2026 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222145;
	bh=gk+wi8ELcXuRvOaaqYFWyYusiZ13hUoSJaH8vRB9TZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYdS7dkyA3A+YdsAYdLKFSZLbeCQbw1Dkv/kA61JKLuGiSO/wm8HwJNbm9Hi4hTyw
	 cpVECxrtjss9SaDsjW7NLVu3axApS3bc5DeRTeEeQozMzkfxW1uCdtHRy4VY8NBwoe
	 i6oX+u1nO8huU2NVsiBQo3+DX8xbVYVjYsEfTCR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 0527/1424] drm/nouveau/uvmm: clear the dirty flag when unwinding an OP_UNMAP_SPARSE
Date: Sat, 12 Sep 2026 08:49:19 +0200
Message-ID: <20260912065619.093948686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Zhenhao Wan <whi4ed0g@gmail.com>

commit 38a62306c4266bcb3cd89e33c7111ee33096ebb3 upstream.

A successful OP_UNMAP_SPARSE marks its region dirty with
nouveau_uvma_region_dirty() and defers the teardown to
nouveau_uvmm_bind_job_cleanup(); it does not remove the region from
uvmm->region_mt.

If a later op in the job fails, the unwind path never clears reg->dirty
(set in one place, cleared nowhere) and sets op->reg = NULL, so cleanup
skips the teardown. The region is left in the tree with dirty set and its
completion never signalled. Later binds over that range then fail
permanently -- -ENOENT or -EINVAL from the dirty checks, or an unkillable
wait_for_completion() in bind_validate_region() -- for the lifetime of
the uvmm.

Clear reg->dirty when the unwind reverts the sparse unmap, restoring the
region to the state it was found in.

Fixes: b88baab82871 ("drm/nouveau: implement new VM_BIND uAPI")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260811-nouveau-uvmm-vmbind-fixes-v2-3-aaee4b395d04@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_uvmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nouveau_uvmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
@@ -1392,6 +1392,7 @@ unwind:
 						    op->va.range);
 			break;
 		case OP_UNMAP_SPARSE:
+			op->reg->dirty = false;
 			__nouveau_uvma_region_insert(uvmm, op->reg);
 			nouveau_uvmm_sm_unmap_prepare_unwind(uvmm, &op->new,
 							     op->ops);


