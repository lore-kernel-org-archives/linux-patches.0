Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521891779B1;
	Tue,  8 Oct 2024 12:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391024; cv=none; b=NGkmqSLWWGlNSljE1pdLqXEwqgAKoxGQI/uwOMriI02JuY5ODp7EhBKObV8v7hhyhdA48TfJBTGH8kgqwpsglXEX4EgHS9BqglKRBugDpxeVmm6KgfAeFYv5zgy/fA1n7CYRpbx06fEz7F4T1kL7d04A7ckIVx3iw2DcUZJbaco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391024; c=relaxed/simple;
	bh=92v5ZQv+el85ndIF/MtEwaUCWokX8F2P8nIk2n9tYtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsvGKPg8y2vbSj0Qjrgs5sYOcnxuiraWF52X2dBUUr4rokr/qAfD6v4GLdXIt2lRSum8GddL6GQG0RId065GesuHXDPxu5j/IlOoRJ3p30hx1GovqDo6PBxMGs0SFijPmgyXL5UDmBBFy6osaab8LM1CBKDrM87/vJKDL/NWkwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qt/7lilb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qt/7lilb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF23DC4CEC7;
	Tue,  8 Oct 2024 12:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391024;
	bh=92v5ZQv+el85ndIF/MtEwaUCWokX8F2P8nIk2n9tYtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qt/7lilb/NEWYUwcYTl19EHQiqt272sO4XzfLEtJlcIa24+axOKNSxPWf5O1dk76s
	 bJy/SNktjZrCyh2rhfikj018q9Nt+1weBx96ymjAoektxKWeKr7JbosKO+ZSDcvbvv
	 h+2nQpruIVk8ZI0LVV6oZlXpJ/UCttvlJbg+OAdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.10 436/482] drm/panthor: Dont add write fences to the shared BOs
Date: Tue,  8 Oct 2024 14:08:19 +0200
Message-ID: <20241008115705.682701417@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

commit f9e7ac6e2e9986c2ee63224992cb5c8276e46b2a upstream.

The only user (the mesa gallium driver) is already assuming explicit
synchronization and doing the export/import dance on shared BOs. The
only reason we were registering ourselves as writers on external BOs
is because Xe, which was the reference back when we developed Panthor,
was doing so. Turns out Xe was wrong, and we really want bookkeep on
all registered fences, so userspace can explicitly upgrade those to
read/write when needed.

Fixes: 4bdca1150792 ("drm/panthor: Add the driver frontend block")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240905070155.3254011-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3436,13 +3436,8 @@ void panthor_job_update_resvs(struct drm
 {
 	struct panthor_job *job = container_of(sched_job, struct panthor_job, base);
 
-	/* Still not sure why we want USAGE_WRITE for external objects, since I
-	 * was assuming this would be handled through explicit syncs being imported
-	 * to external BOs with DMA_BUF_IOCTL_IMPORT_SYNC_FILE, but other drivers
-	 * seem to pass DMA_RESV_USAGE_WRITE, so there must be a good reason.
-	 */
 	panthor_vm_update_resvs(job->group->vm, exec, &sched_job->s_fence->finished,
-				DMA_RESV_USAGE_BOOKKEEP, DMA_RESV_USAGE_WRITE);
+				DMA_RESV_USAGE_BOOKKEEP, DMA_RESV_USAGE_BOOKKEEP);
 }
 
 void panthor_sched_unplug(struct panthor_device *ptdev)


