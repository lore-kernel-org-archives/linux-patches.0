Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58443AF66E;
	Mon, 23 Mar 2026 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276857; cv=none; b=lW52A4uAXgcAbhGYhsfZduejIwR+6QLoqNOu7HIWb3u8MmLyvOkTVKPWdhYAfvirWYRD/1JNbp0Xom4MoKsfVyj4vmRJm2wTPrvpXLYAatBfXLKJ10cS0JNKSB5sPg6v2BCKBxREMJkjlVNRXgYY3ip2vfrJr+oJ/NsdEKkMl6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276857; c=relaxed/simple;
	bh=r3XjbgkmXJ9ek+mR+3uLP92ozRaSn+d1xi6KKkXpJfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p37yCRVjl4c6clD55Sya7mvXPNtHsTvqCa/f31EVQ54LqXCEgzyJ0GjVM3yAVRLigLfqBCL6IKcJ5rhqPfwrQ5R8ZPTjDVCItknfqT2kH1nyd+UoUo61h9OOhRK74p1uhWtC+u4AGH5tyrJmm/ddKzEUAaMXtwZYG4iQJmJP08Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIuGrVo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIuGrVo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17F7C2BCB1;
	Mon, 23 Mar 2026 14:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276857;
	bh=r3XjbgkmXJ9ek+mR+3uLP92ozRaSn+d1xi6KKkXpJfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIuGrVo3jbF9WghDRPpWb10qbdbs1X8iysqvxMW/4igwslOVwg2AmH4+B28BqRteg
	 cCc+9O8fvIPUXypOtEAH8VvxcNlHrj5no8apkdpz9+VWs53pty4/u319LVC+4UML/Q
	 girErm9fJ6noKSq75mLrBWZe3fZVOGYl8K61o/20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/460] wifi: libertas: fix use-after-free in lbs_free_adapter()
Date: Mon, 23 Mar 2026 14:43:45 +0100
Message-ID: <20260323134532.124049656@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Daniel Hodges <git@danielhodges.dev>

[ Upstream commit 03cc8f90d0537fcd4985c3319b4fafbf2e3fb1f0 ]

The lbs_free_adapter() function uses timer_delete() (non-synchronous)
for both command_timer and tx_lockup_timer before the structure is
freed. This is incorrect because timer_delete() does not wait for
any running timer callback to complete.

If a timer callback is executing when lbs_free_adapter() is called,
the callback will access freed memory since lbs_cfg_free() frees the
containing structure immediately after lbs_free_adapter() returns.

Both timer callbacks (lbs_cmd_timeout_handler and lbs_tx_lockup_handler)
access priv->driver_lock, priv->cur_cmd, priv->dev, and other fields,
which would all be use-after-free violations.

Use timer_delete_sync() instead to ensure any running timer callback
has completed before returning.

This bug was introduced in commit 8f641d93c38a ("libertas: detect TX
lockups and reset hardware") where del_timer() was used instead of
del_timer_sync() in the cleanup path. The command_timer has had the
same issue since the driver was first written.

Fixes: 8f641d93c38a ("libertas: detect TX lockups and reset hardware")
Fixes: 954ee164f4f4 ("[PATCH] libertas: reorganize and simplify init sequence")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
Link: https://patch.msgid.link/20260206195356.15647-1-git@danielhodges.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ del_timer() => timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -881,8 +881,8 @@ static void lbs_free_adapter(struct lbs_
 {
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
-	del_timer(&priv->command_timer);
-	del_timer(&priv->tx_lockup_timer);
+	timer_delete_sync(&priv->command_timer);
+	timer_delete_sync(&priv->tx_lockup_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 }
 


