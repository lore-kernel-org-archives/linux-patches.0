Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8424A1F1313;
	Mon, 13 Oct 2025 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368612; cv=none; b=IqUNiTCgihEeHTzeKTrpfWioCWmIzORK8kdClN89WJMGOGVE3a6mlwhbK5gjUarkIUoLeD5+23rxcPnPOt0s5IAnollEuCtdy0iZ4lj4oF4KK4gI8VI9w6thYjB/qEqygoe/oFhyzTEfGyD11vugtdRLlZQ161rYffPNNggNH9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368612; c=relaxed/simple;
	bh=ihIb1d3M8qT/oCM3pQVvM40GTuMRfZj8WYdOzbAayDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJY1WkXNhVDgZmKYz7/IfBiDS1ASRc08lJYaHsQNZYXk3lQ2z0iG7gFQsQCuw3l1vdliV9XxtKdZmhpPUCj3tP0p6JMHvKuFry+8cjtfyHApfagDiUXFkg5eezbwWaPdPV69esc42v2Ei9wRzUO8uoqoT1rS0DZzkD5Zq4njJ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUozcsr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUozcsr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C929C4CEE7;
	Mon, 13 Oct 2025 15:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368612;
	bh=ihIb1d3M8qT/oCM3pQVvM40GTuMRfZj8WYdOzbAayDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUozcsr9gIozv9MAp7d4tBPNyZtH7LpQclqF8OIBaWVblyUrM0oVsdJ4YiCkPfPp5
	 PqJuFbu7QObnt+oN7U/40Tt2PfCgkon1FB+L9bd/gFqQpazvRHwP0/SD0GYiBvcrRr
	 N5LdaIY7TYjZJfbqcGs3bx3QVEzh+Hg62DwDQHcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stefano Garzarella" <sgarzare@redhat.com>,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/262] vhost: vringh: Modify the return value check
Date: Mon, 13 Oct 2025 16:46:04 +0200
Message-ID: <20251013144334.238194052@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0db4f3babe961..781731eb95cfe 100644
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



