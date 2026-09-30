Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACD931D366;
	Wed, 30 Sep 2026 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791792; cv=none; b=a/lQgpFYS9nQq6ZqqSZOKId0EsllJzlOcyMJgqzrIrP5D97zcZpnt2S+fxv0oTRlVqqZYDUeGmTBkOZ/eTj/NQNdl2fZF6FRsCuZUfoPNJ4vkjooZsohSwXt1V3kxIE6XGmpOLUvUnRLjXEJUh126lnQHPXvJz3IhL8XwPadGD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791792; c=relaxed/simple;
	bh=xb8SRmvsXcJCxipVSF2Pal3299cczmIy5PnNAxycF78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHegJXcqoJNt8FR+W0ZYYLT8z1mZLW4TEv5uxkFEBc04QH36AEum8VeaaaPp+55IeAizeSYyKOUxVGHdZUHEr2FNQajj/1ovbrD0brmap2/JAcmz2OkvJpI96n+iDZTtebA40tkyOY9TmL+AOtM0vbKYjdZ7a06jwxs/Up1gW4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNT//Mru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNT//Mru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402FB1F000FF;
	Wed, 30 Sep 2026 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791791;
	bh=Nep6Izkb8eHAnYO/OUDAiBxV6p698+TUFnTg3ePjEEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNT//Mru/oZOFLqCtlmT8jj1JnxlGv9/USYk72qQi7Xd/zwR2pqOQqxbe6VlHmVud
	 e88ujLyQlUkgK1f2CJFomJVmxnQLpW4UsNKqI5rwnTsFzCDWdPqzs5ViIIs/guna5j
	 IOqTj0dd4FYp9UU00/0IT9vmOLF/SSOvagJWGm9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/752] Revert "alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally"
Date: Wed, 30 Sep 2026 17:24:58 +0200
Message-ID: <20260930152407.546810378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit c01b31e8b402985cc0bd60c4dad8d10bc4644423.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/uapi/asm/fpu.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/fpu.h b/arch/alpha/include/uapi/asm/fpu.h
index d28dc36786e27..cea9eafa056fc 100644
--- a/arch/alpha/include/uapi/asm/fpu.h
+++ b/arch/alpha/include/uapi/asm/fpu.h
@@ -101,12 +101,7 @@ ieee_swcr_to_fpcr(unsigned long sw)
 		      | IEEE_TRAP_ENABLE_OVF)) << 48;
 	fp |= (~sw & (IEEE_TRAP_ENABLE_UNF | IEEE_TRAP_ENABLE_INE)) << 57;
 	fp |= (sw & IEEE_MAP_UMZ ? FPCR_UNDZ | FPCR_UNFD : 0);
-	/*
-	 * Disable denormal operand traps only when denormal inputs are to be
-	 * flushed to zero.  Otherwise they must keep trapping, so that /S
-	 * instructions reach the kernel emulation handler.
-	 */
-	fp |= (sw & IEEE_MAP_DMZ ? FPCR_DNOD : 0);
+	fp |= (~sw & IEEE_TRAP_ENABLE_DNO) << 41;
 	return fp;
 }
 
@@ -121,6 +116,7 @@ ieee_fpcr_to_swcr(unsigned long fp)
 			     | IEEE_TRAP_ENABLE_OVF);
 	sw |= (~fp >> 57) & (IEEE_TRAP_ENABLE_UNF | IEEE_TRAP_ENABLE_INE);
 	sw |= (fp >> 47) & IEEE_MAP_UMZ;
+	sw |= (~fp >> 41) & IEEE_TRAP_ENABLE_DNO;
 	return sw;
 }
 
-- 
2.53.0



