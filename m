Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CAE1779B1;
	Tue,  8 Oct 2024 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390937; cv=none; b=IhyjAInhDDqmQ8IWYYJ48NINGb7rZ88KaEbk2ySRRdvZkiD2jbfTL6irvZtRbyvOi3QINB+jVzRuKJXS/UNiDjAbS1anMrG17vxGc1ZTgIifcQAbJNBgI1geQ6sQn2Wj05JG1crLxb2tqCyHeD/nSEPPc8nl4nqyOP4VvuajXS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390937; c=relaxed/simple;
	bh=H/IuwfwmacurTQgm+MKRL8MVWLTgpdNBdWY7u3ZIcD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PW4R39LrkgsrmPEs52KFGrQJpS2IcQbtkX70emAmjP/ExeRK2CqYUYHyBehZFvQ6/TW6lw8xQprvqeOrRuYzKZ7ypKoJYKFDHPu2eJwA85/zB3ncZb8H4LYTLE5ZXRrLdySjrIUrd8XVSFB6qxk/lk4pfZPAHLcobm52ViSoD7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mj2ooDH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mj2ooDH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105DEC4CEC7;
	Tue,  8 Oct 2024 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390937;
	bh=H/IuwfwmacurTQgm+MKRL8MVWLTgpdNBdWY7u3ZIcD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mj2ooDH0GfQZ1Ht5c825S/r+kcxmV7mwXupYZBGZD8u/VnyH2vgSVvbtUGqIoguFt
	 0gwIsBTu3WL5+k66iu0RK38XHifO3a4X1M7Mie3Y5DIxL4mWBEdZvFl3XSMuiyZ2JE
	 G6u2+YYm/Vjlj/+B+JftGJbEVhC9U87zk4BWUUQY=
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
Subject: [PATCH 6.10 440/482] drm/sched: Add locking to drm_sched_entity_modify_sched
Date: Tue,  8 Oct 2024 14:08:23 +0200
Message-ID: <20241008115705.838134971@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,8 +133,10 @@ void drm_sched_entity_modify_sched(struc
 {
 	WARN_ON(!num_sched_list || !sched_list);
 
+	spin_lock(&entity->rq_lock);
 	entity->sched_list = sched_list;
 	entity->num_sched_list = num_sched_list;
+	spin_unlock(&entity->rq_lock);
 }
 EXPORT_SYMBOL(drm_sched_entity_modify_sched);
 


