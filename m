Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C193161A2;
	Wed, 23 Sep 2026 14:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173930; cv=none; b=iw5Mfn1bsGxLR73d3n5WBzCybINzQ2UjNKfYXaix7YWHfhhCAxkzVewpJ3F0pJp6oF/B8DHX/DWna6zYv8GpCtgA0tPgXnTiMYicph7aFyM3yN6ejRk7lEvDnuuE0VP/mLHEZhBtAoBTBn82cnBOIgbI5OZGNPVld9HZgjmPHnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173930; c=relaxed/simple;
	bh=LrPZwwxhBkPXn65rm6LlNN7rWqJi6uDqNdgYLIME4ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9g92vt81SOgHfLZHg6GYlqKlYKN5DKZ1cSXzTlQ7V5g0+c44m4gRz23Klv+lScVHiaeEVBQszAbJax1T+fcxrpZfKulC2SpuADfzgUR2rjxqboZkw4ziB0wXwnf2Q9C/iLXlWb+34OrvrNAUidbRNH0XyexxS8KatEMT1rbEgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j94eoIIo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j94eoIIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AC11F000FF;
	Wed, 23 Sep 2026 14:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173929;
	bh=Yi5uHDM727vS3vrRBl5dhDzSZiLFYr0KLYmoZrfWFQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j94eoIIoKRmm23qYctSh1d2+JErBqJuFe8LDuv/swy7daftTQyegQc49+iZIa9s6y
	 whLy502iY5pKBKWg6GXQbRlX+CXSH7mLT35UGd8gLP2t374DAbygf2XDZnKd35A0M/
	 8bA07X3OKJydtCY4+GSG3Uwv4zaUSmGLezVjku/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 388/438] wifi: wlcore: release runtime PM ref on regdomain config failure
Date: Wed, 23 Sep 2026 16:06:49 +0200
Message-ID: <20260923140654.934171141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3724,10 +3724,8 @@ void wlcore_regdomain_config(struct wl12
 		goto out;
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
-	if (ret < 0) {
+	if (ret < 0)
 		wl12xx_queue_recovery_work(wl);
-		goto out;
-	}
 
 	pm_runtime_put_autosuspend(wl->dev);
 out:


