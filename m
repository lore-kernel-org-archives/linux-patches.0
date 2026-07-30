Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C0E34DCE4;
	Thu, 30 Jul 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422758; cv=none; b=QtYVcM+OeZbeK/klGcp1TUEYrfEAZbp2c1IiTw8fgvz4CPXsrbMvMmRmHMTRiC3QPGqbo4WWWEF+ocfvS0cSuKdaVWFEFH5LGea7+Ei37bZdD4QeOmHt0V8+Bymd5kYczq+PqW8VS1IFzGRB6lavdBcEG1kNiQysKefofYECeFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422758; c=relaxed/simple;
	bh=mZM2rWPrNT+fkLyIka9rfBsyAc5gIf9gd7PkDP+FJ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2I8ZMnN67T47k9XuItiG3a9TzFpdxmgwSmyG1GIxqNugTueC71ptLE4HOQO1wBP2t2kaiAomUFK5O8XBJNsFsgi03/JcAj86ZjRK2O3WbJNb4bGLwyoOtWw8pAL51PrLMtVwMEAKMFjhqYACINVgU9NkhnMCAQ5zSIdCNwmcI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNDfvDdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNDfvDdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1841F000E9;
	Thu, 30 Jul 2026 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422757;
	bh=pFoHxJtem/UkfxIfe3ZX76xkFTY28TcjotaEJUyKxKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNDfvDdxupG82gzZnoAhqhQwT9a8KU+nZqYDmTPuiZ7hCsQz0GGKYU91u1O7vqnRQ
	 z7EiRmW3iyXqyR2VAK2ujLPwSM0/I1VWA7xITssIpsJ0Re21h7Kirp8LSThTH2H4bY
	 6GhV1zLU7oH2Mm7JXJFdGq0ObVOajIkTsmvlyQrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 7.1 544/744] wifi: ath6kl: fix use-after-free in aggr_reset_state()
Date: Thu, 30 Jul 2026 16:13:37 +0200
Message-ID: <20260730141455.838376518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Daniel Hodges <git@danielhodges.dev>

commit ba7debb4dd6427386862220e8335a53a4bfc235d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1830,7 +1830,7 @@ void aggr_reset_state(struct aggr_info_c
 		return;
 
 	if (aggr_conn->timer_scheduled) {
-		timer_delete(&aggr_conn->timer);
+		timer_delete_sync(&aggr_conn->timer);
 		aggr_conn->timer_scheduled = false;
 	}
 


