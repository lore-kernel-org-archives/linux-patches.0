Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F6336124;
	Wed, 30 Jul 2025 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868397; cv=none; b=k4ftC/R4zN9KxkpWS/LiT2eUjR4HUK8bkveugvbmpUD2WzZuSv64cWwcQczrZf3r8e9nE44zQO+NxXjh/6bNQIlZjEH9U5sY8Tg0hsfwQwvz+NCgSvpTsQiAo03cWKU/dZBCOczjfUQzoZJNucumb6Kb4VM5BbUZVYW2RgIWtIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868397; c=relaxed/simple;
	bh=brHKyzCC/Vkfkx4bCgUkTyXwk266HC46y1YCG1s90oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1pQUFRHaFpkeS5njo3r6zYh9uhBV9HYph1CuMg01gMES8nlFmJfW2P99XjPtjNnzZ3MI6PpPyj29w/XZrW6HL+lRss7jYgoUreTUD6CWoTftjcLwUnGCAms0at1++cT1A35/a6zng/6M7Mie1/dm7aihDuBcLU4xrh+UauPt9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frFleaRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frFleaRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E406EC4CEE7;
	Wed, 30 Jul 2025 09:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868397;
	bh=brHKyzCC/Vkfkx4bCgUkTyXwk266HC46y1YCG1s90oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frFleaREJUtTVUGNFAKvTCg8qIdmakQlAAN+mWDBEpDwY18WfJ7Up+gPDPeFLSE+C
	 02+5ZeQLtJhupEGcv0vlCL9jaCcOosEBtOPVbe4GzSq9bEAsosfilgCdvgGNPnIkZy
	 U7dX0hRhuZHDSvj0lQPXtr0fFPvYwzplISZgLJHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zhivich <mzhivich@akamai.com>
Subject: [PATCH 6.6 52/76] x86/bugs: Fix use of possibly uninit value in amd_check_tsa_microcode()
Date: Wed, 30 Jul 2025 11:35:45 +0200
Message-ID: <20250730093228.861559347@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

From: Michael Zhivich <mzhivich@akamai.com>

For kernels compiled with CONFIG_INIT_STACK_NONE=y, the value of __reserved
field in zen_patch_rev union on the stack may be garbage.  If so, it will
prevent correct microcode check when consulting p.ucode_rev, resulting in
incorrect mitigation selection.

This is a stable-only fix.

Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Zhivich <mzhivich@akamai.com>
Fixes: 90293047df18 ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -549,6 +549,8 @@ static bool amd_check_tsa_microcode(void
 	p.model		= c->x86_model;
 	p.ext_model	= c->x86_model >> 4;
 	p.stepping	= c->x86_stepping;
+	/* reserved bits are expected to be 0 in test below */
+	p.__reserved	= 0;
 
 	if (cpu_has(c, X86_FEATURE_ZEN3) ||
 	    cpu_has(c, X86_FEATURE_ZEN4)) {


