Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6D38F92F;
	Sat, 12 Sep 2026 19:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242937; cv=none; b=P9FIV5cd0xZoTEphjz//138qe0JCVMe1ZSforr6AoDKnpiNgVBLz4KurZwUHzfDb1ke82YAbN8lnxzEMDA4ciMVIPnYAZcSGZ1a/PKm4uETNXjaQy30g+C455w31v+A5QYrd2bSJgeUntRTTXgX4YISc+BzthBh9mErwH3iVOdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242937; c=relaxed/simple;
	bh=j08B5pTnc/m+sZIVibP4g/u5R+hL+njSZZKk5WANMoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWcBIIYWv0nqJ9313dSawmaPHHYn1j3NoPUVbQz1VLx8in1TKT0y0NBAElacimqcwfsCMRBmRwtYU8OjO7A5s5FgkgVtFTprwdJQ4LvoerV6ZwTHQxghnfzJHHCyFwYAYGE0SX0x6sMD1+i9evsVJDl2VUF/Jo/kyAv82zssJSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcRXW/Ud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcRXW/Ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7661F000FF;
	Sat, 12 Sep 2026 19:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242936;
	bh=oEC9H3RtPyQLlNmdLQ1kDE3MEScMw6Sv6Quify9pzOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OcRXW/UdlAv363XVN5vVvUrttKtIoc4Cbyx6H/zfl6cXHJZ4BYOPNbwkg7jZI5TXQ
	 O0VKieRG+C2t+RzdbdcVc3KLuxtAwCYfdNqBfU7Gdv/YKBMZz0bN6SKqqZTXQcM+UT
	 1btXKfXxRhgWZB1QqyGNEMqzp8lwOndxcKqIE+Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 579/798] tty: clear cdev pointer after cdev_add() failure
Date: Sat, 12 Sep 2026 09:03:27 +0200
Message-ID: <20260912065530.401700408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6645856f0df3aeecd45519cb611415b4b89c2223 ]

tty_cdev_add() drops the cdev reference when cdev_add() fails, but
leaves driver->cdevs[index] pointing to freed memory.
tty_unregister_device() later passes that stale pointer to cdev_del(),
causing a use-after-free.

Clear the slot after dropping the reference.

Fixes: c1a752ba2d6b ("tty: don't leak cdev in tty_cdev_add()")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260731181844.11330-5-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 984e3098e6317..f0d36f992616f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3144,8 +3144,10 @@ static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
 	driver->cdevs[index]->ops = &tty_fops;
 	driver->cdevs[index]->owner = driver->owner;
 	err = cdev_add(driver->cdevs[index], dev, count);
-	if (err)
+	if (err) {
 		kobject_put(&driver->cdevs[index]->kobj);
+		driver->cdevs[index] = NULL;
+	}
 	return err;
 }
 
-- 
2.53.0



