Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740A8250C02;
	Tue, 29 Apr 2025 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945610; cv=none; b=ZGqHSLOFfWVxchZQTK95oO/raWfC2JYSIG20eajot/blYcrFHG16UMx+FTvv/V2BnU5wrUI6nAHm+sDqEvXy+qjnA5615GnoUwSPSADjHWF3lPDejDuVanRqRIFRxBDU5giB6ovzgvBK9SctvSgPxBnSLZifUDTriGvenDr6sWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945610; c=relaxed/simple;
	bh=roFMgTDoQBm5QlgSPAhZ1ZCOvIZcYWCpJBemWPUD+z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8QdDkPyRoPeWqYGmtp0ybys6iL/nyjq29157R8LxgoWW8V5sVCXjspxOl+KmZLvdRM5rYdpM0OBlQW2VEd5ieTqX4qbVBroYTwjVWVdwGF6+LInfCazEqi94yeh8PLf8LdxTSJnjL+H+onEM7PAJsg97ZXGhpa9qUfptEaFjy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huE0BE6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huE0BE6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7989C4CEE3;
	Tue, 29 Apr 2025 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945610;
	bh=roFMgTDoQBm5QlgSPAhZ1ZCOvIZcYWCpJBemWPUD+z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huE0BE6Mhc7RsdWpLgvT8dmmcekYRewWy1WWRKVkNwxx8RBAxO0AMGZGi0GPRWLJz
	 Ws1nz0ZjS38AXQti0p7jPux0NEU26v68Iddn0Nmad21UVMSg5frwp59iR6wgGgDvRu
	 fAo8cdEDFjtIFL4YAVnGXdajnfOU7OQm+ffUSlGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/179] udmabuf: fix a buf size overflow issue during udmabuf creation
Date: Tue, 29 Apr 2025 18:41:51 +0200
Message-ID: <20250429161056.276685818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 021ba7f1babd029e714d13a6bf2571b08af96d0f ]

by casting size_limit_mb to u64  when calculate pglimit.

Signed-off-by: Xiaogang Chen<Xiaogang.Chen@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250321164126.329638-1-xiaogang.chen@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index ae42e98cf8350..dfb572282097b 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -138,7 +138,7 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 	if (!ubuf)
 		return -ENOMEM;
 
-	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
+	pglimit = ((u64)size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
 			goto err;
-- 
2.39.5



