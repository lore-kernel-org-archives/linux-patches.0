Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625167;
	b=Cy0/RFFgTWCk8b1zKDJyZSKP2WCX9MJ1n7qkHf+cvNAZzrSvFBbGx05g7bf9efLdHqJs
	 AyLj8B0oj1zAty0ughyVoPvikSkqukg321kh1PwrYmhfrflF9MTh5hl/wt+ld6u0kdBaC
	 9cl/GqeiCtovEsvFcnYhohWhGj1l60jCI24ku3iRn80SyoC6kfKyJoC6Ho7yPlyAse9+S
	 Y5RA60st6ctO1ZgRxJlnnatUFlOWWN33Gzgd1lmDvrP5Se/s7cltLZ2y3yj3rt5kcrpP1
	 ZdSk/u/rpOsTtmieiUDGwkG87tbHAt4gKrjoWf5/Wuk/ED30fIMWJdE2zyQn1Pdo7/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bFt9zIruEmrcqhjkyqZWlMljFWdzXTMglkzj+mMPchE=;
	b=uMWOtXIa8XW2YnzqlueJrqopeoj/d+tM16s7zNnAspJ/w1nn7MpPAXISIPZZz6OqQbFf
	 i7ew6wa9BhiH/DbvXi66vu4xItbaKT1YXaXHhDShOmWJ7tm5eHGS2ghgDqMcvRbBYv3K7
	 MpZgRjSOF8cRAwd+Jlok8WmTE3y4c0DalpufApXHb//VFW1bMBf4K+IXzu4XLid278+6t
	 0G3pwA2F7oscqaaJpPotL96kuImMcRTV61+CDLkg193WRGQ4fqZBRywL6yoEs1D3sXqey
	 5RxVNVESRPex9DegGbsHQkmBiNwn4Ld1lZucVhkp7N6Tq1JEh65Ses/kl6e4cJUq5Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vv2FIqcJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4296606A31E;
	Wed, 25 Nov 2026 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vv2FIqcJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820481F000C0;
	Wed, 25 Nov 2026 16:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625167;
	bh=bFt9zIruEmrcqhjkyqZWlMljFWdzXTMglkzj+mMPchE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vv2FIqcJwTXuvEBartY+G+ZobiczQyH9/KIwT1rQtuj5Yzk3Ly0k0lBYhsGAvF6Z6
	 09Gghyvto1PkkeXuRs+hrw5jC+P+wyPsj5f7FrSAspqUQU/AamE9r0SUI/XgwP+V50
	 EPt+NkHWRlzZdAm7057wTU2hgPZ3Zfn6hJuxcv4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 429/816] perf llvm: Fix memory leak of args->fileloc in symbol__disassemble_llvm()
Date: Wed, 25 Nov 2026 15:32:57 +0100
Message-ID: <20261125143859.124637179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit fe529886843f451ad6da7e65d53325432e0f80fb ]

In symbol__disassemble_llvm(), after calling llvm_addr2line(), if the
subsequent disasm_line__new() fails, the code directly jumps to 'err'
without freeing args->fileloc, leading to a memory leak.

Fix this by explicitly calling free(args->fileloc) before jumping to the
error handling path when disasm_line__new() fails.

Fixes: 04885681788855bb ("perf annotate: LLVM-based disassembler")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Cc: Steinar H. Gunderson <sesse@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Applied the fix by hand to symbol__disassemble_llvm() in disasm.c, since the llvm.c file the upstream patch touches doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/disasm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index 8f35232f7f22c..300acc905901c 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -1980,8 +1980,10 @@ static int symbol__disassemble_llvm(char *filename, struct symbol *sym,
 			       (unsigned int *)&args->line_nr, false, NULL);
 
 		dl = disasm_line__new(args);
-		if (dl == NULL)
+		if (dl == NULL) {
+			free(args->fileloc);
 			goto err;
+		}
 
 		annotation_line__add(&dl->al, &notes->src->source);
 
-- 
2.53.0



