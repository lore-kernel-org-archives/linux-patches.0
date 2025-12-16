Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F98234D3B3;
	Tue, 16 Dec 2025 11:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885740; cv=none; b=e/OlhFxzG1lz2ewqqmpbIdG/OmjwCfnlHsd4riB+6ep1kJ8ZubXAY6JG6OYYANYBjYAnD2Rd/pguqpUO5VUK5Rel9k3M8ChNAhN8Sl1DICQLNSW1Bp8QJTFwitZx+sxgX02ohTl+ZVTjJr0RXGBLbiT9ieO1X0UCQ84wcXIOmwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885740; c=relaxed/simple;
	bh=5sxSuQwGNtXCzFobeKBIwvLjj+D/HYrdwiNL8DtDhL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZ8y9h2GMuT8MVdUsfirq9AtIObrKMLyIG0e1d8Rx+aXs5Pq4IsUXz5oUsbg4Yj8A7jo/QZ9Xqrtaj8rPlHhLyg90VF9ZxyamaGkhCMB9YY0LkdBCXCyxo4F/eGTBcHHlN8coHpusvPkHFAO28wPw6GhWyRP4jBCGetasyM3fbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkiI+lfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkiI+lfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A56C4CEF1;
	Tue, 16 Dec 2025 11:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885740;
	bh=5sxSuQwGNtXCzFobeKBIwvLjj+D/HYrdwiNL8DtDhL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkiI+lfH+di4oj6xhs/wBPvUK+qNc+q9nx7HTPkQ6rTIBmv03cFKsY9niiLooaAxq
	 8QpBfDF2UmjX/SOyGZwLISe+gqSxdWL16WFjSyBD7kkuGjA35lwEqyLUrVpChOEpkl
	 s3Q8Rq/t6WIC8liV3FSg8CCfAASwdt2mAzs6SXzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 230/507] accel/amdxdna: Fix deadlock between context destroy and job timeout
Date: Tue, 16 Dec 2025 12:11:11 +0100
Message-ID: <20251216111353.835563772@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit ca2583412306ceda9304a7c4302fd9efbf43e963 ]

Hardware context destroy function holds dev_lock while waiting for all jobs
to complete. The timeout job also needs to acquire dev_lock, this leads to
a deadlock.

Fix the issue by temporarily releasing dev_lock before waiting for all
jobs to finish, and reacquiring it afterward.

Fixes: 4fd6ca90fc7f ("accel/amdxdna: Refactor hardware context destroy routine")
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251107181050.1293125-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index b02f84121f3a5..8e6a608974791 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -675,17 +675,19 @@ void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx)
 	ndev->hwctx_num--;
 
 	XDNA_DBG(xdna, "%s sequence number %lld", hwctx->name, hwctx->priv->seq);
-	drm_sched_entity_destroy(&hwctx->priv->entity);
-
 	aie2_hwctx_wait_for_idle(hwctx);
 
 	/* Request fw to destroy hwctx and cancel the rest pending requests */
 	aie2_release_resource(hwctx);
 
+	mutex_unlock(&xdna->dev_lock);
+	drm_sched_entity_destroy(&hwctx->priv->entity);
+
 	/* Wait for all submitted jobs to be completed or canceled */
 	wait_event(hwctx->priv->job_free_wq,
 		   atomic64_read(&hwctx->job_submit_cnt) ==
 		   atomic64_read(&hwctx->job_free_cnt));
+	mutex_lock(&xdna->dev_lock);
 
 	drm_sched_fini(&hwctx->priv->sched);
 	aie2_ctx_syncobj_destroy(hwctx);
-- 
2.51.0



