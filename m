Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5483471267;
	Tue, 21 Jul 2026 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657445; cv=none; b=MJKFbGdwZgUU2RQmKd209sIlgwup+dMDKajah9+TZWJhCBk34fcW0xitPmxvno9goirdthuBm0neJmDZTjMdFXldcyOPPsD19E/JhfJ2aebBc07+TICMZjsXnAp50bjnMfZ/W2Uj4sybhlx11SDbWkKVgvrBh6MUhVZN0B7IbUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657445; c=relaxed/simple;
	bh=I786ItPzkPxAglknFzLzH1nkN0ou9IYWRBuhVo6Jn9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBfziTQsQKQ9r7zQ+S7cwNiXsn/xUVS8DtRB3hLjHJM30BvUEOkx/HWAgAH6+vcyjd79A1r8TBsWsRm8tfQvdgyv7pAKfz1QBMTmt4RB514kzBELPKEf/2qPceS3YMPAQwqcqJ46CW/yuWaqgtDOwKyGMV92jDHl30uYF1wdjf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gLwX9rc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gLwX9rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9FC1F000E9;
	Tue, 21 Jul 2026 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657444;
	bh=zZOmrm3Wdp0fPBng9iYLursHfOWu8LSwQWGKsaDgV9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gLwX9rcTPE2B8sm1LaS+mVX+FOU+FAHlAgYXpCi189hwPdgG2oENY8aLc+vsOxvy
	 7J2y8gu/J1tMIuqUlR+Y4WaLTIvynbgG2hGCdhWzIswgtLLMEc/GN5MTAT+7+ESRv+
	 7+rU1N675Kv1E07HTi3CgpiMW0Jxcm2dW5/7j+ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0767/1611] sparc: led: avoid trimming a newline from empty writes
Date: Tue, 21 Jul 2026 17:14:43 +0200
Message-ID: <20260721152532.632713617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index f4fb82b019bb93..9b53ac1fe533df 100644
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



