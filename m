Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3853FF1B5;
	Thu, 30 Jul 2026 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422438; cv=none; b=JCy5Vub0iXhll4cUbKWHqPQrERQvwF+sYUJ+2KIZ6rBb2LsJOycHF08j5ESHszKaPiMGfcODXhuDjS5ULvVlIQqv0e6SZDCXgVM2qVoFSlvHJbZrYsT2FwvbJ8mbE+AUA8kaAXIYhwx5e9xSHpRe7QdlL1qKqdnxZYQHGnUW6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422438; c=relaxed/simple;
	bh=aFXSIn3vUNjllFYzMeabElgjXBfQhYEAKtl+CZX+rIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4s2+mibBfi0zj8TlAI3vvVjoxFhyukEOfQpAkKMlXPHYYFqk58Pjr+UMfVnGrDMqjtYcU6Vm0KoYsGkaH/gi/IZsl9sPA1PWw27P/02U5TWXT7K09sqv0klHFJwwnJW7NApAFj+Xe74aJExQQhTLA6+UpoUDUXzM3QVw15wg3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBDcp9I7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBDcp9I7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B0D1F000E9;
	Thu, 30 Jul 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422437;
	bh=BS21Ji2/o17lkO67wzI7qgKdzKZe1ydMkKQQukhHLLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBDcp9I787W74PpiieKEp9r+81NugJUWI4dGyrmbUbvx2YafHo+P/60ReCn7rhx7/
	 E0gdVp5yg7eqBbYoztSo3TvOTaKklJ+7BA7T9iu1NRGVsk6oZ5tmc9MdzPeZpwDu91
	 qKxKuucnsUBThyJfLsgCIz0RowD/s+9TQhBAKleQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 7.1 438/744] drm/amdgpu: trigger GPU recovery when userq destroy fails to unmap a hung queue
Date: Thu, 30 Jul 2026 16:11:51 +0200
Message-ID: <20260730141453.607141373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 614e8a989d462876c4f6a659f56e1075e72ad515 upstream.

Destroying a hung user queue issues a MES REMOVE_QUEUE that times out,
The destroy path only logged the error and freed the queue, so the
next userq submission failed and forced a GPU reset attributed to an innocent workload.

Kick the userq reset work when unmap fails so the GPU is recovered at
destroy time.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8396b9de4198a54ec4760a94a179347540a9764d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -523,6 +523,15 @@ amdgpu_userq_destroy(struct amdgpu_userq
 	amdgpu_userq_cleanup(queue);
 	mutex_unlock(&uq_mgr->userq_mutex);
 
+	/*
+	 * A failed unmap means MES could not remove the hung queue and is now
+	 * unresponsive.  Recover the GPU here so the wedged MES does not fail
+	 * the next, unrelated queue submission and trigger a reset attributed
+	 * to an innocent workload.
+	 */
+	if (r)
+		queue_work(adev->reset_domain->wq, &uq_mgr->reset_work);
+
 	cancel_delayed_work_sync(&queue->hang_detect_work);
 	uq_funcs->mqd_destroy(queue);
 	queue->userq_mgr = NULL;


