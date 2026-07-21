Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7AE42DA39;
	Tue, 21 Jul 2026 19:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660669; cv=none; b=sZL8w9QME4L/xslFz4jgq90ghD5HhtnpHqyoyQIFQK++AKBpOi7nyazMAizbcHloWhd5Dl3PnGe8OmWw7rASBioIS06AE3Iut3GU1oIkHKAnJEGugxRzw4oYvk8P1w3bKgW96mQBqxNoxvy3+MrbGHoTc84A5KsA1dimD1J8lUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660669; c=relaxed/simple;
	bh=FmBtwHCns/cPP4rLoqD2Ns4PMKWd/cXHlE6+Wjfetvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6BYxHVuCjyKZsmImEDvzV9Dpl5sshrT+jWm9DGetNIPScrDbxOslDTBfuYKO4rEyBk63TxLyBJoDlww3q9rzWNj2R4X304RIN+m510V4j0i/6a9taW68X15fIJE9JkagI4/KZYDuOj4bStwC+q+tHoFS9kOf8fdtj6mzaZVBX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Jfbator; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Jfbator"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5451F000E9;
	Tue, 21 Jul 2026 19:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660666;
	bh=k+XC+odLJ7YUTA97bVlMSGG/0WPrwz35OaQIjHEguTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JfbatorvXtEO29SKdJKw6eJyaQRD1eCjNuKYaKDNdEBpCQ/RG6MQEyAWHW+gmNWS
	 maVt0glN0veE5sDAuIRjgJ+yFuuo82nzBG3c8u2s83kL46lvdBfyslofWbYDs6OnpQ
	 XaxdzA74YoN8Qeceshg02RnMPOaaVT4NSOwfXzqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1067/2077] sparc: led: avoid trimming a newline from empty writes
Date: Tue, 21 Jul 2026 17:12:20 +0200
Message-ID: <20260721152617.986294852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



