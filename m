Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E8E2737F8;
	Tue,  5 Aug 2025 13:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399470; cv=none; b=mFBAiVy4rNfzNAcu70rGyKZz4Q5JRFeWpL1uR8bapcm5FFJum6xUjaR22QxlTvAlTbptMyb9/i/9BOiHKYuSQD2o3a7l0AS2ZNb1FsCWMPSdAHNZTz3/JxkfFowwI5tVnEC2Ptj4agIBlQVlQ97N3B78ihdL2uuDZ1poYgUz1tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399470; c=relaxed/simple;
	bh=oZf+e2ws7aIyKk6p8FsCGM33W6e66Bu+o3PoG4ccLd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DCG0T0GwshwWn6DrUTI4rdiPgd7+AXkdbDWIO4qyiBeJWfh2mmerAiQC9bm4lgTN/2CE3FHcXGubSTI9H4RD+xaRJSJrWs++nLgBSInZJDQSWKYoov5+JUP7kSybDkKB/rL8vzHEJkEp3T0Wwk88T8TsjJ47V5F/EXGrhVuoeZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSEHeW06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSEHeW06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543D0C4CEF9;
	Tue,  5 Aug 2025 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399470;
	bh=oZf+e2ws7aIyKk6p8FsCGM33W6e66Bu+o3PoG4ccLd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSEHeW06eP9gb+AmXUTv3HH2Z3MimEG0BHI5RnbP37/lH+ZtPacd3qJ+uqqwNgOaM
	 Yj3psesqstBgKGb6wSKkjtofKSIsCWAYLqRuWoqhBf0VfKHK91JRVHCCW+oK3+CiVV
	 je4ixpx65nxegoJJpyKVxUfz9mnbCTytpV+iGfN2/hJGe7jHM/Twvuidp6LZI1HT3Q
	 S9OD0rqvzD8Yu3zsfXjMa0X7GfnJ9OllqEbwB0DouIwwYTXsG/3dTQDvLvhKomazVn
	 S6GsRfljn4Tz2gULovVJavVPYEs71Rtp1KqiYR1YlUkZim7m7NvVU+oj3EYD1d+FDe
	 PI0ot8o/D4mmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shiji Yang <yangshiji66@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-6.1] MIPS: lantiq: falcon: sysctrl: fix request memory check logic
Date: Tue,  5 Aug 2025 09:09:13 -0400
Message-Id: <20250805130945.471732-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 9c9a7ff9882fc6ba7d2f4050697e8bb80383e8dc ]

request_mem_region() will return NULL instead of error code
when the memory request fails. Therefore, we should check if
the return value is non-zero instead of less than zero. In
this way, this patch also fixes the build warnings:

arch/mips/lantiq/falcon/sysctrl.c:214:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  214 |                                 res_status.name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:216:47: error: ordered comparison of pointer with integer zero [-Werror=extra]
  216 |                                 res_ebu.name) < 0) ||
      |                                               ^
arch/mips/lantiq/falcon/sysctrl.c:219:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  219 |                                 res_sys[0].name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:222:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  222 |                                 res_sys[1].name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:225:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  225 |                                 res_sys[2].name) < 0))
      |

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Fix Nature

This commit fixes a **genuine logic error** in the error checking of
`request_mem_region()` calls. The function returns a pointer
(specifically `struct resource *`) on success and NULL on failure, not
an error code. The original code was incorrectly checking if the return
value was `< 0`, which is inappropriate for pointer comparisons.

## Specific Code Analysis

1. **Original broken code** (lines 213-225 in the diff):
   - Used `< 0` comparison with pointer return values
   - This is fundamentally wrong as `request_mem_region()` returns
     `struct resource *` or NULL
   - The broken check would never trigger because pointers are unsigned
     values

2. **Fixed code**:
   - Correctly checks for NULL by negating the return value
     (`!request_mem_region(...)`)
   - This properly detects when memory region requests fail

## Impact Assessment

1. **Functional Impact**: The bug could lead to the kernel continuing
   execution even when critical memory regions couldn't be reserved,
   potentially causing:
   - Resource conflicts
   - System instability on Lantiq Falcon MIPS platforms
   - Unpredictable behavior when accessing unreserved memory regions

2. **Build Impact**: The commit also fixes compiler warnings with
   `-Werror=extra`, which could break builds with strict warning
   settings

3. **Scope**: The fix is:
   - Small and contained (only changes error checking logic)
   - Architecture-specific (MIPS Lantiq Falcon)
   - Low risk of introducing regressions
   - Simple logical correction without algorithmic changes

## Stable Tree Criteria

This commit meets key stable tree requirements:
- **Fixes a real bug**: Incorrect error handling that could lead to
  system issues
- **Small change**: Only modifies the comparison logic, no structural
  changes
- **Clear fix**: The correction is obvious and verifiable
- **No new features**: Pure bug fix
- **Minimal risk**: The fix is straightforward and correct
- **Important for affected systems**: Lantiq Falcon platforms need
  proper resource management

The commit is an ideal candidate for stable backporting as it fixes a
clear programming error that affects system stability without
introducing complexity or risk.

 arch/mips/lantiq/falcon/sysctrl.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 1187729d8cbb..357543996ee6 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -214,19 +214,16 @@ void __init ltq_soc_init(void)
 	of_node_put(np_syseth);
 	of_node_put(np_sysgpe);
 
-	if ((request_mem_region(res_status.start, resource_size(&res_status),
-				res_status.name) < 0) ||
-		(request_mem_region(res_ebu.start, resource_size(&res_ebu),
-				res_ebu.name) < 0) ||
-		(request_mem_region(res_sys[0].start,
-				resource_size(&res_sys[0]),
-				res_sys[0].name) < 0) ||
-		(request_mem_region(res_sys[1].start,
-				resource_size(&res_sys[1]),
-				res_sys[1].name) < 0) ||
-		(request_mem_region(res_sys[2].start,
-				resource_size(&res_sys[2]),
-				res_sys[2].name) < 0))
+	if ((!request_mem_region(res_status.start, resource_size(&res_status),
+				 res_status.name)) ||
+	    (!request_mem_region(res_ebu.start, resource_size(&res_ebu),
+				 res_ebu.name)) ||
+	    (!request_mem_region(res_sys[0].start, resource_size(&res_sys[0]),
+				 res_sys[0].name)) ||
+	    (!request_mem_region(res_sys[1].start, resource_size(&res_sys[1]),
+				 res_sys[1].name)) ||
+	    (!request_mem_region(res_sys[2].start, resource_size(&res_sys[2]),
+				 res_sys[2].name)))
 		pr_err("Failed to request core resources");
 
 	status_membase = ioremap(res_status.start,
-- 
2.39.5

