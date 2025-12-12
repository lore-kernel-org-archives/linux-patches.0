Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9630E0D2;
	Fri, 12 Dec 2025 06:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765519961; cv=none; b=t095qjhmz4Lzs6CgxPvcnt6yBJ2J8bWfAT+IaeJ8UlgmWM4GPvQQ4wQh9h9hkLPwuR+Ywiyv8hLMAwidaaWPHagJyBlXb7QVZpUq0QvAeCdHo6zNz0zchb2RgPF1NHriYGJBRYonFtnUQdHHNbcNIqmLzCLuOFixKawoHynwl5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765519961; c=relaxed/simple;
	bh=ljan1ta1tpReQppEriQNMwsDTnAwg7mPLf4iQytvmyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CSRoBYL2Q/d5V79YA+jKIhIrI0dLk8Vhd2gZtxFPofiqF61TktTsSflTY7BmqFiUmp7S2roH2PU/Tt43oWFeZRkZsOh5259OiCbCLx/1EC54TeBneMdEMhUKDxAVxZMG80paAQQIwXhNE16HRQcLHfIQEEG7paWtdRrOyyScyXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+thnrQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+thnrQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B628C116B1;
	Fri, 12 Dec 2025 06:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765519961;
	bh=ljan1ta1tpReQppEriQNMwsDTnAwg7mPLf4iQytvmyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+thnrQ9LKiG3xUWRcqLYyDZJIx4aCqSGAzMwFc0BwVfha5IiQDarAs/dlzg5jQhW
	 aqi3NHIneWgKvRWkMhoX6A2hClvpA+EnFjymnLFhPjI6XDZrenN0yeiudiRO408wq7
	 I+kcYqzxL0eVEONhDpRCYcxCBoGMgvkInQgHdPq1dqENREMqZjuO0Ls67TyHTLyVCL
	 WAYBjyywkvSBtk4ef8CoQ+WDqV8bxW1//xAKpUnS7oYWZRiqLieozDwg4z6qhbKitF
	 zSC/VPwmBGaFDvZnVXuxCqFCBnBG5tq/bc4FX4CMhMrfbJ/sz13uhbUsX2An7YxW/H
	 z/VNGRiQlggDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Guangwu Zhang <guazhang@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.17] dm-verity: disable recursive forward error correction
Date: Fri, 12 Dec 2025 01:12:15 -0500
Message-ID: <20251212061223.305139-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212061223.305139-1-sashal@kernel.org>
References: <20251212061223.305139-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit d9f3e47d3fae0c101d9094bc956ed24e7a0ee801 ]

There are two problems with the recursive correction:

1. It may cause denial-of-service. In fec_read_bufs, there is a loop that
has 253 iterations. For each iteration, we may call verity_hash_for_block
recursively. There is a limit of 4 nested recursions - that means that
there may be at most 253^4 (4 billion) iterations. Red Hat QE team
actually created an image that pushes dm-verity to this limit - and this
image just makes the udev-worker process get stuck in the 'D' state.

2. It doesn't work. In fec_read_bufs we store data into the variable
"fio->bufs", but fio bufs is shared between recursive invocations, if
"verity_hash_for_block" invoked correction recursively, it would
overwrite partially filled fio->bufs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary and Recommendation

### What Problem This Commit Solves

This commit fixes **two critical bugs** in dm-verity's Forward Error
Correction (FEC):

1. **Denial-of-Service vulnerability**: The recursive FEC allows 4
   levels of nesting with 253 iterations per level, resulting in up to
   253^4 (~4 billion) potential iterations. Red Hat QE demonstrated this
   causes the `udev-worker` process to hang in uninterruptible 'D'
   state.

2. **Data corruption bug**: The `fio->bufs` buffer is shared across all
   recursion levels. When `verity_hash_for_block` triggers nested FEC
   correction, it corrupts partially-filled buffers from outer levels.
   The recursive FEC feature fundamentally doesn't work.

### Stable Kernel Criteria Assessment

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ YES - Simple condition change that completely
disables broken recursion |
| Fixes real bug | ✅ YES - DoS and data corruption, reproducible by Red
Hat QE |
| Important issue | ✅ YES - System hang (DoS), affects
Android/Chromebook verified boot |
| Small and contained | ✅ YES - ~20 lines across 3 files, removes code
rather than adding |
| No new features | ✅ YES - Removes broken functionality |

### Risk vs Benefit Analysis

**Benefits:**
- Eliminates a system-hang DoS vulnerability
- Fixes a data corruption bug in FEC recovery
- Affects widely-deployed dm-verity users (Android, Chromebooks,
  verified boot systems)
- Conservative fix - disables broken feature rather than complex repair

**Risks:**
- Minimal - the recursive FEC was fundamentally broken anyway
- Version bump (1.12→1.13) is cosmetic; documents behavioral change
- Theoretical: some error correction scenarios may not work, but they
  were already broken

### Additional Considerations

- **Reviewers**: Sami Tolvanen (Google) and Eric Biggers (kernel crypto
  expert) - strong vetting
- **Author**: Mikulas Patocka, dm subsystem maintainer
- **Bug origin**: FEC feature added in 2015 (commit a739ff3f543af), so
  affects all current LTS kernels
- **Dependencies**: Self-contained, should apply cleanly to stable trees
- **No explicit `Cc: stable`**: But severity and fix quality strongly
  support backporting

### Conclusion

This is an excellent stable candidate. It fixes a proven DoS
vulnerability and data corruption bug in security-critical dm-verity
infrastructure. The fix is minimal, conservative (disables rather than
patches), well-reviewed by domain experts, and authored by the subsystem
maintainer. The affected FEC recursion feature was broken since
introduction, so removing it has no practical downside. The user impact
is high given dm-verity's deployment in Android and other verified boot
systems.

**YES**

 drivers/md/dm-verity-fec.c    | 4 +---
 drivers/md/dm-verity-fec.h    | 3 ---
 drivers/md/dm-verity-target.c | 2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 72047b47a7a0a..e41bde1d3b15b 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -413,10 +413,8 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	if (!verity_fec_is_enabled(v))
 		return -EOPNOTSUPP;
 
-	if (fio->level >= DM_VERITY_FEC_MAX_RECURSION) {
-		DMWARN_LIMIT("%s: FEC: recursion too deep", v->data_dev->name);
+	if (fio->level)
 		return -EIO;
-	}
 
 	fio->level++;
 
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 09123a6129538..ec37e607cb3f0 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -23,9 +23,6 @@
 #define DM_VERITY_FEC_BUF_MAX \
 	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
 
-/* maximum recursion level for verity_fec_decode */
-#define DM_VERITY_FEC_MAX_RECURSION	4
-
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
 #define DM_VERITY_OPT_FEC_START		"fec_start"
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 66a00a8ccb398..c8695c079cfe0 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1690,7 +1690,7 @@ static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
-	.version	= {1, 12, 0},
+	.version	= {1, 13, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
-- 
2.51.0

