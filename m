Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C0E27D763;
	Wed, 23 Apr 2025 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420790; cv=none; b=mKFEAQ9S/8x9ejf1RgLlAON1MhRKUkXL3mOXFe/wsnxwf6snO+7gPytwhtaL7HLvjSwCdVeulcgANGiXuprYFR0L8C+K9lkFnHmdJENFg06V5t0qEingueDFJEPLwPcZNugVw3/PwlPZtEb8kurBni57W4ef8jf0GI88MWTpP10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420790; c=relaxed/simple;
	bh=AsWVqR1QmoHR8ZIgSDtHtU84ZzsWyA8/Gj07Xb00OLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWrXMswB4ioCN7k2IRGcgRx0KH3HuPaVwCrwDkgWqA1762/Kj1QbTs+iLtJK3uj70VL5Y4acZi1XdNtzfaKaflsKWPJsfqDFRCRJ05Tv5Pzkv++703BM1WQHJu+XRTZCKNSGzRvl58hpLZcmi1aCBiewzDkCtjorim88NtMjQq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXa+HcI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXa+HcI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442BCC4CEE2;
	Wed, 23 Apr 2025 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420790;
	bh=AsWVqR1QmoHR8ZIgSDtHtU84ZzsWyA8/Gj07Xb00OLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXa+HcI53EGsSjN1lhawnY+caRdP4Ry2V8Lj6F7Go3VE/gcNHj7GFtJBHPikCMTg5
	 5Q8Cc0DwZUeJBeQIrkgc9SO02uFgApYDPsIxk6CXZXIx9lX5cFMx/nwFP5siHaf09H
	 gB5iOppf2VJCjw/FztvA2EpcYrauRpS1S/KPvReQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/393] drm/amdkfd: Fix pqm_destroy_queue race with GPU reset
Date: Wed, 23 Apr 2025 16:39:59 +0200
Message-ID: <20250423142647.543153481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e057c2bc7be42..d11a71e8aa141 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -510,7 +510,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 			pr_err("Pasid 0x%x destroy queue %d failed, ret %d\n",
 				pqm->process->pasid,
 				pqn->q->properties.queue_id, retval);
-			if (retval != -ETIME)
+			if (retval != -ETIME && retval != -EIO)
 				goto err_destroy_queue;
 		}
 
-- 
2.39.5



