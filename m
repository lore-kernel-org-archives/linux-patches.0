Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2431F667A;
	Tue,  3 Dec 2024 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236508; cv=none; b=RXyzmDP4dSGNRrnJWY3v18wHQk79gCl/fCo7pNSRK9/PzoInZnniSgBfaBe+SaakFFzlep6kWwuEfDij1Q+Xrwmbnn7R8Rp611l7A4dB/9n+m8v4H+aim+otH+F3BfmMDj3TDMv2rRh7cwNOsf8CRZdhROwJJasb8IL1SIKmqBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236508; c=relaxed/simple;
	bh=IrC4dveQN9KRatx/AZdOfqFrPYuHXVcpZ7cL1048L+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/J7ug8NuyLxGB1wH9jxcGznHzZ2WEkt0PrfJ5V6Q9DgXO+mvDsBLhp3+dJ0K4QVS1FV7HMqYEmh9kCpPVHveeyz60aVQliJHZ9q+Ii4P22LxzMrfrIiBr0dNIpTBnvIDjUQvTiT4x/Gv4M4jgtYZ4Bm/ukTXOJGD9rg4S6KgAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtabtsP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtabtsP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A173C4CED8;
	Tue,  3 Dec 2024 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236506;
	bh=IrC4dveQN9KRatx/AZdOfqFrPYuHXVcpZ7cL1048L+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtabtsP3FSkgNLsP3UCgeEL7003Eks7C9czLVVnCP1uDUen9eQrg2JXcht2yLGUNM
	 l6N5LGtlWdM8b52F3oS9I0AIEpgTYgjBtrxXEsmPBRxBItaj5jSaXPIRSprzs84kpu
	 MNkvBcAEH5WlOeAwIX+qj35SYaLF8M6hoe5wvpL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/138] bpf: Fix the xdp_adjust_tail sample prog issue
Date: Tue,  3 Dec 2024 15:31:09 +0100
Message-ID: <20241203141925.092340932@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 411fdb21f8bcf..9783754bdd8bb 100644
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



