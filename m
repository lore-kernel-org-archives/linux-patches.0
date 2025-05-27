Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A0C139579;
	Tue, 27 May 2025 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365805; cv=none; b=fiBuD96aQbOqm/cLcaOOu8C8Zj35aLWcNDJgWqVtE68cHz6Tn+78RmI7EvSkGY2lh7iDhemVyhrRCY1LKJj09EUJy3BVV7p7k+nLu6Ga3p6N9vP0y/pRmma8vL7BgYIgNkw4w+EZ7qKpcVGt4jbKpGD5wcfd18FXTClQ5V1AaZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365805; c=relaxed/simple;
	bh=rf4o+f9TM28Y60cONZn/gOK5S7FrjBuEeRtXTxvMi9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsiv1hNp3SMLMSH2dsR3HYGPjtC5xCCjDT3qQO7su+3g8X05xTODh1qDgpdXQFgmEr9eusPJd/iNLTdEl9bKOw2Ah3FclyYXI/T8r2m1ebceNj91nH00IzQH10ilJT/W70icb1bbG7RGs77VAzUE5935mdY3mHSeSLeh+yyKKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpi1OYHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpi1OYHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF71C4CEE9;
	Tue, 27 May 2025 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365805;
	bh=rf4o+f9TM28Y60cONZn/gOK5S7FrjBuEeRtXTxvMi9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpi1OYHwrfYFFbdfvqoGZYFvI2ybEbHkpshG4Zfe53cvhfUzqUCUEakFLxnLlQwzD
	 HQJFMLRpii20W0XDEpzspskhmew3+2lVytwomtess3ZZl8xK1W7CQIKIPPWwo1C2lN
	 J+0VJLObnhdQ6Kdsn+97/qjUPDzYYnWafv7wSzH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 477/626] bpftool: Fix readlink usage in get_fd_type
Date: Tue, 27 May 2025 18:26:10 +0200
Message-ID: <20250527162504.371952968@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit 0053f7d39d491b6138d7c526876d13885cbb65f1 ]

The `readlink(path, buf, sizeof(buf))` call reads at most sizeof(buf)
bytes and *does not* append null-terminator to buf. With respect to
that, fix two pieces in get_fd_type:

1. Change the truncation check to contain sizeof(buf) rather than
   sizeof(path).
2. Append null-terminator to buf.

Reported by Coverity.

Signed-off-by: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250129071857.75182-1-vmalik@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 9b75639434b81..0a764426d9358 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -461,10 +461,11 @@ int get_fd_type(int fd)
 		p_err("can't read link type: %s", strerror(errno));
 		return -1;
 	}
-	if (n == sizeof(path)) {
+	if (n == sizeof(buf)) {
 		p_err("can't read link type: path too long!");
 		return -1;
 	}
+	buf[n] = '\0';
 
 	if (strstr(buf, "bpf-map"))
 		return BPF_OBJ_MAP;
-- 
2.39.5



