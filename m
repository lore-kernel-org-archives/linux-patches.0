Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD801E103C;
	Wed,  6 Nov 2024 12:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896919; cv=none; b=fREChC/biOUOpT7Dx1DK0ymWFb5+DFCd++LJ5IO3EVd7ArrcOz9MVrr57hrF5GwB1Q9MTkSVpvEO3G7PpEsRUh8UAXwEMWU2cakMN72CnkFZOArLxkJyiK1R8IwQxPvzkxgXH5AU/kAsUs2/TXYaKUzaWL+xWOLrvitEGLGxtZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896919; c=relaxed/simple;
	bh=QkR0aqquTWBx21Gjz94942pWOE7B1qLJS/tm7cAgoFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPY7qbzfGX93S/i2NA9icxspLwm/UglP0btZ9DAmRTyRgZnTo2jOjsij7U1yXJIi9OzAgCecholfNPgoXNh3jCxKSikvnwlnFnIW/VdKQ1ibxL5UmoT8uzvES/ue5EjRCwUxpQ+nAaVtzC/ROKO4dFiAWxaOwu8v83tEOTLl6vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gp9WCeug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gp9WCeug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B64DC4CECD;
	Wed,  6 Nov 2024 12:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896918;
	bh=QkR0aqquTWBx21Gjz94942pWOE7B1qLJS/tm7cAgoFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gp9WCeugcdmiLxmy+ATV5YkhuVbgr0jsJms+YN2P2itRGh7563NqHGWGeGP4HaYHJ
	 SFKW3DUO+8xr527/n7YXmPDKJYIwuF7I70DY07RpH5onnfnDh2JKkGvXmlU/Ddflo8
	 ywYoM0IHkj+3IAHIYpf6D9MUDEH9y3cTiWhFIMq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+955da2d57931604ee691@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.10 109/110] vt: prevent kernel-infoleak in con_font_get()
Date: Wed,  6 Nov 2024 13:05:15 +0100
Message-ID: <20241106120306.187887869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4603,7 +4603,7 @@ static int con_font_get(struct vc_data *
 	int c;
 
 	if (op->data) {
-		font.data = kmalloc(max_font_size, GFP_KERNEL);
+		font.data = kzalloc(max_font_size, GFP_KERNEL);
 		if (!font.data)
 			return -ENOMEM;
 	} else


