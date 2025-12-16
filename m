Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C875355027;
	Tue, 16 Dec 2025 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885841; cv=none; b=VFxzL2MkT3kALupk4Pml0iGHY+iG+qGwhZW7DVmHaZYEeBYLlw335XtRzgWWPJ7/0u9XvScMwBi2o/YwgVhQvboQ0Yj0iA1+LcqmMxpOdyYM28ClPGByzkUeMXqfGHhlCgKekeHUkUe4lGaXwBB7U/Oj481H9gNd5Xe0u/VPoNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885841; c=relaxed/simple;
	bh=xLS/X9pZ2E7XsezUXH1ora0aQiX/XAIGxpOJvIYeKAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgbPqcQpxtSakiU4KZ12r3joW+d8YUH5CBS+Aku6vEvtPJdDrvImmhDk5rcp4TrcIQ0Cx5yQU+DUzlymrlvnXF1fdvB4NTKf//wqt2IkNo9JeTqpjMTgO4wyjC+MolI+hc6nYt4r8QcgJcqIkWLW6bjlZyMToTAcadOcBDr/9dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdIVui9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdIVui9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40915C4CEF1;
	Tue, 16 Dec 2025 11:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885840;
	bh=xLS/X9pZ2E7XsezUXH1ora0aQiX/XAIGxpOJvIYeKAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdIVui9hShCaYCUDX7o0Av1foXrUd2eYG5EeRdBR8OlGZ1PXwK7rkFUAe5bnlMNKJ
	 g9GoLMN8zTdj++nyqST70Vse0TL6vqOmiwhDHyjkFmNIl+7k1H/7pNEsTLiy61X2nE
	 stQotSbPjw0IVL9TOZkWhHpqBZo1FSCzIxMCpZz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 243/507] bpf: Handle return value of ftrace_set_filter_ip in register_fentry
Date: Tue, 16 Dec 2025 12:11:24 +0100
Message-ID: <20251216111354.301447838@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit fea3f5e83c5cd80a76d97343023a2f2e6bd862bf ]

The error that returned by ftrace_set_filter_ip() in register_fentry() is
not handled properly. Just fix it.

Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20251110120705.1553694-1-dongml2@chinatelecom.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 0db5673812108..1ce8696f6f6d9 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -220,7 +220,9 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 	}
 
 	if (tr->func.ftrace_managed) {
-		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
+		ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
+		if (ret)
+			return ret;
 		ret = register_ftrace_direct(tr->fops, (long)new_addr);
 	} else {
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
-- 
2.51.0



