Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C56330D35;
	Thu, 16 Jul 2026 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210314; cv=none; b=CGlFS6C5iPuX7tgIXnOMCmh93FXL7AYX1Lt3ddfCmmAJKmUpe0WgJ3P7l6z/otmFoAoLhXzhz7Ro7mSsCzS5ZSt3PmNIXN8xfWy0Tp8cw601KtzlqbzIXDFz9SI9P82/g7lMXOed8zGrth86tUj0z+p1OWSfNwg1nN34qKQLoGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210314; c=relaxed/simple;
	bh=e3kiUzUkPjUwvX8b0DmYsC0rbtWtq9ADAOdzg6L3LQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR6EMJmJbHHIDs52GlK12YwbbfOkccIdwNl/w/erwFnHByTKRwLK2Nmakd78M3tcHLcLrAxhEy//89LVkE5JzNNnRETkG6lsbRjRNDKCSZTGlnfkT5MCvA6YvzUTanvBcKG3ahdIhXHQVvnuRUYze+OoQc+CxDfjQXkS97h+QeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+SDpDYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+SDpDYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4911F000E9;
	Thu, 16 Jul 2026 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210313;
	bh=SgN2+WZITZMFcHJNmhk2Sf+GvKl62L5femgdFEWdR7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+SDpDYuMdp5bt1pN4eXht0tKoBL1ZURF8qaB0PzkvOzCtlWgXWRsgJqelteEy261
	 O4zQ0k3ev8+8NckoQPq+u3SJy8W0vSAjT0/eXjchHGaEv7XtX3VCUwrBYFqYkA3N80
	 vjL8UoJrFAGtxNT1JSti/GIY8D7E8kxmxWAhIzyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 493/518] Input: maple_keyb - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:32:41 +0200
Message-ID: <20260716133058.632385689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 536394ec81419b67d9f4f0028812c4372397be1b upstream.

Set maple driver data before calling input_register_device() to
ensure that it is available if the device is opened immediately and
the callback is triggered.

Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/maple_keyb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/maple_keyb.c
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -166,6 +166,8 @@ static int probe_maple_kbd(struct device
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
+	maple_set_drvdata(mdev, kbd);
+
 	idev->name = mdev->product_name;
 	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 	idev->keycode = kbd->keycode;
@@ -190,8 +192,6 @@ static int probe_maple_kbd(struct device
 
 	mdev->driver = mdrv;
 
-	maple_set_drvdata(mdev, kbd);
-
 	return error;
 
 fail_register:


