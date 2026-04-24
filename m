Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CA733E347;
	Fri, 24 Apr 2026 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037921; cv=none; b=ollD4c5yBw4j3pNyqi5dqy3CIvpFjRNyZZ9smhA3ktopzKoT3WpN/HQE2zR1P0QQSgYqxWpMaY87JptetAPtJJGhw8YBQS3nip9mCqL7aHSxcLK6nNJwjhFZkOWep+xIDiVt9LMz9ScHXac6JHGdvd72u+reLbc6eVIFsJITClI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037921; c=relaxed/simple;
	bh=+1LGcMuDZLawLRhJnahPYqzlwo/Bem9gbiFnfmLjLZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2PcwXlJN8slPYckk09IeWaw1Nxc4Lg6Txt+SBpEef3uVKvGEtYGl0FOLkqd6tXGsDTRbVLUYIB2zf237tvY0sIgvHWAupVdgdvf0elvU00X2mO3alIdB0AERJfclVj8Y09aklSi2H9wwxp+w0j51YLcLQiGSTReW2Ax1fRkFS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9nTYtoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9nTYtoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6935CC19425;
	Fri, 24 Apr 2026 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037921;
	bh=+1LGcMuDZLawLRhJnahPYqzlwo/Bem9gbiFnfmLjLZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9nTYtoNOXECafjtrTJJqaNzn96fIxPHIHC08TNnGfp1Smw7CCK8VBqfW+LAdF1Zz
	 kNIckfOJ5/8hl6QkyQNaEnmg8REH6yfl1WmCmJVxTcEL04nlqffHlVSmsMujKQ7qb8
	 UC7Sug4mMcADLM/YgF6JkiQ/Q7D6scmQemt8Ns/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernie Thompson <bernie@plugable.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 089/166] fbdev: udlfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Fri, 24 Apr 2026 15:30:03 +0200
Message-ID: <20260424132551.363050405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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
@@ -1078,6 +1078,9 @@ static int dlfb_ops_check_var(struct fb_
 	struct fb_videomode mode;
 	struct dlfb_data *dlfb = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* set device-specific elements of var unrelated to mode */
 	dlfb_var_color_format(var);
 


