Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36698237162;
	Tue, 17 Jun 2025 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176737; cv=none; b=N0mJN9sH8JrFdPvg/m873TwhkGw+TdqEu3UGWsPIMC2JYRQdZAu397Mpk5itW3Bl7PQb2Ga/Tsv3bc9GNPq8x+9P12SV+27jQ3+tJQRC/64QuuS0Dl1FtVmbvbGcgzbGNG6ICJ5u+ubLPF1PjnDIuQQ+yJujeUYfqwvGZGVqLdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176737; c=relaxed/simple;
	bh=65qbZqD6h6bAXmbbYlksR+uI876uGT0aHi0yVGYQ52Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt/+wmB8jQm5Qxui7RYbcT2U0A97qTX1pkcTCD5GuqHF3z5WcdeiK8ocYL/zHdnxYErWJ3YJyeqw9u1vQoCdWK3VkGdv9SvvyZMFWaKqrHXWsszFmbwOPIEUrvdxtCGUw3/90MXv2Ifz5XGxLeJtEA6j9McCOJ1flwHzRB7tRd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8cT+3Ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8cT+3Ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4730BC4CEE7;
	Tue, 17 Jun 2025 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176735;
	bh=65qbZqD6h6bAXmbbYlksR+uI876uGT0aHi0yVGYQ52Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8cT+3Ke2uzzsmUkztctM7hY0iDIv/JIz4NkWw9l5R19LD4jD//6y7VxXNt9/hbWf
	 4w/AZgr05mkA+Tc5cRWTC7Di2/g9md61QG7m6jubOTO6c02njweZz2o988kFCybLLm
	 l2H1uvx7PEbScV2ckxi4Nw5oaA4Q/AmRu2tL17CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Wiepert <jonathan.wiepert@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 221/780] Use thread-safe function pointer in libbpf_print
Date: Tue, 17 Jun 2025 17:18:49 +0200
Message-ID: <20250617152500.457415970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Wiepert <jonathan.wiepert@gmail.com>

[ Upstream commit 91dbac4076537b464639953c055c460d2bdfc7ea ]

This patch fixes a thread safety bug where libbpf_print uses the
global variable storing the print function pointer rather than the local
variable that had the print function set via __atomic_load_n.

Fixes: f1cb927cdb62 ("libbpf: Ensure print callback usage is thread-safe")
Signed-off-by: Jonathan Wiepert <jonathan.wiepert@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Link: https://lore.kernel.org/bpf/20250424221457.793068-1-jonathan.wiepert@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2bc0e3bfdd491..147964bb64c8f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -286,7 +286,7 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 	old_errno = errno;
 
 	va_start(args, format);
-	__libbpf_pr(level, format, args);
+	print_fn(level, format, args);
 	va_end(args);
 
 	errno = old_errno;
-- 
2.39.5



