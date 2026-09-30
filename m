Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD6A4F4D08;
	Wed, 30 Sep 2026 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783627; cv=none; b=P++orSZaAX/QYqXNpbJM/bE3xTM2D5L3ylJwflRbKcDITkxgiQoPwAg1WwuEwDRMSIWnKAhV5t9Gwjpc93jBj/WxhYaLVNxZC87FMp4thRl9SFF+P/cztS4UcuJ2RsjjVrBNX/2V7NmhtgNUzhB66ncl5xmUgZj29NQ/b4rLhhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783627; c=relaxed/simple;
	bh=MdcCh0yOI93cengOJ9wfOIaDXPJ0Pg1Qq61DqjzE70k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjOrteHFl5nAvHPCt7iy4zEj12OxRr0284kT7Wbph0Sbcm1VCX90BUeILHUDbFpZgNVdL1XBSqXN+034mmVcpK9JDlhW+U/PsW0jTPuqGqjaFUrNk+aCzcXyYBYv9HTp3JTkdF/Yqn4OkBJOyJbX3Jf24aBZW9ElcAxmWTcK59Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0KDReg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0KDReg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4860F1F00893;
	Wed, 30 Sep 2026 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783622;
	bh=lXZqgg+M5orNxYI6NPVTvMY+Ffh5E4ZO8/a8aq/HjKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0KDReg/ESnhIhAjV5NGrbe/B+sEjxkVgg59i/oPaEPuEtLXPZ5uB09+G8csDxUV8
	 qWshl7mqfB3Jf2qZxOy0rCS4d2vqpTCo4yx741kXC6nDZuUHsZu6a2UqhoGQLcm0xB
	 aKXxZIJ/jNlykbS2t8lNyKEKWICTYsmLwTfnPZb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 465/595] wifi: wlcore: release runtime PM ref on regdomain config failure
Date: Wed, 30 Sep 2026 17:25:58 +0200
Message-ID: <20260930152357.682740568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


