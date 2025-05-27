Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20B028030E;
	Tue, 27 May 2025 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365944; cv=none; b=evt55/GwX2rSTcsDHRjAGFZcxpYw/JTNLQ1Z5+KX1rvUIMiKtT0BuGwVl83nWIBtsxq1S6EWBdIld42ZennXaBSmHKVeH1+Ez3J4PJmLFYUxRzdvARM53Ls03G6fQhJaUjQr71r1ZRavh4oZqY3WHeRrIX+Os1ChTofDQ63OsqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365944; c=relaxed/simple;
	bh=zrZZh1DYb46Rkr2BBk0r/BU9zgsxBFicUIy33qvFhIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBVY8b5wdeEbq9m7/sUqmiJjp6XfLahVAuEOI8zPt7Wu1ZGMeY190A7fcgiBNj53nDDg4e8ofVK0YLVr71FBGdXlEk/lLpgx9g3LbJX3A72nBcXgkgs5qDmEthfnyuYCYYa7aMmH/c5gri7z91LzHGwP9IytRT543Ls/RyKG7mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWUSemFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWUSemFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA29C4CEE9;
	Tue, 27 May 2025 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365944;
	bh=zrZZh1DYb46Rkr2BBk0r/BU9zgsxBFicUIy33qvFhIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWUSemFSqHKtxsrBNTK+XKoNxfaPT1QlBWoahClBtlMS/F/Cog0NDAIVqjiuw4NfM
	 cJbmJMpsIn2B5mM5w9L45MpgLCjKCzT24X+XFVGYU3ofnTGHOEJp0x31TR4RUagqzW
	 ZRYpMyc/fLTyMOrdLuJ2QNmubJW4XRZJk7jskG+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seongman Lee <augustus92@kaist.ac.kr>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 539/626] x86/sev: Fix operator precedence in GHCB_MSR_VMPL_REQ_LEVEL macro
Date: Tue, 27 May 2025 18:27:12 +0200
Message-ID: <20250527162506.887842189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seongman Lee <augustus92@kaist.ac.kr>

[ Upstream commit f7387eff4bad33d12719c66c43541c095556ae4e ]

The GHCB_MSR_VMPL_REQ_LEVEL macro lacked parentheses around the bitmask
expression, causing the shift operation to bind too early. As a result,
when requesting VMPL1 (e.g., GHCB_MSR_VMPL_REQ_LEVEL(1)), incorrect
values such as 0x000000016 were generated instead of the intended
0x100000016 (the requested VMPL level is specified in GHCBData[39:32]).

Fix the precedence issue by grouping the masked value before applying
the shift.

  [ bp: Massage commit message. ]

Fixes: 34ff65901735 ("x86/sev: Use kernel provided SVSM Calling Areas")
Signed-off-by: Seongman Lee <augustus92@kaist.ac.kr>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250511092329.12680-1-cloudlee1719@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/sev-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 98726c2b04f85..ddaf3c62efb52 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -116,7 +116,7 @@ enum psc_op {
 #define GHCB_MSR_VMPL_REQ		0x016
 #define GHCB_MSR_VMPL_REQ_LEVEL(v)			\
 	/* GHCBData[39:32] */				\
-	(((u64)(v) & GENMASK_ULL(7, 0) << 32) |		\
+	((((u64)(v) & GENMASK_ULL(7, 0)) << 32) |	\
 	/* GHCBDdata[11:0] */				\
 	GHCB_MSR_VMPL_REQ)
 
-- 
2.39.5



