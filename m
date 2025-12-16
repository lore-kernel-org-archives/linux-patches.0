Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5FF1EBFE0;
	Tue, 16 Dec 2025 12:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887311; cv=none; b=Ppt0iCe4EUAf5aXSosnwE57162SyrO3poYd2ws6llBs4o5bYmtamw4duVD3Go9+pnK+nsuvObYcxiDy7qQTtJse64OdoCxy4n9HzaIBYORscHOlfPfn2h6BGKfFfSM8WGIxMZ+fbdWjAd2WbPpuX+Uh5ojCnRZzmWZ/ZwdAO9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887311; c=relaxed/simple;
	bh=mW3qCaxDALrwyxnr7leRIHW4rL1sUHYgM66M0inBibw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uiocGyo2bSVHkWSTJ/2X1mfsz5xtu8bMLscszjQQTYeqkn4qB2R3A60ywAGJHuWGtWdACv4/45ec4O+C6S8emkrFDDwuv2Nf9eBHZD/4ymUUGLCKco2tKD9w69QoHinDFMiVrZPW/l1BvobfS0sYtfDXX5LtgJ2UZmoizpXuxdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKT/Jok0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKT/Jok0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23FFC4CEF1;
	Tue, 16 Dec 2025 12:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887311;
	bh=mW3qCaxDALrwyxnr7leRIHW4rL1sUHYgM66M0inBibw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKT/Jok0uFu8TeNbiz0EISneHekPh+ymeX7lcxaXXkpAtWhfTvwibSX387QoSVm5X
	 2yNnpOKYLkUvvCE2Kh1skplzbXEMBpOfvGPbZXFNmUsCZbH7lFzmB1Lo1RP9c5bFeY
	 32EtxDAInAn7MQgDDILZEWXsEVYyRZBCeEjtZzxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/614] drm/panthor: Fix group_free_queue() for partially initialized queues
Date: Tue, 16 Dec 2025 12:09:18 +0100
Message-ID: <20251216111408.291721498@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 94a6d20feadbbe24e8a7b1c56394789ea5358fcc ]

group_free_queue() can be called on a partially initialized queue
object if something fails in group_create_queue(). Make sure we don't
call drm_sched_entity_destroy() on an entity that hasn't been
initialized.

Fixes: 7d9c3442b02a ("drm/panthor: Defer scheduler entitiy destruction to queue release")
Reviewed-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251031160318.832427-2-boris.brezillon@collabora.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 85ef9a7acc147..a39f0fb370dc6 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -895,7 +895,8 @@ static void group_free_queue(struct panthor_group *group, struct panthor_queue *
 	if (IS_ERR_OR_NULL(queue))
 		return;
 
-	drm_sched_entity_destroy(&queue->entity);
+	if (queue->entity.fence_context)
+		drm_sched_entity_destroy(&queue->entity);
 
 	if (queue->scheduler.ops)
 		drm_sched_fini(&queue->scheduler);
-- 
2.51.0



