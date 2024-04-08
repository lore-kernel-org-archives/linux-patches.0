Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23E27FBDF;
	Mon,  8 Apr 2024 13:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583806; cv=none; b=T8Nsgpaf8H2FwhtADGwUuoH9iP3+9QbJkqbB1Q9O95FZqiV6aWWfPhmz6cpKsh22+Jk+S/TXQjfxxPa44uSJgOUqIJU0xWjXDBrjnWS/p/2mXYsFJpV8DI/sV5byTbIYbLxHR4pZ3PEDHkHtSRor6NcbsRw0scG53yL+3jbvcuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583806; c=relaxed/simple;
	bh=oTZ33Dphkek/5F7wDlndm612/kRtIAJMKWk8rbfBfjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMDrBxdbbkv5AIQ1vaOveQU+pVdUvHJoUaDVZbt6oJpq+2LjHj4yOXZYQWlcmBW7F9ljKGma2VYVYI9Uq2qwSmc24dgaDwBTZIiVit4BDCkMn2vNVI2XPoEpagkRSE8zZoQZ01R/CAdn9LLZLKjrwi0u62wavOUkXq9A41W3A9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqk56xjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqk56xjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A805C43390;
	Mon,  8 Apr 2024 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583806;
	bh=oTZ33Dphkek/5F7wDlndm612/kRtIAJMKWk8rbfBfjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqk56xjOCjJsoZWznGOE3V7uEmao24uN/J2khA+yIY+/d45/vzlil3q6WEu7u61wx
	 udYv3ea1FzecygL47ExbdjPwm/WsE9+VtZUPrNRjd5u9zQik7wuLjuCbm53JxfozIm
	 pLsGkUAZU+NdLEseuexVbXlGyN7RT75nWaTTWYYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.8 194/273] x86/retpoline: Add NOENDBR annotation to the SRSO dummy return thunk
Date: Mon,  8 Apr 2024 14:57:49 +0200
Message-ID: <20240408125315.351385873@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit b377c66ae3509ccea596512d6afb4777711c4870 upstream.

srso_alias_untrain_ret() is special code, even if it is a dummy
which is called in the !SRSO case, so annotate it like its real
counterpart, to address the following objtool splat:

  vmlinux.o: warning: objtool: .export_symbol+0x2b290: data relocation to !ENDBR: srso_alias_untrain_ret+0x0

Fixes: 4535e1a4174c ("x86/bugs: Fix the SRSO mitigation on Zen3/4")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240405144637.17908-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -230,6 +230,7 @@ SYM_CODE_END(srso_return_thunk)
 /* Dummy for the alternative in CALL_UNTRAIN_RET. */
 SYM_CODE_START(srso_alias_untrain_ret)
 	ANNOTATE_UNRET_SAFE
+	ANNOTATE_NOENDBR
 	ret
 	int3
 SYM_FUNC_END(srso_alias_untrain_ret)


