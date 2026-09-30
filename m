Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B820C497B61;
	Wed, 30 Sep 2026 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788597; cv=none; b=U5v3DBVNeh6tu1MgV+DEp5oLAnl5UxI70U9BiXnSRmwN1c3wxVlcGWzQ5qxw+IIK3boauaV4BrnBl7hYn44G95QQ6ffuvDXlEW/nsq96XCxVAp8QTUS3uBID6srPaaPMjPfn1o04rANT7F1K8ssSdReSz00L14V4+3dG49xU/oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788597; c=relaxed/simple;
	bh=lPQrc/XO4+O2Jf2jLcq1T2l+3kXybStNhtCjOzi9Tsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWlUGEKaQJoWr2iIIbRjczQW5QCoEIcSBOg00UbrldthDAO9BXRgX8j8zAc52WJssf3SdrvDfquqNb3AyFmtDwSnI8PSxKgYtkmxAMiwwW5NzsrA+mFgccfdJ3gAwSMObb1EM1Hs73JmeFikHp8+BD9MyAPGYgc7lBEgCVNuaV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEXt/R+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEXt/R+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D291F000FF;
	Wed, 30 Sep 2026 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788594;
	bh=ehLVmrsdN49g8W2/xGJsloafyI4xtTrKrZ6JIPVkUD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEXt/R+yRJWthxmYHEo9Di736tDvukkWPSZzwfnNtm+XN3pH885FXSFD4C+3K4jVP
	 Tx4Oq+Uju7TKNT8tgi35sZ3rs3dGyh/gCO4DUE2g41fREplASA3WRkrjO4yFNfP6YF
	 poIH1vhIdejsAE/z+72JJ76NtRD8a7uzn0FhyuS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 180/877] arm64: hibernate: pass HVC_SET_VECTORS args to the resume hvc
Date: Wed, 30 Sep 2026 17:18:11 +0200
Message-ID: <20260930152418.613294996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Bradley Morgan <include@grrlz.net>

commit 955d86e5f3b95b731991fdb84966c50b16314629 upstream.

swsusp_arch_suspend_exit() reinstalls the restored kernel's hyp stub
vectors with an hvc, but never passes the arguments. x0 is not set to
HVC_SET_VECTORS and x1 is not set to the vector address, so the stub
dispatch falls through and returns without writing vbar_el2. EL2 is
left pointing at the trans_pgd copy of the vectors, a page that
swsusp_free() releases right after resume.

Set the arguments up the same way __hyp_set_vectors() does.

Without this fix, Vladimir was able to trigger a hang when resuming from
hibernation with CONFIG_PAGE_POISONING=y and page_poison=on.

Fixes: 788bfdd97434 ("arm64: trans_pgd: hibernate: Add trans_pgd_copy_el2_vectors")
Cc: stable@vger.kernel.org
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/hibernate-asm.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/hibernate-asm.S
+++ b/arch/arm64/kernel/hibernate-asm.S
@@ -89,6 +89,8 @@ alternative_insn "dc cvau, x4",  "dc civ
 	isb
 
 	cbz	x24, 3f		/* Do we need to re-initialise EL2? */
+	mov	x1, x24
+	mov	x0, #HVC_SET_VECTORS
 	hvc	#0
 3:	ret
 SYM_CODE_END(swsusp_arch_suspend_exit)


