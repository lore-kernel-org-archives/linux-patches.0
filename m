Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0891FA17C;
	Tue,  3 Dec 2024 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240776; cv=none; b=DqetdYbKj3LtVPZapLkYEslvzbHo+VwdPfRRRqGqvRuQ9Cm0MmDs65sbFahFUkUYVkxqbMUJeZE5bryxBjvBndLjCr8T2LjBB8dk2/XP1XrB1XExKYTy71WegBMNVbwViUM76EYjBnKnDk0g/EMeGnwM2si4UAmR1NtZW+M3FX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240776; c=relaxed/simple;
	bh=F2m0CodRo/bM43n8L8Nr/1vJCS76okz6AH5JhkfWxro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRVKzny36ues1vglEGXwKnLo/k6LxEGNZiQa1X2F/7SNEHUMp819UvjFTBZFmapUKiMGjLtqvK3z+DK7HcccS20vj0XxeuRtkwdYCOHJMfLgX0S1lxwgfIQdtYDgF9Da1Ou0+LoeNetaYYQut6GHP4Hbvwjjsdwkd8sU2fAvy9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5GnHrGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5GnHrGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE91AC4CED6;
	Tue,  3 Dec 2024 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240776;
	bh=F2m0CodRo/bM43n8L8Nr/1vJCS76okz6AH5JhkfWxro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5GnHrGT2Gf72TotJ18Al6738RCfNqtLWU7jAztDv8jgqYVbJH7u8/jmqumMHrfJt
	 IkpP01qMvyLSxGwSlh5rv0x/4LelajCXkOVkxyzgJU5wGW65w9d8Gdau2Ezp5rQTuK
	 H6skBdHm5XnriCd78BgzhHVLnS6AwMHFTdFD4Ew8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/826] bpf: Fix the xdp_adjust_tail sample prog issue
Date: Tue,  3 Dec 2024 15:39:18 +0100
Message-ID: <20241203144752.759710110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



