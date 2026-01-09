Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1E9336EDA;
	Fri,  9 Jan 2026 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962256; cv=none; b=Hm6rb45l+im/xKxlY7g6MVtOWPcAN3/26rz+py5ZQr1Zg76DMvpctaJwAyCYvtYltEOyk97fDjKS8kW1zeuM/AkZD1cESEV5NJC4w2Nd85n7z5cO7lFk4jmqpibinClAOsFbCBz5dqvhh05gUu+9C76g3Q6Y+Q7LEjc+spaZY1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962256; c=relaxed/simple;
	bh=zbQ8/28qBN85jDu9zfO1z4htcPH5+5jCiVEYr4vVL9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUjvj6OW5DHYSdFGyhUUFZfh8nOsBK+pPII+E6HxvUxQor3HOxy557JtFwvfqrm/HU/ho8C968wLGftTmRTmMEE/LjUym1xCvMaVy+mhOlv/0nEjbbiKDLyGPcyx3EfQOIXruyF/323lD6PFjLz2bsjSpmmJkWlFGEGPo2t16f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgmSQ0bN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgmSQ0bN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA54C4CEF1;
	Fri,  9 Jan 2026 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962256;
	bh=zbQ8/28qBN85jDu9zfO1z4htcPH5+5jCiVEYr4vVL9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgmSQ0bNVTavF78C/BnLe+XzVYE01uYN8uTAXkTnaNC/MkOBXd1qyIfGYqEnmmdMT
	 JqCmG4fMicAp25jpLxQZtgYRVPU7o7b6/908Xlio/JFSS6D5MP4/5q08DbUMOvdsXX
	 J0hiq6mhF3jVZR52eaJRcMt03LFx1f41YXj/vnK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Collins <bcollins@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 301/634] powerpc/addnote: Fix overflow on 32-bit builds
Date: Fri,  9 Jan 2026 12:39:39 +0100
Message-ID: <20260109112128.861196676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Ben Collins <bcollins@kernel.org>

[ Upstream commit 825ce89a3ef17f84cf2c0eacfa6b8dc9fd11d13f ]

The PUT_64[LB]E() macros need to cast the value to unsigned long long
like the GET_64[LB]E() macros. Caused lots of warnings when compiled
on 32-bit, and clobbered addresses (36-bit P4080).

Signed-off-by: Ben Collins <bcollins@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/2025042122-mustard-wrasse-694572@boujee-and-buff
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/addnote.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/boot/addnote.c b/arch/powerpc/boot/addnote.c
index 53b3b2621457..78704927453a 100644
--- a/arch/powerpc/boot/addnote.c
+++ b/arch/powerpc/boot/addnote.c
@@ -68,8 +68,8 @@ static int e_class = ELFCLASS32;
 #define PUT_16BE(off, v)(buf[off] = ((v) >> 8) & 0xff, \
 			 buf[(off) + 1] = (v) & 0xff)
 #define PUT_32BE(off, v)(PUT_16BE((off), (v) >> 16L), PUT_16BE((off) + 2, (v)))
-#define PUT_64BE(off, v)((PUT_32BE((off), (v) >> 32L), \
-			  PUT_32BE((off) + 4, (v))))
+#define PUT_64BE(off, v)((PUT_32BE((off), (unsigned long long)(v) >> 32L), \
+			  PUT_32BE((off) + 4, (unsigned long long)(v))))
 
 #define GET_16LE(off)	((buf[off]) + (buf[(off)+1] << 8))
 #define GET_32LE(off)	(GET_16LE(off) + (GET_16LE((off)+2U) << 16U))
@@ -78,7 +78,8 @@ static int e_class = ELFCLASS32;
 #define PUT_16LE(off, v) (buf[off] = (v) & 0xff, \
 			  buf[(off) + 1] = ((v) >> 8) & 0xff)
 #define PUT_32LE(off, v) (PUT_16LE((off), (v)), PUT_16LE((off) + 2, (v) >> 16L))
-#define PUT_64LE(off, v) (PUT_32LE((off), (v)), PUT_32LE((off) + 4, (v) >> 32L))
+#define PUT_64LE(off, v) (PUT_32LE((off), (unsigned long long)(v)), \
+			  PUT_32LE((off) + 4, (unsigned long long)(v) >> 32L))
 
 #define GET_16(off)	(e_data == ELFDATA2MSB ? GET_16BE(off) : GET_16LE(off))
 #define GET_32(off)	(e_data == ELFDATA2MSB ? GET_32BE(off) : GET_32LE(off))
-- 
2.51.0



