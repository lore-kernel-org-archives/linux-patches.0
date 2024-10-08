Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6051DE89F;
	Tue,  8 Oct 2024 13:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392887; cv=none; b=aMISFnx12aUNQ2C5KLo35G92XPT7Y6EL34/cyp5KlMpmxJIH59hJqDBBh5rDtBF1F44OLJ5ABfl0FnMTcH2YD1K1gJ5mSWrQBfj69rpeukhjGB5xeoPQfeGT1BZVTqunTv7+r9j3AhshO0TdQ8BoR4bUr25MmycFLtnFMHhzCGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392887; c=relaxed/simple;
	bh=iWRZRDv/t+uOOmMt4O/S+/k24u79GVutoJkcr75IOMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJden2YuIprW6ImcLPJh+iJ2rl/4tUAav6UdaOhAVeouZz9qQUzU0KsAEKaearauT64QpRiH6+8Ub0U4rEa2iQzxj2d2OnZ8xEzVcEicGU5F/eodV4DhHa1cMtfubD6gqmjvhRR3jsPM62M1eGXWrzY/QDGZgIeuFHLDPeh05ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzlUKWg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzlUKWg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2596C4CEC7;
	Tue,  8 Oct 2024 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392887;
	bh=iWRZRDv/t+uOOmMt4O/S+/k24u79GVutoJkcr75IOMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzlUKWg5JJ2g9I1nP4yyoU6vJt0wYHsmBFhv+Jgw947iz9i1cxDZADsvJ4ZS0htPk
	 Gelj4ElFnNBGxdFJREmt9EOUCYUnAvj4QJnA6c9HArSP7Xuew8dANCM/Q/wLydUqAz
	 zRu2I74v6mlSR8Fe0A6oWpgdx2O4YeOloSsg08/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.11 517/558] drm/panthor: Dont add write fences to the shared BOs
Date: Tue,  8 Oct 2024 14:09:07 +0200
Message-ID: <20241008115722.573684763@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

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


