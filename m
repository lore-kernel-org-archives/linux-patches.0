Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ACC332EC5;
	Wed, 23 Sep 2026 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175114; cv=none; b=H5JQJ02C39CK/POMsJ2AOfOI6H+Thg3zqQojvQbniQWsOIQVeptlzMR1FD8mNn/Px4XgHD6xAoAN52LSE3EjsrUebn+BmgzwvxFw60rY/Nvt488/cca5S/y0Pi8O/LL6kF9RChm+z7U9YEG1/pASTY/CjMHAS9kqw9rB1CVZ+Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175114; c=relaxed/simple;
	bh=echaVLczUxu8BhN2coSg3QZtiCe4h2aFcEODSa1hSKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/MbPsVGIslaSz0Inm0i8sr2N8UV2QMrqHLMp2IznLdBsX27kD/T3fBdB7GNmbf54BUKb1ekYf3IWJD8hqms8TPIqm03Ea+Zv/bqC3F8AWuMhzTH3TPEQCs4+Plwfcvyv55iQnJbR0kZL2HIflKg2D7Ra2V28/qEvKI0XfvHD60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfvtbsjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfvtbsjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE231F0089B;
	Wed, 23 Sep 2026 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175112;
	bh=LHtbQonVKSXfnbhMaBzE1JJhzoEkG3qOvNRxgTrkqB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfvtbsjOxZ3LxzYXrHRynVyavOpCvfnrYj851BUdHOlmrL1XzX+Ay+EoHh0gv6+xs
	 rf9CUcALWQoeU83mjO53tnxb4wV6pf8nwYta4oJrrtSrP9jlTUiEim5mqy2SCJVztb
	 7ZjaX2vCscmJ9DVcpah68Mh4kKw4IzksUdBVUE2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 325/398] wifi: libertas_tf: fix UAF in lbtf_free_adapter()
Date: Wed, 23 Sep 2026 16:06:39 +0200
Message-ID: <20260923140651.843931174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
 


