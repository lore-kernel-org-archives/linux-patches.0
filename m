Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ED025F992;
	Thu, 17 Apr 2025 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914326; cv=none; b=kHWF2ztlX0pilfIZmJaDDdk+YBIz7C9dW5+nx6CyPLrAEsXQjSMrrzY6eZqrrH2EzS8UHmQL8BZIUZ0gNLn/EVQl9W/OVGSakxdeD30q7EgXt5zo8G3otZODSmMaOOWqjgWa7vD5xvkdnKoZ2RXuFlCMHsAl05QMb6k/+1DGHK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914326; c=relaxed/simple;
	bh=6mUuuDAEdEd+rejRozFgO5yfvs8bRD/+2wappkQSYeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdFv6Q+1Jmlt8n3sg0DaJM2iIq+mzzHTbpjU01jOFhsy/2yHGHcOyA/ru5ZPL7238ZDl0vSdegkuroxP5fAJdBdWMV+Ua5FyMp/R37FdtxKJMxoE0TJnbq4lR+JcjvgDBypSG62LUTqIMyBeYSGgIK7+SWI+1Sym1wIvWNqcRmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZFniTPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZFniTPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C5DC4CEE4;
	Thu, 17 Apr 2025 18:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914326;
	bh=6mUuuDAEdEd+rejRozFgO5yfvs8bRD/+2wappkQSYeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZFniTPOU5F2c2DGwDdB9yAxt7eks5Gcw52nxLoKaUiBvPjauihNYGoErUfhTKLID
	 nivpRyatOmeLa9QcgOC6yLN7kslTX/4ZBZzeUKu3p/DkJA6PPGI6AIYsRpiwXRWPBt
	 AzPoFRz4Xlf6oxyNGVDT3W9z+gMec0ypY1iUrl/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 148/414] drm/amdkfd: Fix pqm_destroy_queue race with GPU reset
Date: Thu, 17 Apr 2025 19:48:26 +0200
Message-ID: <20250417175117.374939666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 866b68146df6b..e015296d8f0d2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -545,7 +545,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 			pr_err("Pasid 0x%x destroy queue %d failed, ret %d\n",
 				pqm->process->pasid,
 				pqn->q->properties.queue_id, retval);
-			if (retval != -ETIME)
+			if (retval != -ETIME && retval != -EIO)
 				goto err_destroy_queue;
 		}
 		kfd_procfs_del_queue(pqn->q);
-- 
2.39.5



