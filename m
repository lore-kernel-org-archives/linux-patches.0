Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C658621B196;
	Tue,  6 Jan 2026 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721128; cv=none; b=jUJn8vAxbib0H6XyMa+gJ9ohLDXjJ22H50uZgwt7Z/zgrmijAgD8iBFdaG/nnvnDQ2SYxNgt1mVGYO9OPTB38a8yuIItOMVzX/D4H6ZaFI6HeCO+43VUZWzfpEpj+WK1AY99KCpZ5gDfxgDcffp8v3YKIVXwYGHxlCYJuKgu9Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721128; c=relaxed/simple;
	bh=y2qZBTBJ16kbZOtPZgHvzyNrGOnKpXYtKsaOudMDAeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1EptRHXis7petSGiOlAC3wQ7s8qBM0Vb30bdNV9Sy1jfTcWH+O8yGTqOu52Vb+PdvrCZSNZ03H6vagxLCh6N8FAJwO+PuywMishUFykZME0qQjkq0KbH2zevJaq7eOXvaEPTeTnSdrF8IiGhB6fXMMjz9s2skbLdJLIC9b+Kzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYLXd1qD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYLXd1qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D3CC116C6;
	Tue,  6 Jan 2026 17:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721128;
	bh=y2qZBTBJ16kbZOtPZgHvzyNrGOnKpXYtKsaOudMDAeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYLXd1qDninV6jTlQpwt+JAJ7SmJ4KwR5paBq1gxB4c3E1ePdtV0OH8ZIkZ0mlS9Z
	 JdvNaBZni/v4so2zAMUktUqLjs0Ssob7YiYZLuMaZAdAbLfMkqEvo0r2CZAWnkoo4k
	 XL7oziw1b/XvJrHU8OAP2dxm+S1uJ9SCa7YAmgyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 444/567] samples/ftrace: Adjust LoongArch register restore order in direct calls
Date: Tue,  6 Jan 2026 18:03:46 +0100
Message-ID: <20260106170507.775416706@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


