Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33343222D78;
	Thu, 12 Dec 2024 17:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023885; cv=none; b=QZrWjNIKFUpg1PY0/EUq+nFeoS/BeU5tN1L678YJ0taauRcITRein1h7P0BrbslIe90aw6YdsfqrjgGAtdRLWBPXHejJOqSJwi3Qcz5WDjq5UT83QH5+H4vcxjLI1AOWqjm/oAocWIXXk87ITNV2hzn6BX2OeamRUBFSIasBLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023885; c=relaxed/simple;
	bh=VzOiSIVT2J1DOuswmQebJVe8XQfW8m47ow1lH9CPuoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G89+d68BG0TjFQBLBt09apkVIKy/i77Qvo0bHzEhP6K0t/LUUXh7pjGDXx61U/p2HrRGFKcTpaPJ1M9sFEKVmFMbXSQSZ0SaBJk9umVPWlS8ePxDF7YO8tuBtrbUTO1cW5sE2Tb64tuyeNzb/JYvwJMJ8g7YUfPb14/7MpBp75Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twKlXlnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twKlXlnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67433C4CED0;
	Thu, 12 Dec 2024 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023884;
	bh=VzOiSIVT2J1DOuswmQebJVe8XQfW8m47ow1lH9CPuoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twKlXlnKGxxjOpBeVgJsbNitw4BNNVdOTuwXqrNv9Y2PS5RQqiI353+iGRClOXhsK
	 qgzAXUGY1JgjvCiTdHfVVPOO9T8wfI3l/q7tVT7WJHz3jX1S3pWjCJFGbnv198HO3g
	 RmCxPZz6Z4PlBn6QrV1quANPDK2KWjHaDqzh8v50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/459] bpf: Fix the xdp_adjust_tail sample prog issue
Date: Thu, 12 Dec 2024 15:57:32 +0100
Message-ID: <20241212144258.014788592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



