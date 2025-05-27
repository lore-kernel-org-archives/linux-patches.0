Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A023E280012;
	Tue, 27 May 2025 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366786; cv=none; b=dFk84TWBLMVXmgrOnQl4lK1E2ldiGGhzjpWjhqTtU/qoYNhUUtYBJMvUPQ8caxcLu7NQEuOVbB0r5KAyFjIFa8ZommpAKVjmNsx+Zz7PGZHAlCmKIMmTCu3Zp3QF8bAPH9xSGjW9ZqN7wbWK7x2hpGZOZ7cyTKDJaRC65/jiibU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366786; c=relaxed/simple;
	bh=iYfKhxp3QvZCX9cVfvdwsWHSgKY1M89GU4X9w2jrrJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVBv2/NLsf4TeQAZ7QPIx68XqtdwHrzzWt7Hr5sEsFz70z2oNSn1UbRHevgoXSl98vkwoMIihJTNlKQRrE2SxhMArTvprd5A8zQiB0+antih84l29k72FImHkg1k3yj1PQE+B4K0Qiupb1qOE0VaCqRCGlib3vpIfGW/4fP7xGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqlvgPdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqlvgPdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C8DC4CEE9;
	Tue, 27 May 2025 17:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366786;
	bh=iYfKhxp3QvZCX9cVfvdwsWHSgKY1M89GU4X9w2jrrJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqlvgPdJ1N27SiYBwlvfe4NqyikealggRNipwf9TftCcDJMAmu9CiWf1iNQ4UZKAm
	 2OkYCt69cRKEMz7L/3+F15LLnlwSeRmkwDUYmxO+HdGRDsNq6f9R1gP3jik4xyNAr5
	 OpiCjpSvKWpa9ZClNhVgudqg93yAHH6E35FOFn1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 150/783] um: Store full CSGSFS and SS register from mcontext
Date: Tue, 27 May 2025 18:19:07 +0200
Message-ID: <20250527162519.269631487@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin@sipsolutions.net>

[ Upstream commit cef721e0d53d2b64f2ba177c63a0dfdd7c0daf17 ]

Doing this allows using registers as retrieved from an mcontext to be
pushed to a process using PTRACE_SETREGS.

It is not entirely clear to me why CSGSFS was masked. Doing so creates
issues when using the mcontext as process state in seccomp and simply
copying the register appears to work perfectly fine for ptrace.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Link: https://patch.msgid.link/20250224181827.647129-2-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/os-Linux/mcontext.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/um/os-Linux/mcontext.c b/arch/x86/um/os-Linux/mcontext.c
index e80ab7d281177..1b0d95328b2c7 100644
--- a/arch/x86/um/os-Linux/mcontext.c
+++ b/arch/x86/um/os-Linux/mcontext.c
@@ -27,7 +27,6 @@ void get_regs_from_mc(struct uml_pt_regs *regs, mcontext_t *mc)
 	COPY(RIP);
 	COPY2(EFLAGS, EFL);
 	COPY2(CS, CSGSFS);
-	regs->gp[CS / sizeof(unsigned long)] &= 0xffff;
-	regs->gp[CS / sizeof(unsigned long)] |= 3;
+	regs->gp[SS / sizeof(unsigned long)] = mc->gregs[REG_CSGSFS] >> 48;
 #endif
 }
-- 
2.39.5



