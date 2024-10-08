Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296821DE88F;
	Tue,  8 Oct 2024 13:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392790; cv=none; b=Ro2pihOCcDKNwSVVON6/csdNg7X8z0Qbroji38t9J8PUol/Ht5k3xME+cGOCsiXXArv76MKrGs6puBfCB0BzyQ81NwMi5eDrsg5qDCsGtW/w9g+6Xcerwmo9nBaDl536BEB33ml9PtGwTLlBC7vg19PQUo7UV0dH96Qh4ExOMsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392790; c=relaxed/simple;
	bh=N6HDXsq3fY/TfGqXJRTnCGdAYKmNCxZaIGFlcRCoVdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oeXO29PIpbhQ4kB8V1GPh2PMOYs6VUjfoMt83IcXAyRzqm6WIxyuAMvL0HtdeGhRvOxdcyVqeeJx//S09AIRlxPlYEqjuDQS5Qr0Ws1+g3RSCgHt3MrbfsqC4Kkcrw9I9Yd7ZJQNn6M8xDnK6ShREFC1fFn8HkI3QrZOSs4oeqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5nDtqlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5nDtqlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9E0C4CECC;
	Tue,  8 Oct 2024 13:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392790;
	bh=N6HDXsq3fY/TfGqXJRTnCGdAYKmNCxZaIGFlcRCoVdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5nDtqlNur5aIYzHfxeeSb44gar9+t+CoKu7w1SLWD6sKwOvNPpnUbVCceYixnCke
	 L4HzEJNkCsIiAsXYrA4FnygBn2m6Z7FFK3KgdjG69xFtKvTADGb6U3e5+YN8e53UH4
	 4nxClYBc0n/4CD0fkq+eS3y2bEGz/mChauMyuI2A=
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
Subject: [PATCH 6.11 521/558] drm/sched: Add locking to drm_sched_entity_modify_sched
Date: Tue,  8 Oct 2024 14:09:11 +0200
Message-ID: <20241008115722.730754697@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


