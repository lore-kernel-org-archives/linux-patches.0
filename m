Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A727482C60;
	Tue, 29 Apr 2025 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946358; cv=none; b=LEkIvOE9TQhFBFTasRbHnhbM1kzCJRgft9WG91atwP7x0hk7XCr5E6zZGoe1WlbFdo87RbQV2XVhk1LiKz6CB09/iMmaRlARnOwcJDAYb9ltKCxLBHUqN1VvVnwczR13Td+dUh0c8G4YIqQe8diB9yKFoWYjaRlQpGoUp1scfgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946358; c=relaxed/simple;
	bh=dg0wesRzJkaofzKBB2bBehAUBCZH/5T4wlAu2ZJCEOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEZqFtSqLlwfqx8tpShjxeeFNPNUpr/nFPOCKmubDOF/hJK/tw63qlgeU64GwMiBd5dCxPlX5eHI5HX/M53ISYvUAH5a7EgyOmJU5SypptDNkeDDY0fxr4VppfqFEcCCqZDJ/+YG75TzzrT5mFK6CVei7TWsBJjUWsgxe76RHco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H43zsepB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H43zsepB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20133C4CEE3;
	Tue, 29 Apr 2025 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946358;
	bh=dg0wesRzJkaofzKBB2bBehAUBCZH/5T4wlAu2ZJCEOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H43zsepBboy4W0Bun42k5Lhm80rb/uvMdWlU4GNzpupKQRhnLcr7xALGX/9CDx1tu
	 RMwMml9O5hYqcGWEl7zivJMsG1WFUmuOjiE61Bq2t2Bmw7fiCleOXSEyc7kSHUCrKE
	 FzkdpbvJkJH/eKmsN+dGBWvCCE2U/vXEMDgBAJW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 240/311] udmabuf: fix a buf size overflow issue during udmabuf creation
Date: Tue, 29 Apr 2025 18:41:17 +0200
Message-ID: <20250429161130.853699752@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index cc7398cc17d67..e74e36a8ecda2 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -393,7 +393,7 @@ static long udmabuf_create(struct miscdevice *device,
 	if (!ubuf)
 		return -ENOMEM;
 
-	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
+	pglimit = ((u64)size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		pgoff_t subpgcnt;
 
-- 
2.39.5



