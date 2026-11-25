Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625189;
	b=r/aYmAv3qr7mD0Nx9Ypfl+VIMxkmX28OdnFihF6KYr79ngYxmoql8uCbIx6s8aOGoClQ
	 tVV3EwqKEbKlh4UJDXedNPvceYK2RoxE5K0TrmtLb+48ICYbovinHSYb4R/3cl/HYpokS
	 ZaOXkZQxDwz1ywq6uk2PgFo+BEuy4/GzvPD3SOBKoFtCe4O72K60Ilixu+b34maiy04GJ
	 ZlF/oYfxaFYoIEJPzrcaIGkwQA6GynLWYb64c7tpaJ/sLDYx6VQ2gRSkVLXXdKrd6chcg
	 YUCQu2AU/+XTVU6WjXYdwD9kpErNq/DAkv6CWYqcIxcOXflcGeZEVaMkkCARi4JQAGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D0+OCOpGekyD8eOHz5uXmNOCkhjqTiGp+fl+37Pa2sY=;
	b=FZ/U0jmuoDB6/JMLx019lGCyS2NRqvBUoMSHuW3d5DxhbJKfd1kO4/nF3y78Mxh+am6N
	 zH3+2kTakZZMc4nnauFyYaGbLgOVX8fUM0jkFNQbFVBFwp5PdiqHL28s7sqQu4tKs8rRP
	 BLVbxtP9TXvWh09uXw7OkUTmJNbDOTXL2IQLyyUGGhU9EgsFYlh/SJ6bTsgmugtJ7BB1J
	 D6z57yo606YoBhquYDrCXZRTRlRxs9hO8XCCkrbqJ67mC70wIyy72rOfv7UvfdDu/u0dB
	 wKXeNPmW4iRawjAraXrH1ETRopOz9OuVvDCoq//iO3H6EFH8vp/XOWXG5y633eVEhmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBrY0KXe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3265606A321;
	Wed, 25 Nov 2026 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBrY0KXe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C021F000C0;
	Wed, 25 Nov 2026 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625189;
	bh=D0+OCOpGekyD8eOHz5uXmNOCkhjqTiGp+fl+37Pa2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBrY0KXeviINlh9e1wNLkgjb/+BKJFIKcEpZyHJoH0QkUiOiueChadbC2k2RGnryw
	 79+KWdrxa+WoegCWBzMU9S0tZ1kuu2XGYF6VrV+AE403HCvV9y3+kvQw5JZmVZOCnD
	 60u6N27ivUWEBI/wmhA5oJEWsIOF99dohqH8wYcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 435/816] x86/fpu: Fix potential underflow in xstate_calculate_size()
Date: Wed, 25 Nov 2026 15:33:03 +0100
Message-ID: <20261125143859.260908352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Vagin <avagin@google.com>

[ Upstream commit f1751b220bc8a9bd2dc38ecf61f5c29f3826ace0 ]

xstate_calculate_size() calculates the size required for a given set of
xfeatures. It determines the topmost feature by finding the most
significant bit in xfeatures using fls64(xfeatures) - 1.

If xfeatures is 0, fls64(0) returns 0, and topmost becomes -1.
Previously, topmost was unsigned int, so -1 underflowed to UINT_MAX.
This caused the subsequent check `topmost <= XFEATURE_SSE` to fail, and
the code proceeded to access xstate arrays using topmost (UINT_MAX) as
an index, leading to an out-of-bounds access.

  [ bp: Remove text explaining what the patch does. ]

Fixes: d6d6d50f1e80 ("x86/fpu/xstate: Consolidate size calculations")
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>
Link: https://patch.msgid.link/20260925162454.1403405-6-avagin@google.com
[ sashal: Moved the xfeatures early-return check ahead of the topmost and offset initialization, and dropped the missing i variable and loop context, keeping the unbraced if (compacted). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index aacb59c4a35c3..1a751da3313b4 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -562,12 +562,14 @@ static bool __init check_xstate_against_struct(int nr)
 
 static unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
 {
-	unsigned int topmost = fls64(xfeatures) -  1;
-	unsigned int offset = xstate_offsets[topmost];
+	unsigned int topmost, offset;
 
-	if (topmost <= XFEATURE_SSE)
+	if (!(xfeatures & ~XFEATURE_MASK_FPSSE))
 		return sizeof(struct xregs_state);
 
+	topmost = fls64(xfeatures) -  1;
+	offset = xstate_offsets[topmost];
+
 	if (compacted)
 		offset = xfeature_get_offset(xfeatures, topmost);
 	return offset + xstate_sizes[topmost];
-- 
2.53.0



