Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331D6346A0E;
	Tue, 16 Dec 2025 11:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885519; cv=none; b=TXFjrvreoFobfGuyjzivFNsomw3nFd1OMHogLLXjI6Q7rgj0R03s2dYaJdIg04gO0TATM7uMYdFVIYBYW3dJqrJ6yFW4zeeZ7cuO1beFtrDC3GBHyeHAx6amPv1JhGpK80ReJ7wyWyBqAHJ/RUQ9lx+h1EJGndsIg1x9DbKUem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885519; c=relaxed/simple;
	bh=MgJXTCulLSRHFl57aifwLRltDMmR69EDnzv9Dm8KrJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCPTpo6KHIdQvMv8JiQGKsPyB8mOKnWrMKqOe6xgZCuMK0Fy9SEVjAfEFFS7H5hcUYihwif3aJGirVgabJzipcT2vc6kfJ9W2H+sO6gEs7XzzZKbZJw/VaaK07uCyyalKASusD/6W7SiQ+VyVvZqEFXWrNhjL+XTKloEPSj0zSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eG7xtWL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eG7xtWL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D95C4CEF1;
	Tue, 16 Dec 2025 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885519;
	bh=MgJXTCulLSRHFl57aifwLRltDMmR69EDnzv9Dm8KrJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG7xtWL6psMXT96Bgsfqa5qNO0PpkOdWx7i92cZQBhQN2/nu1uIc07A3GO2PxXut1
	 BzlnH8QI9ySBci4JVYVDxehucSo3SyIIg+4/WYw7Ux00agee5uaV9rwvGDbbe9D2fY
	 s8l0BnKb01GAiFT9ilboU8jUvNB2ffUTjozAVRRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 162/507] drm/panthor: Handle errors returned by drm_sched_entity_init()
Date: Tue, 16 Dec 2025 12:10:03 +0100
Message-ID: <20251216111351.389670323@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index df76653e649a3..a0a31aa6c6bcf 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3380,6 +3380,8 @@ group_create_queue(struct panthor_group *group,
 
 	drm_sched = &queue->scheduler;
 	ret = drm_sched_entity_init(&queue->entity, 0, &drm_sched, 1, NULL);
+	if (ret)
+		goto err_free_queue;
 
 	return queue;
 
-- 
2.51.0



