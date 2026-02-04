Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B87D28B7EA;
	Wed,  4 Feb 2026 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216531; cv=none; b=RkIdWe5zTeglCxJ6gN6evKAkWKxufXbMjo+kXGPfhCjR0sScuayZfA38mVi7Nezdl+/GHK6g+0ZFrVwIN9T9QNIOvUQralK0wNKCVkPQPAGu4cfPCDsCA/knuuZlQ1iNQtn//Ce0du7WEteKLMdGrXPgOlR8NspNmt3q3QgfJxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216531; c=relaxed/simple;
	bh=Vc0gcnIoJ9Wx1GMtdwgpYpAJyI/EKukIxixcDnpMPFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/jbRBKBVHzU+i0N45JS6Ui3MST+B8kgdTkx/IjXkxcqD5ktRzckFJXzNb3Wl2jHbFriAq09TRXoFGBnQB0iUrzhkU7CcS1FOn9vG5T2sMOjn4LSnrUoTLgnz5rfvrtKSGPDhI/VPBrXKeV5lFTJWb40Sd6/rA8y6C4MaYJkn3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/mIH73S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/mIH73S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742B2C4CEF7;
	Wed,  4 Feb 2026 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216530;
	bh=Vc0gcnIoJ9Wx1GMtdwgpYpAJyI/EKukIxixcDnpMPFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/mIH73SxrlX9NljtZRr+T8rc4+jCB7VcWN4HrqAHS1j7LCojaGs4DCc4JwQQNJdp
	 tWg7U7KG9WqnChnJ3Yf1C2gQbEyfDVtOUkpfYVzDToz8E9bv3DhPx7aar/34/dXo0V
	 nJ51u2Yn6p/tdEnPhM2dhgQOdbJOqmknlZkZErbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	"Barry K. Nathan" <barryn@pobox.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 116/161] fbdev: fbcon: release buffer when fbcon_do_set_font() failed
Date: Wed,  4 Feb 2026 15:39:39 +0100
Message-ID: <20260204143855.920815817@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 3c3bfb8586f848317ceba5d777e11204ba3e5758 upstream.

syzbot is reporting memory leak at fbcon_do_set_font() [1], for
commit a5a923038d70 ("fbdev: fbcon: Properly revert changes when
vc_resize() failed") missed that the buffer might be newly allocated
by fbcon_set_font().

Link: https://syzkaller.appspot.com/bug?extid=25bdb7b1703639abd498 [1]
Reported-by: syzbot <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>
Fixes: a5a923038d70 ("fbdev: fbcon: Properly revert changes when vc_resize() failed")
Cc: "Barry K. Nathan" <barryn@pobox.com>
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2473,7 +2473,8 @@ err_out:
 
 	if (userfont) {
 		p->userfont = old_userfont;
-		REFCOUNT(data)--;
+		if (--REFCOUNT(data) == 0)
+			kfree(data - FONT_EXTRA_WORDS * sizeof(int));
 	}
 
 	vc->vc_font.width = old_width;


