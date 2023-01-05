Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77DA63DE
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D421C433D2;
	Thu,  5 Jan 2023 12:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923486;
	bh=oUMcD5Ler3uMEvfSroYxl8tyOmTk2bvAPexaQohh0GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yALVDmICNFQV81Dk65G7oDJaIlCRRcGJWTeR2xCXzyv2NIT9vPwosMuuraxs4SjX0
	 ucz9KkY04XArryjXLgOohDMXok6ci9WYewx6awyyI+ole/3aShs5M6HdxK+cQ72jH9
	 O8EWJGbGUPtYeUFwcDmxuKVTxZnRMTqlyuzVnxvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 028/251] alpha: fix syscall entry in !AUDUT_SYSCALL case
Date: Thu,  5 Jan 2023 13:52:45 +0100
Message-Id: <20230105125336.056814235@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit f7b2431a6d22f7a91c567708e071dfcd6d66db14 ]

We only want to take the slow path if SYSCALL_TRACE or SYSCALL_AUDIT is
set; on !AUDIT_SYSCALL configs the current tree hits it whenever _any_
thread flag (including NEED_RESCHED, NOTIFY_SIGNAL, etc.) happens to
be set.

Fixes: a9302e843944 "alpha: Enable system-call auditing support"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/entry.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index 98703d99b565..d752ccc53b24 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -468,8 +468,10 @@ entSys:
 #ifdef CONFIG_AUDITSYSCALL
 	lda     $6, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
 	and     $3, $6, $3
-#endif
 	bne     $3, strace
+#else
+	blbs    $3, strace		/* check for SYSCALL_TRACE in disguise */
+#endif
 	beq	$4, 1f
 	ldq	$27, 0($5)
 1:	jsr	$26, ($27), alpha_ni_syscall
-- 
2.35.1



