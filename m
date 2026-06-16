Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06444DB61;
	Tue, 16 Jun 2026 15:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624479; cv=none; b=cdtxJYGYU5iF9gvNehkRmexN9oGdvIfcO9HQQgYK+qrt1ysZs0q68DLFF90OCWB6ZfeSOxCIPSOCpvAgTzj6LQoCDS38y+wo6s2lDdLBvSVfadtdugSzs8GhrXhc0BRzowADhZJyRCmXwp7F7mj7lly7evDX+bDuA3bWezKSS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624479; c=relaxed/simple;
	bh=+/nQwUhgA97JpRbskdkvpXdrdDB150Ha/zHgMiPB1t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DWdzHIIJSpj2K1fT4PjgGNKloUeT8SsQUt42hLj3LYIh2DBmlwdLXq10o5U6RgCFnEHrJk5r4GbkaJ5YSLjZeqvyVn1YzHIYTdcLuRkA37UREaRhIuzNX9vlNQlLw0qZJTv4LMnqpKZwJ32yAey5u2dZKPErYT60cG1RZEi2ITs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXzaVwfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXzaVwfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3E51F000E9;
	Tue, 16 Jun 2026 15:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624478;
	bh=JLGX5XMnV6U8hv9j5ViYlLVHxHzh9a90RF+gOb1XgdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXzaVwfk+fAcYpKfmyRGisSnedejdkapxL2BGJqVYtVSMF25N/rsSZBz4qlcUUiHi
	 PjkbhyrbZnPDjNObmnkZ7xHmMUdjJ019LjAtQaj4CFEMxQQdEcRw/fpoeegfRy0sH7
	 L5zKzcmTx6d9YoUh4TVf/CpZlBkPqSHPIdmZcN2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 345/378] drm/amdgpu: restart the CS if some parts of the VM are still invalidated
Date: Tue, 16 Jun 2026 20:29:36 +0530
Message-ID: <20260616145128.336028376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 40396ffdf6120e2380706c59e1a84d7e765a37b6 upstream.

Make sure that we only submit work with full up to date VM page tables.

Backport to 7.1 and older.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 59720bfd8c6dbebeb8d5a7ab64241b007efd9213)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1285,6 +1285,7 @@ static int amdgpu_cs_submit(struct amdgp
 {
 	struct amdgpu_fpriv *fpriv = p->filp->driver_priv;
 	struct amdgpu_job *leader = p->gang_leader;
+	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_list_entry *e;
 	struct drm_gem_object *gobj;
 	unsigned long index;
@@ -1330,7 +1331,8 @@ static int amdgpu_cs_submit(struct amdgp
 		amdgpu_hmm_range_free(e->range);
 		e->range = NULL;
 	}
-	if (r) {
+
+	if (r || !list_empty(&vm->invalidated)) {
 		r = -EAGAIN;
 		mutex_unlock(&p->adev->notifier_lock);
 		return r;


