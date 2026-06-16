Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ED74502F;
	Tue, 16 Jun 2026 16:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627919; cv=none; b=g46ClNuaAkL6o8t1gZGKzhfRtwjOcXxHEn2hevjWW8V7aYFrHFRCitnNnSnvzei9MqjPbzIW9bXe5Typn760def2otYzG9/n0MvCCYQbs7hN4arHG2+alX67i5dp5rKFHyUIlVSzLucCPd1aIdCG/H1ltE1dUZUulVx81uN12jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627919; c=relaxed/simple;
	bh=u2xVoUKWWNSeyyiWq+URq9O3GeghNKz4dYl8gqpPG0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVCVfKaGdsovOGHyUQ6FXvI4Y/i/XRRTmQPo7Z1Rv6hfzHuSzx78JDGSG9AselqjgkfIHc7cSegs4G093WF/57ZfEVXu/ZfXEv324yx9Q+F2BeCM6VAWNrIGo2DszBmhhCbDI3Y7taPCxwqBOtq2aAX1q2u2fEhbbLh4Jy12qZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcGyH5nP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcGyH5nP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463791F000E9;
	Tue, 16 Jun 2026 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627918;
	bh=TDMjqZdDJxhvEYXRn4cheK+X6rCR8dZlLV8Q6txY60U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcGyH5nP1+bzVfYwnh5f/9n7qQmOCy5/QR1vGXBbWIBAaoUMtn1KL2ZP6j133kVt7
	 qIerskNM8Iu6NuE3YiqykG98ktNVY9zs95xoYclDDGhScfw7RBGXmx7WoOqfyFxEjn
	 dDsTou/CLvkcFTrEi43UnXIgEn6rYYD7u8bEYb4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 219/261] drm/amdgpu: restart the CS if some parts of the VM are still invalidated
Date: Tue, 16 Jun 2026 20:30:57 +0530
Message-ID: <20260616145055.177583102@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1278,6 +1278,7 @@ static int amdgpu_cs_submit(struct amdgp
 {
 	struct amdgpu_fpriv *fpriv = p->filp->driver_priv;
 	struct amdgpu_job *leader = p->gang_leader;
+	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_list_entry *e;
 	struct drm_gem_object *gobj;
 	unsigned long index;
@@ -1323,7 +1324,8 @@ static int amdgpu_cs_submit(struct amdgp
 							e->range);
 		e->range = NULL;
 	}
-	if (r) {
+
+	if (r || !list_empty(&vm->invalidated)) {
 		r = -EAGAIN;
 		mutex_unlock(&p->adev->notifier_lock);
 		return r;


