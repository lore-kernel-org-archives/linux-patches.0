Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4878A217723;
	Thu, 30 Jul 2026 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424613; cv=none; b=rL96kOLyuwaf9nesPhPXV8seZ3BT3ZylkZ8L25jQdytoELbsnfaz6MekGmt44WZH4cTpUyX4/0Py/L8tOzZZCiKYgwa4yQwfSikuaNaZJFBzlsxM6aPBwSIOBoZu8H7TomN+4jHRC3LTFKMvhgwXwesBEcj087kg16ZYUdsdric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424613; c=relaxed/simple;
	bh=BYBpxilC7ZSJEruCBOrSgty/xe1152AtFZhRL2fYINQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZMETlgrlCBMNWbTMwn4WrhT/JaiilFXJHy1O6K/G7jmHggy9nP7EOxFgZKqOEQjiIuVWbEEq2L3PNBMrjoMEbAsPuTRwusI4sydq0OKSqRdfWGzv2LadKQZngiy3lorPFjG58JmXItH3CQLapelWUQBvKsOHQhV6JLhlzP7E+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq6AKVOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq6AKVOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32111F000E9;
	Thu, 30 Jul 2026 15:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424612;
	bh=KWMSMj6pPWYNYpqpn1wfeiGpM40Ss/cKGU4t2MNNQpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq6AKVOJppuxZR77R5LPoaMpr0cQ2ud8koSz7W+bpRYjj5PyXFVUlbfZePxnhfiab
	 g+SxG43b91aEpo8rUq0+rf3E7He2mZKW6GiPaIC4V85RykKGj/gWnCW/7oeK5fFLfp
	 QGLy4WQQErBQm0JAwuRds7wUShfdyqRbozlrWLB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 453/675] wifi: ath6kl: fix use-after-free in aggr_reset_state()
Date: Thu, 30 Jul 2026 16:13:03 +0200
Message-ID: <20260730141454.763163456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
 


