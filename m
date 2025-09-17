Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465B22C029C;
	Wed, 17 Sep 2025 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113315; cv=none; b=M+NCr3I96MEyZTmh7A0Q5z3DJBOiV1sQjX0SW9bN+q9dn4NifZRilVveCm5ElSc2N5pFwU/OqDOHn9sRGgsXhmniUiVlL3svlD6yWmoHXQf8mPbU4c6Rr3wD7LAAV7fgoQuwTTlE0LZgGKfBdZWOQBTb3k3Uvbsp1/QNlLEptws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113315; c=relaxed/simple;
	bh=cPjbg17bWBwZdy5vrPkHcI8xYcNWNuRTT3/ycvFgqNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tq5yMV4EgGYNe8DPr7zJ/Ijb1C61v1WEo9BeCzFE3H/NJf2Qe5QEjw2sHfTt0FA0AfMVNAzfihCTmDX7im+so2sIwWDHNmmaK/szOhtRxHitzAxQwbmXyiZSLglIKpDHiVJrmjPaVJtjgDKRjwiYnfYeMI725cZzGuGTg0mtcWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olfDr3a7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olfDr3a7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B7CC4CEF0;
	Wed, 17 Sep 2025 12:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113314;
	bh=cPjbg17bWBwZdy5vrPkHcI8xYcNWNuRTT3/ycvFgqNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olfDr3a7Rn25JR0Op0q0HuRaUBRd2ef3MjY3uylmeuiesdBagQtwsQ1qb2pFb8yaA
	 bUUaJN73Dc8TIlAkKYn0MosqgbgEhObAvalwa/HN9zuc9pN9wQfrdxWvNMyjaZWlRI
	 9EeFbme1gAUGqbZgg4QnJi9nJOUADAOOP5b0Y8Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/140] ftrace/samples: Fix function size computation
Date: Wed, 17 Sep 2025 14:33:23 +0200
Message-ID: <20250917123345.070326937@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 80d03a40837a9b26750a25122b906c052cc846c9 ]

In my_tramp1 function .size directive was placed above
ASM_RET instruction, leading to a wrong function size.

Link: https://lore.kernel.org/aK3d7vxNcO52kEmg@vova-pc
Fixes: 9d907f1ae80b ("samples/ftrace: Fix asm function ELF annotations")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/ftrace/ftrace-direct-modify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/ftrace/ftrace-direct-modify.c b/samples/ftrace/ftrace-direct-modify.c
index 81220390851a3..328c6e60f024b 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -75,8 +75,8 @@ asm (
 	CALL_DEPTH_ACCOUNT
 "	call my_direct_func1\n"
 "	leave\n"
-"	.size		my_tramp1, .-my_tramp1\n"
 	ASM_RET
+"	.size		my_tramp1, .-my_tramp1\n"
 
 "	.type		my_tramp2, @function\n"
 "	.globl		my_tramp2\n"
-- 
2.51.0



