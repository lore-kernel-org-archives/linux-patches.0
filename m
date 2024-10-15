Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA9F207A3C;
	Tue, 15 Oct 2024 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998224; cv=none; b=ET2oL7yG3cvSU6omvPV6ESUTmU1Ddq/QHz6BG0KcpWyQaeXffBZfNccGDVLRi8zOCPmm67GWaTFbmZcSgQ35LFuUf6OKJgrebla7YM5hMYXIeKT8rn0wzRvpa1h766fkO3lEvcZeZs/NuzGkfaPvb6iHyyj2R31Cv/vGPeqsQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998224; c=relaxed/simple;
	bh=3BY3xdcpgSnMhXUDwfEo9IAv/mSKMnWjNJ9SRqHDnmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2saiYTRB/fA6oCjl/mq9KASHqhY+khedAihXoTu6K8+QuonuM5k6Ql6mJC0B3MvX02O3n31zRI4c8dd/FZ1K4GUyKZ1g974iUOUP6LM1GJyBxXplPUusk/Coy3Grhm28A903UD9KATQgXnisIWY465fHyeX33gxAPlkpE3K9nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1msdJoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1msdJoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146A4C4CEC6;
	Tue, 15 Oct 2024 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998223;
	bh=3BY3xdcpgSnMhXUDwfEo9IAv/mSKMnWjNJ9SRqHDnmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1msdJoB9LO5RsdaSHQI6BoLoF4kfifxd+X/ljusWmEHc0k87efzAYIxGhiyewznv
	 yWYHvcH9q9swpLBR9lu6aFxwIRFSMU+5KTvjga4LWglwsmmzYhIAtEY28w+wwOB4ty
	 +U6I5zx0irhnwO/W8yhmEMo8jgOyxRaPhrqnRw0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Luben Tuikov <ltuikov89@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	Philipp Stanner <pstanner@redhat.com>
Subject: [PATCH 5.10 415/518] drm/sched: Add locking to drm_sched_entity_modify_sched
Date: Tue, 15 Oct 2024 14:45:19 +0200
Message-ID: <20241015123933.013301042@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 4286cc2c953983d44d248c9de1c81d3a9643345c upstream.

Without the locking amdgpu currently can race between
amdgpu_ctx_set_entity_priority() (via drm_sched_entity_modify_sched()) and
drm_sched_job_arm(), leading to the latter accesing potentially
inconsitent entity->sched_list and entity->num_sched_list pair.

v2:
 * Improve commit message. (Philipp)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: b37aced31eb0 ("drm/scheduler: implement a function to modify sched list")
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Luben Tuikov <ltuikov89@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: Philipp Stanner <pstanner@redhat.com>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240913160559.49054-2-tursulin@igalia.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -96,8 +96,10 @@ void drm_sched_entity_modify_sched(struc
 {
 	WARN_ON(!num_sched_list || !sched_list);
 
+	spin_lock(&entity->rq_lock);
 	entity->sched_list = sched_list;
 	entity->num_sched_list = num_sched_list;
+	spin_unlock(&entity->rq_lock);
 }
 EXPORT_SYMBOL(drm_sched_entity_modify_sched);
 


