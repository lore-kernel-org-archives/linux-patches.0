Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E121372EF5;
	Wed, 23 Sep 2026 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175122; cv=none; b=rJLav1AMENN2FsfBXBHtEVgHsKCalYTy/snVmH2R4ecP4QdoKwIc0VTWQz2t45DnNkB+SSMqvK/kVssFTwvaXSKgtq1auF2noj5L1o+p9jrNmyrARERWI1fNZFC+YDsvYUbpv6eGsLskAUQFVTzGXoGoYppAEaQ8EZFvnkdCPRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175122; c=relaxed/simple;
	bh=9YV50onUAEXmJqAinMciS3LlCiiTAcDagZ5G0cxpnaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwxv4gDsu0tdzaMez0UzMX3qt5+TycdSfkbFozmAau+tbT2wRYHclgarpQyRQCmDV+UtiT3kaqkLOtUfflADmm5nSl45kEFAegiAu774sd8BCsq1U26szwCPO93oPrTDp4blYDipCLUIX7nHCDmj5XK1fU9HmEWVWQ/vbwSW5/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7Y+DCGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7Y+DCGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85C61F000FF;
	Wed, 23 Sep 2026 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175121;
	bh=zRDY0BpvRlWqZgdAyoAUB1FkQclq1uENqV1iX3EzWJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7Y+DCGOdU9X0WsYaf+gIdwJJkEDNf9zybxyKGn4Jwn3U4CeX9eS4eJUlaSiO9xxD
	 yto3GE9ZQIfVUDvfGorB8UnK+CjBMBB+X3MZAaQD+zXdRG540PTQFYbO1W8Zh2Jloo
	 6oYOipdDM+c4/3ulSbsiXE4Q1d12x+hJmsWmZhnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 328/398] wifi: wlcore: release runtime PM ref on regdomain config failure
Date: Wed, 23 Sep 2026 16:06:42 +0200
Message-ID: <20260923140651.924021462@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 8a1f3cf89ddcc700e25afe42cfad333059adcc94 upstream.

wlcore_regdomain_config() gets a runtime PM reference before sending
the regulatory-domain command. When
wlcore_cmd_regdomain_config_locked() fails, the function queues recovery
and returns without dropping that reference.

Release the reference after handling the command result so both success
and failure paths balance the preceding
pm_runtime_resume_and_get(). The recovery worker takes a separate
runtime PM reference and cannot release the reference held here.

Fixes: fa2648a34e73 ("wlcore: Add support for runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260820125126.12757-1-runyu.xiao@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3719,10 +3719,8 @@ void wlcore_regdomain_config(struct wl12
 		goto out;
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
-	if (ret < 0) {
+	if (ret < 0)
 		wl12xx_queue_recovery_work(wl);
-		goto out;
-	}
 
 	pm_runtime_mark_last_busy(wl->dev);
 	pm_runtime_put_autosuspend(wl->dev);


