Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B82F9D85;
	Thu, 28 May 2026 20:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001249; cv=none; b=n9+5bldcVg0ybAEjmX2YAzYbY+n9oLinB9qUx3kk8fFFinJtIV9WRPmvj1K26OtzSj11fsxvsVnURvMbTZOOpy9rWSfqdrrVb+MNInywaQwEPPHC/GwkouQZH73IHU6hIFTwajLHcL8y/2NvXOn5cedIJP0jRA+4H67/sZXGMYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001249; c=relaxed/simple;
	bh=LKPSAqwmVyD5OR3Cfn+arMnHKKvfKvduAgITziDVfLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxkXDZYEbKHD2uEXhTuoCVz6a3yJo9tid99uhpXc+aG4qgeJPESpi6cuWvGkxQ0ddVl2ThpxY059DfScpbtVumVd0IG0ceQKWuz8ZU67MxKyY9gWJKZnkHd3bcKqgsLogr5zw93huYR0D5jJNvLDVzzYvXcPSi6/CWzA9RyLcLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSy1B4Si; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSy1B4Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F8A1F000E9;
	Thu, 28 May 2026 20:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001248;
	bh=q3Wj/xV8At5ANL2f1/1CMq94cLt9o52e6wB8+sk8tg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSy1B4SibhD0uB6NY86hQEA9Ma/s9ZrLWvz75HjgkNqXRniod7FsmoqzRe0iPYvU6
	 HeViAF2PCcWq+DPdtsq8yuutiBDNnDJT4qziHUrNWMWrFpX5lHN8fXYX0gwVp7IOca
	 r3eQbbzZEPbNJU1GSvYnMpfoVGQfzcz+p1rnjkdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 059/186] arm64: probes: Handle probes on hinted conditional branch instructions
Date: Thu, 28 May 2026 21:48:59 +0200
Message-ID: <20260528194930.566222434@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Vladimir Murzin <vladimir.murzin@arm.com>

commit 2ccd8ff980b50e842481bae71102fa3883fc4377 upstream.

BC.cond instructions introduced by FEAT_HBC cannot be executed
out-of-line, like other branch instructions. However, they can be
simulated in the same way as B.cond instructions.

Extend the B.cond decoder mask to match BC.cond instructions as well,
and handle them using the existing B.cond simulation path.

Fixes: 7f86d128e437 ("arm64: add HWCAP for FEAT_HBC (hinted conditional branches)")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/insn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -399,7 +399,7 @@ __AARCH64_INSN_FUNCS(cbz,	0x7F000000, 0x
 __AARCH64_INSN_FUNCS(cbnz,	0x7F000000, 0x35000000)
 __AARCH64_INSN_FUNCS(tbz,	0x7F000000, 0x36000000)
 __AARCH64_INSN_FUNCS(tbnz,	0x7F000000, 0x37000000)
-__AARCH64_INSN_FUNCS(bcond,	0xFF000010, 0x54000000)
+__AARCH64_INSN_FUNCS(bcond,	0xFF000000, 0x54000000)
 __AARCH64_INSN_FUNCS(svc,	0xFFE0001F, 0xD4000001)
 __AARCH64_INSN_FUNCS(hvc,	0xFFE0001F, 0xD4000002)
 __AARCH64_INSN_FUNCS(smc,	0xFFE0001F, 0xD4000003)


