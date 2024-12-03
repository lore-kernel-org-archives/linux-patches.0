Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8312C80;
	Tue,  3 Dec 2024 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240955; cv=none; b=pplWlUMPXCD55zuDyff2bkhFsIuv8U4cpr9SEVc7PZ3siCWxcyuqHdm4ar/vQSvk+UklYdYYzbJ55Ysw1jwtOqh6ZZhL+nLUb9w3kzFEz2vcT8lXfH2kgEXNkQL5aQA4qE4qAcPg7ZvMplUlGtF4TrYVqNYL7vBZXVK8/tBsJgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240955; c=relaxed/simple;
	bh=vXT/QlB1u6fcoLaLAWylLsqUWLFcCqmsrVP4pfpCJ0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+HWMqRQkJWmXSFpHTQ2qevhjn6H5oNmB3ZIdLUREsY4MFWsB3yLqVIC/4Xt74PIXWFTNl1itRXdTh+bU3DlisWX9+EtgO8DOb3n3dDTzTrHYh5XGcXRZ0fo1o6W5Sf5QD2sBaiuYnyA+88L6+3fb0/dkjS1moRRjPSuVgbyrYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdOyAugE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdOyAugE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279D5C4CECF;
	Tue,  3 Dec 2024 15:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240955;
	bh=vXT/QlB1u6fcoLaLAWylLsqUWLFcCqmsrVP4pfpCJ0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdOyAugEt7ZzCD8QGoctwf+OjuaLQraDEinKWzb6KHqxrtlagtNInGJsYvFsuUCSl
	 3TjjKdW0rHgBtXfTwK6lhlBjkkknGdqTT7lIIloB+NinNtBLjNLxdRr5yvizRxOIPq
	 n4R1Msp72bp573/dOeQE7Sha6e0pU9Rd9KFw0YZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/826] drm/nouveau/gr/gf100: Fix missing unlock in gf100_gr_chan_new()
Date: Tue,  3 Dec 2024 15:40:12 +0100
Message-ID: <20241203144754.889327404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



