Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA5502D5A;
	Wed, 30 Sep 2026 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792207; cv=none; b=cyciIJMU1wlC6Ju6AnwCTzUlyO4DGej2MCqO93fpam4uZ/sMJacAql5GGtvXwoSrGxye8zcxpZUhk2+CQ9KqGZKj4R1/lvnzIvHWr6YgpGrEs8vip+4HLiaHnpRXZHM/K6SOEiCxo4zW+NBpAxpg34rVd+xRMiM2klq270J2nRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792207; c=relaxed/simple;
	bh=fi/ZKJaVkqPKdlXxuWMYLnaZExDwpP1xa6TjiV/wDCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEUHJnQ6AuIECwLGhcALCB5uhg9zZBE2/jBWnCJYQaFL8c2n62+kqNzAmsPyDD3X+a4Gf/cgRW9KGYJvxxhjMR9idIdL69L4w/IghNjMsEmGht8PbWEw9VJeabhgG9tsOs3NTdERmgQ4HPA9ckqu0/ddgKsgeSikDlgac3Wzx6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HewTx7ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HewTx7ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9BC1F000FF;
	Wed, 30 Sep 2026 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792205;
	bh=s513LRVEl4shuiUHeUNL16WU9His0USgaKe83Ld8NMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HewTx7ss3cn9rlgj1PzHc6cwhgv+w+GkbMDX3rPKvJKnVpebEPRRI8LN0WXavBNGI
	 y5k9zR7E7EJRESIE1HlS8vVANgeyipJRVFm7dCI25DZAJUdvJD2eNmuUHIcty/1mOg
	 4dJ7phZiyPnuoa9U3kNJ5+nss8GoTGiQfRHN7+jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 574/752] wifi: wlcore: release runtime PM ref on regdomain config failure
Date: Wed, 30 Sep 2026 17:27:24 +0200
Message-ID: <20260930152410.716367812@linuxfoundation.org>
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
@@ -3666,10 +3666,8 @@ void wlcore_regdomain_config(struct wl12
 	}
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
-	if (ret < 0) {
+	if (ret < 0)
 		wl12xx_queue_recovery_work(wl);
-		goto out;
-	}
 
 	pm_runtime_mark_last_busy(wl->dev);
 	pm_runtime_put_autosuspend(wl->dev);


