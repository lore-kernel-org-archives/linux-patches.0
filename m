Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8FD48165B;
	Tue, 25 Aug 2026 13:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665503; cv=none; b=ruD8d4fcypfFY8rs7qdqQ2w4kxwVc2qX1NAVmYyD4YGMef+JyooeV083P2BXq5ctTE5W97X+HYYnZMoNdLzkQhqPCx75Uwo7Qz/PnVLayu8pcWJ3EccH++V/Y6D/1GaDpgwo0wJkeei0vg4vvqOiBNg1M1a2j5c1wjvgE6ZBW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665503; c=relaxed/simple;
	bh=Mhy77zRqDostscVrkB7S9mq/TMPR/+lF3J4w6pzz4o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBe8jDdjJVPAcyaRo64iwJ5mQ/7pbWcYOw/jDthA6IAf/vGaxD/g2EIC58q9JF/5AzKj8y37HeE2QSgImcpgPCemCKXVG8w49CDdBjOVBCpQxIc1icGtBh0HQepVC5NPP54dn1Tky2djGj4oyIDK0EubpmaEVadRnh6aqB0+jA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBa5fk25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBa5fk25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9CC1F000E9;
	Tue, 25 Aug 2026 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665502;
	bh=rg3aRidbOolrHP4aRg+aTOTXjqawUuP23eYJg2rEPG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBa5fk25dE/9Z54I0401nNHPegNYzyNw56qk5ldpZKjTMO0TMpefrrSPn4uUxi81z
	 1Zk2GysMIHobY12vR690ncRzLD3rWLoIoBEHBBvRCTh2bXcMRDNRdyet2CeXgpgcaP
	 VQ4GJ8pMNEToUJnCS6wxUkcDq0F0JaMi3syRRb4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 46/77] Input: byd - synchronize timer deletion before freeing private data
Date: Tue, 25 Aug 2026 15:26:08 +0200
Message-ID: <20260825132543.367003114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


