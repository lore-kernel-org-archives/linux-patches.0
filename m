Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A28216605;
	Tue, 29 Apr 2025 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948568; cv=none; b=iyxDiiit5V6zSXkMQDhLLwBjrj87vMv5oyAKUtxbjRqznVAkNGVBtup9ICaB38gIzRFuS+T0uRxitpkscxGoOFVLEv+sIuicsuGtFlibzr9i5bg5u6aTPSby5muSNqWtcOlLj1VPJajDawJQpxI166/QW4d+loWBMR99OEAaoGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948568; c=relaxed/simple;
	bh=ZZzXZAljn48QUpjfxwVXMe3MeHp008JNnyG6qpjqidg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq6jJYYpWW1GNGZAboO3Kcw0ovd7gZx/4lFObhSeZlTNR0lKUDentdHgYcRpYT2NAihmBUcvTrlSLBJ7AuvxEAGzGy8Ol+TYZgtJRPsiJJDXXTyFoQOoUO20cwf8VgYLLlqR8ggviWuz8cWW/ioL0ed7tJvtt2kdrdFxn4JyNs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2rnAwf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2rnAwf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A195FC4CEE3;
	Tue, 29 Apr 2025 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948568;
	bh=ZZzXZAljn48QUpjfxwVXMe3MeHp008JNnyG6qpjqidg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2rnAwf75UD8zfO4KbdpeOHSZPc+6P3hCh0HJew/H2wbchN1CHTjzpfKZBkDqoy6P
	 Ekq1hRE8R/sjavtQ8Ou3TLCoWC/cxkPDLKfJ4bjTraSvfVDZYb0s5i+pSU0EeD3NDE
	 N3jX0os3Mf6LMUb96yuRYqj7hRW+yqpy4BLCa0bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/373] drm/amdkfd: Fix pqm_destroy_queue race with GPU reset
Date: Tue, 29 Apr 2025 18:38:43 +0200
Message-ID: <20250429161125.029744692@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 7919b4cad5545ed93778f11881ceee72e4dbed66 ]

If GPU in reset, destroy_queue return -EIO, pqm_destroy_queue should
delete the queue from process_queue_list and free the resource.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 243dd1efcdbf5..7a298158ed11a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -384,7 +384,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 			pr_err("Pasid 0x%x destroy queue %d failed, ret %d\n",
 				pqm->process->pasid,
 				pqn->q->properties.queue_id, retval);
-			if (retval != -ETIME)
+			if (retval != -ETIME && retval != -EIO)
 				goto err_destroy_queue;
 		}
 
-- 
2.39.5



