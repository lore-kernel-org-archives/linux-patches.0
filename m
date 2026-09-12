Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47A035C6AA;
	Sat, 12 Sep 2026 11:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214271; cv=none; b=Xu6QHlKVtGO9SVggZymlc5CC+LNCmuAfE49GxxqkFmIFzhapqLHWTIVZzmgUaF/IIy1XUC1tKz981jOM/26XIynaqvramWdIrvV61FVMIV3gxkX5EeoHotcHkSpw26PBAjOsWe7jT81QD8h2jFc3Kaj6eBvg/EE/42MHAzl3khI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214271; c=relaxed/simple;
	bh=KLjCvPzcYbVDBW+VJZQo/mRgSm3+dA9JCR89VE3+6ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvdebqWFbRNAIpJgmysDYBwUPDFBN3atzmxpODeDy5m1KntmklBMJN6mQLBVYAhhZmkputraSVpT9aHKhczQDMwRsOQTP23i4XZmnonE922h4RX1g9iu+t0CsuueNW1eVJDxcCBhbKXE9jQAv2hP8qOkXfJ1g55izAMfnVapYGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xi4DLkQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xi4DLkQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D991F000FF;
	Sat, 12 Sep 2026 11:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214270;
	bh=WHftdjhOgdMYIMzJXzecYhhfYjLylP5+treOuyB/Oqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xi4DLkQNsy4QWvDXuAI9fMEPnslzR6NBM01nckiHrolRRU29XYXJlLAqRJNricfH2
	 GFJ7U0MFYvVU6qO3kCNNXt4UhNPnMXtbLtXcKnZhSllwd4MbbovN3sQ75VCsdcVfgp
	 xgtrUEi58GzwXrEabdL+SnNYTwXXlxr8kzF5ZzRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 0285/1376] drm/nouveau/uvmm: clear the dirty flag when unwinding an OP_UNMAP_SPARSE
Date: Sat, 12 Sep 2026 08:45:11 +0200
Message-ID: <20260912065613.898835866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1404,6 +1404,7 @@ unwind:
 						    op->va.range);
 			break;
 		case OP_UNMAP_SPARSE:
+			op->reg->dirty = false;
 			__nouveau_uvma_region_insert(uvmm, op->reg);
 			nouveau_uvmm_sm_unmap_prepare_unwind(uvmm, &op->new,
 							     op->ops);


