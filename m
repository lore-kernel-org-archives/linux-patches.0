Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94460288B9;
	Sat, 12 Sep 2026 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230848; cv=none; b=tgFu+HZw4neM3gDspQQCO9fDBJwWQa/iMswKxaLNQEksHKbun91cMjpr3AGgES4ffILQmoNPn2j54uqJy8hpCbDpcIKJw6GS4KHXlE+nq7Q+Zn+Vj4nVDsEF/LjU58+IxxQ98u5QR5D/IUsLGO2tOoarZZ6kp86HA+rs/bmDlAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230848; c=relaxed/simple;
	bh=6ijxYclHLARakE1z6+DKbn9c2WAiEC7Jr/e8xz7IpYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z44KJaacQfDSgLjEVVqx7QUfZBNTjkJgSK4Vbkaxv1TpuwwSC+/TNsV93V8zeuNIXczEkwz1sL3/yC8e39W5Tqz+FyzXF+St5HunaVS7PfdH6VZ8iTSk0rU+8rIS/iEIO5jEYp1HQxI6gQ2hrrMHR1NONESMD2jrUJszjrkhMc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kETZokTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kETZokTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B6C1F000FF;
	Sat, 12 Sep 2026 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230847;
	bh=QVkIjSaVy6mnK8yvJKma0RBK62/aaUXE7WG6+oRYh7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kETZokTjPJ8hgTzDSThKp//xcrCj6zFMy4+R/MfxUlmjzbIO3JTsRSTjTWXSRIfqh
	 N649dSEDd/0f7bGODo6yIcl8ToJkBaxaKevEQXZSmBK0SFFrfRFThfNoKmiEBggS6r
	 XxIjheUJccQt3uuPwaOCT+sghFLJ9J+S3WulHpCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0835/1191] tty: clear cdev pointer after cdev_add() failure
Date: Sat, 12 Sep 2026 08:59:23 +0200
Message-ID: <20260912065607.016333982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aaf77a5616ff1..9eceb168137f7 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3156,8 +3156,10 @@ static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
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



