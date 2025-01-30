Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669A01E522;
	Thu, 30 Jan 2025 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247221; cv=none; b=NkPudA3lo6EL1cDehrNW30TUfs6sJetQqLswdZB+3J+bVP+V3Ysk2UKffXjEBy9ENeMDM14lTmZO/oAM1ZYqvfWebBN0rYgZVUlBVEfMrir4zZCeGzb1UZa44yCMKtBunRX5cC9USYPgxn+neboiuNqjjy6a6ppkuqQLH9ATuUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247221; c=relaxed/simple;
	bh=AonuH7t9rRb/xcLVyTl6gSeINaZV5Z6ov8IXj0821UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VazkvmIB9W+iiUYuKC2cy6fCmOOFPGNcW3c3gss5NpYGAd2D0QoIuFq/5F+p440Dgsnmx86inN/K6SRbReGje3BvLZ8M9+puyccweaxeKImcuJxcgftorRC8CO3dudJ8EcRFrcbVgKQAWptDVcxZkqg4SyDpYVQ8bu1rP4JMmbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z66pknyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z66pknyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD022C4CED2;
	Thu, 30 Jan 2025 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247221;
	bh=AonuH7t9rRb/xcLVyTl6gSeINaZV5Z6ov8IXj0821UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z66pknyp7C4gE220wbk+D1LYQWV62rQvyevJSopzpSQo2oIfXqm3wtz1F7Zk0elZ5
	 xkbcAS+rp5czatxWgMA9GdDH4/dxPDCAMFTsovk5EP7/XWrbQDq2/ndm2yOouiEjej
	 ilCmLw64ZrCnbvk//cvzQqgFQsFGYy6KQpGSgKbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.10 123/133] m68k: Update ->thread.esp0 before calling syscall_trace() in ret_from_signal
Date: Thu, 30 Jan 2025 15:01:52 +0100
Message-ID: <20250130140147.484112328@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 50e43a57334400668952f8e551c9d87d3ed2dfef upstream.

We get there when sigreturn has performed obscene acts on kernel stack;
in particular, the location of pt_regs has shifted.  We are about to call
syscall_trace(), which might stop for tracer.  If that happens, we'd better
have task_pt_regs() returning correct result...

Fucked-up-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: bd6f56a75bb2 ("m68k: Missing syscall_trace() on sigreturn")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/YP2dMWeV1LkHiOpr@zeniv-ca.linux.org.uk
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/kernel/entry.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -189,6 +189,8 @@ ENTRY(ret_from_signal)
 	movel	%curptr@(TASK_STACK),%a1
 	tstb	%a1@(TINFO_FLAGS+2)
 	jge	1f
+	lea	%sp@(SWITCH_STACK_SIZE),%a1
+	movel	%a1,%curptr@(TASK_THREAD+THREAD_ESP0)
 	jbsr	syscall_trace
 1:	RESTORE_SWITCH_STACK
 	addql	#4,%sp


