Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452218462;
	Thu, 17 Apr 2025 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915485; cv=none; b=uLKU6qdZzLvbE++idc1sKpim1yo2zx6bHWunHyp69YQnTP03fhN0FRC+AzWKKTmVzzN9zGcbePU9pk88Z34I8Io9+n1Etd7JwGStUd+M1PWW2+fdPc3Af/pjRPnfBp1H1xdcJ0BPPqTVXiGF28P8JYBBgposS2X+soCysuJJ86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915485; c=relaxed/simple;
	bh=/J6RNYJwjXI1JeqPdnfnW/ZWX5rjz8GO+DjgF15dPeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCHxY0PwuI+GrlDSl5nlojAndoXxCVoUQqv2yHxraxDljwx4ePmaAvrE7PvDssKyUbLgLB//wZ2mkbCvRHXGj+KsCi7jYsSjd6VawrMpoiGGemVbglX/DsJUG95Bj67EfQolWTQKPp5b6oLp8sPnKiCzc3G5wPAVtZ02ca0uS/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYesNglu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYesNglu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83A1C4CEE4;
	Thu, 17 Apr 2025 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915485;
	bh=/J6RNYJwjXI1JeqPdnfnW/ZWX5rjz8GO+DjgF15dPeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYesNgluetcbC28VJcY7bdpKVD1T43BF+Vy8A5qoiKDyFnBNwkSKKSVPqNiZhkwxz
	 hR6yNB/Qv9JT0BIPHHiG0DoZucMQmE733JEcIrs+HeJqGeq7kkQ7gRghOF51731hxv
	 EAphwyNtFQhBPqGKGorJ2rOwXQusNdrlM6Asjekw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/393] drm/amdkfd: Fix pqm_destroy_queue race with GPU reset
Date: Thu, 17 Apr 2025 19:49:11 +0200
Message-ID: <20250417175113.297764722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ac777244ee0a1..4078a81761871 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -546,7 +546,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
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



