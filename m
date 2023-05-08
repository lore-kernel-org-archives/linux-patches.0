Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B84168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D45C4339B;
	Mon,  8 May 2023 11:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544194;
	bh=rix6UicrSFSuwNlTAyAjtW4dtJE6YI4DzhI9eWvV56Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdz8x5VowbJjNwbfdJxIxIMUM+imWyXbqvjEo6C/dbe8eCMyh/QIpfSAmIJ7YZgi5
	 rXpoXO8u2MJ9shHFDNUkpUx+D1JI3q1ZFnWLEpAElNfZlWz5TEpErRxq/+UiY9KoQA
	 6uSTYospLfKVb48DeiVNW8bICsUclefCNTilQmvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Liu <liucong2@kylinos.cn>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 314/694] drm/i915: Fix memory leaks in i915 selftests
Date: Mon,  8 May 2023 11:42:29 +0200
Message-Id: <20230508094442.492782459@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cong Liu <liucong2@kylinos.cn>

[ Upstream commit 803033c148f754f32da1b93926c49c22731ec485 ]

This patch fixes memory leaks on error escapes in function fake_get_pages

Fixes: c3bfba9a2225 ("drm/i915: Check for integer truncation on scatterlist creation")
Signed-off-by: Cong Liu <liucong2@kylinos.cn>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230414224109.1051922-1-andi.shyti@linux.intel.com
(cherry picked from commit 8bfbdadce85c4c51689da10f39c805a7106d4567)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
index 01e75160a84ab..22890acd47b78 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -69,8 +69,10 @@ static int fake_get_pages(struct drm_i915_gem_object *obj)
 
 	rem = round_up(obj->base.size, BIT(31)) >> 31;
 	/* restricted by sg_alloc_table */
-	if (overflows_type(rem, unsigned int))
+	if (overflows_type(rem, unsigned int)) {
+		kfree(pages);
 		return -E2BIG;
+	}
 
 	if (sg_alloc_table(pages, rem, GFP)) {
 		kfree(pages);
-- 
2.39.2



