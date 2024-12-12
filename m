Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F2420A5EE;
	Thu, 12 Dec 2024 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025131; cv=none; b=K4Ee1c2+NQJfjiRDzA+SF8Jp+CCwNv+OaQndLamK3cMTkMecb4w8QE0CUQwFylR3DR9Fvmj8ZMwMNrp8kR30meHEFrGtHj5PS+NqT4nPRwuspOGdUE3CXSU7CiJK8abp8y+ktn6xNVdwGji4ZKzlUUCC2IDG8yRMP4Kll+8br1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025131; c=relaxed/simple;
	bh=jfQfEevJEzj0W7CqA27fBVZsqQa9l8/A2REnwbLW/R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrmHrYbeRqUOdYOPWj4YahXnGQC4z6cFndD767y5KdEczxVQl2ynN5xx02FuPa/97VDaWbtDKs74ly8e5lVCay/QC/kkKjBgzRuMT9zsehFVXiweGL+fvYAvrWBBMU9KDE259NA8co5zKlAbQejxRA7fhtKJjlOp7rRibI09U44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/g32Tmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/g32Tmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B8C4CED0;
	Thu, 12 Dec 2024 17:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025131;
	bh=jfQfEevJEzj0W7CqA27fBVZsqQa9l8/A2REnwbLW/R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/g32Tmc/o9ntAZ9KtmN1WoVgOjOqDs6BPLPC8GrHFv9U5P0SK6sbp+fhc7XQjsAR
	 YpbG5EorepjovE2xDbWinZrZ3Iktb1y7UEphgFILVOWug4/O7h1y2TSE7FHkeCTlws
	 KxvI3hY3ZfMtmSq1RzmfNjWwUmz0x1vIOC5gMIcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/321] bpf: Fix the xdp_adjust_tail sample prog issue
Date: Thu, 12 Dec 2024 15:59:44 +0100
Message-ID: <20241212144232.599261425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 4236f114a3ffbbfd217436c08852e94cae372f57 ]

During the xdp_adjust_tail test, probabilistic failure occurs and SKB package
is discarded by the kernel. After checking the issues by tracking SKB package,
it is identified that they were caused by checksum errors. Refer to checksum
of the arch/arm64/include/asm/checksum.h for fixing.

v2: Based on Alexei Starovoitov's suggestions, it is necessary to keep the code
 implementation consistent.

Fixes: c6ffd1ff7856 (bpf: add bpf_xdp_adjust_tail sample prog)
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240930024115.52841-1-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_adjust_tail_kern.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
index cd9ff2a40a398..d9c409190c2c2 100644
--- a/samples/bpf/xdp_adjust_tail_kern.c
+++ b/samples/bpf/xdp_adjust_tail_kern.c
@@ -54,6 +54,7 @@ static __always_inline void swap_mac(void *data, struct ethhdr *orig_eth)
 
 static __always_inline __u16 csum_fold_helper(__u32 csum)
 {
+	csum = (csum & 0xffff) + (csum >> 16);
 	return ~((csum & 0xffff) + (csum >> 16));
 }
 
-- 
2.43.0



