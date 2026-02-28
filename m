Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C79F39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302520; cv=none; b=kwtPdmqYMEAB3I9o03bsAY/asGCxta+NHIQ+qZbaTF5fsjyL5MdxDi8SQu+62pGcn2Qcjj/5KgWOvVcNMtyg7b6CWDqAK0aeTqTW+6VbnwFFSnSJHWoQqPiwfkkBCAsYnbUkRJaPXflI7WRIlSZA61jD9XM6F6LEpjKFIgJw098=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302520; c=relaxed/simple;
	bh=7HS2Ok7LSxvzbFwSjKGKt9KtMhNHjvooaHRFdMiA1zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE0XZ2bzelk9sAwAZO/vukKXNa01PYGF4/zdY1+AXbVA33omV4HcjT+Ct46ab3WpY9chsHvhdSz3v7qU7lC19QHj03anGQo+izMY9w/F4jCp87Dj2nfhbcnDRaGQIAbjeNzX8k8ow07Mpsa1L3kuIktAp6AI69danJeQFjG+CEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FiNm3o0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiNm3o0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A44BC116D0;
	Sat, 28 Feb 2026 18:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302519;
	bh=7HS2Ok7LSxvzbFwSjKGKt9KtMhNHjvooaHRFdMiA1zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiNm3o0Swg+ipzvwPvncnLqpy3Cr45fQi+mE0M0uQK5vwiaCPLLnjKupSsctXpSRt
	 dDRr1sdF8mFI+CrfY340qun8bgjDSo5oxpvxFiww0Rzw1PaaXpnq78JSaZEeCVH4cA
	 DrCohRHfdzFCuqioP9x/ygQV3/fFV3FCPODqeiKLUYjMdabwPH6Sajoj44uEvuS1Rg
	 zcV2ygF4SLKAt8qTeL6CxYwnYH+MZQmZ4vfO9Q8i36li8HsE89eKhji1DJaI9apyig
	 PtiflF9dfZHWSbgEoCvNMkdvO9svD4cGy+X+2tP+DA+1uy6Fd3kRpAf2up3LbkfK2c
	 CY4fRVUFUahRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Salah Triki <salah.triki@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/164] s390/cio: Fix device lifecycle handling in css_alloc_subchannel()
Date: Sat, 28 Feb 2026 13:12:36 -0500
Message-ID: <20260228181505.1600663-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 3c499136af657..4c3fde0bd5512 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -247,7 +247,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 err_lock:
 	kfree(sch->lock);
 err:
-	kfree(sch);
+	put_device(&sch->dev);
 	return ERR_PTR(ret);
 }
 
-- 
2.51.0

