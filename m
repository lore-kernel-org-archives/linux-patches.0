Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100A0424D48;
	Wed,  9 Sep 2026 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963131; cv=none; b=jGh6VFD6Y7iuA8MfyxZwEhzP5t7xXMX8QK59463JGazzBz3yzTqJxOf/BFuHrvMdl75D4IiYtPURsPvco780bpqPMLGrABSGQ1woIQp0RxRsVOQAIZE7i8VRH6ToMCX94T8r3evju7j9YuHdFV7qGqgMGuUrZdr2xd8uePV9Z34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963131; c=relaxed/simple;
	bh=mZEqoYkp3qftkjU54frZd2vzFjwhmlx1D7NQIhBLM18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkukXt1yULLeTJwLhKNJDMx3PvZxqWmUPt7/iozMVwAraXEaWq34LVbhKt9zszT/OdQA8CIjnxUxKUnUdzx8MAJWDsUB7TlsechaDy3wJHEtfMpIs0uDDnkgToPECO7rbJ2Wt13TxDyfNUjk1ldP7HhliZ/4SMg6lc838LvyerY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMzMupOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMzMupOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6729C1F00A3E;
	Wed,  9 Sep 2026 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963129;
	bh=FrrB0H7MG+273XH8ZV+STfT1lJLUWDfX/mNvg4ChyQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMzMupOonV6xHfylNwpEil3ZLZClnXB14FTiKAlh/hr56wZ5xEgG6Jlxc1/o0WZoB
	 LQn3r0oWrE8mAtI1XtN5jJshnRTwj74ElkGUtJZVj/Mxi9jyFuuaZZvDA/WevOqI0Y
	 4b+PXAsAmMcjwLOuFhDqdOR2yJSbwveIb1wSBBus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.2 531/556] drm/nouveau/uvmm: fix NULL deref unwinding an OP_MAP_SPARSE op
Date: Wed,  9 Sep 2026 15:43:31 +0200
Message-ID: <20260909134249.086462125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenhao Wan <whi4ed0g@gmail.com>

commit 412a6ceb56d501ef2f8202e26ab4b5d4dfbca566 upstream.

Each bind_job_op is zeroed by kzalloc_obj() in bind_job_op_from_uop(),
and the OP_MAP_SPARSE case in nouveau_uvmm_bind_job_submit() only creates
a region, so op->ops stays NULL for a successfully processed sparse map.

If a later op in the same job fails, the reverse unwind loop revisits that
op and calls drm_gpuva_ops_free(&uvmm->base, op->ops) unconditionally.
drm_gpuva_ops_free() dereferences its argument right away
(list_for_each_entry_safe on &ops->list), so a NULL op->ops oopses. The
path is reachable by any render-node fd holder, since NOUVEAU_VM_BIND is
DRM_RENDER_ALLOW.

Guard the free with IS_ERR_OR_NULL(), as nouveau_uvmm_bind_job_cleanup()
already does for the identical free.

Fixes: b88baab82871 ("drm/nouveau: implement new VM_BIND uAPI")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260811-nouveau-uvmm-vmbind-fixes-v2-1-aaee4b395d04@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_uvmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_uvmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
@@ -1489,7 +1489,8 @@ unwind:
 			break;
 		}
 
-		drm_gpuva_ops_free(&uvmm->base, op->ops);
+		if (!IS_ERR_OR_NULL(op->ops))
+			drm_gpuva_ops_free(&uvmm->base, op->ops);
 		op->ops = NULL;
 		op->reg = NULL;
 	}


