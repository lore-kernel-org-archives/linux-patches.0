Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168BA1E9B0D;
	Mon, 13 Oct 2025 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367330; cv=none; b=q1dP2Y3FG7HpRyj38wSPkUqg7CVc7oBsYmW/gLFcVzb51fLKM7DRhqy2yKJJI53gtK5qdZQfkyXnP6xXBDdYdlkILEQ2RfadUkm1Tw2SYpZrZmeu3UfNyDlG/hh0oMKsU6GphgRMvM8zunVDuO+KKE2498hRgM9mf1fc8lhc9Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367330; c=relaxed/simple;
	bh=yE2ahAN22Je5YlmOhd/A0jKNx+xf0cTB2sVTIM4x0xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juj8GEtVmDdK52nq7M4qv9M4I4m4x4LGcbdH76qADG2SFR5/ENSbnday2Xi3esPboC7pliG9a3zHWXgNDiRTtqzL1ETnorXL9wrulcIV2V29PkPsKjv0WOV2Yh7qyCvdTBaEeH/LgDoQ559x2X7xDhJ4l6IYyhFPZzs+sExn3Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwKrCbg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwKrCbg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91071C4CEE7;
	Mon, 13 Oct 2025 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367330;
	bh=yE2ahAN22Je5YlmOhd/A0jKNx+xf0cTB2sVTIM4x0xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwKrCbg3qe4BsHUhYw+7ObECqUVAmn3yZKuxHzkqZyJ1P/p90s8lZOkxojRzWiwxD
	 1NzXpk9xpE69ZiP2JQeu3GYB/AMfK/vT88ZwMCz2CIQ3Y0/3JsyIxsXNvS4hVHMNRK
	 B++mjlouw0RjrUJMWJ6IvpqcWnzu/1VkWM0WENus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stefano Garzarella" <sgarzare@redhat.com>,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/196] vhost: vringh: Modify the return value check
Date: Mon, 13 Oct 2025 16:45:45 +0200
Message-ID: <20251013144320.918671169@linuxfoundation.org>
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

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 82a8d0fda55b35361ee7f35b54fa2b66d7847d2b ]

The return value of copy_from_iter and copy_to_iter can't be negative,
check whether the copied lengths are equal.

Fixes: 309bba39c945 ("vringh: iterate on iotlb_translate to handle large translations")
Cc: "Stefano Garzarella" <sgarzare@redhat.com>
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Message-Id: <20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index c570d214d5b68..d89c2bce94cbf 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1162,6 +1162,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
 				      len - total_translated, &translated,
@@ -1173,9 +1174,9 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 
 		iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
 
-		ret = copy_from_iter(dst, translated, &iter);
-		if (ret < 0)
-			return ret;
+		size = copy_from_iter(dst, translated, &iter);
+		if (size != translated)
+			return -EFAULT;
 
 		src += translated;
 		dst += translated;
-- 
2.51.0



