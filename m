Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A36271473;
	Mon, 13 Oct 2025 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367891; cv=none; b=hU4+7I0186/q7UCfWILyzw19w/+dfSm0QOyYxPmaHWrXXcfmb3oRwOwJUD6pLkAdVWFln2O6BsXgSgrHmpSDy6BWFciZy2D+qMRAeXKFcrTIEcSEX+F0yg6rFd3OWRSirqNo+M8pd0Cdmx0I/wJ6WH6/NGoMydA5/7QPi3PKtOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367891; c=relaxed/simple;
	bh=pi5/Y0Drbw02GRsbMgh3g7RqAQ6YtyTXveGYhJRDv8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFbxXxdkEvQbktWXhjPEiglNLCbuQNZnOZqCDlD9pQTXkLfsiX4IXEuQaN5a4O/uYgIh/gVEaK7QgjFrq7/KJk86QcVBC2irRjbvrcVOXFzI72ZdA/Xc3kbTflvCRxdgWTJZcw/LUKH839eDXeL0Be5TdQ6c2X0bqCkJVOkYfuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzZg/A9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzZg/A9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE0DC4CEE7;
	Mon, 13 Oct 2025 15:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367890;
	bh=pi5/Y0Drbw02GRsbMgh3g7RqAQ6YtyTXveGYhJRDv8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzZg/A9nqTlKLOTDnjvfSwdo1Na/wJQuwCmfJB5lxRfxNUvOsFn/fte26v6TdewT4
	 +aA1Am2eZhOAj8srEOkU693In7G0LK7PusXpQP1DfkbsIvmFJ5o9dvQAQ46Q5EkDLF
	 gw9F8MXZZHL2Q/B9aRzWriDYk3hh3nsAP1PDR+E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stefano Garzarella" <sgarzare@redhat.com>,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/196] vhost: vringh: Modify the return value check
Date: Mon, 13 Oct 2025 16:45:58 +0200
Message-ID: <20251013144321.351481908@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60961c65fd472..134cc10af776b 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1191,6 +1191,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
 				      len - total_translated, &translated,
@@ -1208,9 +1209,9 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
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



