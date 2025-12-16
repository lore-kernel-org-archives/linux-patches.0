Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C26135CB79;
	Tue, 16 Dec 2025 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887308; cv=none; b=BLUjy9Ok69xeOgVH8MHNr6NouS8dgkvxEfPHb4NXtebDZ/VrrkqDIctH0lRhTm/WSyu3tPEeHY9p+ynGhsNkjNf25w25JiWSN4OpQPqKclPoRiPHyp9WJSiSQxyZSa0MeEtOXI07Dgk7QW2xoHntJfLDRTb3ZirQin8mv49bQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887308; c=relaxed/simple;
	bh=Sa6fPRSuGD/EgfKABfUFCek1eUrFJ0hzEcxAEDzW1x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufk/8jVLNggAyfTCteCmJwoSnhdWiEOS4wTDjmuNAkpDLMCzyncyKxSYikldAcSNxRbs1zo4SJgmHRWga4yg323INk8wfdgVYpOY8+j0DiFTagByMTULEIKN8PHNPea7SqGwkJ1jgITo1QZX9AwGY3U0pZwFz1g/hATNL6s7PCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVwsp5B9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVwsp5B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B67C4CEF1;
	Tue, 16 Dec 2025 12:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887307;
	bh=Sa6fPRSuGD/EgfKABfUFCek1eUrFJ0hzEcxAEDzW1x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVwsp5B9EUTUoJI7+jOtevhXX5MeFDL7hP9ua4doyckwgIQawWs6jMkhN3I8+LIwQ
	 Kpctt5o29IH4Xq6h2xU3YEv3+ndUqw0Q7G/ccap2BvGNp4mR5YrbnSrmVFovg49I7G
	 7rCdu5+0W69Tmxkb4lnBt2vUAmNkCLyd4kWkevvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/614] drm/panthor: Handle errors returned by drm_sched_entity_init()
Date: Tue, 16 Dec 2025 12:09:17 +0100
Message-ID: <20251216111408.256198620@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit bb7939e332c64c4ef33974a0eae4f3841acfa8eb ]

In practice it's not going to fail because we're passing the current
sanity checks done by drm_sched_entity_init(), and that's the only
reason it would return an error, but better safe than sorry.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251031160318.832427-1-boris.brezillon@collabora.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 3d1f57e3990f4..85ef9a7acc147 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3403,6 +3403,8 @@ group_create_queue(struct panthor_group *group,
 
 	drm_sched = &queue->scheduler;
 	ret = drm_sched_entity_init(&queue->entity, 0, &drm_sched, 1, NULL);
+	if (ret)
+		goto err_free_queue;
 
 	return queue;
 
-- 
2.51.0



