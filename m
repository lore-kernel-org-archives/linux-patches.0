Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F9530595C;
	Tue,  6 Jan 2026 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722448; cv=none; b=bn5/AYBvMbKbLhu9ht0EAolihzKKPCkMBqCjrET6DNn+EILWrgweVfLs6+TgOKU0IDyMSIxECU/8qc7iZFebMCUzLIi/awFO4H8db+8wprf4R7j6G0E5j4E/a3g6QOrEu42kzOdPOSzf/VwlIy5KRNpkNVYMryL+5L2CD1ra4g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722448; c=relaxed/simple;
	bh=V6TvJTbC0eoe+0esIF8e7TtRZIHyXhicWKRXevDqLvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1KRl+Ty1U928uPDFKMDRM4BQryFdHRYgRJbcqgq3hezQWUHDxnYfVupW9feKP6R3p7o56TGWDBnjG5vw51PQDKnDHsHFRXMJv3/PoATUWOFRcPFi2j+3v9u3y9o3C73NBCItjAGHVEwqpL7yviOwaBLHUNDZOaPlZKwHQ071uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kykYsHbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kykYsHbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42B9C16AAE;
	Tue,  6 Jan 2026 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722448;
	bh=V6TvJTbC0eoe+0esIF8e7TtRZIHyXhicWKRXevDqLvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kykYsHbeWfHXDrHZ/NttI1skwZVBQmFr6g+JdIfrvUl7nex+2KvieQiWPeqog+c2j
	 s8TRnt88sRTELgrrWT6EW7mE6RN51n7ZY4V1WPwDIfnJPGWcZWbvJWHGhNCZiiEtNI
	 yhs2hGbf81HYomwpu9sTLl8PcItsb6dmtwv75J5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 235/312] samples/ftrace: Adjust LoongArch register restore order in direct calls
Date: Tue,  6 Jan 2026 18:05:09 +0100
Message-ID: <20260106170556.353647844@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -176,8 +176,8 @@ asm (
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
@@ -189,8 +189,8 @@ asm (
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
@@ -199,8 +199,8 @@ asm (
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
@@ -215,8 +215,8 @@ asm (
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
@@ -131,8 +131,8 @@ asm (
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
@@ -143,8 +143,8 @@ asm (
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
@@ -124,8 +124,8 @@ asm (
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


