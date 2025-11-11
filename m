Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F754C97;
	Tue, 11 Nov 2025 00:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822409; cv=none; b=sTYgUTgYfP00jvySJ68JvOPrTvkSno1wsa2b2n1cRr1a7qBrvFsCeK8P4gtoFK0sQeNr38XJK+cq5y5oTUF2Tq1re6dW0KIYSHwFyeCEvm7rVpVLWGQzKHTcrSWfX6Wdfc6Ze/fiPHh9s9ZHl+AcayZrqn60581AS71jZhjw0Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822409; c=relaxed/simple;
	bh=NuqdgO724e1HG6QEqX5SD9UVduw7KN5BQM0FHu70DgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5eboLJh85Wv/NsZMBuybsgS+i3Y+nLEf8z1Yj3Y7ZgC4UvGIPhJMGLXO1K0kWz9huQaIa0yjDh3LEhpN9JI8qjsZr4rRoiq5205SRXKy3bDH6iW+wEcpZtwvZxEx9wLErnfmUYZ14GK0L2KIlFRqqUsGZpS+kPu9YK6IsyqA6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhS7sU8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhS7sU8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EB7C4CEF5;
	Tue, 11 Nov 2025 00:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822409;
	bh=NuqdgO724e1HG6QEqX5SD9UVduw7KN5BQM0FHu70DgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhS7sU8gshi5oTiGhjIbGxZOaU0dm+Xc3dgFPL4lod4XUMo6r4hbu3RdhzxxBmTxt
	 YOstifDKqse+u1brbLgm0kzXVF/6tk1KnclnX50/DEkdIYI8rtJU9KIn6qbM0sExQW
	 irTEtacyIDIly2KhAcZjSsnBqjWHsREnLqIrbQkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.17 102/849] drm/nouveau: Fix race in nouveau_sched_fini()
Date: Tue, 11 Nov 2025 09:34:32 +0900
Message-ID: <20251111004538.871337495@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -482,6 +482,17 @@ nouveau_sched_create(struct nouveau_sche
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
@@ -489,8 +500,7 @@ nouveau_sched_fini(struct nouveau_sched
 	struct drm_gpu_scheduler *drm_sched = &sched->base;
 	struct drm_sched_entity *entity = &sched->entity;
 
-	rmb(); /* for list_empty to work without lock */
-	wait_event(sched->job.wq, list_empty(&sched->job.list.head));
+	wait_event(sched->job.wq, nouveau_sched_job_list_empty(sched));
 
 	drm_sched_entity_fini(entity);
 	drm_sched_fini(drm_sched);


