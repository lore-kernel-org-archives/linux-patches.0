Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336873502B9;
	Tue, 23 Dec 2025 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766484327; cv=none; b=S/vnsC/s3yy3Z2ZX3hK7+Pi9KrlQc7uT2fs/P29V1h71u7IaL+WewiwUjR4h/JgdzqrVPdtD6Vv/DQoiEELxOFizQsmSKjKq7lfs6FKzFsbT3bNM14cvSImlqkyPrFPQBxseICnCdYzFvRQdLTDX0urU0i+cJ802gGJgO++djhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766484327; c=relaxed/simple;
	bh=ddQ4P35GJ65fx1phlIRY6geJ4UujdLlbIP6/qv+iUsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VlZfbL6lvs0eOg+vzBYXAiJmWdOTIiI3aKYWYRsLks/I5U9b53+SPARM2HJW7A6Q8YcaLhUwG8tdlPmRM+0OoaSG0qOLgH3HsZ6pFjImFf7dRMdNNPiiVjSoAUKF8vY+pdNShpRHfbC9Hnmf3S5ChpxAuAYZHgBd5Fhq9mAJQZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hbt7u+zP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hbt7u+zP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D534AC16AAE;
	Tue, 23 Dec 2025 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484326;
	bh=ddQ4P35GJ65fx1phlIRY6geJ4UujdLlbIP6/qv+iUsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hbt7u+zPupAG5jcdaNAkQeWzPuyZEzDlio6UJw5q1tiO22mNq8jF/561nJftqLBWI
	 BBDyNn6EJvUX2nu6SHGjRlWF9WFWMp+tnzOEIMggWMp+vcIUrxVX4SlbASBS78c4lT
	 wf54uSHev0oqJ/e5LQpJAIIEhYYEz09UXSV6zyjo5oI2J1v1azR/morInAFfgfauyt
	 938sYYlKlcl45+F/BqxmW29FEUkDUTl2RdKHhYEKqyhvjuppg/FfuW35o53248+Rl0
	 4ciI2PCC5+X4+iNeKjm0NeSiKsslmfHWW+KNR39gKNfYD6CkYXazC+l1Ae9VljszET
	 +mOmTXFl/uQsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] block: validate pi_offset integrity limit
Date: Tue, 23 Dec 2025 05:05:10 -0500
Message-ID: <20251223100518.2383364-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251223100518.2383364-1-sashal@kernel.org>
References: <20251223100518.2383364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit ccb8a3c08adf8121e2afb8e704f007ce99324d79 ]

The PI tuple must be contained within the metadata value, so validate
that pi_offset + pi_tuple_size <= metadata_size. This guards against
block drivers that report invalid pi_offset values.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary

### Problem Being Fixed
The commit fixes an **incomplete bounds validation bug** in the block
layer's integrity limit validation code. When the PI (Protection
Information) tuple can be placed at a non-zero offset within the
metadata buffer (a feature added in kernel 6.9), the validation check
only verified that `pi_tuple_size <= metadata_size`, but **completely
ignored the pi_offset**.

This is mathematically incorrect. If:
- `metadata_size = 8` bytes
- `pi_tuple_size = 8` bytes
- `pi_offset = 4` bytes

The old check (`8 > 8`) passes, but the PI tuple would extend 4 bytes
beyond the buffer boundary, potentially causing out-of-bounds memory
access.

### Why It Matters to Stable Users
- **Data Integrity Risk**: Block layer integrity/PI is used in
  enterprise storage environments (NVMe, SAS with T10 PI)
- **Defense Against Buggy Drivers**: The fix prevents the kernel from
  accepting invalid configurations from misbehaving block drivers
- **Potential for Memory Corruption**: Without this validation,
  accessing PI data could read/write beyond buffer bounds

### Stable Kernel Criteria Assessment

| Criterion | Met? | Notes |
|-----------|------|-------|
| Obviously correct | ✅ | Mathematical correctness: offset + size must
fit in buffer |
| Fixes real bug | ✅ | Incomplete bounds check could allow invalid
configurations |
| Small scope | ✅ | 4 lines changed, single file |
| No new features | ✅ | Only strengthens existing validation |
| No API changes | ✅ | No user-visible changes |

### Risk vs Benefit

**Risk**: Extremely low
- The change only makes validation stricter
- Can only reject configurations that were previously (incorrectly)
  accepted
- Any configuration rejected by the new check was already semantically
  invalid and potentially dangerous

**Benefit**: Moderate to high
- Prevents kernel from accepting invalid integrity configurations
- Guards against memory corruption in PI-enabled storage stacks
- Important for enterprise environments using DIF/PI

### Concerns

**Applicability**: The `pi_offset` field was introduced in kernel 6.9
(commit 60d21aac52e2). This fix is only applicable to stable kernels
6.9.y and later.

**Dependencies**: None - this is a standalone validation fix.

### Quality Indicators
- Reviewed-by: Christoph Hellwig (highly respected kernel developer)
- Signed-off-by: Jens Axboe (block layer maintainer)
- Part of a series of validation improvements (similar commit for
  `interval_exp`)
- No follow-up fixes needed

The fix is small, surgical, obviously correct, and addresses a real
validation gap that could lead to memory safety issues. It meets all
stable kernel criteria.

**YES**

 block/blk-settings.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d74b13ec8e54..f2c1940fe6f1 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -148,10 +148,9 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 		return -EINVAL;
 	}
 
-	if (bi->pi_tuple_size > bi->metadata_size) {
-		pr_warn("pi_tuple_size (%u) exceeds metadata_size (%u)\n",
-			 bi->pi_tuple_size,
-			 bi->metadata_size);
+	if (bi->pi_offset + bi->pi_tuple_size > bi->metadata_size) {
+		pr_warn("pi_offset (%u) + pi_tuple_size (%u) exceeds metadata_size (%u)\n",
+			bi->pi_offset, bi->pi_tuple_size, bi->metadata_size);
 		return -EINVAL;
 	}
 
-- 
2.51.0

