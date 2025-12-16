Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB4A25FA10;
	Tue, 16 Dec 2025 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883869; cv=none; b=JAkeviH4ZXFig0n6l4bRiST3ribKNZeodzVyWR7xVntYzeKaDmUmSf9Q7cp/lUIb92A8vKiAtg/ePeso75/HVKmLggiWpVVDZpzmQnTXd3v9vFnANwRW1HnPQL0jVX2tK7rb3CN1QE65Qt1AN3y1805iL4DCLa7GeSxL/kXumM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883869; c=relaxed/simple;
	bh=Xifj5F+qBj9BoyPZjiRf4AyfZYYMx2kwXsz5CXtL+5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6pGqbdFek/Evmz7Xxgk5NygLZdePAwT+/s1e15HxVZ9Qdkth0m6ntnxkgFg9jStBrXW9wWO6pbO8fYdpKzXnZuRPxxyP7An2/qnRSdV02Rzm8Ra4ZwhrzJwgNOXmLGi0ADJn+D26R8rQok1o95YnMOWpI6I2h8tN6cDV10d9qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHx4USku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHx4USku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F705C4CEF1;
	Tue, 16 Dec 2025 11:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883869;
	bh=Xifj5F+qBj9BoyPZjiRf4AyfZYYMx2kwXsz5CXtL+5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHx4USkuGgMPnwhhKz37zxeEsyiLFtu3QSHvG8fsFasabeDLPnHT9Yigxd03jd4Eu
	 plVk1TarOPRN/EEVCW+IG8aDZALN7fzQayI+gPo88FkyuTNffB/L6V7Pcqt4v3OWQD
	 afoBvz9wfE1vePybhBpTcj4o85ovkqkgU4dD1XdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Hatch <dylanbhatch@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/354] objtool: Fix standalone --hacks=jump_label
Date: Tue, 16 Dec 2025 12:09:50 +0100
Message-ID: <20251216111321.750825933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 59ca5b0c093d8..4adb3f3d9aed8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2671,7 +2671,8 @@ static int decode_sections(struct objtool_file *file)
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



