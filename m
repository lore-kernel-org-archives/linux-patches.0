Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB7E33EAFD;
	Tue, 16 Dec 2025 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887634; cv=none; b=c87gXXeUy0KsFQ6L6/AqMn9UWx9Oo8EgAJPn+3ISrxIBynNO+92NWXYwROP8RsWoLMyPd3xkXNvyaBvfPSTYfWQIOo3ACzoYiMYFp/Vr4TVwI8ii5IA6UZr90cFUmNmXxk9ysZVwXPPzxO0JjzJs5bLbYkZu+5TwSL6Jo23CRrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887634; c=relaxed/simple;
	bh=LT9Eilf3XOAIRbmB7FgYiEDcgv9sDHogjaPiquOnggs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBOFBSN595FIcjGwTpLv11QcsCoARpfKUhNgvT8974DTk1WIsyuN7ZH1/dxuHqMVki1pAb9WFQwZ8ohHm32AIHdM3HzlptBRUVid5aWY0+LGFVDHO6Be7x+tF82/SiQn1Jdtv/YFmOl/Nv64gnt6TcisiJZ+NtMD8OjjQNFRRT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+s6Q/7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+s6Q/7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28467C4CEF1;
	Tue, 16 Dec 2025 12:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887634;
	bh=LT9Eilf3XOAIRbmB7FgYiEDcgv9sDHogjaPiquOnggs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+s6Q/7I1AHz5YvDkPtEA+2mXuXIwgq3LsT1KnHkTjgXma7c9qf96ExdHJ/20NRGG
	 PP4HsHZB1+jRwEBfbeiR+OiRgqvwbFi3idrDfZVyspQmsYGVk4KhXcx6TX4g2HD5WZ
	 eovcKnaKn6brBXcx0taQRSFtWYmRBhHWLv0MMHec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/614] bpf: Handle return value of ftrace_set_filter_ip in register_fentry
Date: Tue, 16 Dec 2025 12:10:59 +0100
Message-ID: <20251216111411.951307935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f2cb0b0970933..04104397c432e 100644
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



