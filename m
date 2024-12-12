Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891A62156FF;
	Thu, 12 Dec 2024 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015940; cv=none; b=n9eansoLHg5ZmhTh9KxihcDd+G3U4T06RilUaH2q+hCG9v251KpOwQRPk0Wpr8yiLozSJQJuxZVCF3ov05zfUDW2nKj4zbWTqenv5xV+0CU04cKJ2GUop7YSKkZJBl9mZvhFXWr+R18eBgoADgypqW2cXSpncEwUmBFP7/9GFcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015940; c=relaxed/simple;
	bh=YlIq5ter9dMRQziWC5IE3jH9833ELXyYR9MIVNP9+aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDLvPzx3AihdFCFaiWgIS9vPnrbnYsNtxzWw22gFZFp2dsTYnBB5mz1OrW4E6or05Zb8QFM6wIvgqfX317/D9ZZfNhoW94IiT+RfF3T6kAukMrfb42TNlqlVw2r3n4e+i0O2W8/qoLf6oYooOpdDHog7lGPY6HQtk1Ep8xhpe70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8OWeIx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8OWeIx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA884C4CECE;
	Thu, 12 Dec 2024 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015940;
	bh=YlIq5ter9dMRQziWC5IE3jH9833ELXyYR9MIVNP9+aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8OWeIx6u2OPmkMU9d936kTKqrWlgIafNF/THD7a5oTw6RrcTVeOEYYrMHZ2OZFiy
	 Cuzgu5/fnjoZn25+HK2YQjVt7qYLrDXrJERuTEGB3iTzF9Ixx97vJ710Gep6BTfNw7
	 ayIiZ73mMeml2TZzmU7+qmIi/ahw00BgCX0PS72E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammadi <amiremohamadi@yahoo.com>,
	Quentin Monnet <qmo@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/466] bpftool: fix potential NULL pointer dereferencing in prog_dump()
Date: Thu, 12 Dec 2024 15:54:15 +0100
Message-ID: <20241212144310.217662046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Amir Mohammadi <amirmohammadi1999.am@gmail.com>

[ Upstream commit ef3ba8c258ee368a5343fa9329df85b4bcb9e8b5 ]

A NULL pointer dereference could occur if ksyms
is not properly checked before usage in the prog_dump() function.

Fixes: b053b439b72a ("bpf: libbpf: bpftool: Print bpf_line_info during prog dump")
Signed-off-by: Amir Mohammadi <amiremohamadi@yahoo.com>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20241121083413.7214-1-amiremohamadi@yahoo.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 2ff949ea82fa6..e71be67f1d865 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -822,11 +822,18 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 					printf("%s:\n", sym_name);
 				}
 
-				if (disasm_print_insn(img, lens[i], opcodes,
-						      name, disasm_opt, btf,
-						      prog_linfo, ksyms[i], i,
-						      linum))
-					goto exit_free;
+				if (ksyms) {
+					if (disasm_print_insn(img, lens[i], opcodes,
+							      name, disasm_opt, btf,
+							      prog_linfo, ksyms[i], i,
+							      linum))
+						goto exit_free;
+				} else {
+					if (disasm_print_insn(img, lens[i], opcodes,
+							      name, disasm_opt, btf,
+							      NULL, 0, 0, false))
+						goto exit_free;
+				}
 
 				img += lens[i];
 
-- 
2.43.0



