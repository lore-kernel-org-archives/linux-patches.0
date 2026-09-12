Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC4A2C08D0;
	Sat, 12 Sep 2026 18:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239482; cv=none; b=nKiXprS8s0YH8KYUgZux6x1c7Uv06+E9YIbMuBJEDZk9Z+GWdTuDCqk7xFzF5GW/QAygfuWprRZNf7FetzZNiKnr86UDKAwyK3wIV7i1tobPZtD0nH9ti/tG0k2wIiyBciC6STFpnLlEFihY7+nYB+avu/Vp084wIg20Gy95MHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239482; c=relaxed/simple;
	bh=8qhYQgDGcKibGkU154ZKovgUWDOXV2YDNL7tO5gAzAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5yzSniFIC4GmkbuMKk4DLOo1cxFL0D6e7P/4dDmiKxIAMXPQwrg/+yosWl8EL87FWKOX4HRBIYhfmqNjHn7k1W9jL7Pl/S3irw0uSicqjJ4haE08xTEceC65rs05254+aC0Abc/hlliG+GDyTGU1hZshb+nR1IjMSk32nOmsQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDXzk84g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDXzk84g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5AF1F000FF;
	Sat, 12 Sep 2026 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239481;
	bh=4wP7OPGdODUBZsDmuf6IF5eqfKvbyihtugdvscNxAN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDXzk84gw2C35Sr0707tKpW1u+fAiUxuxHfpJBKSMrY1+IksDXTf76VnKihBGagMj
	 Mjhy9U+i/GKel7hJdOuPe0+GQEE7A5w2KuvpqEBs4TvFSu1DhscbggrdF/kdGSwP0B
	 Iz3+1dh3OJ+M6kxiukH8A/JVdROH8HqUNR0ufHy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 671/935] tty: clear cdev pointer after cdev_add() failure
Date: Sat, 12 Sep 2026 09:01:41 +0200
Message-ID: <20260912065542.232633906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d5191065b6e91..d63ab274ff4a2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3194,8 +3194,10 @@ static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
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



