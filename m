Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5DB34888F;
	Tue, 16 Dec 2025 11:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885158; cv=none; b=o0BGVr5092nMNRxodfHu8e+7CgO5aCyAI5AE5+sOd5U7EKUCbUmnX3WKz1Spw3xNG9ziFaXqMgveSfuGIpKgd9EmcPBGaIbKdUcuMke01ND3RAn6LhcMi7Dl1YK2yA0i6UStSx+v1h9ZMd8Ps6/OzpxdsaSF5oTontQVVENyUcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885158; c=relaxed/simple;
	bh=oQTxL2ijJwtDjmvRWG1utDaVI//vy9yNohG7f5O5T1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtJzLzoUW3DEyECs88JIMVzP//ME/TRTls4mfPM0y9csJ7D2cjhqLirtxNaxGC7jmoHpWCRxZyLQc8uz+vDuXl8boML482tZ0OKfSSmKE02sEEo4ZgiEqlIYhplxE/oCKquBE/I/JZ8qR2GS2++DeMv6L3/R6qSxLgukvGDIWj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2xvi736; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2xvi736"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23A8C4CEF1;
	Tue, 16 Dec 2025 11:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885158;
	bh=oQTxL2ijJwtDjmvRWG1utDaVI//vy9yNohG7f5O5T1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2xvi736WbklyDhV1tUT/iVtvQ1pi54rfzL4bOYjGVf7IcgyIVslv5tQfEn5M/UnW
	 /IPu57Ix2fgkan+8tZvi+VQECxJXBp2r2834YkgTj+MWLl4zxtdHgHyz98nbJNt5Wr
	 UJgNpXJPUTHCP9sSoGTPMgvgxAeUER1wW6dFpH9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Hatch <dylanbhatch@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 028/507] objtool: Fix standalone --hacks=jump_label
Date: Tue, 16 Dec 2025 12:07:49 +0100
Message-ID: <20251216111346.557894656@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Hatch <dylanbhatch@google.com>

[ Upstream commit be8374a5ba7cbab6b97df94b4ffe0b92f5c8a6d2 ]

The objtool command line 'objtool --hacks=jump_label foo.o' on its own
should be expected to rewrite jump labels to NOPs. This means the
add_special_section_alts() code path needs to run when only this option
is provided.

This is mainly relevant in certain debugging situations, but could
potentially also fix kernel builds in which objtool is run with
--hacks=jump_label but without --orc, --stackval, --uaccess, or
--hacks=noinstr.

Fixes: de6fbcedf5ab ("objtool: Read special sections with alts only when specific options are selected")
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index d23fefcb15d38..ac2b8813c4a0a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2563,7 +2563,8 @@ static int decode_sections(struct objtool_file *file)
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
-	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr) {
+	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr ||
+	    opts.hack_jump_label) {
 		ret = add_special_section_alts(file);
 		if (ret)
 			return ret;
-- 
2.51.0



