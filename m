Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0941C89;
	Mon,  1 Apr 2024 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989241; cv=none; b=sqUwzFHcNkJzw4DxmFe/pmT9kz+1JKG8vNtKCb57R5whyRzLdW6hYWCn7P0ZqFBxkwt5yZDyLvyDErh6r/NqhHUdVyDw6/PEmu7o2gvIq1FM9SGRmWeK/tZsIqB0qIZpcgXY0zQLW3Xxewt66lPWaTqVlZO9gPtp3HQFAjv7md0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989241; c=relaxed/simple;
	bh=987qMbZ6r2R0yPjXgjWoTvG0ld2tFw3cI3n2eJ7scQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGNmWxtcwbr/e38K67qU9WItakIv2mlEDNzNpz6tcwZMoQYI0mkqav9vXQ3EOPlETsiM0QI/+haTCd6BwjT1oDHQJHW2lVtq9PoDiRbUP6xRVjvM/x7erlYGpp9EH+4cR71MYowwNUmxiCOPWQOBUNKsGh4AvTaLUd5L/3bYIdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSfbqbKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSfbqbKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10E3C433C7;
	Mon,  1 Apr 2024 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989241;
	bh=987qMbZ6r2R0yPjXgjWoTvG0ld2tFw3cI3n2eJ7scQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSfbqbKjTwyeJJWf1QAXoyE0uwhHmv2lEBdO4/YmAfejA27dm1PCWhng9z9SzRnqO
	 sHj0OSUlxmyKMjMCKu/tGbTjnfuUnGoBrDkSlQknG6fudsjGgqLjlXG3GXe9m3i0R/
	 +cawund48aPp0z9VMBPVvloUaI2Ay8QukGXmrr+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.7 424/432] x86/bugs: Use fixed addressing for VERW operand
Date: Mon,  1 Apr 2024 17:46:51 +0200
Message-ID: <20240401152606.074272629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 8009479ee919b9a91674f48050ccbff64eafedaa upstream.

The macro used for MDS mitigation executes VERW with relative
addressing for the operand. This was necessary in earlier versions of
the series. Now it is unnecessary and creates a problem for backports
on older kernels that don't support relocations in alternatives.
Relocation support was added by commit 270a69c4485d ("x86/alternative:
Support relocations in alternatives").  Also asm for fixed addressing
is much cleaner than relative RIP addressing.

Simplify the asm by using fixed addressing for VERW operand.

[ dhansen: tweak changelog ]

Closes: https://lore.kernel.org/lkml/20558f89-299b-472e-9a96-171403a83bd6@suse.com/
Fixes: baf8361e5455 ("x86/bugs: Add asm helpers for executing VERW")
Reported-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240226-verw-arg-fix-v1-1-7b37ee6fd57d%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -332,7 +332,7 @@
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
 .macro CLEAR_CPU_BUFFERS
-	ALTERNATIVE "", __stringify(verw _ASM_RIP(mds_verw_sel)), X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "", __stringify(verw mds_verw_sel), X86_FEATURE_CLEAR_CPU_BUF
 .endm
 
 #else /* __ASSEMBLY__ */


