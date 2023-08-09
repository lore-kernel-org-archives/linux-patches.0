Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA4017AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DB7C433C7;
	Wed,  9 Aug 2023 11:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581179;
	bh=1GXU7AerLz6uR1sIweQdVXR8B03QAXtd2cCD+CNDc1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEpe5taXQqWCuUHhCcVKKSAZhgfSDUYLKUTFngO9I+lRhhPMMiKvXcDywMTkueY6a
	 MNTwjQPX5RF4seANEV0qKx/F+zD3Kfe2fNvE1NJrLyCR2+ASF5aSfYla3Ubp0FOZRf
	 /g3beDBvMz84zAgJ2//kyFNMeUylJ65c2rYzW85E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 5.10 116/201] x86/kprobes: Identify far indirect JMP correctly
Date: Wed,  9 Aug 2023 12:41:58 +0200
Message-ID: <20230809103647.656448685@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit a194acd316f93f3435a64de3b37dca2b5a77b338 ]

Since Grp5 far indirect JMP is FF "mod 101 r/m", it should be
(modrm & 0x38) == 0x28, and near indirect JMP is also 0x38 == 0x20.
So we can mask modrm with 0x30 and check 0x20.
This is actually what the original code does, it also doesn't care
the last bit. So the result code is same.

Thus, I think this is just a cosmetic cleanup.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/161469873475.49483.13257083019966335137.stgit@devnote2
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -478,8 +478,7 @@ static void set_resume_flags(struct kpro
 			p->ainsn.is_call = 1;
 			p->ainsn.is_abs_ip = 1;
 			break;
-		} else if (((opcode & 0x31) == 0x20) ||
-			   ((opcode & 0x31) == 0x21)) {
+		} else if ((opcode & 0x30) == 0x20) {
 			/*
 			 * jmp near and far, absolute indirect
 			 * ip is correct.


