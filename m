Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19796AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7300BC433F0;
	Wed,  4 Jan 2023 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849485;
	bh=RKeG6pAXImq9qcj+T4tzTpmu5OGLr1tJpPPZeeygvbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBRDj7wzSP0BGW6tUUL3Nhn3NNj4N1oYThZp3+h+QK3w1U/QdAP7Xs3i8YSfoZJAV
	 PmjZanZDD0j0bmppbKaAkpoaOlR2xnjwlcp5Jb/2WcVwXeBzLcnCzLl4EpT3BxlBGR
	 8Fuhv1FgpAoSoZIg7iikKfsn23NQTsjk3npM0XeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 6.0 130/177] drm/etnaviv: reap idle mapping if it doesnt match the softpin address
Date: Wed,  4 Jan 2023 17:07:01 +0100
Message-Id: <20230104160511.586835469@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas Stach <l.stach@pengutronix.de>

commit 332f847212e43d584019a8264895f25cf92aa647 upstream.

When a idle BO, which is held open by another process, gets freed by
userspace and subsequently referenced again by e.g. importing it again,
userspace may assign a different softpin VA than the last time around.
As the kernel GEM object still exists, we likely have a idle mapping
with the old VA still cached, if it hasn't been reaped in the meantime.

As the context matches, we then simply try to resurrect this mapping by
increasing the refcount. As the VA in this mapping does not match the
new softpin address, we consequently fail the otherwise valid submit.
Instead of failing, reap the idle mapping.

Cc: stable@vger.kernel.org # 5.19
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -258,7 +258,12 @@ struct etnaviv_vram_mapping *etnaviv_gem
 		if (mapping->use == 0) {
 			mutex_lock(&mmu_context->lock);
 			if (mapping->context == mmu_context)
-				mapping->use += 1;
+				if (va && mapping->iova != va) {
+					etnaviv_iommu_reap_mapping(mapping);
+					mapping = NULL;
+				} else {
+					mapping->use += 1;
+				}
 			else
 				mapping = NULL;
 			mutex_unlock(&mmu_context->lock);


