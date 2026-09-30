Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B550B437;
	Wed, 30 Sep 2026 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788958; cv=none; b=bGngyuu/WcH6xfmCIdrsfaSdvXDm+qVY8fviCXUDiMzPopRpPe5e6rsjFSHc5tTbyL4VjuybGWn7mZo5KKstJGh+cUlG9Rk72SsUqUZS4Z2YLETjFt24gslaajN3L/Fw8DyzEkBEBd6+YIudIkOkKmx7wE0vNpz54xtSTB47P+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788958; c=relaxed/simple;
	bh=rg/wDW3t7JNY0s9sVgpQvGR6406cKqBZ6V+bYnuqXps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUUhVQmiTtWtDpZ9LN1Y3kXO+GqesJiM1224B0+KyhD39sBFPROiTJj3bwRjFyKwM92GQRza2lv3ieDUkiTHSJiDLN4cgV2nYAgXlEjzVpeUBEzbure2zQuS2YwpjM8Wuu7/XWtgZhtpXl4WU18ih/jc1GQ15wMxnxAYXbVLLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIXaOnoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIXaOnoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DEF1F000FF;
	Wed, 30 Sep 2026 17:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788957;
	bh=DJkvGx4zncmFSDKNIy2KiTZGLHgcxIC8lWP8ifJkeqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIXaOnoRocu6PxBTH7GVhlIU3Mq6aEQaNQAdTcLMba/BT8xzvXGfMJVYovE8gY7gY
	 wDNd3ITwjHvepKDJSbYs1xc0gLa3weiBwxuSZ7nENhFPoMaiT5CChZZ0a9PvgHAknT
	 PpOTqDpQX3Csju25u+ekOMgVpcH/UL0oZ2uCvMfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 263/877] wifi: wlcore: release runtime PM ref on regdomain config failure
Date: Wed, 30 Sep 2026 17:19:34 +0200
Message-ID: <20260930152420.398773286@linuxfoundation.org>
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
@@ -3718,10 +3718,8 @@ void wlcore_regdomain_config(struct wl12
 		goto out;
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
-	if (ret < 0) {
+	if (ret < 0)
 		wl12xx_queue_recovery_work(wl);
-		goto out;
-	}
 
 	pm_runtime_mark_last_busy(wl->dev);
 	pm_runtime_put_autosuspend(wl->dev);


