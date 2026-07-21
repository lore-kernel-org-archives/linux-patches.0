Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E7C35C69E;
	Tue, 21 Jul 2026 22:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673889; cv=none; b=ZEEFKp7TB1mZYTzSiuGgISOMakvZUauvmDlH9baCcbB6emzCbHsyehFYEcp2XhvhV3Ts9vN21ioUKaHd0JYcst5546B9C323GNTf1Ffi0gbgYnX+nsXh14zQhYv9riTfOCv8AB+g6vUHi7cwt19eOX90ShoGub44cXvj24NJ8fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673889; c=relaxed/simple;
	bh=yLjQR9s43SX6iAmWyouxvQzNwVdOIfE/8kerAbhjWgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WK/bgzb3wj1Pp2iFZweOwqWlmKwuSjGtu1fwc6y5lmndBEPvvj0nvJiD/MJ2jtNwgBWT2V8mIr5wuLFEthILICtOmr5hKowa4xS7aF9qg4u3jgyAmSbCjBk1Jk7foJrnDwLymQVdjB875uzLYkJNISJ5mf8oB7UYnSZTxButM04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abpucEPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abpucEPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CC91F000E9;
	Tue, 21 Jul 2026 22:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673888;
	bh=9SDD+bvA7/zKCZPwxIsYbHV58Ciz80XTKGVVRPh/SJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abpucEPDPVHso6ze/tgCZS/92iIKaob4paJqqBb1jFj9coUCfsB0OLOynBaa2oXJM
	 VkNf5vApXQRHFYHSx9OEjHugSSOmdDK9iwd11OB7IwdL49T2TRBAl3JNewIvFjF5rZ
	 DjTmUXfaE19aqwnbG5peyt7277J+Dcx6xgfuHyjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/699] sparc: led: avoid trimming a newline from empty writes
Date: Tue, 21 Jul 2026 17:21:32 +0200
Message-ID: <20260721152403.204469884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7eb475e8a738ee6fd1260aa59ddccb610fdd4300 ]

led_proc_write() duplicates up to LED_MAX_LENGTH bytes with
memdup_user_nul() and then unconditionally inspects buf[count - 1] to
strip a trailing newline. A zero-length write therefore reads one byte
before the duplicated buffer.

The previous version rejected empty writes, but empty input already falls
through to the existing default case and turns the LED off like any other
unrecognized string. Preserve that behavior and only skip the newline
trim when there is no input byte to inspect.

Fixes: ee1858d3122d ("[SPARC]: Add sun4m LED driver.")
Suggested-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
index 3a66e62eb2a0e6..9d1e93d25f6cc0 100644
--- a/arch/sparc/kernel/led.c
+++ b/arch/sparc/kernel/led.c
@@ -78,7 +78,7 @@ static ssize_t led_proc_write(struct file *file, const char __user *buffer,
 		return PTR_ERR(buf);
 
 	/* work around \n when echo'ing into proc */
-	if (buf[count - 1] == '\n')
+	if (count > 0 && buf[count - 1] == '\n')
 		buf[count - 1] = '\0';
 
 	/* before we change anything we want to stop any running timers,
-- 
2.53.0



