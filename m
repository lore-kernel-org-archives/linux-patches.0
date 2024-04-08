Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E587D06E;
	Mon,  8 Apr 2024 13:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582500; cv=none; b=qqZ0qqM7mpxp+VWEEeY6CfG8/E4VCcGNXxaXc+WOQbI2bMuyKuAmakMGy2cQhmoXokzVvxf0y3SqZMKMhZs8+nKHKWhyWrrMPt2/h4ahRyZi07GyjzGR+BM364qC6ZmvxkK3Q3rdeCxKVFisAcBUYtIF2MsSHM30Dp2CtzjzvfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582500; c=relaxed/simple;
	bh=c1bLYu6kGf/2+a67dFXhlcHYSnAfCQ5dDFW9vICtvdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMrQXVmheRbK8SmOFJbyqREA3dRYq3tU1nJgh0Czzeyyq2XAQTbLA4cfD+Zmrt5YgTUqFv+fpCOXhNCqRKI4fSuvFYedZNZJGn4gMZFIsgst0JNWex5mHrKnttuzOuQg2YKL+YKnWNJuRVT4CousonLmx04kKvsDVKYih3XjyGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPG6al0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPG6al0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57592C433C7;
	Mon,  8 Apr 2024 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582500;
	bh=c1bLYu6kGf/2+a67dFXhlcHYSnAfCQ5dDFW9vICtvdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPG6al0wIBlg+o0JBJVcec1LO/B1WULWUNwl35UvAfnRvust41QNaetQIHybWKk5E
	 VJ4/5GC6C/IdMH2I6TQlfuAT8lP0agP9WjnOK+j6/0ZBAIIHDnfM7WKHpdZPNKB1yj
	 tOLt00+OK6wnOhsUGPQ6wvD/A4NB21iyA+iIVoP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 111/138] x86/retpoline: Add NOENDBR annotation to the SRSO dummy return thunk
Date: Mon,  8 Apr 2024 14:58:45 +0200
Message-ID: <20240408125259.684506456@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -261,6 +261,7 @@ SYM_CODE_START(__x86_return_thunk)
 	UNWIND_HINT_FUNC
 	ANNOTATE_NOENDBR
 	ANNOTATE_UNRET_SAFE
+	ANNOTATE_NOENDBR
 	ret
 	int3
 SYM_CODE_END(__x86_return_thunk)


