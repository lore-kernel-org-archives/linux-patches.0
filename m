Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A037BE7A;
	Thu, 20 Aug 2026 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238155; cv=none; b=MRWnGWJdw60VNflsOXaC1xjiE4aSDSnt0e/Zs1YlFQjTR1Pc8auf8D4yDskO/9anEUh5hNFSc1RqSVvVmBdEFqAIYD3TqLOIEQ8TfFn4FbUsOUB03XHkYCE4A4ynWAEYUojAbwzqPQl8RkbcDHNFwRF7W3m85fjuNQSmhoKXJpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238155; c=relaxed/simple;
	bh=SWV1hR7LriH4SnXfEPG5lV9CQaXQEH5IEBc+0g2RyDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSUTF9WrhPrUTDWPWDvMXQVSa3QHnOdWXqQu7ccKvnKhRjXvPh2tc8Ob/4Y5HkIxgB+k7vN5f4sA3TNh8Qwv5tZx0Y22hovtLfQJJNhodyrpZmJaMLlegivjuJRuLTX4uyqMOAiDkASBxubpf6LgTVmIxZ1jyGyubBHzlU4eBE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dg5mIhPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dg5mIhPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA861F000E9;
	Thu, 20 Aug 2026 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238154;
	bh=JQd/HC6KvqSqpgU/3zMQvXrzPSWY+IqWVNarz/49HPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dg5mIhPDNXIZTuN2iApw7U5XKFplYSrcV91TP7bec8/65gYGI3z+IBSEOM6L+7c/a
	 neOyi0G8cu6uZFobOkn5L7REWe1DI/EdvWR3SdBj8x3xW7E2RMrHoGDDg6l1jAexjX
	 ac9es+zjLd2vb7zK9punW7HbIzOFJprdZASvL4CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 049/228] Input: byd - synchronize timer deletion before freeing private data
Date: Thu, 20 Aug 2026 16:53:11 +0200
Message-ID: <20260820145245.961936988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/byd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/byd.c
+++ b/drivers/input/mouse/byd.c
@@ -423,7 +423,7 @@ static void byd_disconnect(struct psmous
 	struct byd_data *priv = psmouse->private;
 
 	if (priv) {
-		timer_delete(&priv->timer);
+		timer_shutdown_sync(&priv->timer);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
 	}


