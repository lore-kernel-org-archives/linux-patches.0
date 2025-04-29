Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8E2155A4E;
	Tue, 29 Apr 2025 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950627; cv=none; b=cf0fsWFKVVui43F5mDy6WhTY1buXR09fJ1I88jrmz3Gw3pFhTUzxmDt8dpPsZNCZkxkEZhS0afxHqPPZvUhcuFsBpBse/3PJ6xn23V3CjcmDCN58tO6zEnlf6z7n47InsTVXIRWj4k8q/gESrwdVCsHMhYpSoFp2iyKDjM3zeUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950627; c=relaxed/simple;
	bh=6JFQocfNGQgnJkyZIOAs/qk7amQLFPN7vQ59sR1WdlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pzeF9V6lu8YycZBXft6I14kv/Pw4pdXaEfqQlcROKdgyb1UQ9judnevmIzTXOu0zObiD3m/kEf8aFpWzp/ld8nAJS/pw6utV0YKzS4FNir8YAv+Sf6jkXC0ZRgPKFV9XVpvzxaegZqhyxkf/nZgx7u8iSZ1H8Z0WKhg/qADJcT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeKVblVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeKVblVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6EEC4CEE3;
	Tue, 29 Apr 2025 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950627;
	bh=6JFQocfNGQgnJkyZIOAs/qk7amQLFPN7vQ59sR1WdlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeKVblVvW0oLV6BIDYaSh2Ksj5/FnCRCF//3y+XNywPVnt+gKNo+lBZNBLTF+jS2S
	 49qx9yQYedtC4mFjjZoPpGPBarN+iNT+jCTKFTUroL4u0KUtuchUrhLEye+7h4jrMd
	 GHeadxj/nuNvVpihzYMKltisrb9PYK/7XYAYA5s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/204] udmabuf: fix a buf size overflow issue during udmabuf creation
Date: Tue, 29 Apr 2025 18:44:03 +0200
Message-ID: <20250429161105.759897550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d1fcdd1f9aaed..373282beeb606 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -214,7 +214,7 @@ static long udmabuf_create(struct miscdevice *device,
 	if (!ubuf)
 		return -ENOMEM;
 
-	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
+	pglimit = ((u64)size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
 			goto err;
-- 
2.39.5



