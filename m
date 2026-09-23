Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDA25372FD;
	Wed, 23 Sep 2026 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174796; cv=none; b=g0cOobLb62uc9ObtVhFlro5cZLjgojs7Np8gxBcc3roRoP5tzaqbp9mu7eLR0Xn8FydioUnR6/H0OmH40WwsEKnV+Xwe+ccTVL0Qd53ii99oPf/C1+HG+UGrNFMZFyXjAs7+3oi7ZFz3iEioxi8OTJgvEnEQhCuvktEO5Qv9PS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174796; c=relaxed/simple;
	bh=N69ygNlexApPM1iyBcxt6bHJ055KQAqVx4TwfV9VahQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC6+TLoRwCNXfXaBPELfim4BYUWBY8HdaMgTHv6cPdJHJzoL4BNTw8Qu8KWCyK++QuSZ9hYfgh0WR8yf0ga5mwA1+iISwqpZGlbktLZv59czSXgS2ou1tmM9c1R4iT2UxukyQHtc4vkHqHPZ630Rx5NlhC9mNuZZnlUYODu5xF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3bzHwfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3bzHwfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CB91F000FF;
	Wed, 23 Sep 2026 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174794;
	bh=UtlSLqGnw3g1DIh1BxKWbGukLfvN/qGggBS+pe8SZ4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3bzHwfJboOXCA4WxykrdByCPMj/9Px7jaaZl0VZcPQzE8g+Ynktn/47CtnlQSBx6
	 iU+VR9jrZp3YuQHVNQmopZiicG0QOLRk7Pj+RteCV3DEDv5VwrGWxEdVFezjcEpjcs
	 cbkSEqcKxmg7gyRPZ+l+9jj462Z5AyiwNeXQFeIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 228/398] arm64: hibernate: pass HVC_SET_VECTORS args to the resume hvc
Date: Wed, 23 Sep 2026 16:05:02 +0200
Message-ID: <20260923140649.329211722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Bradley Morgan <include@grrlz.net>

commit 955d86e5f3b95b731991fdb84966c50b16314629 upstream.

swsusp_arch_suspend_exit() reinstalls the restored kernel's hyp stub
vectors with an hvc, but never passes the arguments. x0 is not set to
HVC_SET_VECTORS and x1 is not set to the vector address, so the stub
dispatch falls through and returns without writing vbar_el2. EL2 is
left pointing at the trans_pgd copy of the vectors, a page that
swsusp_free() releases right after resume.

Set the arguments up the same way __hyp_set_vectors() does.

Without this fix, Vladimir was able to trigger a hang when resuming from
hibernation with CONFIG_PAGE_POISONING=y and page_poison=on.

Fixes: 788bfdd97434 ("arm64: trans_pgd: hibernate: Add trans_pgd_copy_el2_vectors")
Cc: stable@vger.kernel.org
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/hibernate-asm.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/hibernate-asm.S
+++ b/arch/arm64/kernel/hibernate-asm.S
@@ -89,6 +89,8 @@ alternative_insn "dc cvau, x4",  "dc civ
 	isb
 
 	cbz	x24, 3f		/* Do we need to re-initialise EL2? */
+	mov	x1, x24
+	mov	x0, #HVC_SET_VECTORS
 	hvc	#0
 3:	ret
 SYM_CODE_END(swsusp_arch_suspend_exit)


