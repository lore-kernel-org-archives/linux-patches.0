Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F583176E4;
	Wed,  8 Apr 2026 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674107; cv=none; b=ci9SjmpRRBWfPZTOFB2B9ZM2hDV2HSosm9eikgAf1YbeK1wtoeKdk2WZbuR++JbvBUzouUQjNTcR+COjTtdR2dM3hWjPozKWWse0HXr8/y0HjHCz3gVp4cv0uSLSZlKRlzvFnmkQptumzOYDIL8Z5dsgRsWLsWPRV7N/RVUY2fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674107; c=relaxed/simple;
	bh=q8slEUg3QgxrW9TRgHqYdag7SmT69QVvJlMvPffFqWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB5llIySA6ZH/tM32/ZIsUhE8X7kePtZA805mBkrEuU0q9M8glteefb56fC31Yrm4PJCAku0cKOmtJft28lgIfJzyXU3cQXAyLHleh6twfTWOqnv+bx7+GQc2v+eZ5TiKvC7EG0tm0M+wWWa4GHCBUQL8EDeWslcaZvJqAyqCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L54HqKwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L54HqKwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9D8C2BCB1;
	Wed,  8 Apr 2026 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674107;
	bh=q8slEUg3QgxrW9TRgHqYdag7SmT69QVvJlMvPffFqWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L54HqKwp8qX8ZHWTWxmTKzLTMDKnnPpFavv6teqIFq7z2DL1rrepUH7WzNHcxuk0x
	 e/TU4qdge667frzkvrbwdaW2kDowV+ui4YQyJPh22DsipUjldHvSzm1KLDD33vChJ1
	 2PxQAs9DvF1RCHyCqVEDB5O0hHMSdPnfR6/gsI9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/242] Revert "LoongArch/orc: Use RCU in all users of __module_address()."
Date: Wed,  8 Apr 2026 20:03:30 +0200
Message-ID: <20260408175933.450777613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

This reverts commit 2e6949777d1dbfa5c906a880028680cc3ebe1f68.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_orc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index 59809c3406c03..471652c0c8653 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -399,7 +399,7 @@ bool unwind_next_frame(struct unwind_state *state)
 		return false;
 
 	/* Don't let modules unload while we're reading their ORC data. */
-	guard(rcu)();
+	preempt_disable();
 
 	if (is_entry_func(state->pc))
 		goto end;
@@ -514,12 +514,14 @@ bool unwind_next_frame(struct unwind_state *state)
 	if (!__kernel_text_address(state->pc))
 		goto err;
 
+	preempt_enable();
 	return true;
 
 err:
 	state->error = true;
 
 end:
+	preempt_enable();
 	state->stack_info.type = STACK_TYPE_UNKNOWN;
 	return false;
 }
-- 
2.53.0



