Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED88522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501B2C433C7;
	Sun,  9 Jul 2023 11:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902422;
	bh=B32SVhQMe+FpiMbO6keH5Pk5eWOnQv6AS1MyQdnAyUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUkM6SbyHt8FZE0Hb6VF5QGNDxw+JPoH0lYkO8e2jndRvqXtVlWvDpd6pRuqJQFLb
	 kwhTag8YXWMwgRHPwTIu8efbUf47SyDeU9Hjg0xLcgKqQcPyq18eJEyUYAuJ6w68qO
	 swIPwJ2CYRrV4vq8UUKwGR7W7PwPZd2v2/GkIqP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 371/431] powerpc/signal32: Force inlining of __unsafe_save_user_regs() and save_tm_user_regs_unsafe()
Date: Sun,  9 Jul 2023 13:15:19 +0200
Message-ID: <20230709111459.860958592@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit a03b1a0b19398a47489fdcef02ec19c2ba05a15d ]

Looking at generated code for handle_signal32() shows calls to a
function called __unsafe_save_user_regs.constprop.0 while user access
is open.

And that __unsafe_save_user_regs.constprop.0 function has two nops at
the begining, allowing it to be traced, which is unexpected during
user access open window.

The solution could be to mark __unsafe_save_user_regs() no trace, but
to be on the safe side the most efficient is to flag it __always_inline
as already done for function __unsafe_restore_general_regs(). The
function is relatively small and only called twice, so the size
increase will remain in the noise.

Do the same with save_tm_user_regs_unsafe() as it may suffer the
same issue.

Fixes: ef75e7318294 ("powerpc/signal32: Transform save_user_regs() and save_tm_user_regs() in 'unsafe' version")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/7e469c8f01860a69c1ada3ca6a5e2aa65f0f74b2.1685955220.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/signal_32.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index c114c7f25645c..7a718ed32b277 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -264,8 +264,9 @@ static void prepare_save_user_regs(int ctx_has_vsx_region)
 #endif
 }
 
-static int __unsafe_save_user_regs(struct pt_regs *regs, struct mcontext __user *frame,
-				   struct mcontext __user *tm_frame, int ctx_has_vsx_region)
+static __always_inline int
+__unsafe_save_user_regs(struct pt_regs *regs, struct mcontext __user *frame,
+			struct mcontext __user *tm_frame, int ctx_has_vsx_region)
 {
 	unsigned long msr = regs->msr;
 
@@ -364,8 +365,9 @@ static void prepare_save_tm_user_regs(void)
 		current->thread.ckvrsave = mfspr(SPRN_VRSAVE);
 }
 
-static int save_tm_user_regs_unsafe(struct pt_regs *regs, struct mcontext __user *frame,
-				    struct mcontext __user *tm_frame, unsigned long msr)
+static __always_inline int
+save_tm_user_regs_unsafe(struct pt_regs *regs, struct mcontext __user *frame,
+			 struct mcontext __user *tm_frame, unsigned long msr)
 {
 	/* Save both sets of general registers */
 	unsafe_save_general_regs(&current->thread.ckpt_regs, frame, failed);
@@ -444,8 +446,9 @@ static int save_tm_user_regs_unsafe(struct pt_regs *regs, struct mcontext __user
 #else
 static void prepare_save_tm_user_regs(void) { }
 
-static int save_tm_user_regs_unsafe(struct pt_regs *regs, struct mcontext __user *frame,
-				    struct mcontext __user *tm_frame, unsigned long msr)
+static __always_inline int
+save_tm_user_regs_unsafe(struct pt_regs *regs, struct mcontext __user *frame,
+			 struct mcontext __user *tm_frame, unsigned long msr)
 {
 	return 0;
 }
-- 
2.39.2



