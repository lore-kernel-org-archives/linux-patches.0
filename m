Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA9A382F01;
	Thu, 30 Jul 2026 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426819; cv=none; b=PKNJBljJHWrOLyGx/QCdUVC2hgHhF2Gm8PL3AzEZRvLTkvfGZcriNkqnOWhcd0ySRROIG0hUzHyJGYJRSiaP+LbCLCT41W+8ZpFu8NvGiMIMRLq0DgtQ7OCCVprn/39FpmYZs6NLYey7Ljyum262d0u/WcBCsLQvMfNkfWQ/2Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426819; c=relaxed/simple;
	bh=7We4KNbSQowKn0yGhaZyGKs7/f/b7nPXksdpXrP1qQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWXmH/PMzXSA6QTmJUaodCkHVIVnCh/swn+UNMfU/RmqpjiEND11wOf1OZzQXvXkXDOYVU6WKxId6KE/VTuR2BawcTFUU0oSGDv4n4hxzPOpG4SBrDvCCoX6j7Jhf3tNpvtwXAC9x8bQbrYL0kNO2S4j0ZwZAlL0Ph4NQ5ZwmVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqWY13Vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqWY13Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA51B1F000E9;
	Thu, 30 Jul 2026 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426818;
	bh=bErStkx392a8W6tOrklcqgInpM02+9Il0k2Gsbsuhfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqWY13Vc11whUxwgd/8DwsicfwUuecUhraK52Mh1YvOBtrn7uHS6Prw1SEOVJc3Ue
	 qgh7cs4eg/YCE0T1iu1Cv5uc20uThO3Il3YwAaWkihGF6G1PT4W0hW4MtQRlmgK4w3
	 E3lAl0/kHGpdHIf2JL7lwSU55Z3cmDqGEqwWB89Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 552/602] wifi: libertas_tf: fix use-after-free in lbtf_free_adapter()
Date: Thu, 30 Jul 2026 16:15:44 +0200
Message-ID: <20260730141447.634500033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit aa6dcd5c8dd9ba1d7d0f60093bcda41c0d6d438d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
-	del_timer(&priv->command_timer);
+	timer_delete_sync(&priv->command_timer);
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 


