Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018A73446C0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301651; cv=none; b=hGKVL4ONwy9wDxE/9Zkt1PQErs+n1SsCGIfX3+RVMK1Gv/k8OWU9rQFpJLuDJm+Mhk17SpesBgCYsVXsYN1y2YZgynEypuHSlie3sXlnrpOScb/3CbqaiqR8Oap1a0nAsHsbkphFoT3c+b8kaavhYiLW1HySsh09/38O+1nY+IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301651; c=relaxed/simple;
	bh=yoJ7WeKGaTiJqVxHpKc45bDibvRBlhY+IGTN5l2RU0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXkViGzT17wa3qcm1qVAHtaS1l3zewJBLWn5cMDKs3xf52OPqBPvtze67IFgrCWgVExHFHFCTbKsv11gaN2Y/6bp2r5hmVkZLKyffbVzVegQ5YmW9GIzNXY9gwurTeIFKz75fBvxkJr97sFOd7QikNh84UxeLsV5NxK984AgRK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X83oFtt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X83oFtt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51977C116D0;
	Sat, 28 Feb 2026 18:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301650;
	bh=yoJ7WeKGaTiJqVxHpKc45bDibvRBlhY+IGTN5l2RU0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X83oFtt4mPJLVft9rXsY6dchIqr1D5aRma+R/6SlGaUEp7bg9EuHtLATylTlWSAPC
	 /N45qHKqBuY6wVIPw/xwGoL7USQ2rkCl9rEXx+AmPpxuFjC5dsfmzX4kb/1jPcxObY
	 WEIuYLKybYoGCf7XiOU2Pl7BvYvbPpksvXOv/09pQGz31/m3E5ojvxBHZX/3H0sCUK
	 noNAfFGfqE1HxijeFAmfd+RmzeTVijtLjXPqB7aOnrXt6SxT0E/z5pNxxo7voMvEC7
	 23adCCJ9GF6JTvtfkiNBiSMCOV1FoKzRFhhmRlc2gJI1Xsgg73H/rGymw5u3KdoAO3
	 G7XCUIetqV3Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Salah Triki <salah.triki@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/385] s390/cio: Fix device lifecycle handling in css_alloc_subchannel()
Date: Sat, 28 Feb 2026 12:54:29 -0500
Message-ID: <20260228180011.1568201-47-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 7b59d20bf7850..61be7c0550bc4 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -236,7 +236,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	return sch;
 
 err:
-	kfree(sch);
+	put_device(&sch->dev);
 	return ERR_PTR(ret);
 }
 
-- 
2.51.0

