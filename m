Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FDA24889B;
	Tue, 29 Apr 2025 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945198; cv=none; b=tS7fdFg/Wxgog8CGiu0FGEgVx9VeE/I6M6HJf4ZACUYc+niI4A9bbWTfM8RFULDqhKY3LS27s/FzyG5dGzajt5B36L8I8ZDpiJRt7EZiSObNRpeM1Es7UYSlvn55dEnDKq2iwtmGZ9/FHg7cxDgnjVGv0T/maUcnSXSHEUeDWuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945198; c=relaxed/simple;
	bh=3PwovqhGi0YUD0IgtHTw/YycYLg+lh4YU1Hrbj2BXpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qc4Ju3q861iwfZ+n4aMuSHU1AUnlcIUQ6tD2P4qkAu29pbuPxQxvwvHC1NLmy2/Q/wzA5bE78qToLsh5XYx7s6MISgD+mQ9s4wigWyGC+gE7pFA/PXnCGZyAOeYwesz9LpvqOCxq7ItCl0B5vPjsn7/dQkGevmYzUYQoaEuUDvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqlpoA+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqlpoA+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BACC4CEE3;
	Tue, 29 Apr 2025 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945198;
	bh=3PwovqhGi0YUD0IgtHTw/YycYLg+lh4YU1Hrbj2BXpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqlpoA+ly877AlhCfgz0xZrB8EX2fro1HmBfcD8wO4SLGxhV9T+DzoB8y1o/gWGRn
	 Ld/10/0D2HP5LJC7eJK1YXdvmQF8nJNkJVmRM1uAJtvV69qb67aX/yjmTgJBPVq2dp
	 vNiSOydmSa8ehSanUNQFZDXQEBjo/7RsCs2ABNyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/179] drm/amdkfd: Fix pqm_destroy_queue race with GPU reset
Date: Tue, 29 Apr 2025 18:39:35 +0200
Message-ID: <20250429161050.791407831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7e6c3ee82f5b2..234a09b60c552 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -380,7 +380,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 			pr_err("Pasid %d destroy queue %d failed, ret %d\n",
 				pqm->process->pasid,
 				pqn->q->properties.queue_id, retval);
-			if (retval != -ETIME)
+			if (retval != -ETIME && retval != -EIO)
 				goto err_destroy_queue;
 		}
 
-- 
2.39.5



