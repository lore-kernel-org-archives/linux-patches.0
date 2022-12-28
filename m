Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3111875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44602C433D2;
	Wed, 28 Dec 2022 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243012;
	bh=HeK+KAzK0BSEobLSQIr/eliNCLZbKEyHKi+Wbe7wzxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzfpGcgD68fAmxEziUecmjGUIlqxg3K7ub2ot9RJf9tk/k/BRfEIrl3MuIa3cSM0b
	 QUKALxgaGNp1eMb8psylXhA6jswtSGbRmtz1g9W5J1cRVTQYo0VCRDFM2jFonTBHeF
	 5MqUGL1Jj0phcQqPEhlTd/8hbYlfFc973HDYeUuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Fukun <xiafukun@huawei.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0440/1146] drm/i915/bios: fix a memory leak in generate_lfp_data_ptrs
Date: Wed, 28 Dec 2022 15:32:59 +0100
Message-Id: <20221228144342.132258884@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 28bdb936cd1f..edbdb949b6ce 100644
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



