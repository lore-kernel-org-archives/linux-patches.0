Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00A055409D;
	Wed,  9 Sep 2026 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962712; cv=none; b=ie4KL4BwCRMEXmU7Dk32UOjn9MW36bnrHlDz7P2d/DGbN0283oYWva7oo6fkoIebr0+BL9tbx5iTYTtM53w6eXrhbPR8/nqn/yGj2GUNolKL7XvZHUiVyFWDB7H0byrrTCRlc3j32RAfoYaY9ZsYwZtpy6S/ybdbazJUFTnt7+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962712; c=relaxed/simple;
	bh=X20hsZvJHTZP6ZtN/a9cxq9MIQ92Qbx+3NJw2qVZrEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7nKyxUztYkiofqYVl2asWLkUuiE91bDyXKe6vALP5oilMhSQPpyseCTIDGmTIf5cLbHA4Uknb5vZX9v0fm7nylwvvNAsK4W+6zYzay56YPWATimxnW1+wWJziPBGSQ6y/09eVOcozr3HzuKVDRIMawtw9J2lzk0vGsA/v5cvbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buuE6CMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buuE6CMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2991F00A3A;
	Wed,  9 Sep 2026 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962711;
	bh=2KJcuEAvlvJBh4OyY5onUbb94CW81gxRKQXBi6DPrsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buuE6CMiadtXn5PDsMvblY002ccFwb7W+otQv2xl8vVfLyvaV1YJbcQOKavk+yebm
	 qL7XnNa7tdsY5SCWkB5vUovcS5LwMEPv+yUfur+RRyfrkOQ/j5Ere+7h3k7r/APoZ2
	 IopchWu6VKkkk3iTK00JWdVQ4skTNa8MnsJ0798Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Linus Walleij <linusw@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 383/556] media: mali-c55: Fix scaler factor overflow for large crop sizes
Date: Wed,  9 Sep 2026 15:41:03 +0200
Message-ID: <20260909134244.150669024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 2447c768cb5dfb9f52630b82d419e2b24fee27a3 upstream.

The horizontal and vertical scaling factors multiply the crop dimensions
by MALI_C55_RSZ_SCALER_FACTOR, a Q4.20 factor of (1 << 20). Both operands
are 32-bit, so the multiplication wraps before the result is stored in
the u64 scale variables. For any crop dimension of 4096 or more (the
maximum is 8192) the value overflows; an 8192 to 4096 downscale yields a
TINC of zero, so the scaler never advances and the output is corrupted.

Define MALI_C55_RSZ_SCALER_FACTOR as a 64-bit constant so the
multiplication is performed in 64-bit.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-resizer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-resizer.c b/drivers/media/platform/arm/mali-c55/mali-c55-resizer.c
index c4f46651dcee..6706939b4a90 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-resizer.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-resizer.c
@@ -15,7 +15,7 @@
 #include "mali-c55-registers.h"
 
 /* Scaling factor in Q4.20 format. */
-#define MALI_C55_RSZ_SCALER_FACTOR	(1U << 20)
+#define MALI_C55_RSZ_SCALER_FACTOR	BIT_ULL(20)
 
 #define MALI_C55_RSZ_COEFS_BANKS	8
 #define MALI_C55_RSZ_COEFS_ENTRIES	64
-- 
2.55.0



