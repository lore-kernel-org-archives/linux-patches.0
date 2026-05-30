Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139452E7379;
	Sat, 30 May 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162860; cv=none; b=dqdGMQnZilScIwVFznku0f7ifsekiAEB/FhIZyZ5UFNFf3ojdl2ZL3Po4ei7386WcEGT0LZwdGpFacNDtlBQukg59Fk+uHpE9QM8THGP9saTLS25IyEa7oBrY6faxTJ9cWw5rxWLF5Kr82zoz3qD3VlFfz2Vic8vrBsEHgb5L8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162860; c=relaxed/simple;
	bh=tOlcIhzb84TzznIH1wcjCrojK30N5Z/MWrJCk4FwDxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9e7B1npk0LLGeIYxtPOdSvPJFkzGoSU1NuRbHca2+pQAFtpRQPmaT7qUGVXuxXvhBctYQgShgJCpz+8sVudcMxN4n0OiQWo3aZEwPRwUlcVylTiwbieW7zqGErsDe2D3QQgpBDOYBQkaCLTeA5IDF3oh13Wvkj9bwRnXqfTWe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBk+mLH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBk+mLH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0F11F00893;
	Sat, 30 May 2026 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162858;
	bh=whGWo8EVAiJXX8FK2d+Gy6uY/HAwpSUuvE75n3JFv5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBk+mLH0eqPRwrWE7V3ZafeFzBSsWqMlaOdNs2Dt0r2gFVPWSNSF+NPJW1tatvdI/
	 GezeyeJVhENoT0UNRURSNKi/EtiTcuMjabbxa7H3zZV55ZwH7V6fPi4j1Ds2mYONjk
	 GGoVsiHq9ARJfklsAibVi5qXiYNLsOGxtWhoFS58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernie Thompson <bernie@plugable.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 067/776] fbdev: udlfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Sat, 30 May 2026 17:56:21 +0200
Message-ID: <20260530160242.049771983@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit a31e4518bec70333a0a98f2946a12b53b45fe5b9 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Bernie Thompson <bernie@plugable.com>
Cc: Helge Deller <deller@gmx.de>
Fixes: 59277b679f8b ("Staging: udlfb: add dynamic modeset support")
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/udlfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1077,6 +1077,9 @@ static int dlfb_ops_check_var(struct fb_
 	struct fb_videomode mode;
 	struct dlfb_data *dlfb = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* set device-specific elements of var unrelated to mode */
 	dlfb_var_color_format(var);
 


