Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D3049890;
	Mon, 18 Dec 2023 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZgCxVBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF868C433C8;
	Mon, 18 Dec 2023 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908580;
	bh=MGNbER9KFcGGqJ2eyTrj/QZXpoU5MX4gTXnCoeTExKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZgCxVBLh4jHdGD9b2YE44iWK0yV3KNc0+Q1MmiejSHgW9H94WWCBnBl0k5etWTCf
	 miow5dZbsgiJCxrXnSHtH/bHa1nMUqopA1I/A8PxaQ4HchKKP93W0CCUTyzrEn9In0
	 gALHwoM6ke0baJqQApJKHuVlKaePj0gs+TV3V5ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 62/62] powerpc/ftrace: Fix stack teardown in ftrace_no_trace
Date: Mon, 18 Dec 2023 14:52:26 +0100
Message-ID: <20231218135048.893095002@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

commit 4b3338aaa74d7d4ec5b6734dc298f0db94ec83d2 upstream.

Commit 41a506ef71eb ("powerpc/ftrace: Create a dummy stackframe to fix
stack unwind") added use of a new stack frame on ftrace entry to fix
stack unwind. However, the commit missed updating the offset used while
tearing down the ftrace stack when ftrace is disabled. Fix the same.

In addition, the commit missed saving the correct stack pointer in
pt_regs. Update the same.

Fixes: 41a506ef71eb ("powerpc/ftrace: Create a dummy stackframe to fix stack unwind")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231130065947.2188860-1-naveen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/trace/ftrace_64_mprofile.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
+++ b/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
@@ -55,7 +55,7 @@ _GLOBAL(ftrace_regs_caller)
 	SAVE_10GPRS(22, r1)
 
 	/* Save previous stack pointer (r1) */
-	addi	r8, r1, SWITCH_FRAME_SIZE
+	addi	r8, r1, SWITCH_FRAME_SIZE+STACK_FRAME_MIN_SIZE
 	std	r8, GPR1(r1)
 
 	/* Load special regs for save below */
@@ -150,7 +150,7 @@ ftrace_no_trace:
 	mflr	r3
 	mtctr	r3
 	REST_GPR(3, r1)
-	addi	r1, r1, SWITCH_FRAME_SIZE
+	addi	r1, r1, SWITCH_FRAME_SIZE+STACK_FRAME_MIN_SIZE
 	mtlr	r0
 	bctr
 


