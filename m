Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4762F56E06A;
	Wed,  9 Sep 2026 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963228; cv=none; b=rZLkRbsJxdbag8nA9z1pUBmxuULwZ5ab/vLoTH/YvV/X0OxU/vg/kc6gT0Vt5kBxwzeXeY7QgnXdqI5ajhmggDykgQl6Rzna/8sYtwHquxBx62N0U76wSCUduCeyE1ui8PxjXZ4TnELMenHOYSZtomZm//SxM7auIBs7U5PCo94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963228; c=relaxed/simple;
	bh=tZ1ZVCyZnLFTJ1mRlg/QRadUxPxiUnFVt6eQOcIeyvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrfsm538UwydaGX+BPrUqzcbYsLoaR3zV91wRMhdbFx1BheKwZlOHi1bYWsF/WwwcdCPmWFaTG4Qmr+OBHh3RKhDIx09IfotbDzepmhQfxGHr9BqkqLwxmOvn2F224hJCJ0B/l4/B2K/0DUPVUlNlcVgD2Z6wAAbx4ZoJTrGeTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+T/sSXz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+T/sSXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF211F00A3A;
	Wed,  9 Sep 2026 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963227;
	bh=uI9Yxm93I5Z+xnqU6zn+OPkNLR6dfpZSYSyhEg1ctbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+T/sSXzVrrDIuFXYRWL8ZVX31bQb2AIgQCKyR/rcYL1TuCQNqbYNHz33Rf0bUOuA
	 5ZL73IdoCuPRPI3bqLMpqzi2rhstrTQmrYZB2ht7qqHnQrwiBCc2IQv/kivvqzsW9G
	 wraTno+fhx91XjlrctVfI0iiHjFIsi5pKiQjfg6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.2 516/556] drm/amdkfd: fix scope of mqd_mgr dereference in pqm_debugfs_mqds
Date: Wed,  9 Sep 2026 15:43:16 +0200
Message-ID: <20260909134248.582666201@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 012a026bae0212952b423a842b7e2c0bf21f8e7a upstream.

Reading /sys/kernel/debug/kfd/mqds while a process holds an active KFD
queue triggers a NULL pointer dereference because the for loop that
calls mqd_mgr->debugfs_show_mqd() is incorrectly placed outside the
if (pqn->q) block that initializes mqd_mgr.

The queue list can contain entries where pqn->q is NULL (kernel queues
where only pqn->kq is valid). In the original code:

  if (pqn->q) {
      ...
      mqd_mgr = q->device->dqm->mqd_mgrs[mqd_type];
      size = mqd_mgr->mqd_stride(...);
  }

  for (xcc = 0; xcc < num_xccs; xcc++) {  // WRONG: outside if block
      mqd = q->mqd + size * xcc;
      r = mqd_mgr->debugfs_show_mqd(m, mqd);
  }

When iterating over a queue node where pqn->q is NULL:
1. The if (pqn->q) block is skipped
2. mqd_mgr remains uninitialized (NULL from declaration)
3. The for loop executes anyway
4. mqd_mgr->debugfs_show_mqd(m, mqd) dereferences NULL

The crash manifests as:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor instruction fetch in kernel mode
  RIP: 0010:0x0
  Call Trace:
   pqm_debugfs_mqds+0x10c/0x1d0 [amdgpu]
   kfd_debugfs_mqds_by_process+0x9b/0x110 [amdgpu]
   seq_read_iter+0x132/0x4b0
   ...

Fix by moving the for loop inside the if (pqn->q) block, so mqd_mgr
and related variables are only used when properly initialized.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5689
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20260831130051.2031435-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8bfe29d5c798940f797aa24135d2734c3ffce9de)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -1148,13 +1148,13 @@ int pqm_debugfs_mqds(struct seq_file *m,
 			mqd_mgr = q->device->dqm->mqd_mgrs[mqd_type];
 			size = mqd_mgr->mqd_stride(mqd_mgr,
 							&q->properties);
-		}
 
-		for (xcc = 0; xcc < num_xccs; xcc++) {
-			mqd = q->mqd + size * xcc;
-			r = mqd_mgr->debugfs_show_mqd(m, mqd);
-			if (r != 0)
-				break;
+			for (xcc = 0; xcc < num_xccs; xcc++) {
+				mqd = q->mqd + size * xcc;
+				r = mqd_mgr->debugfs_show_mqd(m, mqd);
+				if (r != 0)
+					break;
+			}
 		}
 	}
 


