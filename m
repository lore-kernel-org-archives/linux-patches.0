Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3161F30DEDC;
	Mon, 13 Oct 2025 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370120; cv=none; b=awIuHdTAq0J/y0R1eZJbM1oQ41DrX1YW5Z967NmN/p0edHUg2eiL8DLNEDhqf4gqk+kPtRW7GxXxr4wPR4VoDfP1qRXSp5LYLI2i8Amwv32tcC9c+axHuInqKiL+ila8k3FwZ37wHgivjR7GvO5ngU+SCL8pjhYL6PP8XrTZn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370120; c=relaxed/simple;
	bh=62Z4lJznNy/Sy+pbgOYzJhDLuEZ0RwYYRPFekwtEdRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCcxEm38wxf8aLgrZJNJ9Rfrknhi0TpI+MuX9inZAVi8D/+ILGsg8Jr/y9j4JmzPga/Dn0BC0n84Iy7M0PNvrgAV6Tbbp795XZaA6tkKU5b7p0eFtdAJEwyHs4FNvzi/5adijmpSDP0KN+iB4UaVkLKVNHb3EDFo6KaQ6kr6th0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gh6an74O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gh6an74O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C57C4CEE7;
	Mon, 13 Oct 2025 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370120;
	bh=62Z4lJznNy/Sy+pbgOYzJhDLuEZ0RwYYRPFekwtEdRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gh6an74OKKbOvrx6I0i/hwWjUSFNBbgW5lFzmmHqx/E60UYc30JarmiQU6lm0IU0w
	 IZ8buE7hkne2QWZ3FicAWpJJZmgfAVIijYWvrkHS8+TDPUGsmMeP2GRb7MQpZ3ctgM
	 9DAAULMcjXyJtQOiVGzdnz+tltaLSyziwZYwSJ9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 452/563] vhost: vringh: Fix copy_to_iter return value check
Date: Mon, 13 Oct 2025 16:45:13 +0200
Message-ID: <20251013144427.655674133@linuxfoundation.org>
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
index 9f27c3f6091b8..1778eff7ab006 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1161,6 +1161,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
+		size_t size;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
 				      len - total_translated, &translated,
@@ -1178,9 +1179,9 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 				      translated);
 		}
 
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



