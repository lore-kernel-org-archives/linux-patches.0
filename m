Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA33BD22C;
	Wed, 30 Sep 2026 19:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796452; cv=none; b=D6mgdMACGtSMKRabtX5egk001VMy0dnTmqfocgdFbN/OVYBZC1Qv8wh1Wo5t1xDIZCELuxkOJ2ZFPQM6P71y7Nj1HS0tVl6ug9wF5arAZq0403HywxMvIbFVK5VLIgSQD+bCQwn+GsyQVCjrEDJ6+wKakT8+7cF8JrUUgDRZS34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796452; c=relaxed/simple;
	bh=dy6ruZn1GXLWkSheC1zfVjWnmhw5q7VM/uUJ0x3Mib4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bvn0oGB9ds7zoXTwlI3xTC9tpnk0NSjVGuP9uTJ+FOd6hzSFf+7SUOvuE4rKhbbr2aebc88zDvbfjgp6wComEoaCr5DR6TZFz0h051k5bGod7amjcYHwZN3MArBLy4PdgY5caMuamhHj5lrzU3dFwffKdhj8p0Dyaj1Z18cEtNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/CIuR4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/CIuR4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1111F000FF;
	Wed, 30 Sep 2026 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796451;
	bh=ocxVNJfq22fWDtlQO2rOWIVPYtF2b6ZqTOhEdKQZuqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/CIuR4a3z2lMXkhcpw9uLl9F8p7FXm8GVR01dVBJ/9yuOjmL11iplJYTRDqbqARs
	 FU3/v8ACaI3mCk4xkJ3W8jl7Y/+xUA6vpMXmTIn0Bld+cpKXB/dm10Ax6PmCv720YG
	 I4vNkDhRmbiHymf24VsxtyIH+ixYTnFDZnOb/TmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0919/1193] wifi: libertas_tf: fix UAF in lbtf_free_adapter()
Date: Wed, 30 Sep 2026 17:26:43 +0200
Message-ID: <20260930152454.658319136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
 


