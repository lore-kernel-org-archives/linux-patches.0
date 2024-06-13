Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA8114265E;
	Thu, 13 Jun 2024 11:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279047; cv=none; b=T94bN522d2kN8fRBLOXvblbWWCKPfvWwGa6xN8JXQF20jnA7C9UFaiZ6OlewS7PUEpOI+J+SQyGYvFLFp7hZUxOfdgW2jIdbQyQ84+E2rgxs8IXLjJIFKXYxxgrbons8m776m5acsrkP1OYcEIs5C8vX0JXGntqyoc+wIsXCOpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279047; c=relaxed/simple;
	bh=4KbujfCK88SXRjcRqEGfORatlwtHKiAokLLC+IBeUo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzlrcmMAXj6g2Gd1tCGLnc2Fl+iyQpbc84lroPfb28GDmuBbEIRQ+JkUly4GPBWyl52x4jD2jW1ooXPvWaxGqyV7K3mQTirIk1oHco2+TsCJbNJSIAWCEzzYd/98jD5sxJUoreQp61O/iuS/0LNm5WWyjLZAjSNetoJurn3yoas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QlxOOL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QlxOOL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B052C2BBFC;
	Thu, 13 Jun 2024 11:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279047;
	bh=4KbujfCK88SXRjcRqEGfORatlwtHKiAokLLC+IBeUo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QlxOOL6gapUBlNENw+aQmBQZqnYh/zO3U8Yh9Y0QPHr+S4Yt9NpwHYG9HADWlxtB
	 D21FEOXcGkLfDqJ8lqO0p4PE9oOAwYtmx/PpmS4dfYhHrpuLPcoetUL1w6KN5EVI3R
	 Ff1kwWWEy2xYIZBMXbkm2UimYBikJbsbtq5+GABI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 158/213] fbdev: savage: Handle err return when savagefb_check_var failed
Date: Thu, 13 Jun 2024 13:33:26 +0200
Message-ID: <20240613113234.082117412@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Xinchen <caixinchen1@huawei.com>

commit 6ad959b6703e2c4c5d7af03b4cfd5ff608036339 upstream.

The commit 04e5eac8f3ab("fbdev: savage: Error out if pixclock equals zero")
checks the value of pixclock to avoid divide-by-zero error. However
the function savagefb_probe doesn't handle the error return of
savagefb_check_var. When pixclock is 0, it will cause divide-by-zero error.

Fixes: 04e5eac8f3ab ("fbdev: savage: Error out if pixclock equals zero")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/savage/savagefb_driver.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -2271,7 +2271,10 @@ static int savagefb_probe(struct pci_dev
 	if (info->var.xres_virtual > 0x1000)
 		info->var.xres_virtual = 0x1000;
 #endif
-	savagefb_check_var(&info->var, info);
+	err = savagefb_check_var(&info->var, info);
+	if (err)
+		goto failed;
+
 	savagefb_set_fix(info);
 
 	/*


