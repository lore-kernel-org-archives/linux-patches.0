Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343142FFDE1;
	Thu, 16 Jul 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210567; cv=none; b=JhqqWMe3S1alMdZBHgCF1JXabiHI9OLMOitL4vW8InzHs5odPm51C2JPfsN6XD2flHzNw6yiWEOmYPklEuziyMRCA15K0VWzfJ7LD6Er38dND3tL2s/z1dniQlyMg+Au/+wnJgcZcbvu/ABYdYS5PFs2pHiGpd8Gcf9f1fTxjz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210567; c=relaxed/simple;
	bh=W2sXNCcIF/HfFkqkQliuLWOjDFxjcFeBjEzwmahepjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXMl55qTSQrjslcqvzPVNpxAFuIxfv5XbVfiXZXrOvm6l7Lp07EOExy9Azp4P1QeWFlaP1faujM56z1Bywiy2YKA+CJ8fswqWXwKbHWcTR1uSEbExTH32CxDrJsyIUQry8gdp7gJo4LfdFbiWNH3zpLxFzw2pEaIfU4r/ZoxtFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7CKaLvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7CKaLvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990AA1F000E9;
	Thu, 16 Jul 2026 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210566;
	bh=jgLyeg2t7ho//JqIIOX7hHhWUHzBruD5ePXKudWOuCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7CKaLvYwJGea8gqrtRYWQnbI+XrF4hnntCnvsM+Hb0dl6CH7wOevyamBwG9NPl6k
	 ShB/I4c4LYqV2HWajuIpjZp8rsmuTUSykJ+fCHbws33gkI3d2FTm7HEVvSfUHf1Z90
	 hUlp2g5FpEfWSDHTUvBOBhgAV8Ufk2ZkJ0JvEhTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/480] rust: kasan: KASAN+RUST requires clang
Date: Thu, 16 Jul 2026 15:26:30 +0200
Message-ID: <20260716133045.635557779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 5b271543d0f08e9733d4732721e960e285f6448f ]

Kernel KASAN involves passing various llvm/gcc specific arguments to
the C and Rust compiler. Since these arguments differ between llvm and
gcc, it's not safe to mix an llvm-based rustc with a gcc build when
kasan is enabled.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: stable@vger.kernel.org
Fixes: e3117404b411 ("kbuild: rust: Enable KASAN support")
Link: https://patch.msgid.link/20260408-kasan-rust-sw-tags-v3-1-e07964d14363@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index cab3ad28ca49e7..0c25e78e10f47e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2096,6 +2096,7 @@ config RUST
 	depends on !CFI || HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI
 	depends on !CALL_PADDING || RUSTC_VERSION >= 108100
+	depends on !KASAN || CC_IS_CLANG
 	depends on !KASAN_SW_TAGS
 	depends on !(MITIGATION_RETHUNK && KASAN) || RUSTC_VERSION >= 108300
 	help
-- 
2.53.0



