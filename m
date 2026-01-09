Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434E32BF21;
	Fri,  9 Jan 2026 11:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959462; cv=none; b=Oe51354bvzrvi1OAZ0E5JjSn9pThgwNb1cbjbxrgs0vpNLEO2u0G3X12Vld5tfdjd7oaVYzblXr2wRPwhUA5JTo/bFy9ZOQ2Dh5PoJGdD9f27IlBgebp17WoUXnNjquS5vrXnNR3q2dsXSFcszoJ15bJR82Vhs/XKeaWzRfQ/NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959462; c=relaxed/simple;
	bh=5G1AqviVlE71JX8f3f2v0pz2qvKecElcIWnw23EceGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcrzR/mnJeI0muBhl6Jxl8scukPpmkbBEpd6HyH9HfOTBkcbFqGou4AmNIXr8fcTXcYmy2GXc4cE5L6gX+nZMiPS4/rY7fNRSuAl3Rfvg0puL6vr4H7cKG44TarQhS0f59ho73+G7fjioeyWG9nKufDldM+DAq0meEPo3vLGCQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKP0Jv2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKP0Jv2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD67C4CEF1;
	Fri,  9 Jan 2026 11:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959462;
	bh=5G1AqviVlE71JX8f3f2v0pz2qvKecElcIWnw23EceGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKP0Jv2lqjS+9lgzijjD3v6d0HBBrl2W90Y4AAttGby/t8AVgvg0/K9s6HectZp/r
	 5Rijl6nLFqQir2bMk9ZI1qayBRfuQBMKUFxUcZYh4F3WW2c+pL2Hlm/5AvGKmuI8eJ
	 jfk8ZgjxJvM+pyKjrOkUU+szKqtANqQSuN6Tt1Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Hatch <dylanbhatch@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/737] objtool: Fix standalone --hacks=jump_label
Date: Fri,  9 Jan 2026 12:33:19 +0100
Message-ID: <20260109112136.250373526@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f8e676a6e6f8e..c021798ba8372 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2619,7 +2619,8 @@ static int decode_sections(struct objtool_file *file)
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



