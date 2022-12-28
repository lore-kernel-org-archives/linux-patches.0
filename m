Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE46E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EEBC433D2;
	Wed, 28 Dec 2022 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239983;
	bh=42Y8QxZyZzt8It3aAKopBhcGIJD49TelzXjP2Zcvcz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gu94kikGV/6ul4MiQfoDIORdp9FD+QZNIISAgvpOM5NE5MUHAhQlDcFxnHlQwh91G
	 hfwnbFQwsOIXgIB3vUm6o3pzG1gUTvXmLylTbEhqS9uQAi/e5bK2W2DdNdUFo0I2Oj
	 U+1edakuSoD+DWeVekjfkbaB1mfuz8p6N0YyTohE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0104/1073] alpha: fix syscall entry in !AUDUT_SYSCALL case
Date: Wed, 28 Dec 2022 15:28:12 +0100
Message-Id: <20221228144330.871316366@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index e227f3a29a43..c41a5a9c3b9f 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -469,8 +469,10 @@ entSys:
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
 1:	jsr	$26, ($27), sys_ni_syscall
-- 
2.35.1



