Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9266E1D540;
	Tue,  8 Oct 2024 12:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390146; cv=none; b=VXQ3hAvjx+TtqLv/osCeJr3ngSUMkSBQk5R204Q5NBV7hemcSOx7bqcYD8761zFQg38HRCl/gBEt3/VnqtPbanqhbQaIsc6dAFnf8wkMPHR1+qwqALMye2XHXLpHkOLq2mTw7r03mIntgTaeyT5Cs93C8lfzy4pCVuPz6rqF7QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390146; c=relaxed/simple;
	bh=j9L0sPQ66smGS/6WqBAMTtWSPoL8/SPhEEMzKpQrtSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGIQ8+4utf/sDzrts5jhRpM3NTJi9hcRKe1y5zcdiKUUaAszBfa0RxUsQYXvDoB374cpitjnxlBxO7JdnOeUNA0SNV5/dDzjtFHuTWf2R2W132Qx1tjhm5VgwolU0owk8qxvmBwP+PdOScYBSEyCAEaY4BgxmXmXjrwrb6n9c54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekjygL3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekjygL3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13657C4CEC7;
	Tue,  8 Oct 2024 12:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390146;
	bh=j9L0sPQ66smGS/6WqBAMTtWSPoL8/SPhEEMzKpQrtSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekjygL3u/Fta4Faz4nqUFHUEy1gl1pzAav06fGSOYBQ8TDp0DeqRoog5rkQ6pjhzr
	 dUe2lNiVGqIWQg1H8gfT5J7gl1HB/E+rzErnUVjIi4iNsGLnGr7XRo3t+t7Rj3wP6r
	 rz4S4PBnhrjXokHKU3xkMlrOHTVFsG5JjbHCeoXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 205/482] drm/amdkfd: Fix resource leak in criu restore queue
Date: Tue,  8 Oct 2024 14:04:28 +0200
Message-ID: <20241008115656.377911563@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit aa47fe8d3595365a935921a90d00bc33ee374728 ]

To avoid memory leaks, release q_extra_data when exiting the restore queue.
v2: Correct the proto (Alex)

Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Tim Huang <tim.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index c97b4fc44859d..db2b71f7226f4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -984,6 +984,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 		pr_debug("Queue id %d was restored successfully\n", queue_id);
 
 	kfree(q_data);
+	kfree(q_extra_data);
 
 	return ret;
 }
-- 
2.43.0



