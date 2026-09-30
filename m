Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDA250B437;
	Wed, 30 Sep 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788953; cv=none; b=BUWf6MQpZKh+OcmC+NtjSi+K3W1S3Nd0uoe8BsRuk+LLVoQBKRkH7RhW0ALdVa4JkvHPyTDFWCCETQrw1rEEfOxobLv/9TjPWuEten3Tylqk1QwxfFkoObxA7UIQ6Kz0ZS5UedlIJDy8pF9idxYpf1k7bCvBO2xdlG1DebA9Ny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788953; c=relaxed/simple;
	bh=6jiLSTl6ADXred8xNW8eBd8zlbvoLZAITT2HlLz1xhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tb0RrV6inhoIBuo+uwNJggkdXGl0XxvldPyb8BftDf55rtT9N35aFnZcxVYoNosxTawFC+fhlVyLLfG+MpEyBtSAlbjZBVCv896SnoFgOFXMwzW72Tj6sjaxYQZM68AjViCvywLRG76RxSpf/TLJ2EDPdm7S1LuIemQFvmvLRDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz3HjBuU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz3HjBuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA201F000FF;
	Wed, 30 Sep 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788951;
	bh=WtbfXSzslPapvYCjq+4f0bFfWfILLU5H+wlGzMiydZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz3HjBuUkap9TqcsIblrTODB08WlAnmpme+hwK1AG14ma4XjJovaKQ/56a6wOKXCv
	 0AdZY4YQIGVY578ANFhA1mVRSALJsC5VO9mEDG1LLmcIF6A86RjmE3YiT1qacesYaL
	 HIpZ82PmKPYlp2c1ZxSqObkD/wVXwjL+ud9l4PmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 261/877] wifi: libertas_tf: fix UAF in lbtf_free_adapter()
Date: Wed, 30 Sep 2026 17:19:32 +0200
Message-ID: <20260930152420.354331059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit bbb9a0ab96d44a64529aafc7a16de460a1712f6a upstream.

lbtf_free_adapter() calls lbtf_free_cmd_buffer() to free the command
buffers before calling timer_delete_sync() to wait for the command
timer callback.  If the timer callback (command_timer_fn) is already
running when lbtf_free_cmd_buffer() frees the command array, the
callback dereferences priv->cur_cmd->cmdbuf which points to freed
memory.

Swap the order so that timer_delete_sync() runs first, ensuring any
in-flight callback has completed before the command buffers are freed.

Fixes: 06b16ae53192 ("libertas_tf: main.c, data paths and mac80211 handlers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://patch.msgid.link/20260815115724.920628-1-yijiangshan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas_tf/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -173,8 +173,8 @@ static int lbtf_init_adapter(struct lbtf
 static void lbtf_free_adapter(struct lbtf_private *priv)
 {
 	lbtf_deb_enter(LBTF_DEB_MAIN);
-	lbtf_free_cmd_buffer(priv);
 	timer_delete_sync(&priv->command_timer);
+	lbtf_free_cmd_buffer(priv);
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 


