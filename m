Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881932528ED;
	Tue, 29 Apr 2025 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950089; cv=none; b=KGKCgX8EvEfkHEmfBq3YVq68V7AE/9tDcpONOiIajOa3p2h+cvYRywBfRbyA8AxGXcEWl7+vVQVwUe5vdMw3K0wfilBi6mu+Zl+4he9MIwQ+NFlrHn4HU5lWNOCVxaS0A79yn9dGSMmAa1Ms4PmIz//psZBkwMhI2jP8OWWDsHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950089; c=relaxed/simple;
	bh=cittUK7G9jMsPDX9/wtIYccY8cycqbRl0/ak7TajJm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTA9AgJXdNX/qx+lYAw7x+WNhzo18/pbGPvvbqpRtNESy5yxYUbbmnmKLLYUHrPHdWpa9FvWyWtgNOlX7WXQOtx1IRjiduqt2c75VEUjas2wGTca/LVLkS8DA5rgvHSXqbtpwwdPRlCLEFD04+VSDIVY58MgycBcbRHvu/U2ikQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7V9/zb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7V9/zb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1025C4CEE3;
	Tue, 29 Apr 2025 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950089;
	bh=cittUK7G9jMsPDX9/wtIYccY8cycqbRl0/ak7TajJm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7V9/zb4H3PPO1X+wYlzxY8unCK+/EBlzPwboDaOE+diXiYEkLl/awot0uYmIrRx5
	 vOmu/FFcXjuGH1Mu8i51N2I9r2lHEKJ5u+ASCrvcNzZL3nHVDdYGjNI+qb5hEpbKTS
	 ZtrFuQlkTRvZhQruKRCLJs73U3E76O0X1PWAXwC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/167] udmabuf: fix a buf size overflow issue during udmabuf creation
Date: Tue, 29 Apr 2025 18:43:53 +0200
Message-ID: <20250429161056.799057359@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ef99174d81ced..546bba502fbc1 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -186,7 +186,7 @@ static long udmabuf_create(struct miscdevice *device,
 	if (!ubuf)
 		return -ENOMEM;
 
-	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
+	pglimit = ((u64)size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
 			goto err;
-- 
2.39.5



