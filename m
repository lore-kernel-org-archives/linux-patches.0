Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAA1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59179C433D2;
	Wed, 28 Dec 2022 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242557;
	bh=vejQkFDdSOS03xjmkABwON08TrvkSVRcuB0GKoJf21k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+ubaS5kn5RTjRKYy8mDBYjU1Inr5FuqnaHfbM/u4A6qiyL1FP38nSIIv0p9eERTV
	 24U7rIzAKCss6QbCByZVWf56T+aod5ylY2a6DbRvexUJhrhi0Ggm7xTK5doAH12F4q
	 Wx3JwK0M+Kv+8djxnZZNzNTnltKsHYOqyXDyk514=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Fukun <xiafukun@huawei.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0425/1073] drm/i915/bios: fix a memory leak in generate_lfp_data_ptrs
Date: Wed, 28 Dec 2022 15:33:33 +0100
Message-Id: <20221228144339.566314747@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xia Fukun <xiafukun@huawei.com>

[ Upstream commit 1382901f75a5a7dc8eac05059fd0c7816def4eae ]

When (size != 0 || ptrs->lvds_ entries != 3), the program tries to
free() the ptrs. However, the ptrs is not created by calling kzmalloc(),
but is obtained by pointer offset operation.
This may lead to memory leaks or undefined behavior.

Fix this by replacing the arguments of kfree() with ptrs_block.

Fixes: a87d0a847607 ("drm/i915/bios: Generate LFP data table pointers if the VBT lacks them")
Signed-off-by: Xia Fukun <xiafukun@huawei.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221125063428.69486-1-xiafukun@huawei.com
(cherry picked from commit 7674cd0b7d28b952151c3df26bbfa7e07eb2b4ec)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 459571e2cc57..2bfcfbfa52a4 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -414,7 +414,7 @@ static void *generate_lfp_data_ptrs(struct drm_i915_private *i915,
 		ptrs->lvds_entries++;
 
 	if (size != 0 || ptrs->lvds_entries != 3) {
-		kfree(ptrs);
+		kfree(ptrs_block);
 		return NULL;
 	}
 
-- 
2.35.1



