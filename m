Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456E61F8913;
	Tue,  3 Dec 2024 15:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238632; cv=none; b=Nzx68fblT28hs7hXrtGDF++K3xyfqQVdOA9ee+ovzGgCb280QPI+MMnhpRv0jghoVqrgysdHqn++1m9R70Cui8tOtCfLMoK9hw38BXDeIuxijh1wJnIw/aVHyzC/+YvGLSz61fsCz8KWk6UI6o7cXNoX8kjA/yaLJ1u/VsOVrSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238632; c=relaxed/simple;
	bh=L4mOVFBq88Rc1rYey/V0Ena49ThaSAVK0COnJy4ETi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuntLTyyQ7Zdy6Z/4EQ5tsnc4b/G7H4f6zFvXtk2+xe+xJE9aRWOGV+uBSjJzjTn8a+mG4etMVu0h5tvo4hPYRYUHS4zV0bo8MyiwZjdz8WOrJdzH+E3YMss63gVBmmtz+YN1OCXaQd+1qYiQYxOVCD1xoFPPzszXMV7mGrUoq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avvhULlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avvhULlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5448C4CECF;
	Tue,  3 Dec 2024 15:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238632;
	bh=L4mOVFBq88Rc1rYey/V0Ena49ThaSAVK0COnJy4ETi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avvhULlued8VTZoQDQ/EBZ8SfpM+mCHGb5ofBvRJVTDPp9EqF5S4uduc5L41R4TJu
	 ORl1XAq5j802wfs4lrEm2l1p36eRHJh77VGypKHdlK3ZqYxIND4h0Ka64GpTN5ySHA
	 U8IxmdQzUEM9oB5tqK/Ftv+UdOoStAzc//oMvdvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 303/817] drm/nouveau/gr/gf100: Fix missing unlock in gf100_gr_chan_new()
Date: Tue,  3 Dec 2024 15:37:55 +0100
Message-ID: <20241203144007.644004019@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit a2f599046c671d6b46d93aed95b37241ce4504cf ]

When the call to gf100_grctx_generate() fails, unlock gr->fecs.mutex
before returning the error.

Fixes smatch warning:

drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c:480 gf100_gr_chan_new() warn: inconsistent returns '&gr->fecs.mutex'.

Fixes: ca081fff6ecc ("drm/nouveau/gr/gf100-: generate golden context during first object alloc")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241026173844.2392679-1-lihuafei1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
index 060c74a80eb14..3ea447f6a45b5 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
@@ -443,6 +443,7 @@ gf100_gr_chan_new(struct nvkm_gr *base, struct nvkm_chan *fifoch,
 		ret = gf100_grctx_generate(gr, chan, fifoch->inst);
 		if (ret) {
 			nvkm_error(&base->engine.subdev, "failed to construct context\n");
+			mutex_unlock(&gr->fecs.mutex);
 			return ret;
 		}
 	}
-- 
2.43.0



