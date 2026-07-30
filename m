Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE053442131;
	Thu, 30 Jul 2026 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423977; cv=none; b=aa7GUxR+s4XWIaG87jPhJAPmmJ/Ib8t6tgFpP/eyEoo75hEjGVKwe+d/ps/b1SdwYjV0RPIxhYuvsuw050Nw93jzF4dtDXGvybzHfhhUMFhvJqodYG5Z143DDQsm9isVLRF9QRL4n2avfvW9Prn9MvGOK/Z6zcCqrJCDS/l48Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423977; c=relaxed/simple;
	bh=6JnCbfWhW5HdjkXLGVgVic0He71mdLHQUsa25sxF8GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbYPs1LRd7shNnVN/eXiKlZ1oAC5vc2JYk4rt8yNh5fAaVEe7ACRgnT2CZxROOf/wljUVDcdONWzGhQTZrTCfdxUc4+kDmh/KCqdZSjyEwRghVXmMFXnznJNKRWEd+odceVAcyBUSripCYcackmHX4HT7bR8ppQ+Npo/BxPuiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRx6BIbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRx6BIbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5BF1F000E9;
	Thu, 30 Jul 2026 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423976;
	bh=l5RwSIlv97HG9iYy4EoZb5uICuXnYbWeunDruA8hixI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRx6BIbdpROvdKfLc7WoDWvf0vAllaIDmptNQoeZZvaMtScn06dEiOh7yzEcJ6tii
	 JRIf7LQhfdzJeQMIgAQCuhm1QbcLqxp5DcTcpxoWFAM1Q6Nk/fxZCT6jxynShaXs5w
	 aiTuGHHm2cUd+IguN/7iIDC27e9yGcIzBdE3nIQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 233/675] arm64: Correct value returned by ESR_ELx_FSC_ADDRSZ_nL()
Date: Thu, 30 Jul 2026 16:09:23 +0200
Message-ID: <20260730141450.088176034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Steven Price <steven.price@arm.com>

[ Upstream commit b877075d0baa22c225842c2f19e3ea0a9cbcbe39 ]

Address size fault, level -1 is encoded as 0b101001 or 0x29 according to
the Arm ARM. Correct the value to match the spec. This also matches the
offset of "level -1 address size fault" in the fault_info array in
fault.c.

Fixes: fb8a3eba9c81 ("KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/esr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index e1deed82446450..31058567eee465 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -130,7 +130,7 @@
  * Annoyingly, the negative levels for Address size faults aren't laid out
  * contiguously (or in the desired order)
  */
-#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x25 : 0x2C)
+#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x29 : 0x2C)
 #define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
 						   (ESR_ELx_FSC_ADDRSZ + (n)))
 
-- 
2.53.0



