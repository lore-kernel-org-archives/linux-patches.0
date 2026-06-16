Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3B4449EA8;
	Tue, 16 Jun 2026 17:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629836; cv=none; b=LbMqVNW85Xs3hDaPDLm1QFLgS5LwWwRwa5H8o+YNF1LKkOzRAZ3DgXxN6gXrTNlE0xMVtvdZo6gqId3p06bVGc2p0Q9h25dfstIv32gWLiCtH78cO+u4SmJ4Zfgxd5fnrzK7lO8ii/xQkN62gbGVgvgRn66c5xMfA5zNtCrxwrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629836; c=relaxed/simple;
	bh=I1GaJPvLEgQsnF9SvLEyYYCrohM11LDDEh6wl49S33Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF4T7Eb5J8Q93XHjK6KY6wAqCsNjK7IX278vIannBz44pvwFtoPRDpmgZx5zzFj6WfJZY1LFw8pRlFI6tkP+zOIQ/hfoiE0mUXqXqYTjD24hZgdBQ2Uq4kPJ0abNz4148mm24/u5/8UYFq6TsHuqgozNQUF7FuTn4VR51cjZ1vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPeXiyay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPeXiyay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D441F000E9;
	Tue, 16 Jun 2026 17:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629834;
	bh=UpOSn6McfM/UEfTNPoDnQ5gSWi0CbXR6Xg1LmhCi6/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPeXiyayL+2vGNH9G0+IdIiL2nHN303C2RiWsnLw6tWy167jEszR/E0FcvQiF0JnL
	 Aoedjz53WyTGiV5aol7/8R5KENDR+zS/uKpLTfWyvQZFfNjeht/q3Gx5/7qWsaocHU
	 TyvrhEwDEyxV5lW8fJgHNgElBjv6ptHNTY+H8RM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 361/452] drm/amdkfd: fix NULL dereference in get_queue_ids()
Date: Tue, 16 Jun 2026 20:29:48 +0530
Message-ID: <20260616145136.070804094@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 2bd550b547deabef98bd3b017ff743b7c34d3a6d upstream.

When usr_queue_id_array is NULL and num_queues is non-zero,
get_queue_ids() returns NULL. The callers check only IS_ERR() on the
return value; since IS_ERR(NULL) == false the check passes, and
suspend_queues() calls q_array_invalidate() which immediately
dereferences NULL while iterating num_queues times.

Userspace can trigger this via kfd_ioctl_set_debug_trap() by supplying
num_queues > 0 with a zero queue_array_ptr, causing a kernel panic.

A NULL usr_queue_id_array with num_queues == 0 is a legitimate no-op
(q_array_invalidate never executes, and resume_queues already guards
all queue_ids dereferences behind a NULL check). Return ERR_PTR(-EINVAL)
only when num_queues is non-zero and the pointer is absent; both callers
already propagate IS_ERR() returns correctly to userspace.

Fixes: a70a93fa568b ("drm/amdkfd: add debug suspend and resume process queues operation")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f165a82cdf503884bb1797771c61b2fcc72113d4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2787,7 +2787,7 @@ static void copy_context_work_handler (s
 static uint32_t *get_queue_ids(uint32_t num_queues, uint32_t *usr_queue_id_array)
 {
 	if (!usr_queue_id_array)
-		return NULL;
+		return num_queues ? ERR_PTR(-EINVAL) : NULL;
 
 	if (num_queues > KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
 		return ERR_PTR(-EINVAL);


