Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDB84C97;
	Tue, 11 Nov 2025 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822527; cv=none; b=ksvFBFmQAsFp6ouaXPQrIcSVhkMEgDbuLITY5C/+Hfaqduw4G9kUcYFJRK6VGllD2gO4/43Ekp5KpOzBdW8rxVx7OJVmOk2KPcWqKXg3gilBIn0k/Txv+IbA4m+LgH0f/EIi2cRlv8JX54eRyVim3cmOQdtgAHOurJ0FCUDTbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822527; c=relaxed/simple;
	bh=dKSVGaozOVo4Bom0HD3QOrMbs/AGYuCDP9161RhQ1lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq/LnvMW4Z8Lww/5ws279Y9CDYJF4cjnTumBIYjqdNbn6uzQWxP7j7o6pLa9VVxDa1uUzPrkaMkLeApmHb1DGG63uqZOg7s5fYI3F1FDN6CnxWzsLeNGOXENFIKdvA5fggICDbEjYPSn2jo0PrO+zL3fhymb3zWrT7fMfqPabmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2QsdIT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2QsdIT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B96DC4CEF5;
	Tue, 11 Nov 2025 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822527;
	bh=dKSVGaozOVo4Bom0HD3QOrMbs/AGYuCDP9161RhQ1lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2QsdIT509v1vFqsbWFUS5L3olaRsVGjRRIvMRn502T9BoevADz61ZzGl2erbq6r0
	 jsHimRnxTRsBMbwsE1uotAzY+G+QesUG9Cdc2sc1TFXuaeKLMt7nnzekNRQdMN2ewX
	 mhPTsuiFsHHI1j3ifKmUy6LXGTaQu78NdCDeseRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.12 068/565] drm/nouveau: Fix race in nouveau_sched_fini()
Date: Tue, 11 Nov 2025 09:38:44 +0900
Message-ID: <20251111004528.478421094@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

commit e0023c8a74028739643aa14bd201c41a99866ca4 upstream.

nouveau_sched_fini() uses a memory barrier before wait_event().
wait_event(), however, is a macro which expands to a loop which might
check the passed condition several times. The barrier would only take
effect for the first check.

Replace the barrier with a function which takes the spinlock.

Cc: stable@vger.kernel.org # v6.8+
Fixes: 5f03a507b29e ("drm/nouveau: implement 1:1 scheduler - entity relationship")
Acked-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20251024161221.196155-2-phasta@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_sched.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_sched.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sched.c
@@ -475,6 +475,17 @@ nouveau_sched_create(struct nouveau_sche
 	return 0;
 }
 
+static bool
+nouveau_sched_job_list_empty(struct nouveau_sched *sched)
+{
+	bool empty;
+
+	spin_lock(&sched->job.list.lock);
+	empty = list_empty(&sched->job.list.head);
+	spin_unlock(&sched->job.list.lock);
+
+	return empty;
+}
 
 static void
 nouveau_sched_fini(struct nouveau_sched *sched)
@@ -482,8 +493,7 @@ nouveau_sched_fini(struct nouveau_sched
 	struct drm_gpu_scheduler *drm_sched = &sched->base;
 	struct drm_sched_entity *entity = &sched->entity;
 
-	rmb(); /* for list_empty to work without lock */
-	wait_event(sched->job.wq, list_empty(&sched->job.list.head));
+	wait_event(sched->job.wq, nouveau_sched_job_list_empty(sched));
 
 	drm_sched_entity_fini(entity);
 	drm_sched_fini(drm_sched);


