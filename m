Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076591F8F13;
	Fri,  6 Dec 2024 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497077; cv=none; b=eTQgKVf2sB+7ROiAZf76Lfq7mVvB3JGU311hGCehhGvUfh4FbNncCWXK8S+bWam9fL62ziGGWSzvf9e/07KEA6MFyfWk2XE39zpmEZwOrHNmuIz0SmYVAtJZ0rE553eYM3DmQpKw5oNWGHHspjOk9byx3NtCV9fHR51zFMduT7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497077; c=relaxed/simple;
	bh=Ib8xFen2vxwOTvWpP48/tspFK9nxNXAwGTS0nLDdqSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2lYj7VcPo9urpDTQsOUDdc/lOhSxXT9d9/YBS1bMJVoLMcFxLgdVCQwHlR272tCHpLG3VarO91ycAivigXH1YeBUMhqjcAvAYlktIuwlUZZA5DU9/Wuo9HaihQiEnnLZySKU3eZL50rbc6Agw50BOnfedWv5GZcte4eWzYO6Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mU9ile/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mU9ile/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612CDC4CED1;
	Fri,  6 Dec 2024 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497076;
	bh=Ib8xFen2vxwOTvWpP48/tspFK9nxNXAwGTS0nLDdqSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mU9ile/MDb/ZqbGBu8lMIUg6ZSlqi/To2Cs+KBDrf+CV3S52+o6nHvz3gv0z4hdFq
	 FjynjHLgsj4P3C7i+DrFzOIV5xWspnpCNtnN3hTt99+GHAJW8q3ZwX4jhvAx3UKLzc
	 g0qCRBQw81YlXMrU8O680GzGkLvlFzlfIAxbEAZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/676] bpf: Fix the xdp_adjust_tail sample prog issue
Date: Fri,  6 Dec 2024 15:30:07 +0100
Message-ID: <20241206143700.691947971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ffdd548627f0a..da67bcad1c638 100644
--- a/samples/bpf/xdp_adjust_tail_kern.c
+++ b/samples/bpf/xdp_adjust_tail_kern.c
@@ -57,6 +57,7 @@ static __always_inline void swap_mac(void *data, struct ethhdr *orig_eth)
 
 static __always_inline __u16 csum_fold_helper(__u32 csum)
 {
+	csum = (csum & 0xffff) + (csum >> 16);
 	return ~((csum & 0xffff) + (csum >> 16));
 }
 
-- 
2.43.0



