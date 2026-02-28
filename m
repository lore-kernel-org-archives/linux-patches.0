Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39D035AC00
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302673; cv=none; b=R4CIpsSt/E0svaeCAqVvQKkCpWus+lGfqjwa/UQKuIs7wFwndlu2z5gCulABebAuhKUJPdT9Wa6xl9mrNiwE9TH6GTJnSUPqwj4tpa5Wr4A09rmvQruQeyXCNRwPHKaEa/uw5Ls3pF7SgMTYC3VFyZcR96Oolj2qMf0NtbKy5fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302673; c=relaxed/simple;
	bh=FfUHppN2aS9CzHXhDjZLuiSFkwQR2ELxDCGP6b1C/+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIWMcayPxitv3VqNJDO2y32kbb0gS++/iUw74APQHCNW0owSfAbtzD1eBjZKpoSw+owJT2H972m6JeoO5HpuMv+i2JWu1PlFm/+ixM6V8fCGUThUrLetBn8nM3LDy8QimjoyrMjk0zLDp7nCFsuHecDcw/csH08PKo6FdDKMv3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rYj5fYxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rYj5fYxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12504C19424;
	Sat, 28 Feb 2026 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302673;
	bh=FfUHppN2aS9CzHXhDjZLuiSFkwQR2ELxDCGP6b1C/+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYj5fYxXVXxj3PyPqp9KEeoS0hnZW1wsKtoVCTDpcf9ppI89XJk/hzs7vSEi4KYv0
	 oqD/Ge8XXhf5xx031TzIgWeP5gfGz1BNFtHRcL2gk24ToR3n8+tNvrGNw1KmGiuvkP
	 dRZGo7fA7Wm+MOt9xAOPSLEIqxQ/FX8SsUpV7oHIxRfClm1bHjYU5gKYAXruIHylop
	 psP1m+2YbeDlxwBRCNvDy9Q3A1f1UHoiXretXSMhvZxTwk6NItz3m3LnhFIxGtgFQh
	 A6VJYUZItBSqgDnxned4K5j/ZLlFc4GOUoq5eNNX/AiN6KKQMvl6blkT8OXtNCkcV6
	 01QmA9wvBWwaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Salah Triki <salah.triki@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/147] s390/cio: Fix device lifecycle handling in css_alloc_subchannel()
Date: Sat, 28 Feb 2026 13:15:30 -0500
Message-ID: <20260228181736.1605592-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit f65c75b0b9b5a390bc3beadcde0a6fbc3ad118f7 ]

`css_alloc_subchannel()` calls `device_initialize()` before setting up
the DMA masks. If `dma_set_coherent_mask()` or `dma_set_mask()` fails,
the error path frees the subchannel structure directly, bypassing
the device model reference counting.

Once `device_initialize()` has been called, the embedded struct device
must be released via `put_device()`, allowing the release callback to
free the container structure.

Fix the error path by dropping the initial device reference with
`put_device()` instead of calling `kfree()` directly.

This ensures correct device lifetime handling and avoids potential
use-after-free or double-free issues.

Fixes: e5dcf0025d7af ("s390/css: move subchannel lock allocation")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index cf2c3c4c590f9..e5e20ea850aad 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -241,7 +241,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	return sch;
 
 err:
-	kfree(sch);
+	put_device(&sch->dev);
 	return ERR_PTR(ret);
 }
 
-- 
2.51.0

