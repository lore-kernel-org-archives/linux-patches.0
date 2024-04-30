Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E90129E89;
	Tue, 30 Apr 2024 10:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474516; cv=none; b=cKR7XAgXylmLub+Q2S7RXA9idvBWz34iofL6AW76n143WFdNw7W5NFTDiFgWB9ynTZdkP7dNkcjzBM/La0CeYkLw9H/2O3v7TRdIibmqC+PSZf+1T/OSb6QkPSx/PI/wrYnHPYlG8mukJ9O+HxJ40DhUzLFbpIQgj2htUlIbs04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474516; c=relaxed/simple;
	bh=ht9jEVNJtM2+W+UZ5cklyYV8/66Obq+Mor1zUTtsoVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3LXzl+bXIRyXHFZPpeVETvO4xZtY3BtJpQkROq6CaEeDmL582lmjwhXujTeK9SzTA2dZ8AVjXAJ0Ns3uEJiMV6kj+43faoOYYBsd4ic82hrjvu/9+Ckw5A1zr/Y0d/2rri+7k/CvfF3vgS0cDkNwtMO1MXuWNfsZrodEzwz+lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/Q2Tc0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/Q2Tc0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070CDC2BBFC;
	Tue, 30 Apr 2024 10:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474516;
	bh=ht9jEVNJtM2+W+UZ5cklyYV8/66Obq+Mor1zUTtsoVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/Q2Tc0wLsIWZcFJvmlRuqo4nNxi3+WOOzREsJCbZprbGncEDMdZ2rCg8PKgxPNPY
	 FZtdTDoMrc+6PBapQgJ+iEYjlMOzp8EXCxxLAyI/xZqDuBhOmkCsmU/d9tvrGRu77a
	 x0uLbjTFeOB1paMnFH7PFBemhFTNOReGr9p0rL9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 179/228] drm/amdkfd: Fix rescheduling of restore worker
Date: Tue, 30 Apr 2024 12:39:17 +0200
Message-ID: <20240430103108.968747917@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

commit e26305f369ed0e087a043c2cdc76f3d9a6efb3bd upstream.

Handle the case that the restore worker was already scheduled by another
eviction while the restore was in progress.

Fixes: 9a1c1339abf9 ("drm/amdkfd: Run restore_workers on freezable WQs")
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Tested-by: Yunxiang Li <Yunxiang.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -2011,9 +2011,9 @@ static void restore_process_worker(struc
 	if (ret) {
 		pr_debug("Failed to restore BOs of pasid 0x%x, retry after %d ms\n",
 			 p->pasid, PROCESS_BACK_OFF_TIME_MS);
-		ret = queue_delayed_work(kfd_restore_wq, &p->restore_work,
-				msecs_to_jiffies(PROCESS_BACK_OFF_TIME_MS));
-		WARN(!ret, "reschedule restore work failed\n");
+		if (mod_delayed_work(kfd_restore_wq, &p->restore_work,
+				     msecs_to_jiffies(PROCESS_RESTORE_TIME_MS)))
+			kfd_process_restore_queues(p);
 	}
 }
 


