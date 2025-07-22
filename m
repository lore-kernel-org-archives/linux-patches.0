Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A785E2EE299;
	Tue, 22 Jul 2025 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193481; cv=none; b=mL3GFvGAL6kqQwqWHYp1ZeCTEVuLrrwCJEbTTVWu+gZzYl085Y45T6dv0+eaQ+f56BfmIDKwb1/IOD5Yj7qyBUnfxXVdYxbf5+TwMgPZUxYGan5DCksOln4VMTubqmN19EZTwm6QkmpNsiJSHCSMzrxOyxLARI0YFmENxk8aA3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193481; c=relaxed/simple;
	bh=OCZq9ED5B4HzvNgrKKr2WAVbErzPU4ZRupJp3itplmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ix7V3A3fOzgqh8RWbTp6fWiuFQb9UnMZYx/X8tmPoizwVVvYBlEgjP3hBzMdpc6JFsBlj4826pg+zp87w4ED1PY3lv3LEVsd25FvNcB58YF4UsZvu3AeKWZAHdQBkkySGvvVVnTirJRtZwxU2usDhM/wu1ezhYEuA3vuJlFzAlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1o/Xvt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1o/Xvt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A67C4CEEB;
	Tue, 22 Jul 2025 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193481;
	bh=OCZq9ED5B4HzvNgrKKr2WAVbErzPU4ZRupJp3itplmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1o/Xvt20kFkwT8CYTjKYsXnflyxkOwKqh+swwXyKlT524JL4KoXdlFIgYptFqqrz
	 z8Chhb7Bceryf5CyONat3RWg0jcGlA6V4TgRaeWeu7swjLSNRmK92DLrhqoxlkkcGP
	 9zSgLWb8KWd869N+eO8glIN3MouSF+bRaiwGn7SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.15 073/187] s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL again
Date: Tue, 22 Jul 2025 15:44:03 +0200
Message-ID: <20250722134348.450010459@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -544,7 +544,15 @@ static void bpf_jit_plt(struct bpf_plt *
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


