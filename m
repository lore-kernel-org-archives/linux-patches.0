Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921FE3B8BBB;
	Sat, 17 Oct 2026 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258302; cv=none; b=aYzmDPnJNwU8hOKs9qjWDImzhFbQDi/rD7thpCnd89wB0hRYLXbtI4epnKwMdZ5hTFXJme4y73rMPtisn+tQsZqHMNeEDcABlyC141kwoh9MrpdujtG+vUy0vMpSAQgo19Iajs78ryWXH/c1CL8Xnko+jyY2VGNH7IeOl61WOEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258302; c=relaxed/simple;
	bh=HtEUrE6jFS6MeO2ewS2TErkiVi90IOKynLvQEEoTzCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZ1dtyjDRRpdxMvOSQfJdlDa5310xtei+4E5xC+cPfP1L6EUGz5djU2RXXacMLz6cOca+plt5VGWVnvsL5jHuthZm7Kq0P3UVS365BryZoKLUqdJ+TkYEH3Vq7Rnkl545DKmpIzc7/xf9GFjK0Kuj7+O66aTw+jPIykEam/Z+EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fc2w0wGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fc2w0wGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1E81F000C4;
	Sat, 17 Oct 2026 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258301;
	bh=UXgrM5x+9VRe6fk/t/DO1IKTS9E9i5lVcUGYvgUfPVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fc2w0wGiAaI8yjUDRBIivDm2wfGRml6u976eJAcsiPd8HQog8MBwfpw5VvRHIxBfX
	 o2cWfDb+4OGTY5/et1q3QlqoJjITiah5NDT+kfTYIc/pMyWukAPlvATZ+tQqk9HleE
	 u6fxensaoCIYl/0RzXT2RRT2VWHQbclP5420UxrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minseong Kim <ii4gsp@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0837/1674] Input: lkkbd - disable pending work before freeing device
Date: Sat, 17 Oct 2026 17:51:49 +0200
Message-ID: <20261017160452.614723466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minseong Kim <ii4gsp@gmail.com>

[ Upstream commit e58c88f0cb2d8ed89de78f6f17409d29cfab6c5c ]

lkkbd_interrupt() schedules lk->tq via schedule_work(), and the work
handler lkkbd_reinit() dereferences the lkkbd structure and its
serio/input_dev fields.

lkkbd_disconnect() and error paths in lkkbd_connect() free the lkkbd
structure without preventing the reinit work from being queued again
until serio_close() returns. This can allow the work handler to run
after the structure has been freed, leading to a potential use-after-free.

Use disable_work_sync() instead of cancel_work_sync() to ensure the
reinit work cannot be re-queued, and call it both in lkkbd_disconnect()
and in lkkbd_connect() error paths after serio_open().

Signed-off-by: Minseong Kim <ii4gsp@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251212052314.16139-1-ii4gsp@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/lkkbd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index 047b654b3752c..7b57577a1715c 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -671,6 +671,7 @@ static int lkkbd_connect(struct serio *serio, struct serio_driver *drv)
 	return 0;
 
  fail3:	serio_close(serio);
+	cancel_work_sync(&lk->tq);
  fail2:	serio_set_drvdata(serio, NULL);
  fail1:	input_free_device(input_dev);
 	kfree(lk);
@@ -687,6 +688,7 @@ static void lkkbd_disconnect(struct serio *serio)
 	input_get_device(lk->dev);
 	input_unregister_device(lk->dev);
 	serio_close(serio);
+	cancel_work_sync(&lk->tq);
 	serio_set_drvdata(serio, NULL);
 	input_put_device(lk->dev);
 	kfree(lk);
-- 
2.53.0



