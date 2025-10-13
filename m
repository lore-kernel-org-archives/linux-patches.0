Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F513064B7;
	Mon, 13 Oct 2025 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367290; cv=none; b=XuWzQjT6gorkRUv86tJMfy0auLxSfuwnwQgysU0OMrirbzvPlggIngwwIA+GgcApYRQAsZO63aWvxVYCUy4Bu6oxJ/bEcRnZmVizxXFaZl18GJqGlEy98CywY3xYSHHiJVP5IJcmhNpsGkclGrJMGgERNl2Bv0i3AHBbssItvOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367290; c=relaxed/simple;
	bh=u82e+pLHyakCKJnPPKFjW2M+6d5Cyk7oxIHdVoFLbko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIOXLsbNfTelIVGHBjzGuoReAXcvB/TPYeRAS0MlINbQsOmxNekuNUozgFAvJ1btoIvKQCrKbde6eFwitGJbCv25rPwGBMT9lVbaoh7msuMjKNpDD+ZgW74igxyKiI6+lQeqx5MbbUJZgbPX83LjHYkNtsF4TyI02a863xOU9O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKNC3iWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKNC3iWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35660C4CEFE;
	Mon, 13 Oct 2025 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367289;
	bh=u82e+pLHyakCKJnPPKFjW2M+6d5Cyk7oxIHdVoFLbko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKNC3iWzh2sAirnpPOoi+N7p0lM2JNEID5le+OIqqmkB7y37ZEcSoEhcqwJ7s1v28
	 5eKQG0bo8hGrQHkylhOST2gDHJ7qA+982TRhyQdfs7xpLkAfzpsHDKMHwWApEk92Yl
	 KaQT/nHZIeNL2FlXLOTVApCmBBhJNPIm1qh4Dj+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/196] vhost: vringh: Fix copy_to_iter return value check
Date: Mon, 13 Oct 2025 16:45:29 +0200
Message-ID: <20251013144320.343298393@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 439263376c2c4e126cac0d07e4987568de4eaba5 ]

The return value of copy_to_iter can't be negative, check whether the
copied length is equal to the requested length instead of checking for
negative values.

Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/all/20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 309bba39c945 ("vringh: iterate on iotlb_translate to handle large translations")
Link: https://patch.msgid.link/cd637504a6e3967954a9e80fc1b75e8c0978087b.1758723310.git.mst@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 10bfc5f1c50d5..c570d214d5b68 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1195,6 +1195,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
 				      len - total_translated, &translated,
@@ -1206,9 +1207,9 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 
 		iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
 
-		ret = copy_to_iter(src, translated, &iter);
-		if (ret < 0)
-			return ret;
+		size = copy_to_iter(src, translated, &iter);
+		if (size != translated)
+			return -EFAULT;
 
 		src += translated;
 		dst += translated;
-- 
2.51.0



