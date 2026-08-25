Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C81338B7DC;
	Tue, 25 Aug 2026 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665745; cv=none; b=PelZ0+ZaWi/Hjr8uv2G9GWIwRZMzwM+x1z9SOIemFt0VXC7WAqgzk+YqWut5jgQ0rHbkrbjMUln299Q3Jx27ljS+iuK02YDK8QICS8xMy/o/soCsxuFqh7h1ELRVblB1EGBls493n8J0Tb0Gv/ER2tAvzUtLvZAr9NI7tB9gyFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665745; c=relaxed/simple;
	bh=1DMWm2+SjrMZiq3UA6WCELOkJDpT2CF30RwIKZxVdJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWpK9awMlVfA5xWltTpY0/uibPlb0emHy3QcSlhaAdJRH96PqKrrQdg33LrrgT51hGVMYU5qJCjsoA6A3iyiVr6x4Go4MNw37vh8LUWs73fySPIdTPXy1hH2flJh1PLLsFIDPnUAGuxeLuBMJLJYmDYJld+orHBHId3W7dyGpNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4+yJYec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4+yJYec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B371F000E9;
	Tue, 25 Aug 2026 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665744;
	bh=A1yZBaZ6T3lXbim8WauibpSU+jd4ITq7PpaNgRgb1xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4+yJYece+Mx9Dc78F6zySj+jpD/HJ1VBUx5wGFko39+ileAYeOugyO7NvvgRvxZ2
	 jcQWIXIXimL1KsVEJ0ctopPc0OSBHIaalO00h5a63q7WPC3Pxjicqihj6gTOaZnm7i
	 qL1wNXVWSgE2fr+GHZXW/U8ZBjnoc5Ogh5TyEuTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 50/87] Input: byd - synchronize timer deletion before freeing private data
Date: Tue, 25 Aug 2026 15:26:13 +0200
Message-ID: <20260825132543.811556181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit c83e79c0842ed29860648bcce5022ef0ba5001c6 upstream.

byd_disconnect() uses timer_delete() before freeing the driver's private
data.  This does not wait for a running byd_clear_touch() callback, which
dereferences the private data and its psmouse pointer.  A callback racing
with disconnect can therefore access the private data after it has been
freed.  The timer can also still be re-armed by byd_process_byte() while
the disconnect is in progress.

Use timer_shutdown_sync() before freeing the private data: it waits for
a running callback and turns any later re-arm attempt into a no-op.

Fixes: 2d5f5611dd0d ("Input: byd - enable absolute mode")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260720061259.1601281-1-lilinmao@kylinos.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ changed `del_timer()` to `timer_shutdown_sync()` since 6.12 predates the `del_timer()` → `timer_delete()` rename ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/byd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/byd.c
+++ b/drivers/input/mouse/byd.c
@@ -426,7 +426,7 @@ static void byd_disconnect(struct psmous
 	struct byd_data *priv = psmouse->private;
 
 	if (priv) {
-		del_timer(&priv->timer);
+		timer_shutdown_sync(&priv->timer);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
 	}


