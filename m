Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A11E79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A69C433D2;
	Thu, 12 Jan 2023 14:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533326;
	bh=F9n7AZkWBkEHpuUdOvX6pL4BkYIT9fgyn8/4D80uZDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3UgyGKBq/6pkeBo6W10J9V+gc7te6zgVdvbElB0Hm6DYmB1QOPFV/iKC2sxHUZ8f
	 rx831XCTQ7JVsuIgqxqomlXZ7gL/buNGfCN86zwLEJNgK6QbZMUrhIOEPqnLuSoKws
	 S78ebG4AuxRqrBp2XqF+H/71e4fjwRk9wgyN9Uj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/783] powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds
Date: Thu, 12 Jan 2023 14:52:31 +0100
Message-Id: <20230112135544.479667734@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 1c4a4a4c8410be4a231a58b23e7a30923ff954ac ]

When building with automatic stack variable initialization, GCC 12
complains about variables defined outside of switch case statements.
Move the variable into the case that uses it, which silences the warning:

arch/powerpc/xmon/xmon.c: In function ‘bpt_cmds’:
arch/powerpc/xmon/xmon.c:1529:13: warning: statement will never be executed [-Wswitch-unreachable]
 1529 |         int mode;
      |             ^~~~

Fixes: 09b6c1129f89 ("powerpc/xmon: Fix compile error with PPC_8xx=y")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/YySE6FHiOcbWWR+9@work
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index c6a36b4045e8..2872b66d9fec 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1433,9 +1433,9 @@ bpt_cmds(void)
 	cmd = inchar();
 
 	switch (cmd) {
-	static const char badaddr[] = "Only kernel addresses are permitted for breakpoints\n";
-	int mode;
-	case 'd':	/* bd - hardware data breakpoint */
+	case 'd': {	/* bd - hardware data breakpoint */
+		static const char badaddr[] = "Only kernel addresses are permitted for breakpoints\n";
+		int mode;
 		if (xmon_is_ro) {
 			printf(xmon_ro_msg);
 			break;
@@ -1468,6 +1468,7 @@ bpt_cmds(void)
 
 		force_enable_xmon();
 		break;
+	}
 
 	case 'i':	/* bi - hardware instr breakpoint */
 		if (xmon_is_ro) {
-- 
2.35.1



