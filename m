Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF90F1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6381DC433C8;
	Tue,  1 Aug 2023 09:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882502;
	bh=anNq+DgTWNlMX1ULsb+0b5vq3jTs2vPSLz4jNs/1vmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0slums7cGkyWdzZsz8VvOXvszygfhSq0Zck/HvN2M/LKs2iZM3UTlbTFOQo2ibcTo
	 h60+xkh3iW2Ri8/lu+A5GAhsLRuQmSKHjn0kDijZVZ5pEPAJ8IXz4T6r7dWtYqMPJb
	 zPDW5ShqfeL0kK2zL/3ZkeJXL9OCYlXa/oNk2GFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/228] drm/i915: Fix an error handling path in igt_write_huge()
Date: Tue,  1 Aug 2023 11:19:47 +0200
Message-ID: <20230801091927.408426825@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e354f67733115b4453268f61e6e072e9b1ea7a2f ]

All error handling paths go to 'out', except this one. Be consistent and
also branch to 'out' here.

Fixes: c10a652e239e ("drm/i915/selftests: Rework context handling in hugepages selftests")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/7a036b88671312ee9adc01c74ef5b3376f690b76.1689619758.git.christophe.jaillet@wanadoo.fr
(cherry picked from commit 361ecaadb1ce3c5312c7c4c419271326d43899eb)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index 436598f19522c..02fe7ea8c5df8 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1185,8 +1185,10 @@ static int igt_write_huge(struct drm_i915_private *i915,
 	 * times in succession a possibility by enlarging the permutation array.
 	 */
 	order = i915_random_order(count * count, &prng);
-	if (!order)
-		return -ENOMEM;
+	if (!order) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	max_page_size = rounddown_pow_of_two(obj->mm.page_sizes.sg);
 	max = div_u64(max - size, max_page_size);
-- 
2.40.1



