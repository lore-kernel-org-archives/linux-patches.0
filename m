Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4551459EA;
	Mon, 24 Feb 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409136; cv=none; b=taXWBPecGPGzmhOU7EtONDfC0G7LN3V3WZ0CZ1WHXNvgkP0iAWC6Ni/nHnN7MaKwiSFE5AJ3U80xVCc4JNLKYTmAddTGBP7tvO/N1WEfYuQLsA3SkUxpsIDbci150hBE+4Sv3gtxAzF21fy5YF+ZieL+I8iM/DHwFKTGzvEsqew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409136; c=relaxed/simple;
	bh=L43wwQgJs5TW799l52/WWJEbJTO2S8SZx1cX/h+pBgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khjLWv/ctxIMNVBOSi/RhTt4Sl+Ee75CWKyT9VH4993ejTLsZbnyPnWWX5Ya7ctEWyl0RMLNUfy3ZcJrZbPBMnM7XFasoaBmKvALLHFGU+Rm4cKFIDwD9AvG7PDfxNbeSLF5qUWzbHNvBKWgIiUBRegjXrLU+ng8Uxd7ziHabYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyZ4d16W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyZ4d16W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB18C4CED6;
	Mon, 24 Feb 2025 14:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409136;
	bh=L43wwQgJs5TW799l52/WWJEbJTO2S8SZx1cX/h+pBgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyZ4d16W/I/LqptK/I2pf0mOf25WA1x1VT/O1C914duiP++6MhWOlGVx6k2OSNB7u
	 ObdkFlKeu92S9thk6mGhQLrC1JT1k3hiTqwU4C42DaDxAVYizsn8qn+7BhicFGUJe7
	 vmNQ6FY2h4j6k3T/pXZFn+hIaa5FAeYgBN/15Kjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.13 108/138] s390/boot: Fix ESSA detection
Date: Mon, 24 Feb 2025 15:35:38 +0100
Message-ID: <20250224142608.725203223@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit c3a589fd9fcbf295a7402a4b188dc9277d505f4f upstream.

The cmma_test_essa() inline assembly uses tmp as input and output, however
tmp is specified as output only, which allows the compiler to optimize the
initialization of tmp away.

Therefore the ESSA detection may or may not work depending on previous
contents of the register that the compiler selected for tmp.

Fix this by using the correct constraint modifier.

Fixes: 468a3bc2b7b9 ("s390/cmma: move parsing of cmma kernel parameter to early boot code")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/startup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -75,7 +75,7 @@ static int cmma_test_essa(void)
 		: [reg1] "=&d" (reg1),
 		  [reg2] "=&a" (reg2),
 		  [rc] "+&d" (rc),
-		  [tmp] "=&d" (tmp),
+		  [tmp] "+&d" (tmp),
 		  "+Q" (get_lowcore()->program_new_psw),
 		  "=Q" (old)
 		: [psw_old] "a" (&old),


