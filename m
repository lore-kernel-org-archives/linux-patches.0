Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A1E2E92BA;
	Sat, 12 Sep 2026 19:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241127; cv=none; b=Rl2j69UzhWUamDGgnU8SazNrdH1vRuCp6QF3222o0MBxP0pZIgYjR/yEERRy8O0P/t8aCBeT9ZxY93HEMbpd/bpaM1KHBT1WgJYemGrriDTT1pah6HXqnb5zn+WNwSn9mmFVRG9FXdrSl30tTb+HVO1CJSTmWI/NZQv5zgGS8Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241127; c=relaxed/simple;
	bh=zFWHeNPg2KPiKh2F8M5x109es0NU58DTOLh4lhm0LEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0HboeA45LRc2TxDm2bIXqHRPG1bu4Vo10Q6QoE1+ybIi5yefCMNieEAnU3qxvBfByxESdbr4iwgy3qfNftCdO89tqeIqZgoBpfiCcpLzofIm7UuPNk2aggjI5lKEbWwCpONj9fuKPHXPtPcAjBuMVQ46u48gXXEhJagwNTnmek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0M44XaHE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0M44XaHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474791F000FF;
	Sat, 12 Sep 2026 19:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241126;
	bh=yq3YlpKQUc96GgFyPy4Gd4sERt3wWb+M5WUXpYtWLDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0M44XaHEpsvOl7cMgb5jtXjuGAyOXroEprozkJV4mUygzOdbs1tllMh/fEcxGT499
	 281y3F3qK91hdkEE64xL2bnTS8a8gP6l198pAYtECVsOIzshlS4/Op4kRFQNTml65C
	 FORLkq8TNe8hsvuK3dCtMp98zwfvREuIzsAkd3gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 5.10 073/798] alpha: marvel: Fix irq_set_status_flags to use correct IRQ number
Date: Sat, 12 Sep 2026 08:55:01 +0200
Message-ID: <20260912065518.639453277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

commit 3a3ac1f6c6a67b3803f2643584310f78301e58a8 upstream.

Pass base + i to irq_set_status_flags() to match the IRQ number
used in irq_set_chip_and_handler(). Previously, IRQ_LEVEL was set
on the wrong (low-numbered) IRQ descriptors rather than the IO7
IRQs at base + i.

Cc: stable@vger.kernel.org
Fixes: 08876fe8519c ("alpha: marvel: Convert irq_chip functions")
Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260528230516.1839694-1-mattst88@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/sys_marvel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -275,7 +275,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
 		irq_set_chip_and_handler(base + i, lsi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -289,7 +289,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
 		irq_set_chip_and_handler(base + i, msi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	for (i = 0; i < 16; ++i)


