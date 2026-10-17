Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C159394470;
	Sat, 17 Oct 2026 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256184; cv=none; b=IAhF46peJmp+mAJY9W6zQyAfjrjoyhqycBde+uHe0+cEW2TS+D3dm58jSXnoCKjEuwTjLpbxgNiGd8oTCQJribZIlSoSyiQ5Kl1nypP0ZypNjJp7v3/4ZrkSY87Y7Y1GsLVZXHoqzUa+23Gq2Su25gf20rEBKATPDJLadDVKVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256184; c=relaxed/simple;
	bh=1k5RNtmn8BMoyhHVBhCkdTAxsXX223esFHASQIyiZag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0AFs8dZ53JEKfbPMZWtgtO7EWpRTQFtq2YWOqcP4YLhn/8mR0jRawsQOPU8JwC8lAxzdZgEC0FxblqdUsOQJFvDUxVGszdEYQW4KJz7/G3mnhYi25/4b6x2bBvC2kdbRETxWnhhdSXXIy1uYb43jJJ3jQ4eFouSuynxxI8GYA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0//rc6Bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0//rc6Bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3BD1F000C4;
	Sat, 17 Oct 2026 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256183;
	bh=SQc019uv7VYtETdECRtAi9Lf9WLMRPgTTSdvjwgkpfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0//rc6BiYcJ1WAKxgSpa09FJDIV4YCfAqx3AofoJsmUrbjgaqKSTev+T4YWIRuQ+y
	 eKY+YCJb5+TNx+elyNMiD7wAzVWa8oYvvvPVXtGgqjBle28yNDdbm2faDSq0sA7MJm
	 h2Cw/oVtd4Pd9UoE+3wcrKdG5vYqA3MocjzYDAnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0151/1674] drm/nouveau/uvmm: fix NULL deref unwinding an OP_MAP_SPARSE op
Date: Sat, 17 Oct 2026 17:40:23 +0200
Message-ID: <20261017160435.040602352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit 412a6ceb56d501ef2f8202e26ab4b5d4dfbca566 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_uvmm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_uvmm.c b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
index a56d6adf42958..b9d16d42cfc67 100644
--- a/drivers/gpu/drm/nouveau/nouveau_uvmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
@@ -1419,7 +1419,8 @@ nouveau_uvmm_bind_job_submit(struct nouveau_job *job)
 			break;
 		}
 
-		drm_gpuva_ops_free(&uvmm->umgr, op->ops);
+		if (!IS_ERR_OR_NULL(op->ops))
+			drm_gpuva_ops_free(&uvmm->umgr, op->ops);
 		op->ops = NULL;
 		op->reg = NULL;
 	}
-- 
2.53.0



