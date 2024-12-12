Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7696F2FE;
	Thu, 12 Dec 2024 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017801; cv=none; b=Snq8eVB4oufAbeYFGopn7zMn+GLjr8iLQfG8t9ueHNBZ+UlxsPX0nMrNpC7av54PKAaTOM9NfLTJCEyIydvMkXvrK7zkCusS9hhYWTHalR2e8yfRKpEVfCiSB0uQq0fCrM4bCtfhWWEEP+9D+iJ9RRYn/RfMsiQ7Bi2m3KP2BEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017801; c=relaxed/simple;
	bh=41gCDumUho9y4L/QAUgCCPFp0L43lmd4nfCRMNwCUAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRnoCNtet9e9USpFsLXvnGIT4fl4n+ZrAX33kljY1lYKQENOXpCDP8kTqm53CPReAjvJevEgFwZeXCbD1doyWyMJmagj++2huJneNkV1LpISxRvLf9DKArqka+cxSuyBEvx1KENAl68zibfClNpv3/ZpvLWA6ZKB98P8ZRxRB78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTvH4Aq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTvH4Aq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A9AC4CECE;
	Thu, 12 Dec 2024 15:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017801;
	bh=41gCDumUho9y4L/QAUgCCPFp0L43lmd4nfCRMNwCUAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTvH4Aq3uZ33onPajXINqnCkfPfqsGfHtfacnd2nleYbI3pz6OrktUQuV1BtHyr+F
	 yc50TeLNxpR6pCH8PST2ts6D9kxwQSOk34sAW+55OP3Z+akQnuMCo5RPwe4eidqfQE
	 l2YjFtq8X/cI7uVXXfXt3pr46mh4ouUzglS+cWeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammadi <amiremohamadi@yahoo.com>,
	Quentin Monnet <qmo@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/356] bpftool: fix potential NULL pointer dereferencing in prog_dump()
Date: Thu, 12 Dec 2024 15:57:13 +0100
Message-ID: <20241212144249.149605036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5e0fe3854a35..90ae2ea61324c 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -818,11 +818,18 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
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



