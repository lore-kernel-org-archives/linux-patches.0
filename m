Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1042EA475;
	Tue, 22 Jul 2025 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192359; cv=none; b=e0j2SYAB6YiTuSvuZs9Ff2lm1C9XUPtQad5QMBe33v4BtKplaVKzFXZQuCaKSD9bNjZGFdgTOpzKH8OZ8IhTDgOTAlLBhmH9xFvFGcGTYU3wptoT+ZtVcSOKzy2lHckmLuq2zOXz9bXuhglkC+5vmunsU4MaA9/iUCBOJRUDMxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192359; c=relaxed/simple;
	bh=T0d6PkC4q1v1Nhhn8iKg/SgfTTYy0/U6XyfYmNmf43E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM25sPaaT09AB0mUhqVy+0vZDeGKp/KJLulIpIaWXKdqKTz6QAn9m17zfrQLWFL5pDZv7rvwJSwSXNuvHvd65qjG4VD4jqDBOQZYK9LtDcqyLMON8u+Nr2U7n8xckt+vqw7zr4i8zydBP1aNeTtZBZZeVzfQs4Ty/HypOso4uDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUyGxY+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUyGxY+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEFBC4CEEB;
	Tue, 22 Jul 2025 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192359;
	bh=T0d6PkC4q1v1Nhhn8iKg/SgfTTYy0/U6XyfYmNmf43E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUyGxY+nPDKwmsjTsRqKnzPpkvhwWJbxWmGSD6cLQk+KSBeKFt3D+04AJUymtv5ft
	 /UAKVTKDpX+SBVEXcj1VNUfvDJ5IDKui4sqwbiQ3ZZOzUmQNYkZcf9uyz+8ydA3sOu
	 taGa/qpcAdfH9Raw8dE6nkSX3pYDtw/b7NaXZtJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 043/111] s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL again
Date: Tue, 22 Jul 2025 15:44:18 +0200
Message-ID: <20250722134334.999390774@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit 6a5abf8cf182f577c7ae6c62f14debc9754ec986 upstream.

Commit 7ded842b356d ("s390/bpf: Fix bpf_plt pointer arithmetic") has
accidentally removed the critical piece of commit c730fce7c70c
("s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL"), causing
intermittent kernel panics in e.g. perf's on_switch() prog to reappear.

Restore the fix and add a comment.

Fixes: 7ded842b356d ("s390/bpf: Fix bpf_plt pointer arithmetic")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20250716194524.48109-2-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/net/bpf_jit_comp.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -539,7 +539,15 @@ static void bpf_jit_plt(struct bpf_plt *
 {
 	memcpy(plt, &bpf_plt, sizeof(*plt));
 	plt->ret = ret;
-	plt->target = target;
+	/*
+	 * (target == NULL) implies that the branch to this PLT entry was
+	 * patched and became a no-op. However, some CPU could have jumped
+	 * to this PLT entry before patching and may be still executing it.
+	 *
+	 * Since the intention in this case is to make the PLT entry a no-op,
+	 * make the target point to the return label instead of NULL.
+	 */
+	plt->target = target ?: ret;
 }
 
 /*


