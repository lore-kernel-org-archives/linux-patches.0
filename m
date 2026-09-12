Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E1C26ED46;
	Sat, 12 Sep 2026 19:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242502; cv=none; b=OXwuPw7KE7bofKSgTEKKzg29GxsuUNBfuRyWZ6G+xoJRS4q1c5B5KKAHeic1nbUjqss7GXINWQcfLw/Bbdr9M8ybqEM1z9qxNJ3gTlGZClnVqHjedJFotvyeyWsMyrPFmjHRSp6n0FQKEtWu9496Icgo/XrG6YTE9SCDnly7aSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242502; c=relaxed/simple;
	bh=k0hRIU2vDS7xMM7tdygdZY2oNEvri5TUAo7Xygverv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP6D/wIMPAdW3boh8PVh5PZozz0jmjRXDgrjw/1by1x8SiRFKXb7621qDD9vE3F418Z0Q1bNPYxjxO2+xp/nfG1Q7N41wo70QE5Rnr9of/yA16p5MOvxF7NB3CO3sV7SCLiKza78xMKWihfqZP7YMHWRW8Y0rM8Zv2+kwW3BwWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwsNlyTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwsNlyTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D171F000FF;
	Sat, 12 Sep 2026 19:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242501;
	bh=e+OFwhYkEHM8afwqBvlWswbneczPo8hR7OsEAfmSR2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwsNlyTUPvznG/Q2oKa9Horng1gi/gnV5XoRoOa0xBGEfKXxPMSPl8mcbVPsil5bt
	 9TgAemQW6DoHNv7+THwcR7c36zUjJowbi5fsn+c6UsJuIRVrbjKDXOiuJEyf04nBCS
	 fuNJWtsiVk/V24T+zU7Rg+ZUGk5CerYeSzOaf8fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/798] staging: fbtft: Use sysfs_emit_at() to print to sysfs file
Date: Sat, 12 Sep 2026 09:00:12 +0200
Message-ID: <20260912065525.952476798@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 221192a784c25e28b489a7e75fabf59be4f63d57 ]

This scnprintf() uses the wrong limit.  It should be "PAGE_SIZE - len"
instead of just PAGE_SIZE.  We're not going to hit the limit in real
life since we are printing at most FBTFT_GAMMA_MAX_VALUES_TOTAL (128)
u32 values, however, it's still worth fixing.

Use sysfs_emit_at() to fix this since this is a sysfs file.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/ah_Y_Y2RtqeGxchF@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fbtft-sysfs.c b/drivers/staging/fbtft/fbtft-sysfs.c
index 26e52cc2de64d..68e2b5156bc51 100644
--- a/drivers/staging/fbtft/fbtft-sysfs.c
+++ b/drivers/staging/fbtft/fbtft-sysfs.c
@@ -102,7 +102,7 @@ sprintf_gamma(struct fbtft_par *par, u32 *curves, char *buf)
 	mutex_lock(&par->gamma.lock);
 	for (i = 0; i < par->gamma.num_curves; i++) {
 		for (j = 0; j < par->gamma.num_values; j++)
-			len += scnprintf(&buf[len], PAGE_SIZE,
+			len += sysfs_emit_at(buf, len,
 			     "%04x ", curves[i * par->gamma.num_values + j]);
 		buf[len - 1] = '\n';
 	}
-- 
2.53.0



