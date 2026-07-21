Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67E446EC78;
	Tue, 21 Jul 2026 19:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662723; cv=none; b=qG1/5g6zGjN5ISiOfJf0bds1IpLLrCRrVfucBPpaSsCNo6R6+cSYVvL89IywOW4pKhFiLb9jNFw1hGnFS8G0NER/74qquJ4wTRpyH06CiOmCUUN37Kvdg9eIQix3gZ59XYMrNu4ydx0EgJS6/lOBe8OukbLjBNLk6R6eZ+ufnG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662723; c=relaxed/simple;
	bh=14E+AKv6OChqJH2enajJjgDXARISPFhEvnUMqi+2dbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCL89hrXq4luVi3dVICja/tLrLE4CP+9ec+gl+nmXOPHcyaxviZ3zcX4Vhocxflf38x1GSkztPHo8OzU2EtHTfVvXqG3/Af/EszSVHnbo0B/4we+E85R2cgn8P9xOdQSzE6PwbxGwwX9u9SGjy+4otBV0UMw3mScHlDLmqY++vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLz1A4ny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLz1A4ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240D81F000E9;
	Tue, 21 Jul 2026 19:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662721;
	bh=mNwpW/XbC/BK01S2tcrIYjmWyRxcGLaTaqm8b6WWyY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLz1A4ny7nb27Sm9hO8PCpa2IKJO7e8hBZSqE8ZjLvWXnao1tYmEJFy2eelq+CcUl
	 nreEoiqUPfx4a4pJ3YqMlTGC8kqJTSJbrVd8mDgrO/qjdrB2uZE0qHAYRB+qBGiXAG
	 4RiOxCfXLztg9RK4B1DhxBp/TbpAg+V8eVCTZtdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0550/1276] sparc: led: avoid trimming a newline from empty writes
Date: Tue, 21 Jul 2026 17:16:33 +0200
Message-ID: <20260721152458.429916224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



