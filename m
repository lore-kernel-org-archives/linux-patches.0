Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A9F23400;
	Thu,  1 Jun 2023 15:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7334C433D2;
	Thu,  1 Jun 2023 15:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685633190;
	bh=ZEqKq2MGPwE7UmZkmGx9PfcvEwEnm43p6Kqjn+YHD54=;
	h=From:Date:Subject:To:Cc:From;
	b=pJlEQRFcI1KzDRh4BpUI27GOM3eku6JhOS/Ayy53bJhJuapS07hiAcwnTvVmzm33U
	 xcN5uXQprcvLy/XkjzidhfE2B4FreQ0htuC9/gQs/EVlPMnvWuKcOZHsV8AfAb8N2c
	 Alezdo7LrD/SWzCggR89nYqDOgVt0l2KJpYZxfZvguVFKriRy/RHb443PFZJAjCYX5
	 dx02TK8eJkab4dvfDANuTuj8A0SBrDOvg4oGVKZ39QeRciohsdasVqsLNkQJc6sHPe
	 EAWqSSSXEitfwpYOds4m2XqtbPYUlZ5slVRsm1ZWdf5kNzEEf731l2k3+lRzuswRUI
	 qtIpPYzOROyCA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 01 Jun 2023 08:26:16 -0700
Subject: [PATCH] zswap: Avoid uninitialized use of ret in
 zswap_frontswap_store()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230601-zswap-cgroup-wsometimes-uninitialized-v1-1-35debdd19293@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJe4eGQC/x2OywrCMBAAf6Xk7EIao6K/Ih7y2LQLJg3Z1EpL/
 93U4zAwzCYYCyGLR7eJgh9imlKD/tQJN5o0IJBvLJRUZ3mVPay8mAxuKNOcYeEpYqWIDHOiRJX
 Mm1b0YC/6HoJW+oZetJY1jGCLSW48atFwxXKIXDDQ9z/wfO37D9EgKUOQAAAA
To: akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, 
 vitaly.wool@konsulko.com
Cc: ndesaulniers@google.com, trix@redhat.com, nphamcs@gmail.com, 
 linux-mm@kvack.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2147; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ZEqKq2MGPwE7UmZkmGx9PfcvEwEnm43p6Kqjn+YHD54=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCkVO5bed5S7uD8+/sOyRdGsao9Xmk2Yvnz1dOWbW/bWC
 /dotL071FHKwiDGwSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmYsbHyNDCZ6By9rVc22rm
 aT/vpyya/5YhwNDziVVFTOyV9S+z9/Mw/E+oFVHuYWPSKJ54UmRy+7anmQLf/JJuO3uE3j7OoeD
 3mgkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  mm/zswap.c:1183:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
   1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/zswap.c:1327:9: note: uninitialized use occurs here
   1327 |         return ret;
        |                ^~~
  mm/zswap.c:1183:2: note: remove the 'if' if its condition is always false
   1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1184 |                 goto reject;
        | ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/zswap.c:1158:9: note: initialize the variable 'ret' to silence this warning
   1158 |         int ret;
        |                ^
        |                 = 0
  1 error generated.

Set ret to -EINVAL, which seems to best match the situation the comment
mentions and matches an earlier bailout due to an unsupported type or
situation.

Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com/
Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com/
Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 mm/zswap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cff93643a6ab..e8313e2f5807 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	 * local cgroup limits.
 	 */
 	objcg = get_obj_cgroup_from_page(page);
-	if (objcg && !obj_cgroup_may_zswap(objcg))
+	if (objcg && !obj_cgroup_may_zswap(objcg)) {
+		ret = -EINVAL;
 		goto reject;
+	}
 
 	/* reclaim space if needed */
 	if (zswap_is_full()) {

---
base-commit: b2424568bd9b947b2698b693ff24fec63bb4b36a
change-id: 20230601-zswap-cgroup-wsometimes-uninitialized-b549ff4247ed

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

