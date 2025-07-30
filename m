Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B53A270ED4;
	Wed, 30 Jul 2025 09:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868782; cv=none; b=IPYBQ/zUMltM7BUXcgC8oJznErXTLoHYK4NvNqtKOPYgfcm2Rxu7DqRw/Hgk8LB+35RXYjKcb2KmC2GyiMJ9AFFu2Hjvd+4IS6SnN7cz4hKlf45SZGzT8XbTovfjJ+Tn9gJ2Hdk0TP6GoNYLbLlSoAuU5KQWeaCTyB3je7XrpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868782; c=relaxed/simple;
	bh=Ni7++IXiHaq5UzlAjeLDx7elOfcxz5DtncjkC9SQakA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR1DjBENnWXbw3UvJOWjTrYWaogkq2cQc/dNsNr6EAjO43VyKl0VI/SzJNU0jU9lfBwvnZxub5x+N/Dl0+ruQw+6Pyils41EbfWgf9691SlKV+hBmYAFVyIXAhkQKEVZTnzsjieRSqkO3xt39jepwMq/BfKjYTK5RscSeLQdjc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo73KoDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo73KoDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49230C4CEF5;
	Wed, 30 Jul 2025 09:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868780;
	bh=Ni7++IXiHaq5UzlAjeLDx7elOfcxz5DtncjkC9SQakA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo73KoDLqAYUJg++5HhtU8Vo7qLwdvnlLEbd1bxTIzZ5XT5weliuCYk+DbsSJ+RoY
	 pMKTUO95WPpF4H8sQKiGDW5k9enBK98I9uuiP4zA2dDgnyEjKWWyyC4X3RP1+WUo07
	 1aAczwwXcPrgySDzDBryPF/pDUFbsry6k2IjxAus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zhivich <mzhivich@akamai.com>
Subject: [PATCH 6.12 073/117] x86/bugs: Fix use of possibly uninit value in amd_check_tsa_microcode()
Date: Wed, 30 Jul 2025 11:35:42 +0200
Message-ID: <20250730093236.377924666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Michael Zhivich <mzhivich@akamai.com>

For kernels compiled with CONFIG_INIT_STACK_NONE=y, the value of __reserved
field in zen_patch_rev union on the stack may be garbage.  If so, it will
prevent correct microcode check when consulting p.ucode_rev, resulting in
incorrect mitigation selection.

This is a stable-only fix.

Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Zhivich <mzhivich@akamai.com>
Fixes: 7a0395f6607a5 ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -378,6 +378,8 @@ static bool amd_check_tsa_microcode(void
 	p.model		= c->x86_model;
 	p.ext_model	= c->x86_model >> 4;
 	p.stepping	= c->x86_stepping;
+	/* reserved bits are expected to be 0 in test below */
+	p.__reserved	= 0;
 
 	if (cpu_has(c, X86_FEATURE_ZEN3) ||
 	    cpu_has(c, X86_FEATURE_ZEN4)) {


