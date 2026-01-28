Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D02E1D6AA;
	Wed, 28 Jan 2026 15:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615810; cv=none; b=qJf5qgdSR6s4cyBeSMCpUQCDmepWpdBTh7ZgK12ygJBW0SQ6x6m+SQ/gdCG+KAgFzrfd0YW3V64eTPvRPDcbB/A2GEP7tUlS68ZCifMatBYWl6HMvCHTOfxDTDrTBV6UBm6T4HV9i5B/AqBLJkGfjE1mvIkW4gFffKgy49HjqY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615810; c=relaxed/simple;
	bh=1Z+eu5/7i8GWl0j7etOlFWtju8tPzofWSXInaUtkRZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLAAMkNFNqGWCl/D1JDOrsVNxXwu0EPs9MPLJlWMKpQxoB0p6ldF3yXMp5TUydPekjie6vXI6PnsOxHTWPo7KMkLZSwwATX8JF3sJPMb8tvPVm2UTEbDN3OEzIdmcli0BdFqs+zwZmwc3TdoPFdgmkwUsdwwrnEGrr2seSrEPy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCJMWloL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCJMWloL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CC8C4CEF1;
	Wed, 28 Jan 2026 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615810;
	bh=1Z+eu5/7i8GWl0j7etOlFWtju8tPzofWSXInaUtkRZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCJMWloLNfa5q0wOu07omC8hR8UPIKs5eqtYoLNKJlJKeYcARIi9hBjgpT1EG+oAd
	 4eSoppiJkt26PiklM43TT7ueLCAHP414suzPrBzlV9lz56/dEH5xY8lKQ0t7NpM4/x
	 5h0P67hvYEdIztpGBwX39kvyBrxdjLXWI4RxdG4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/227] drm/xe/migrate: fix job lock assert
Date: Wed, 28 Jan 2026 16:22:45 +0100
Message-ID: <20260128145348.783090301@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 772157f626d0e1a7c6d49dffb0bbe4b2343a1d44 ]

We are meant to be checking the user vm for the bind queue, but actually
we are checking the migrate vm. For various reasons this is not
currently firing but this will likely change in the future.

Now that we have the user_vm attached to the bind queue, we can fix this
by directly checking that here.

Fixes: dba89840a920 ("drm/xe: Add GT TLB invalidation jobs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Arvind Yadav <arvind.yadav@intel.com>
Link: https://patch.msgid.link/20260120110609.77958-4-matthew.auld@intel.com
(cherry picked from commit 9dd1048bca4fe2aa67c7a286bafb3947537adedb)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 3acdcbf41887f..b6905f35d6c81 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -2182,7 +2182,7 @@ void xe_migrate_job_lock(struct xe_migrate *m, struct xe_exec_queue *q)
 	if (is_migrate)
 		mutex_lock(&m->job_mutex);
 	else
-		xe_vm_assert_held(q->vm);	/* User queues VM's should be locked */
+		xe_vm_assert_held(q->user_vm);	/* User queues VM's should be locked */
 }
 
 /**
@@ -2200,7 +2200,7 @@ void xe_migrate_job_unlock(struct xe_migrate *m, struct xe_exec_queue *q)
 	if (is_migrate)
 		mutex_unlock(&m->job_mutex);
 	else
-		xe_vm_assert_held(q->vm);	/* User queues VM's should be locked */
+		xe_vm_assert_held(q->user_vm);	/* User queues VM's should be locked */
 }
 
 #if IS_ENABLED(CONFIG_DRM_XE_KUNIT_TEST)
-- 
2.51.0



