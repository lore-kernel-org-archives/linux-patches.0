Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6353FA5F0;
	Wed, 30 Sep 2026 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785649; cv=none; b=KWdiWQVIHLslyDmo/7VHwrwSjTyNK+scrMHOEToW2NtsjYqEMMHyFUB3zka0iIDlXhXIF47ZjjcXaZF/tvFFZenq94IPj337Ul8PcOxhTMKVy6bOvttjlsrwQ1t4v1BHFHUXE1U2R74gFeTtVLW/51Fr1uXW/U7YuqEOg/kVpJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785649; c=relaxed/simple;
	bh=zSPVuI+oUKdyj1xN75utzMmX/2pcJQMiHNvsquyOyAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ptz87uu8JEeCKbLvWs0bkJEVXzaUQR44T5USA5zQdr2YD7qKKbIo4m1LILdFRCkeAmYxb0TIJ/21bxXTtkuTqQehjZ/xZG9Ezzh8bjzvMIDaMwnWQs3fROjC0RP+oCQl/HHnV/1ry1yPljdnyHiTgTh+whCSpw1xxzcVlDVl+jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJGUDElz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJGUDElz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0864D1F00899;
	Wed, 30 Sep 2026 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785645;
	bh=fUy8RYT5Lt3VXUZFCiOLG2TWWGPrgP1nQjWlhNRD9NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJGUDElzor8bz4IA5bzQnhZMWxbhGXmNHukMv9IqQpcCnXu1uKq7c5PJHnfxWmxCJ
	 PAR+sbnlpnsw1rskysMWCgv2KrKCZHLPjH/n4UF+E3cGHc87pbeaG6+cnvwtC8HJGc
	 lS/nTC1r8iNxynsuiMWx5gNE07L612nMEZmmObsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 580/982] Revert "alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally"
Date: Wed, 30 Sep 2026 17:21:56 +0200
Message-ID: <20260930152429.233874193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit a51363d8b28e3d05a2a63ea0c9167bc1494bf5af.

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



