Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB23A34C81B;
	Tue,  6 Jan 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719984; cv=none; b=lRmHlWXAmELABlofK6Or7HfAY5SuuYabHSpjQAEdyaYd1uvJtggPv5sXrC/4KfcP2jowEPKnrD6Sc+lnFt4qO834NesYCuZj2sj0JFw06dp+QNebUS1zQpUYGfSq9sdMhX+D2mSsnLkqVOHBq/tmzPsi3Q6ZKYRqOA3H986XSjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719984; c=relaxed/simple;
	bh=MGq93dE9P3zfnhQfntVn9Ton66hNe54se/mqU9JFVzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wj546uNyJedUUtR9+1GUoDcMfKsfgGitFmkt0oyAhuNbs/WMowmT2j5e0xvgbM3Mb0Jvdrxn+za1Lxg9uELqN8TyBtNEpdkKi+w3QmBvYOItHz9fTjCbe8rb8H42vx0sGNt671r8chdrRgqSfBlJBpx3dKg5VyowS7VFUzp/kyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFNdhTkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFNdhTkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B82AC116C6;
	Tue,  6 Jan 2026 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719984;
	bh=MGq93dE9P3zfnhQfntVn9Ton66hNe54se/mqU9JFVzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFNdhTkDLvZ9+my4EaZan2ZGwk6eiXa/lKkNb68A7JGNv0cFKaaVafKVwx3jQJAHt
	 aYtyoDeHCzZ5p+lLmAvIlF7ZZezDk08bWLShqxjhdWQ8QfaRq79ddy6PTc6bLX3+Ot
	 qbLpPOv6/vQO0AkzWoVQ7QMHuo2MVe130Y6BE8lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minseong Kim <ii4gsp@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 098/567] Input: lkkbd - disable pending work before freeing device
Date: Tue,  6 Jan 2026 17:58:00 +0100
Message-ID: <20260106170454.953299452@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Minseong Kim <ii4gsp@gmail.com>

commit e58c88f0cb2d8ed89de78f6f17409d29cfab6c5c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/lkkbd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -670,7 +670,8 @@ static int lkkbd_connect(struct serio *s
 
 	return 0;
 
- fail3:	serio_close(serio);
+ fail3:	disable_work_sync(&lk->tq);
+	serio_close(serio);
  fail2:	serio_set_drvdata(serio, NULL);
  fail1:	input_free_device(input_dev);
 	kfree(lk);
@@ -684,6 +685,8 @@ static void lkkbd_disconnect(struct seri
 {
 	struct lkkbd *lk = serio_get_drvdata(serio);
 
+	disable_work_sync(&lk->tq);
+
 	input_get_device(lk->dev);
 	input_unregister_device(lk->dev);
 	serio_close(serio);


