Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFD339903B;
	Tue, 21 Jul 2026 18:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658543; cv=none; b=DVj9di4Ng4wsFcC91nDiOLnW5W4B4gogwylU3xX6AsOrUnLlGkNEUUAQ2XKBDOFf7ejbzBlFn5L3x86iuCfkvbbUi8+1zVqQ7dUIfhSs5XiH8jxnbesdJdZFeyKlPGRc11JdJIAMEWstj37nAb4xbH6+FEbkxIz/b7SNjIOGavY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658543; c=relaxed/simple;
	bh=QUK/mj2NnmqFluimwZ4G0NJDt1e0GARDD0ix15hl4+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJdemjwMOj/TiqkQvzlHDvJIc3loT3O1T21pj7EMINnCzmBG2X86ccCK4CAoLW0sv5s6ORi095XcfKMpWE7y0W6gHveSra5YEz5xdgnl6Bwp6j91jfh2e6udI9e6DNzrx6QvToo8TcQd8x+/XcCbH8Mpx38qSOf2tEd0f67ysS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7xpQUlA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7xpQUlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7F71F000E9;
	Tue, 21 Jul 2026 18:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658542;
	bh=gADZeKcEYTciYdpVVWK8ZNZKzT+fUS/OGvHVEJBcqE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7xpQUlAWYLOQDinNdUK1GQQ38+NbgOZXeuwMiTugugvWljOMAo3bVaSHr0/QJQeH
	 CPfaEMVuO9y/6lnDBbfjyOPeIp9mPIknqBA7aozeCyiRVnI2/8BuZE+7ZgaBUog6ma
	 igqrZzE3Icq8fv3GVwKizbpOi7wGeyiBeK+MzWFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 1183/1611] leds: uleds: Fix potential buffer overread
Date: Tue, 21 Jul 2026 17:21:39 +0200
Message-ID: <20260721152542.042505895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit c19fe864f667afc49d1391d764e20b66555bcf7a upstream.

The name string supplied by userspace is not guaranteed to be
null-terminated, so using strchr() on it might result in a buffer
overread. The same thing will happen when said string is used by
the LED class device.

Fix this by using strnchr() instead and explicitly check that
the name string is properly null-terminated.

Cc: stable@vger.kernel.org
Fixes: e381322b0190 ("leds: Introduce userspace LED class driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260524235553.189134-1-W_Armin@gmx.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/uleds.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/leds/uleds.c
+++ b/drivers/leds/uleds.c
@@ -102,7 +102,8 @@ static ssize_t uleds_write(struct file *
 
 	name = udev->user_dev.name;
 	if (!name[0] || !strcmp(name, ".") || !strcmp(name, "..") ||
-	    strchr(name, '/')) {
+	    strnchr(name, sizeof(udev->user_dev.name), '/') ||
+	    !strnchr(name, sizeof(udev->user_dev.name), '\0')) {
 		ret = -EINVAL;
 		goto out;
 	}


