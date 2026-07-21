Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EC33C1081;
	Tue, 21 Jul 2026 22:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671940; cv=none; b=BEbkS/OxoDl0yyjxj/n7ee+9Y/mckGQFOEuw9YpxJkRT+8aZUnadS9tb8hcZc8QMISEiHtVIaXzZpCijH8dxmpcDm7wEXAoQrVjd6Q11gkUfSO5TimC45BYJEmKgx6PwP9jzqSzmTHms/UBOJtMVhxL+LQOkQnA/qISEkgFC2Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671940; c=relaxed/simple;
	bh=YaKJU/s4D2xiPUGwnzFF+7dt5xOXTpX7zbysYcrqjVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtXyhZOV/49Irx2EPFdE6UJ2pwTs+R0cJC1sWXtpPep/1tLjwdeXwzrmkqQrtrxKG3q+hJrX7uLapaht/2Vh1sxgi7watSS+3TpY8pHLCBXwdHkRHmcR4p1EiqEZTTeef1dpSnfob8z5bYDSBC9A4dcFfpXqqvPETRgDWayLVF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZ2b0dVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZ2b0dVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502801F000E9;
	Tue, 21 Jul 2026 22:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671938;
	bh=3G5zx2ZRCqpSDtUO8VASmvwrJbhACxsvH/zc27KwO8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZ2b0dVDl7WxV8lNoLkCZ+qP8LxfkuXUqvPcQphkRgO8erG/yLICwu+G2roywAhYj
	 TOJPdFWIWgYDufdSZzuIVLqtvqAd+0/UggNmCT6Gdx82zbhOMTmHIdF1qJTrZ2NI/f
	 gtwHYKskmUVzJE1szyU6U2TIWPc9YPbHw9EZ2nIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/843] sparc: led: avoid trimming a newline from empty writes
Date: Tue, 21 Jul 2026 17:21:10 +0200
Message-ID: <20260721152415.819212896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



