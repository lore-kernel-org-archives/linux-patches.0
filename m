Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FE6449B2A;
	Tue, 21 Jul 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655054; cv=none; b=rWSEijrzHf2tznzZb2kuKy8QvlF4dq5LFc097tMOF/nwQBrEgjqU0B02Wg399dzTzJCcXvltaSgz5fuf5lkd8R5dNQOKZveCtOk481EwBaWlkiwyXRrTwH0eYiCN8FWYjRa4cx796Nef/q9SqGwH5FFCbAMinDeuKG5m95p85ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655054; c=relaxed/simple;
	bh=HgEIrNU90d3JjGlfeh7yqCAxcQa1LnlWzNDT76yn1Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWWoRZbNIm9O0eoR3pjiWaTH1KHAIm+WPVWjiziPm26EAh1WRiOCX5NSgF+gNcaoR9Jb3AOmCrpgut6KscjKnDKqkE+UpThJQ4NuAE0YDYIqnIJNkIbP9iTxdoPAJQ4tNeftSyU5IyDWVut0z+iZPzXm9IK1PYTSSjclZITXEYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kg8x7vfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kg8x7vfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF321F000E9;
	Tue, 21 Jul 2026 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655052;
	bh=crnmLFOFJ7pTiZSeEnHBLbuVa0NFZSACj8TYxt8n8Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kg8x7vfY+YU94ywyWql+KUiydxY+jF3PV3fL6TLNFZmFE76fuPxeXaAiHThvSj6rX
	 aiJ94Kcz0MzQwHKKHGj35jrppFa0ULmSQAnHcHhA7vUBYDzHTTjQbRAaFjzabRo4Ma
	 4JGv6807qlpl55b7rfYAo+82daGzyDN657TZ9FJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.1 1895/2077] wifi: libertas_tf: fix use-after-free in lbtf_free_adapter()
Date: Tue, 21 Jul 2026 17:26:08 +0200
Message-ID: <20260721152637.416357590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit aa6dcd5c8dd9ba1d7d0f60093bcda41c0d6d438d upstream.

lbtf_free_adapter() calls timer_delete(&priv->command_timer), which does
not wait for a running command_timer_fn() callback. lbtf_free_adapter()
runs on the teardown path right before ieee80211_free_hw() frees priv,
both in lbtf_remove_card() and in the probe error path. command_timer is
armed by mod_timer() in lbtf_cmd() whenever a firmware command is sent.
command_timer_fn() dereferences priv. If a command times out as the
device is removed, command_timer_fn() runs concurrently with teardown and
dereferences priv after it has been freed.

This is the same use-after-free that commit 03cc8f90d053 ("wifi: libertas:
fix use-after-free in lbs_free_adapter()") fixed in the sibling libertas
driver. The libertas_tf variant has the identical pattern and was left
unchanged. Use timer_delete_sync() so any in-flight callback completes
before priv is freed.

Fixes: 06b16ae53192 ("libertas_tf: main.c, data paths and mac80211 handlers")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/178211481807.2212567.8773346114561900100@maoyixie.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas_tf/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -174,7 +174,7 @@ static void lbtf_free_adapter(struct lbt
 {
 	lbtf_deb_enter(LBTF_DEB_MAIN);
 	lbtf_free_cmd_buffer(priv);
-	timer_delete(&priv->command_timer);
+	timer_delete_sync(&priv->command_timer);
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 


