Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34FF35B121;
	Fri,  9 Jan 2026 12:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961113; cv=none; b=IVHKaqBBx1ZYQESTjtYWeilNCZzIfHIdGaha7UyQpOGkVz0meXrRKFclcaF/6a3yZ0CK2F/E/nOYfOcSh4p/lc2YI1WHwR0dGd8pKpdR2uGKNce6PG5W40I9P7D8lJ+YuireOj6SfAGzlLiwS0Qr3AcZlqwhma6d+r8o6N4gxng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961113; c=relaxed/simple;
	bh=yVWGZDzneT/qNASpI8n2yKDdtVbrXD8f/ycms/5M9yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU2wS7wIYcQQQcc/SXnyOuqT9sGb07Sx6yMAM6O9SZWZI4stpU2vqVdl78/sQIv4aNk9iRREnPRO/Mwk10Es8TTBN3Zt0RSe4ylrHWvrskxXrIvB0XpOtZ4MH4JDyJobJQI9RIQoMaCHk9s98AfR5I27fadgPAJaTnWVt+3do1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4jeQAY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4jeQAY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607A6C4CEF1;
	Fri,  9 Jan 2026 12:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961113;
	bh=yVWGZDzneT/qNASpI8n2yKDdtVbrXD8f/ycms/5M9yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4jeQAY8m2iZkP8GX0/dX7FhYLPfDlZiOU6DC2l/HagQgl9Y1CoRFtPG0fyghZlqp
	 UaY3MhLNKG0gGf2OMsURWq+gWcTR0qlj0GU+BWBhtcmzPgHJMTQK9uhA0/HDeHe1Lm
	 guH2d+4CxcF+PDfoJICfxcpnJlxQ2TxnWjB/0AVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 606/737] samples/ftrace: Adjust LoongArch register restore order in direct calls
Date: Fri,  9 Jan 2026 12:42:25 +0100
Message-ID: <20260109112156.802477086@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chenghao Duan <duanchenghao@kylinos.cn>

commit bb85d206be208bbf834883e948125a35ac59993a upstream.

Ensure that in the ftrace direct call logic, the CPU register state
(with ra = parent return address) is restored to the correct state after
the execution of the custom trampoline function and before returning to
the traced function. Additionally, guarantee the correctness of the jump
logic for jr t0 (traced function address).

Cc: stable@vger.kernel.org
Fixes: 9cdc3b6a299c ("LoongArch: ftrace: Add direct call support")
Reported-by: Youling Tang <tangyouling@kylinos.cn>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/ftrace/ftrace-direct-modify.c       |    8 ++++----
 samples/ftrace/ftrace-direct-multi-modify.c |    8 ++++----
 samples/ftrace/ftrace-direct-multi.c        |    4 ++--
 samples/ftrace/ftrace-direct-too.c          |    4 ++--
 samples/ftrace/ftrace-direct.c              |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -141,8 +141,8 @@ asm (
 "	st.d	$t0, $sp, 0\n"
 "	st.d	$ra, $sp, 8\n"
 "	bl	my_direct_func1\n"
-"	ld.d	$t0, $sp, 0\n"
-"	ld.d	$ra, $sp, 8\n"
+"	ld.d	$ra, $sp, 0\n"
+"	ld.d	$t0, $sp, 8\n"
 "	addi.d	$sp, $sp, 16\n"
 "	jr	$t0\n"
 "	.size		my_tramp1, .-my_tramp1\n"
@@ -154,8 +154,8 @@ asm (
 "	st.d	$t0, $sp, 0\n"
 "	st.d	$ra, $sp, 8\n"
 "	bl	my_direct_func2\n"
-"	ld.d	$t0, $sp, 0\n"
-"	ld.d	$ra, $sp, 8\n"
+"	ld.d	$ra, $sp, 0\n"
+"	ld.d	$t0, $sp, 8\n"
 "	addi.d	$sp, $sp, 16\n"
 "	jr	$t0\n"
 "	.size		my_tramp2, .-my_tramp2\n"
--- a/samples/ftrace/ftrace-direct-multi-modify.c
+++ b/samples/ftrace/ftrace-direct-multi-modify.c
@@ -158,8 +158,8 @@ asm (
 "	move	$a0, $t0\n"
 "	bl	my_direct_func1\n"
 "	ld.d	$a0, $sp, 0\n"
-"	ld.d	$t0, $sp, 8\n"
-"	ld.d	$ra, $sp, 16\n"
+"	ld.d	$ra, $sp, 8\n"
+"	ld.d	$t0, $sp, 16\n"
 "	addi.d	$sp, $sp, 32\n"
 "	jr	$t0\n"
 "	.size		my_tramp1, .-my_tramp1\n"
@@ -174,8 +174,8 @@ asm (
 "	move	$a0, $t0\n"
 "	bl	my_direct_func2\n"
 "	ld.d	$a0, $sp, 0\n"
-"	ld.d	$t0, $sp, 8\n"
-"	ld.d	$ra, $sp, 16\n"
+"	ld.d	$ra, $sp, 8\n"
+"	ld.d	$t0, $sp, 16\n"
 "	addi.d	$sp, $sp, 32\n"
 "	jr	$t0\n"
 "	.size		my_tramp2, .-my_tramp2\n"
--- a/samples/ftrace/ftrace-direct-multi.c
+++ b/samples/ftrace/ftrace-direct-multi.c
@@ -106,8 +106,8 @@ asm (
 "	move	$a0, $t0\n"
 "	bl	my_direct_func\n"
 "	ld.d	$a0, $sp, 0\n"
-"	ld.d	$t0, $sp, 8\n"
-"	ld.d	$ra, $sp, 16\n"
+"	ld.d	$ra, $sp, 8\n"
+"	ld.d	$t0, $sp, 16\n"
 "	addi.d	$sp, $sp, 32\n"
 "	jr	$t0\n"
 "	.size		my_tramp, .-my_tramp\n"
--- a/samples/ftrace/ftrace-direct-too.c
+++ b/samples/ftrace/ftrace-direct-too.c
@@ -115,8 +115,8 @@ asm (
 "	ld.d	$a0, $sp, 0\n"
 "	ld.d	$a1, $sp, 8\n"
 "	ld.d	$a2, $sp, 16\n"
-"	ld.d	$t0, $sp, 24\n"
-"	ld.d	$ra, $sp, 32\n"
+"	ld.d	$ra, $sp, 24\n"
+"	ld.d	$t0, $sp, 32\n"
 "	addi.d	$sp, $sp, 48\n"
 "	jr	$t0\n"
 "	.size		my_tramp, .-my_tramp\n"
--- a/samples/ftrace/ftrace-direct.c
+++ b/samples/ftrace/ftrace-direct.c
@@ -100,8 +100,8 @@ asm (
 "	st.d	$ra, $sp, 16\n"
 "	bl	my_direct_func\n"
 "	ld.d	$a0, $sp, 0\n"
-"	ld.d	$t0, $sp, 8\n"
-"	ld.d	$ra, $sp, 16\n"
+"	ld.d	$ra, $sp, 8\n"
+"	ld.d	$t0, $sp, 16\n"
 "	addi.d	$sp, $sp, 32\n"
 "	jr	$t0\n"
 "	.size		my_tramp, .-my_tramp\n"


