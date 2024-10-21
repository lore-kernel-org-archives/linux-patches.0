Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F61E7C29;
	Mon, 21 Oct 2024 10:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506725; cv=none; b=qeG0YqaNRvVs2VuzkpqP0PmuscQdlJ812zm/4R8fVP7ZXv6/J1Kf2PkHmhVOucI41GB55Kv9Vq2Ys8JIQow8z6nVUYf1H0fDa3GTFzq/8Xbtkn9I/gHrLl7AXiwoC2P3U6dWEY2lKBSciYa1jsGKlaLm+izy2NVIQrejwns3mt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506725; c=relaxed/simple;
	bh=ckPvU2LvqN6Gs/FnGsDS99vhBKSyuwlDUU7oMQbF0SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EY7H8E0WribEwAz224ydMnWnslQtOQhL0+9kG1VMFwIKlm64SSVVB6Ze0X6dz1I8E/OhC8XtRnQeimfYpbklAfWMTgoQggaesqlEdtX3kic8oM8DvKpeTo1QPcBgPUmO7mbRfl8X5htZp37fkM9AU+aF012pbvDjtF3GiHebhkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y678w5lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y678w5lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B2DC4CEC3;
	Mon, 21 Oct 2024 10:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506725;
	bh=ckPvU2LvqN6Gs/FnGsDS99vhBKSyuwlDUU7oMQbF0SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y678w5lRa1qVFc7+LW/YgITfHKFKCbtrh9tkBp8ZAP0cbayyxiupfHRB1Qg2f101Z
	 SYxf5ySByw2nmUmDTE5c1emfxkZVfxn1M6BDEc93jHvcTa2GtUic1wG7ghXvkRPpgH
	 lHV0PHvaeXkfyflkgF+IqzUVfLgiIZBFh2IaKO00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+955da2d57931604ee691@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 6.11 099/135] vt: prevent kernel-infoleak in con_font_get()
Date: Mon, 21 Oct 2024 12:24:15 +0200
Message-ID: <20241021102303.198614204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4726,7 +4726,7 @@ static int con_font_get(struct vc_data *
 		return -EINVAL;
 
 	if (op->data) {
-		font.data = kvmalloc(max_font_size, GFP_KERNEL);
+		font.data = kvzalloc(max_font_size, GFP_KERNEL);
 		if (!font.data)
 			return -ENOMEM;
 	} else


