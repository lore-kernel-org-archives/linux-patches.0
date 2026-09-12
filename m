Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36F6369D72;
	Sat, 12 Sep 2026 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217041; cv=none; b=eBP9SP+sffacFs1e1H9qq2O0Z3THR6OMUL1qUiav4/5IdHfIYn1H2G75sJxWgCX1rrjSrZJhGMiPKtctsFgE/j1JOwen8bWDtY6wEjlBrFKEfhSwlOcXixgJAs4fwnBVoXVuQZRP8dvmZt7OwPjTTomUqvNqd96Pb/N7IQ/nvcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217041; c=relaxed/simple;
	bh=7SxqTKez1/+R1a2jriV2UiYx7kwCHwILFbHcCAflwhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX6/5BYH3BSVpqSXKuX1u5xadvFieAfJZ2cV4LBEh0p3IAIRl1ThtcancPWS1quj6KKMOS9OgWdaPqmbgH8wstqjc5KWDQ0aLaXBhbH5AY1tY8TfCdJYcnElY4ZKPE/UhwyUluFDhYFgq8q5H0KAqPdNrzc03/qPM8q7vV7JOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3+XXLzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3+XXLzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66EC1F00898;
	Sat, 12 Sep 2026 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217040;
	bh=bNHOzKc6O5YG2k2HbC8KasuVDeVsc9wacnVX6dgJPTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3+XXLzFEgK+GZbqy1x8K/ruCtu+D+WRAs/ZFk7ZBYb3CxlG2YjJNAkvEkGRpU3Tq
	 TH4TB3Zlrc0lF2yn1IOtFRHz64o6VFVe6ZinjgZX+ditIE/c4nx9Q+abo5pLVZ0PVx
	 byZtiK1O0CwCDnC1fG1Jg5QmJNY+jNKTByhWVswQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0860/1376] tty: clear cdev pointer after cdev_add() failure
Date: Sat, 12 Sep 2026 08:54:46 +0200
Message-ID: <20260912065626.727596959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index dcb1769c3625c..5d372fd7423e3 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3181,8 +3181,10 @@ static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
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



