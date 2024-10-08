Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C621CCB32;
	Tue,  8 Oct 2024 12:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391967; cv=none; b=S24KdpCo/lYHoFuzn0PGG1ONXZrSwoEzQ4/78bc1vFoAN7wfbOCdUkKuQl9Y9Ua1Lfxj67bh9tkDFh46CMJy4bVUykM1E7Ey/tMRVF4N0jY0fcsxItsxsmrnQiUsAk6r++WEDvO36CX5n/t3tIagkdnohviAKd8WF9ITUCO1G0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391967; c=relaxed/simple;
	bh=+IB9NfzAhLFuIvmojBNEP1MwfyWL9AyXG+l1CeP98hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJzTGuOtUJC5z4K8JHgrVS7zXq/gf/UruIgxQIvP92DNMbSy0oirk9vZD2wP5ur6bRZrEdQjpXhaaoTEH5yxfJ42ikr4YhWptfb+Zsxw8zzBhdemR/ZvXTRzQF9k8lWcYcmvZTPnIOF3ADWu9IMGl/KTjglvo/LqhXZixQ9ItgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqO9Aze8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqO9Aze8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9B0C4CEC7;
	Tue,  8 Oct 2024 12:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391966;
	bh=+IB9NfzAhLFuIvmojBNEP1MwfyWL9AyXG+l1CeP98hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqO9Aze8kL5mCDN1EOzUqeML2YM9dpauyTa7w85MfXiWShpTWmD9foOYRBrZmRjmX
	 U3FJQgJeI2Bw6CygkjIIWsWq7g5DKDG0Z9vsliFKn1S51kCEYPBJNS2Cljn9TVWOwY
	 P7yeoUG8Z0h4NWPna9nABURDTu+rJGdhMCixCo0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 245/558] drm/amdkfd: Fix resource leak in criu restore queue
Date: Tue,  8 Oct 2024 14:04:35 +0200
Message-ID: <20241008115711.980346158@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 36f0460cbffe6..e0f19f3ae2207 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -988,6 +988,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 		pr_debug("Queue id %d was restored successfully\n", queue_id);
 
 	kfree(q_data);
+	kfree(q_extra_data);
 
 	return ret;
 }
-- 
2.43.0



