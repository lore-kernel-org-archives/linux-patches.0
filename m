Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E82F1F8901;
	Tue, 17 Dec 2024 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456450; cv=none; b=GVoqvgdJwBxKH6XwcJaO/D1aILPQwu+JUzF4ybX85Uro9VeGofEkrQREzTAsXvlNs3a87APakmc8fuVI2N2EJjZUjoZeL4LHk5QBmQjmMAcC5TnITc3AZpdwCMLR5rk5kGI/hjD1knKRipTzKiptrAzUootpsjiwE+1yR4F7FTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456450; c=relaxed/simple;
	bh=ER2s1WcjUJdybPqTxRZTm2SWiCOZ+Q5nAy3bQMQPjuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMwl8DLgDGTX62P3y14pCmxDhmY/3+exWKj4sF3yBy9bmI5DWwojLU8JipTLOlW28mrMRoMfp6X39LCJYIXLCKocf9KhfwR/Yj9oe+CY5TMREkeafQw7z219oOntJm1b8rfhWUp0ZxEtSrnGWqC6kXFG1B1FlkHU+sxbZJC9plk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1KS0fJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1KS0fJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058E8C4CED3;
	Tue, 17 Dec 2024 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456450;
	bh=ER2s1WcjUJdybPqTxRZTm2SWiCOZ+Q5nAy3bQMQPjuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1KS0fJOj2vNHaNgRiMAiakPhSIgpAjPlzWaTVW0fSANGbwOzzYiMKcVYZK7A+5BL
	 9psMLBb/G5QnRlKB/03TMuQ4kna5bjPrD7/FlM2cUSdBef76exM2+0H9Y40xNF4KkG
	 R1ZYu9ZCFDKhtXS3QK8Od0Cs5RO/ugsHMRFfijO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Martin <Andrew.Martin@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 064/172] drm/amdkfd: Dereference null return value
Date: Tue, 17 Dec 2024 18:07:00 +0100
Message-ID: <20241217170548.933715284@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrew Martin <Andrew.Martin@amd.com>

commit a592bb19abdc2072875c87da606461bfd7821b08 upstream.

In the function pqm_uninit there is a call-assignment of "pdd =
kfd_get_process_device_data" which could be null, and this value was
later dereferenced without checking.

Fixes: fb91065851cd ("drm/amdkfd: Refactor queue wptr_bo GART mapping")
Signed-off-by: Andrew Martin <Andrew.Martin@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c   | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index c76db22a1000..59b92d66e958 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -212,13 +212,17 @@ static void pqm_clean_queue_resource(struct process_queue_manager *pqm,
 void pqm_uninit(struct process_queue_manager *pqm)
 {
 	struct process_queue_node *pqn, *next;
-	struct kfd_process_device *pdd;
 
 	list_for_each_entry_safe(pqn, next, &pqm->queues, process_queue_list) {
 		if (pqn->q) {
-			pdd = kfd_get_process_device_data(pqn->q->device, pqm->process);
-			kfd_queue_unref_bo_vas(pdd, &pqn->q->properties);
-			kfd_queue_release_buffers(pdd, &pqn->q->properties);
+			struct kfd_process_device *pdd = kfd_get_process_device_data(pqn->q->device,
+										     pqm->process);
+			if (pdd) {
+				kfd_queue_unref_bo_vas(pdd, &pqn->q->properties);
+				kfd_queue_release_buffers(pdd, &pqn->q->properties);
+			} else {
+				WARN_ON(!pdd);
+			}
 			pqm_clean_queue_resource(pqm, pqn);
 		}
 
-- 
2.47.1



