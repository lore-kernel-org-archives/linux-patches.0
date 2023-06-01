Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C8E5180E;
	Thu,  1 Jun 2023 18:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA3EC433EF;
	Thu,  1 Jun 2023 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685644474;
	bh=dgx+pG+EQbcKekXLixzZt5jEHumR2BEG7sgIUT5wxGU=;
	h=From:Date:Subject:To:Cc:From;
	b=I/nOLwmpjGdksnabUHkvc+aX0DH9qZ0MNYZGZddSTGaeKSZh9OLJbDb7TYmYLlPqa
	 fBjgirHOo7OJxi9ZG15mlDa91JKTm7/WNUNddTdBB7PjVH+w2q2dMBruU9UX9U+Tnz
	 nICHF503IGtcQc2Z77T1B+I7jWlXkWAW0E8HgRT1pVhXVKdknO3ig39PW8pbByQNN2
	 uQkqAWcd0BvVsTQoe5e4nHfad6g0Oqb5YZNHnnZG1Agxi4aN8lwBVvxAlsM98TvWpq
	 zjXiAgIXk2t5REhJ6mo782mVNW5mId330yukt/XMjejrIRuQIbXu8o+Dhc70bboBoP
	 MV6AHNxZdmFOw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 01 Jun 2023 11:34:26 -0700
Subject: [PATCH v2] zswap: Avoid uninitialized use of ret in
 zswap_frontswap_store()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230601-zswap-cgroup-wsometimes-uninitialized-v2-1-84912684ac35@kernel.org>
X-B4-Tracking: v=1; b=H4sIALHkeGQC/5WOQQ6CMBBFr0K6dgwtqMGV9zAuWjrARGjJDKBCu
 LvgDVy+/5P3/6IEmVDUNVkU40RCMWxgDokqGxtqBPIbK5OaLD2nGmZ52R7KmuPYw0tihwN1KDA
 GCjSQbWlGD+6UF1WVm/yCXm0uZwXBsQ1ls9s6KwPyXvSMFb1/B+6PjRuSIfLn92fSe/rv9KRBQ
 3by6LzXhSmy2xM5YHuMXKvHuq5fM7/h9PQAAAA=
To: akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, 
 vitaly.wool@konsulko.com
Cc: nphamcs@gmail.com, yosryahmed@google.com, ndesaulniers@google.com, 
 trix@redhat.com, linux-mm@kvack.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2366; i=nathan@kernel.org;
 h=from:subject:message-id; bh=dgx+pG+EQbcKekXLixzZt5jEHumR2BEG7sgIUT5wxGU=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCkVT3ZaWZbtWO9zObPqzrx3Z8PkXLJ2zGDo/fx7hbxlA
 o8kf4l8RykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhI1DuG/wF1aRZfP/GuzZLb
 YsR02S46ZdKuOzGuC288Opf1um6L9C9GhoP7JN54LF127WzB9TnTusXcldd2TlAVXeluNMXL/c9
 Oc04A
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

This condition used to return -ENOMEM by going to the shrink label, so
set ret to -ENOMEM in the if block explicitly to avoid using it
uninitialized.

Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com/
Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com/
Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Change ret to -ENOMEM to match this condition's previous return value
  (Yosry)
- Link to v1: https://lore.kernel.org/r/20230601-zswap-cgroup-wsometimes-uninitialized-v1-1-35debdd19293@kernel.org
---
 mm/zswap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cff93643a6ab..30092d9a3b23 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	 * local cgroup limits.
 	 */
 	objcg = get_obj_cgroup_from_page(page);
-	if (objcg && !obj_cgroup_may_zswap(objcg))
+	if (objcg && !obj_cgroup_may_zswap(objcg)) {
+		ret = -ENOMEM;
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

