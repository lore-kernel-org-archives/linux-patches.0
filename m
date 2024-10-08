Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA81DED6F;
	Tue,  8 Oct 2024 13:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393432; cv=none; b=C/qKXui5nrOrHq/xfqDvYJKKlBmiNcf4OqjjYrhcBazcvDl8x09cpoumLvXavBGxhx6Cnby7/Bm042K8x2xdZ+FEFo++nSXxmdt46VoUnv9JJIFo7vwqFyMCNHdDj37ot24PO6RmMoYdH7eGY/FE5DgKN9/ZRDN7QrNWwfwGb9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393432; c=relaxed/simple;
	bh=5SvU8ARRQZsmJ83bNdm5qBSKNkF5Rjnv3/yRxWcoy5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojTf+qfMg7KRlbyVR1JTqYoSc1FJQL+5BU7/gRRuSdZq/ioqu7NL0H8ihg+L7bggVQn83C8GtKT/y/Z8P9UeurBEY3QVJ+7ywSLzY5aQBYFsz4hFLpGkpZLtu/HC1kxHwdF52A0x1LpUowo9uhjAJgabdsbn9y5KYxBmMkwAnGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aZ2mRVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aZ2mRVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E6FC4CEC7;
	Tue,  8 Oct 2024 13:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393432;
	bh=5SvU8ARRQZsmJ83bNdm5qBSKNkF5Rjnv3/yRxWcoy5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aZ2mRVJ/Jy/9hhHx9MzXWLX8si5c05tf/oeptdtvJMvj1yuN6ir3SjEiowaWDbXr
	 4OPcWpWXRK1/FhiTY0vAXPIkXKacnhc29C1d4em7Rl/HD37QtlwDV2oRgL5gHJqspo
	 kxNb3GedpdWRhLu0u14HIwR1TCF9hdTXEBcgi+es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/386] drm/amdkfd: Fix resource leak in criu restore queue
Date: Tue,  8 Oct 2024 14:06:35 +0200
Message-ID: <20241008115635.330537959@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dbc75ca84375a..0583af4e84fa3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -982,6 +982,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 		pr_debug("Queue id %d was restored successfully\n", queue_id);
 
 	kfree(q_data);
+	kfree(q_extra_data);
 
 	return ret;
 }
-- 
2.43.0



