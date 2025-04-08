Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904D0263C90;
	Tue,  8 Apr 2025 11:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111189; cv=none; b=caRLlO4VhZbIcw0HpNaRlrZl9qMXAj5xxNpovt7WOqZsWLA1K2Adrhb+FPB1OVzg2Vp52salUtDSDA6Pfn6MzL3/mkTKLUYUppKOB8zMuK8+A0wTG2tfbryeUkAda3GWglGGDUai4gu3qHEBpTWk5GTSmBPXUKHJe9Xygm1BuSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111189; c=relaxed/simple;
	bh=wdUbPQoW0O0EvPy+Kq9KP0Tq3CH7k+S2RMbHk/9Ix1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqBP42+jVma7LERY8KRpm8xkkybSjQXwfgW9Dl4IJv1vUQ2PcTtqguBm+tPZ7Qyowig5YNZTypaR27NS1FCmlC1DM5c6tNM10Ec36VWG+T3vmWVo+I71ps+adtsdvRrVLOYERAHSge35ho35KymKNKWRNreZ9d1QWllOh30b+5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEsn8qwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEsn8qwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48CBC4CEE5;
	Tue,  8 Apr 2025 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111189;
	bh=wdUbPQoW0O0EvPy+Kq9KP0Tq3CH7k+S2RMbHk/9Ix1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEsn8qwjg44nJ6rgtiSSeLBXeftplu5wDE5LZqXjqHxmyAqvWSRe0HWr7uSsg/4Wb
	 K8NuPBM9a4q6vngqs87/IDxyKzQug5m9qMyHkA0/ghIL70ooAFTCi2XzPGzGBQJkc3
	 50DSETk0GPg7uXgoI3kkW24qLScgeeXjhLLlIVQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 302/731] drm/msm/gem: Fix error code msm_parse_deps()
Date: Tue,  8 Apr 2025 12:43:19 +0200
Message-ID: <20250408104921.301885951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0b305b7cadce835505bd93183a599acb1f800a05 ]

The SUBMIT_ERROR() macro turns the error code negative.  This extra '-'
operation turns it back to positive EINVAL again.  The error code is
passed to ERR_PTR() and since positive values are not an IS_ERR() it
eventually will lead to an oops.  Delete the '-'.

Fixes: 866e43b945bf ("drm/msm: UAPI error reporting")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/637625/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index dee4704030368..3e9aa2cc38ef9 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -509,7 +509,7 @@ static struct drm_syncobj **msm_parse_deps(struct msm_gem_submit *submit,
 		}
 
 		if (syncobj_desc.flags & ~MSM_SUBMIT_SYNCOBJ_FLAGS) {
-			ret = -SUBMIT_ERROR(EINVAL, submit, "invalid syncobj flags: %x", syncobj_desc.flags);
+			ret = SUBMIT_ERROR(EINVAL, submit, "invalid syncobj flags: %x", syncobj_desc.flags);
 			break;
 		}
 
-- 
2.39.5



