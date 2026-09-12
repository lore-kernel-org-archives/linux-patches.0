Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CB919D8BC;
	Sat, 12 Sep 2026 10:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209515; cv=none; b=uKqTm7QClFpxyqOFwAQNKydXoezgFvk2r/dNU6cUFKv4Y5YBctrEsomJc8jIICjkPtYEtOJBjkgc8UrqNNHVfgbZp/YUS1LGgNQC1zrXd3CzdExe+q4Q6RFoWOWlQNivdYARvx3OcM4NrCpmdDsB48ZTr3g0Hlg8pdDf15VYuD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209515; c=relaxed/simple;
	bh=T7SPrJ8gve8obyUu0Sf0Pazssm4SSat1/sOw2LqVzOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhZSlUi2G+5vkH3FFU31F4IcRzsKGDuuvoFiAPrfK4KiFEpZAFKae2BN8wdflQwJmFKwgfIzDPki1JSC6cusGx70/3xG+w7HkjiSaGJ7UhNQ2KfPUc9sskdSEmmeqbakWyy2RpGGjRzuSJEWxx93EczgsiNdDogud+jGeztaC4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFPV4TW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFPV4TW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BD81F000FF;
	Sat, 12 Sep 2026 10:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209514;
	bh=xVR6KWaEc6qQ7HI1jK3iehZrhulzzYAvDmjV17b/HTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFPV4TW5Ikckur5L5KDyv4PiliD/p4Llbf9stk2wt4vFf+89Fkua2rq69KSlehmm9
	 sfwFZZ2+WX46ydPquhrHuYVPAnHZdOaTGChOBdCwfbIakd4LqLJ/Ruy74An91jc39V
	 yN6Ay3RoYWqC/t1TOp9/6QPglwOl/Ee2R/UUGi1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0837/1518] tty: clear cdev pointer after cdev_add() failure
Date: Sat, 12 Sep 2026 08:50:06 +0200
Message-ID: <20260912065642.373561672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index e2d92cf70eb78..f779f8fb138e8 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3167,8 +3167,10 @@ static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
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



