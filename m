Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1892F8E8B;
	Fri,  7 Aug 2026 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114543; cv=none; b=qLkD381OuvwFyjXBsClCXQBKO/BIeXWDqWEm+Z+1roK0VdXdG4Zx/zqesXjWTIwCYNWrdMB+bKa4I2tRdZQiGh/r9ZrZsFyhPqXVXYYO750fkD+mjNrGLlLA4y2cjiR46sucq5V9BokLxokA/IZmjJNcmowPryCxUvkgnh4dIZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114543; c=relaxed/simple;
	bh=GpzzUqpRJ2foLsbdZcIcPBmV9VEvyjgMo/JH/UxCDvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgIVBxoDOnKZ5lG4aRhIYkWnsPWz74Nhg5V80ydG5F+FvPFDkE1+yrBP23Pz4bihkjczmITl+0DaAkwIGY4P6Qrz7ATyj1ZXk+imNBpKc6cyMWs5DciK+KntIPNbl1iQMkG6j2C0n3rFSYTARym5Xr3cxxBIPxocI9tpT/E97Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clePEtRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clePEtRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703991F00A3A;
	Fri,  7 Aug 2026 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114542;
	bh=NVlx/Dqi1jt4EzDUZbWKzYoE9rMAHBrvfs7Z+QD9mr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clePEtRzrDMqeLYy6biiltlBH7mYSCIYv6MQzFJmwUOMiE/WFgKcKZ/9XOO7ctY+h
	 Cj6vP3stP9zUwC0kcro9a0IE3rJ67Mrapp/s9SUczsYZCEJVnPAXnEU5IkaNQjbWZG
	 LzbctGwMxuWcd9rj2yokZi7+eUnTQlPUGyAWpu+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/337] wifi: ath6kl: fix use-after-free in aggr_reset_state()
Date: Fri,  7 Aug 2026 16:38:22 +0200
Message-ID: <20260807143425.009488081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Daniel Hodges <git@danielhodges.dev>

[ Upstream commit ba7debb4dd6427386862220e8335a53a4bfc235d ]

The aggr_reset_state() function uses timer_delete() (non-synchronous)
for the aggregation timer before proceeding to delete TID state and
before the structure is freed by callers like aggr_module_destroy().

If the timer callback (aggr_timeout) is executing when aggr_reset_state()
is called, the callback will continue to access aggr_conn fields like
rx_tid[] and stat[] which may be freed immediately after by
kfree(aggr_info->aggr_conn) in aggr_module_destroy().

Additionally, the timer callback can re-arm itself via mod_timer() while
aggr_reset_state() is running, creating a more complex race condition.

Use timer_delete_sync() instead to ensure any running timer callback
has completed before returning.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260206185207.30098-1-git@danielhodges.dev
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1829,7 +1829,7 @@ void aggr_reset_state(struct aggr_info_c
 		return;
 
 	if (aggr_conn->timer_scheduled) {
-		del_timer(&aggr_conn->timer);
+		timer_delete_sync(&aggr_conn->timer);
 		aggr_conn->timer_scheduled = false;
 	}
 


