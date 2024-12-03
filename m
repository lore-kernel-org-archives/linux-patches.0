Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726691E3DF9;
	Tue,  3 Dec 2024 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238386; cv=none; b=IAiy/ThYLE07pi+62mQYsRLEzWcGLknK4G5KgfFb5hcRSyA4piT32mn8jCg3IIlurmHCATowC+t2HXEuo87XgKlrJQLzeHBWPQyk1o2yHnPoWykdymLL65ZYhVUVWpnRNy+J6mJB9espm7OC8CI9izu9xV8HeSDZu3F3ZwN+c+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238386; c=relaxed/simple;
	bh=bQxzpaPcvrLTJBBM+co7KmeFJ/XIfp/GHNMhFGPPxQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caPvcQkjObW+rFgVsoLLkhr90l9+NnPpjr73Wts88SBqEAk9C3OK/Tgs1WU6lhLuQkU0C0qkyU511sWqaDCOaCBjyTgDZ2qZkfCplU//h0tJSLfYiXQR82PzLRCazoB6eHWy70lK2wJS2bdECYjuOh3p0CWxzrjAwXUMWX89u0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1/VxAeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1/VxAeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED667C4CECF;
	Tue,  3 Dec 2024 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238386;
	bh=bQxzpaPcvrLTJBBM+co7KmeFJ/XIfp/GHNMhFGPPxQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1/VxAeSOMdYYtZLrjz+pH4Be+xYe18mVBHXBy0/f/icl7XymFa23QidUl+YY43qQ
	 wM/VxjlVOvaJacgKu2cgvF2QKnJj1DMi0ilNcwinD8PACcFeh76uco51PZO+UY1Ylc
	 J/6Q+d4jbBI7I/lMHJ28OvN1MNIuTMaEFXsa8vzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 259/817] bpf: Fix the xdp_adjust_tail sample prog issue
Date: Tue,  3 Dec 2024 15:37:11 +0100
Message-ID: <20241203144005.898991298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



