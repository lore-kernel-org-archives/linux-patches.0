Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1396253365;
	Thu, 12 Dec 2024 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023127; cv=none; b=u5nGU9YM6m1sRL5OxJwgvt3YK4t0YyAnTgkPdkvi6OTJI18wLT0yw0X8o0HLGEYpq7Pdhj5B/PEKokJOKzEOJiPKZ9W61Eof/TCX+dIkw0jPy38gAqB0jPXHuoqh765+oZVCoUOAD2p2b6QNoKwoc15D0aH3ynVJ4pREv9g/mVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023127; c=relaxed/simple;
	bh=nOkIzn68S8J9USZ5xaPqqbWcT0j6/in1gUSvAs6pges=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3t8QS+1rvEkHX3CO0+eE/DnhST1oNSpQ5o6X3XMnMMFu4cqtb1pI3tdwr3PX9GiECFYDbGhKYXbKS8ueAmmH99b8JqS6HPsa6xOTy2sMeQkLRbqYvOT9F/SD+aTwTBFXUeN97fYwJwe2Rdpe/seDprBy7aGRy/Ry+QfP69a3no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USe5OKg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USe5OKg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB08C4CECE;
	Thu, 12 Dec 2024 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023126;
	bh=nOkIzn68S8J9USZ5xaPqqbWcT0j6/in1gUSvAs6pges=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USe5OKg65juvzreiL5wIu0H1WlM19ndsR7QJd1ECzD8lMjiLf/RLLSdM+wUUYKnWQ
	 SOpHHrQ2wzo7FpYNUArkBp3hBi+BYYQQHWSyT+xr+WD5cnh+lfZNywbJAEKWAyKaWJ
	 HggwyALJuaK9FktPWekywOZaJCO+jzDwsf7kOj1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammadi <amiremohamadi@yahoo.com>,
	Quentin Monnet <qmo@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 433/565] bpftool: fix potential NULL pointer dereferencing in prog_dump()
Date: Thu, 12 Dec 2024 16:00:28 +0100
Message-ID: <20241212144328.800413875@linuxfoundation.org>
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
index 75f71c3ad4f62..64142f3d06655 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -744,11 +744,18 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
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



