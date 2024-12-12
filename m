Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7F215764;
	Thu, 12 Dec 2024 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022160; cv=none; b=BYUqua28tESNTUdgfwe3Ep41xrGGXPk8wRGrOssfuiiHJnbTTKICDORMFdPz4LR+skzulMCZttfUmOMqXjbIWBjM/n0PqJSgqk9y9gvaRUx+T9AK0qtkTNAzS8sWGhrTEEvxYY4yLm/SpEsHkOElrcWmB58L8DPz/j7MU+hlVLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022160; c=relaxed/simple;
	bh=l0lYLfOJIBWOAOPHPQNuTmgBogg21RiNmxMKOafr+Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQgeVIqOc8b4/NSZxNpWk2WkEiUC0MdAutsJASzY/UCzyML2YH4QUJgjrd8X7n2xp87U98D2dRLdS0AW8tDMoV9vs6e0OX0niw1lq5QGA56C3r5GrUPucl7AJzeTa5UXaF3X4Njb/gn36REncumVHHCImKlztkTH2T1zt60C5gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA+8U6rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA+8U6rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7BFC4CECE;
	Thu, 12 Dec 2024 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022160;
	bh=l0lYLfOJIBWOAOPHPQNuTmgBogg21RiNmxMKOafr+Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SA+8U6rFXMcbY0QcVU0u4J4h11qHmm3ujNziHnu3iV7oENsQzkARn/qNLoCoL+b38
	 XfK0THATvbn2OmGTgs2IO8w+BsEMcTTi4k4UakvfT/EbjuVUwkGCOjhK1QOBLBYKAr
	 cxGy0rdLOo1SM3lgZBpcSh6hQ1vdEtzQYt3Yjoj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/565] bpf: Fix the xdp_adjust_tail sample prog issue
Date: Thu, 12 Dec 2024 15:56:00 +0100
Message-ID: <20241212144318.000035417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



