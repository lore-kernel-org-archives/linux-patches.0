Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46163A8C3;
	Fri, 24 Nov 2023 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jc/b8ZK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AABC433C8;
	Fri, 24 Nov 2023 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850713;
	bh=Jzd8qNyED4G6yGaKbclyz2O9Ftn8oNPoEx4L68D2k5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jc/b8ZK/mKuX7REMpHQ1Mv3h7f95kRHgdx6GckjxYddDZ4vkIt/OL+MhIfv3Lve6u
	 k8FYJPkmrAj2WaWLJqNNNFwSWxU4KbIpKVLHHhk4KkheoE6x1Vz/LEjhV8apWMaJU1
	 3tTRy4Nt53XATOXg9te489Bsr1P6NUo2sj1XfOi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 159/491] drm/i915/mtl: avoid stringop-overflow warning
Date: Fri, 24 Nov 2023 17:46:35 +0000
Message-ID: <20231124172029.256143983@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 390001d648ffa027b750b7dceb5d43f4c1d1a39e ]

The newly added memset() causes a warning for some reason I could not
figure out:

In file included from arch/x86/include/asm/string.h:3,
                 from drivers/gpu/drm/i915/gt/intel_rc6.c:6:
In function 'rc6_res_reg_init',
    inlined from 'intel_rc6_init' at drivers/gpu/drm/i915/gt/intel_rc6.c:610:2:
arch/x86/include/asm/string_32.h:195:29: error: '__builtin_memset' writing 16 bytes into a region of size 0 overflows the destination [-Werror=stringop-overflow=]
  195 | #define memset(s, c, count) __builtin_memset(s, c, count)
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/gt/intel_rc6.c:584:9: note: in expansion of macro 'memset'
  584 |         memset(rc6->res_reg, INVALID_MMIO_REG.reg, sizeof(rc6->res_reg));
      |         ^~~~~~
In function 'intel_rc6_init':

Change it to an normal initializer and an added memcpy() that does not have
this problem.

Fixes: 4bb9ca7ee074 ("drm/i915/mtl: C6 residency and C state type for MTL SAMedia")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231016201012.1022812-1-arnd@kernel.org
(cherry picked from commit 0520b30b219053cd789909bca45b3c486ef3ee09)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_rc6.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
index 58bb1c55294c9..ccdc1afbf11b5 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -584,19 +584,23 @@ static void __intel_rc6_disable(struct intel_rc6 *rc6)
 
 static void rc6_res_reg_init(struct intel_rc6 *rc6)
 {
-	memset(rc6->res_reg, INVALID_MMIO_REG.reg, sizeof(rc6->res_reg));
+	i915_reg_t res_reg[INTEL_RC6_RES_MAX] = {
+		[0 ... INTEL_RC6_RES_MAX - 1] = INVALID_MMIO_REG,
+	};
 
 	switch (rc6_to_gt(rc6)->type) {
 	case GT_MEDIA:
-		rc6->res_reg[INTEL_RC6_RES_RC6] = MTL_MEDIA_MC6;
+		res_reg[INTEL_RC6_RES_RC6] = MTL_MEDIA_MC6;
 		break;
 	default:
-		rc6->res_reg[INTEL_RC6_RES_RC6_LOCKED] = GEN6_GT_GFX_RC6_LOCKED;
-		rc6->res_reg[INTEL_RC6_RES_RC6] = GEN6_GT_GFX_RC6;
-		rc6->res_reg[INTEL_RC6_RES_RC6p] = GEN6_GT_GFX_RC6p;
-		rc6->res_reg[INTEL_RC6_RES_RC6pp] = GEN6_GT_GFX_RC6pp;
+		res_reg[INTEL_RC6_RES_RC6_LOCKED] = GEN6_GT_GFX_RC6_LOCKED;
+		res_reg[INTEL_RC6_RES_RC6] = GEN6_GT_GFX_RC6;
+		res_reg[INTEL_RC6_RES_RC6p] = GEN6_GT_GFX_RC6p;
+		res_reg[INTEL_RC6_RES_RC6pp] = GEN6_GT_GFX_RC6pp;
 		break;
 	}
+
+	memcpy(rc6->res_reg, res_reg, sizeof(res_reg));
 }
 
 void intel_rc6_init(struct intel_rc6 *rc6)
-- 
2.42.0



