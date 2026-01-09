Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A841B2DEA6F;
	Fri,  9 Jan 2026 11:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959737; cv=none; b=p6Ok+JYbpa+YGEkIKRTQMjW393SUBo/W7sBQW5wS2qDQzOxcn4U041nhAbkMgCTUnU2Xv/lsPbOjid4DnZx3rKkY3XIkoRBHOEyilvl9v/5EbpklXPJRL/Iryt0hrh52yPKZ7zpExb494SSYbiB5N1REb925UyBWHkABfI/73YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959737; c=relaxed/simple;
	bh=f6mLKU/x7vZJVf8K/Y1WBZ6fdAMvn+BtkZzilUihM/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBNNT5sRfkCra+3lhh0sOpgS0kUnSWxypM88DZPqX3WQJvjNah5uXFgSnD+HAnq29Hlk7FGm4mRO3abQD9tR9opuHxmtKmv4nE2WfjIJgDs7eyAv5xWN0utKxFZuz9wQT4BkLba/4EuwclajKi01yLSeb06bYt9ZNv70Nd/VUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OufJMxnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OufJMxnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36476C4CEF1;
	Fri,  9 Jan 2026 11:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959737;
	bh=f6mLKU/x7vZJVf8K/Y1WBZ6fdAMvn+BtkZzilUihM/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OufJMxnmKGUFUSbRih+PsgpYAWb+83koXgOEuw8WWaFtQqbaeBLb8EN4znuKpf8wI
	 8gMRyaWRY0ETnXY5RSTfR+HgZGQAc4kYjFJ99ZYKxNchZcumjifRV1CiQ6sCbfWKLc
	 GAvNYsqqMnHhasoo5sAJpatbmG4FHjkKXiUqozfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/737] bpf: Handle return value of ftrace_set_filter_ip in register_fentry
Date: Fri,  9 Jan 2026 12:34:57 +0100
Message-ID: <20260109112139.939506827@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6024fc903490..f8a58b4130701 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -216,7 +216,9 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
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



