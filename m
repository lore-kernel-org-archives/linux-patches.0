Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D9D1D1E79;
	Mon, 14 Oct 2024 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919009; cv=none; b=pjw9C+Za3CyCLXcHnIPmuUE00VRwgMLSpZN3Lz8/EJ8xxDPn3gmdDnG9U/T/dzegnuxMUd3vaBJjABwjEwOwAcN0Pv/v/Mr+7PVe7G7oJe7uItPqu9rFIsqdESBecsrUu2oqoh7q6I609eElG4B92XFv6wpa16s8p1dmi3JGGB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919009; c=relaxed/simple;
	bh=9ENQ7wNyEhqmvRdUW3as7m/9AxCWZ55RQWTCGwpq3Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urAUy3CapC1+0uOhGFzvElL8cI7JXbtmXl5tXuYs2me1lHsMNBXaTxVml6oNX1pP/r/km6B+XtttUHPrsFKKdKbB9+kSqihRT6HC/3Gdl48UHgDufJT16yEOENzfNJ56Ftj26fmgnnuagwewoGlYyRlQYo3BrhPMEid4Ugx8Z+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSoc16PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSoc16PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F7FC4CEC3;
	Mon, 14 Oct 2024 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919009;
	bh=9ENQ7wNyEhqmvRdUW3as7m/9AxCWZ55RQWTCGwpq3Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSoc16PJWzUeuXKlblMx5lzBo0ezq2te1u9q7a6zeAJxI875JuMZKmjTMK3bmdzXx
	 nFFewBM3y5o+jxYYltjDQ0sjLje7TbwqWXxWYx89z9dtZk9lly44ny1RT0/EtpQZVh
	 qvTaLjyuEqzqeFILOZhWWL90MPq/nLFfux4JBE54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 487/798] drm/amdkfd: Fix resource leak in criu restore queue
Date: Mon, 14 Oct 2024 16:17:21 +0200
Message-ID: <20241014141237.104281052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4236539d9f932..99aa8a8399d69 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -890,6 +890,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 		pr_debug("Queue id %d was restored successfully\n", queue_id);
 
 	kfree(q_data);
+	kfree(q_extra_data);
 
 	return ret;
 }
-- 
2.43.0



