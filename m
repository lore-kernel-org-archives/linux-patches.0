Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582B4502D5A;
	Wed, 30 Sep 2026 18:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792201; cv=none; b=GcwVagY5yez6PPMQEGAohTW/4DK2dgvdqQB5uhidYQblpdlBbdad9Mb3/mKCscmJpa1+DtQp0z3tx18smDIFtzaXSkfe1FFQvVcCIzwdA/qfn5sbf5k+u7JcJ6CILJtrehXzVIq6X0EQ0hjy8d9YyxobaGQzY9/Vy1wUwib5yDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792201; c=relaxed/simple;
	bh=T4f95I3OJZS69amDY+6Rnba/kVpWELj5mdKgbYf34io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8pI2ObbAKTG/MqUfm8Nq7pEwzCNvDceg52QF1GdUjzPnZXyDeSAkwlkQxuibLNwmlCJKfleMdtreEw9BejN/dp4+WP9Wdv8gekOVMd9LHA1UGj7h+B22vdyFGJBiNwwDSwPBHbj/+Ox8GPVZXeL3FrvAeH4746/dbWBVVYccM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB2F6KNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB2F6KNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33F71F000FF;
	Wed, 30 Sep 2026 18:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792200;
	bh=1mM97pEXszXRYDXwKs69mBoo6Htr7BbaQQxwk0Ribxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TB2F6KNfgKqSeX4IvxScaX6Hk5ZVO9IhbpphquiIv7V6+7JgmfmS5pCTkxA5UlcIQ
	 PVtIPmLdEie7lbDWQkJRPYeIx484X0Lcxa59HxaGOHjOYfVNRnA89r+EQGEbxOxIc+
	 OrTWPePBVeRaFYUQTZEx8U3+hunlR4ngIUgIIfYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 572/752] wifi: libertas_tf: fix UAF in lbtf_free_adapter()
Date: Wed, 30 Sep 2026 17:27:22 +0200
Message-ID: <20260930152410.610829497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
 


