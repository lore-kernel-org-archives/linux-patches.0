Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A1F1DF98C;
	Wed,  6 Nov 2024 12:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895832; cv=none; b=hU+9zT+yNsYQixwdnaIX+l1e78uH4OIP4drA17pC3leoi2rCnoKa/MfHirH76blNYxUOgn/FZNfs3Eu1Dmk91CyFhQSwO8lY+9QvxOrqrBuwBUwdyMn/GhQMWz93lkbi387yC35xB44sLbXUHxwlze/tHIxfpmo4a2xWjE/vEL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895832; c=relaxed/simple;
	bh=j+bRRNwcSmCHLvYCpnDKSy+j945RA0mtWeh9ako53Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7TjYzoBz8fM9Jn2MGlTVJ2vdnr0NAGOzkv7mHXR+s4+bbxwRuaqkx1dajELLnURCCavxWZNqTX8To2k5LXj0AWc9OVbjqbpBCmd7C1q2QDTpJmjnqe3CRRrWDp2D7muQpqFuqzlZIB7BhJdBGrk7rPZ5USgTASuW8SH7AVjk0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOmgH8LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOmgH8LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF40C4CECD;
	Wed,  6 Nov 2024 12:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895832;
	bh=j+bRRNwcSmCHLvYCpnDKSy+j945RA0mtWeh9ako53Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOmgH8LA4W6HvpHSKORs3rJ7GzQ55Nw7BKicNmESMpRTR+EKzKrFbEN4rHdIoKz8N
	 pIUH/tlEIPVMXma2MA1PTEE4YpGsb6eJ5qaTnFvWXmewrBuybRGHdiahGb2wUBp7Fl
	 x18uZ28ghxU7T3kdElX7SrNcDLXUzZx3sOHJCC/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+955da2d57931604ee691@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 4.19 350/350] vt: prevent kernel-infoleak in con_font_get()
Date: Wed,  6 Nov 2024 13:04:38 +0100
Message-ID: <20241106120329.321362730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit f956052e00de211b5c9ebaa1958366c23f82ee9e upstream.

font.data may not initialize all memory spaces depending on the implementation
of vc->vc_sw->con_font_get. This may cause info-leak, so to prevent this, it
is safest to modify it to initialize the allocated memory space to 0, and it
generally does not affect the overall performance of the system.

Cc: stable@vger.kernel.org
Reported-by: syzbot+955da2d57931604ee691@syzkaller.appspotmail.com
Fixes: 05e2600cb0a4 ("VT: Bump font size limitation to 64x128 pixels")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://lore.kernel.org/r/20241010174619.59662-1-aha310510@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4450,7 +4450,7 @@ static int con_font_get(struct vc_data *
 	int c;
 
 	if (op->data) {
-		font.data = kmalloc(max_font_size, GFP_KERNEL);
+		font.data = kzalloc(max_font_size, GFP_KERNEL);
 		if (!font.data)
 			return -ENOMEM;
 	} else


