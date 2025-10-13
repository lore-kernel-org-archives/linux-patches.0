Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138603090CB;
	Mon, 13 Oct 2025 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370217; cv=none; b=Z0xbSDkCoIcotmQjinK8oMSlPPgAgBAAWg3UDw+XVvFKmoj9+cK0CGJzhy/oMM2qzVC6Gry0OdckubhNZ36BlSed3nSEafr2UKaI7V/17M5D6b13cSxERU5IGeLMgCIeHc651L34yo0FKkTB0NZYytxHqKrImurI84vn5gBJZq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370217; c=relaxed/simple;
	bh=/HhLSqk1j56uD5CrwIdxs7SwvXxulaZmDSlnmrQAaaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxDg+15GoJnLZTIu7nYYUnAsNIjZU5EL2s+18annAQ2ibirC/y00m1F1FEWa/Wl2TazQ/lZpiRDm9Ov4bwpUPF9yEmQk4jxAEsQXXygpuvYWRZMfOU2cuiZF/N2kztUxtwqwEoBJ8DdTdCfjpHVyRA02gYNz+ZLoUbtS35n6tFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X58O/QBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X58O/QBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0B9C4CEE7;
	Mon, 13 Oct 2025 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370216;
	bh=/HhLSqk1j56uD5CrwIdxs7SwvXxulaZmDSlnmrQAaaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X58O/QBi9TRY1U0K23VpbGUOy8j5nsLPxI1/5Fo58qhCy87qqyPxiKM6CZPHKCaEE
	 Ggmsb7orF4+rm1eHS3hznDhxDvAoTQjHkPUBHFjWsK96yNFqB9yEa7JoP+mfzTlvVg
	 EmxCIA3hvy8/S+oNm6ku/q503vU/YGiixjRjEPw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stefano Garzarella" <sgarzare@redhat.com>,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 487/563] vhost: vringh: Modify the return value check
Date: Mon, 13 Oct 2025 16:45:48 +0200
Message-ID: <20251013144428.935149533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1778eff7ab006..925858cc60964 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1115,6 +1115,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
 				      len - total_translated, &translated,
@@ -1132,9 +1133,9 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				      translated);
 		}
 
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



