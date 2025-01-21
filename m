Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532241F75AC;
	Tue, 21 Jan 2025 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482680; cv=none; b=fO29bvgDO/uJeiCSkRzo1JKElD3XTrMMNu6jPLuYENid5GCZljOdKMLylNbN4Npy3h1RhubdGELvVMaDbv5c6vWacqphEbypIRlSbtqNfwHTS7Js6vzKhokiAYOjoW4yIf0MGF8+VbpU1EuuhZpfbWrNY5mzhdgJdG96WsbjVyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482680; c=relaxed/simple;
	bh=ZW6g8NYQBHrY9aEMwOxACgB1Gt130oeppY6WvqNgqcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SakpfaB1IdsLywejE4SXh5gfSCNrZYRc2uxkX/aHIaMaHX9pFmsLyKdphEDZNqantON2oeRiwjFOFhd/OultT+k4Y0GXuMpp8LHba9hN/K5o8U1lhl59DHv4RGsAuVBEHXl+56MSa7c92EIg0bgZiu0/5ZDUHNl4EBCAV1VMqAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKaq7gbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKaq7gbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF3AC4CEE0;
	Tue, 21 Jan 2025 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482680;
	bh=ZW6g8NYQBHrY9aEMwOxACgB1Gt130oeppY6WvqNgqcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKaq7gbvZb8kczt3RHXE0mq+PUV6xkGHRsfR93lfmdI7SrMMJqn1A8JOXuRuhJN//
	 QeuIneTgvY67OQXpIS2O+b52UgFhxcFAk6Bdg1iFQ+YU9wGLGFU4ORBV90JSy00iAR
	 5E0Z0JYu5WNoP5+mNEy0dcge6H6AJ6d2ytWW5Pmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/64] x86/asm: Make serialize() always_inline
Date: Tue, 21 Jan 2025 18:52:28 +0100
Message-ID: <20250121174522.665891871@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit ae02ae16b76160f0aeeae2c5fb9b15226d00a4ef ]

In order to allow serialize() to be used from noinstr code, make it
__always_inline.

Fixes: 0ef8047b737d ("x86/static-call: provide a way to do very early static-call updates")
Closes: https://lore.kernel.org/oe-kbuild-all/202412181756.aJvzih2K-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241218100918.22167-1-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/special_insns.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index c2e322189f853..373aed0f14220 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -225,7 +225,7 @@ static inline void clwb(volatile void *__p)
 
 #define nop() asm volatile ("nop")
 
-static inline void serialize(void)
+static __always_inline void serialize(void)
 {
 	/* Instruction opcode for SERIALIZE; supported in binutils >= 2.35. */
 	asm volatile(".byte 0xf, 0x1, 0xe8" ::: "memory");
-- 
2.39.5



