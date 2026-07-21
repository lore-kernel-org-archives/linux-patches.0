Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973E633A9FC;
	Tue, 21 Jul 2026 20:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666497; cv=none; b=TZhYarbHn41+lA0/PkRtKMFPj2sDOuz8hDiFjM9AZOUc1g7KDSFn2mj26BCIE5qNF6ix1r2iHsyxVd/HJfG293P657nlKofijXmP+oo9lKgK/swM4jx4eL+XiDzCz4W+fmGzruEx0zpCuKCEDw477wsdEkeAwdUR2RWzJHG+kks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666497; c=relaxed/simple;
	bh=/j/+xkQVhnzCUGNxookD9BAlIKE24Sh4m55Bmc4/HMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXGZZCurgZmasopWEIoCGqFmzkOvlxauZdVrRRFftlldyozWWFfEYyki8WOl9IPuwUsVpZ/tY8/H3nCA5ehNG0/H6Ko/R3mNiTAjRttIp+t38gPwq2023Ed/o9ihWJSQAsFgiRpP6H3bjRjKwwT7V2zZT66FfjjioVnQSBGXNs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1IqoozM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1IqoozM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90EE1F000E9;
	Tue, 21 Jul 2026 20:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666496;
	bh=TygbO+e3paBPfeXNfK9/XbEMtTOlqQcLN4hEmNzrvt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1IqoozMkW3vScvoJxs9ZAKiS4hIC9Hjox0nj3OXhBK0bXBLZwh+JcAnMNTEBYdtu
	 Wz4wWE24xxOyxnL/yr58UI5KLoIS5hoHL7fhEUZr6Nc6X9f2TPUI1AnwSbYCbnyYVd
	 r/tROgLo5MtAtI29NiRA4qk4YBcDqRKywQW5kzDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0706/1266] sparc: led: avoid trimming a newline from empty writes
Date: Tue, 21 Jul 2026 17:19:03 +0200
Message-ID: <20260721152457.661081742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ab657b359789ea..36d851c7454ac6 100644
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



