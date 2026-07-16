Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE15B42F700;
	Thu, 16 Jul 2026 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212472; cv=none; b=IHTz79O4BD5DOIjRckK9aB7Ed12mSHUFonxDWNc7Nq5iU5tSGmgLdds/uvQ6QlAtgU5D0vdE5RT/IWfv+EtyY7ksxkfjZkoFfqvWaxT/fMX0M0ibl43dNBN+NHd7JqvQnve2KmMZxDAreX+4AYKznvoY9KndqWdt/klw2uM13Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212472; c=relaxed/simple;
	bh=aSNJiZQ1BWSg3FxFCQmV0Xe5PmC43Jaa+UtvP1SMDWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMvejZBo5FN3qcd4l7Jy6SPSqC9A+9Od/2NCAjB2TVOzq0dJTjEI+rkTpLzo0TL8OdtEcrgivp0/vV9xKsHzZDynoliK4kvm/o4X4UYT4ZpGP2aNtUMcZlvh2IYhyLJ282NAJWfiGLrKMBvf6T4+c6r6PyLkePcgcTM/A9aLbQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0aSQxKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0aSQxKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC391F000E9;
	Thu, 16 Jul 2026 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212470;
	bh=kKM1wyyYRn7QblEb7hdGe6plHLnOR7hGm1rPzsl+0ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0aSQxKPTXVPnrab7h9c5S4W1MbUd0EtkbVNicz3F96W+G7oxzXYgtxBBl2ZFjyG/
	 0EINQbPUT1n1sLTJiw7d6O36osozuz0AHgkPawGW/F4k/cVJ9y2fsNNxJEzyBZaAJT
	 VXmjxmF+qJENPbVb8AwFLDY/WLQYlmbw/D3yeTzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 341/349] Input: maple_keyb - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:34:35 +0200
Message-ID: <20260716133040.940907944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -169,6 +169,8 @@ static int probe_maple_kbd(struct device
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
+	maple_set_drvdata(mdev, kbd);
+
 	idev->name = mdev->product_name;
 	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 	idev->keycode = kbd->keycode;
@@ -193,8 +195,6 @@ static int probe_maple_kbd(struct device
 
 	mdev->driver = mdrv;
 
-	maple_set_drvdata(mdev, kbd);
-
 	return error;
 
 fail_register:


