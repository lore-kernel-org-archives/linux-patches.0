Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB904C97;
	Tue, 11 Nov 2025 00:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822400; cv=none; b=QYmK83YmQFWc8gVclEGlCWq4rs5nNBKlb9DGTRW154Lxpmk5+gFmpAakHBoLGyZ/ZhzwcL/y5GvGVK0cdqU43i3zsmYrx9VXLzv5mCKlP/xFsqc/QCrEJfDMmO13Aj1m62cOwKJ/7SfPOghLzP1BuLYGtxTFPM6vWsVcfUnJul8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822400; c=relaxed/simple;
	bh=v6bFqT8Mh6BCpvEnXvdHkDnLm+g6Q74ysh7utcIK6nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXPob3RgDNC/5Rjo2aIONwpt8XqoaEN6tO/Tr6lSoYri2//nQa+BvWpQ7KtSEGrEkPIieqBepsElnqJT15koPIVZuD5eU+DRFknHrSmwii/NZ3W3ltxTSHz0t7HuoL3WRAYEf7I1Nj9AetSYAwF4OLx4XBEC2lDErXS9PRdf2nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPOc9HaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPOc9HaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCCCC4CEFB;
	Tue, 11 Nov 2025 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822399;
	bh=v6bFqT8Mh6BCpvEnXvdHkDnLm+g6Q74ysh7utcIK6nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPOc9HaJKewzEczLjk/72Ek9OkkzBpDTIKsa9ZZP+05n1DRguo2NyRd80SR3AatB1
	 +ZzuaZE+lgugW91kxczCo/acBQAjLi7D7rW5rNeNLUNzGzQLipwsFUsrWKXQ4Yvtx6
	 jP4H+rExfF25C45JiRmqfhZDTmIn/OMfz5oCltJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.17 100/849] drm/sched: avoid killing parent entity on child SIGKILL
Date: Tue, 11 Nov 2025 09:34:30 +0900
Message-ID: <20251111004538.822358794@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit 9e8b3201c7302d5b522ba3535630bed21cc03c27 upstream.

The DRM scheduler tracks who last uses an entity and when that process
is killed blocks all further submissions to that entity.

The problem is that we didn't track who initially created an entity, so
when a process accidently leaked its file descriptor to a child and
that child got killed, we killed the parent's entities.

Avoid that and instead initialize the entities last user on entity
creation. This also allows to drop the extra NULL check.

Signed-off-by: David Rosca <david.rosca@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4568
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
CC: stable@vger.kernel.org
Acked-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20251015140128.1470-1-christian.koenig@amd.com
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20251015140128.1470-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -70,6 +70,7 @@ int drm_sched_entity_init(struct drm_sch
 	entity->guilty = guilty;
 	entity->num_sched_list = num_sched_list;
 	entity->priority = priority;
+	entity->last_user = current->group_leader;
 	/*
 	 * It's perfectly valid to initialize an entity without having a valid
 	 * scheduler attached. It's just not valid to use the scheduler before it
@@ -302,7 +303,7 @@ long drm_sched_entity_flush(struct drm_s
 
 	/* For killed process disable any more IBs enqueue right now */
 	last_user = cmpxchg(&entity->last_user, current->group_leader, NULL);
-	if ((!last_user || last_user == current->group_leader) &&
+	if (last_user == current->group_leader &&
 	    (current->flags & PF_EXITING) && (current->exit_code == SIGKILL))
 		drm_sched_entity_kill(entity);
 


