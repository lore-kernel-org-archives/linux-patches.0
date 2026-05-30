Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C2F241C8C;
	Sat, 30 May 2026 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164964; cv=none; b=ImgSI03f08RSXzyeOTxBMluVtZ/aExCUqiUXGuGwGPbJEh/mUikLFnjUiNwOOwA2Vt8oUwft6IFxRUlzeCJ297VVgaK+NFmrjltEND/dBf7U/k2asfpQSlafjauSzF60MjfvidXh+k8ekHpnbOgBGHDxl+osvDoeDfHgNK3X/XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164964; c=relaxed/simple;
	bh=T3cEM8CXte04y9b5vhQY0LKPD6VwXQUKIeGvOI/MzaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhFTlBRshteNMsI6hiPA+g1SRmzH3zU3sVi7MzBL3R6q0TgB79i3GE/I+P1LjN+IEuIaeWaH3xSZ6WxU12oBFxvYJvQO/a0icxJlHFXAg+DMUxrzeT6R5MwmqBHrl+QcZBBSCyHfDPU/XGQxU7xJ45oGgbBrEgcpkThLprYh1No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnaX+AXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnaX+AXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84051F00893;
	Sat, 30 May 2026 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164963;
	bh=I09w+/MFzgALbxIvJ4x/c8Hkec6Mz0O7raEzPqwPIsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnaX+AXMQ589RFz7BDby6dRIlm6/xlUzLKlWXTUjLxN213AdpMUVLFTawDHfFVqMF
	 ihU00Rys77Zclr5C6t6xxRIpB09YmMqxyF9gnhgCoe7gD8Xs8kH1/fkfd1qb/Dvq5D
	 G1Dv1uQaaIQlHn7wiEYGtDz3EQS1dbDU5VB7zwew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 710/776] batman-adv: fix tp_meter counter underflow during shutdown
Date: Sat, 30 May 2026 18:07:04 +0200
Message-ID: <20260530160258.186586234@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Luxiao Xu <rakukuip@gmail.com>

commit 94f3b133168d1c49895e7cc6afbcf1cc0b354602 upstream.

batadv_tp_sender_shutdown() unconditionally decrements the "sending"
atomic counter. If multiple paths (e.g. timeout, user cancel, and
normal finish) call this function, the counter can underflow to -1.

Since the sender logic treats any non-zero value as "still sending",
a negative value causes the sender kthread to loop indefinitely.
This leads to a use-after-free when the interface is removed while
the zombie thread is still active.

Fix this by using atomic_xchg() to ensure the counter only transitions
from 1 to 0 once.

Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
[sven: added missing change in batadv_tp_send]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -435,7 +435,7 @@ static void batadv_tp_sender_end(struct
 static void batadv_tp_sender_shutdown(struct batadv_tp_vars *tp_vars,
 				      enum batadv_tp_meter_reason reason)
 {
-	if (!atomic_dec_and_test(&tp_vars->sending))
+	if (atomic_xchg(&tp_vars->sending, 0) != 1)
 		return;
 
 	tp_vars->reason = reason;
@@ -869,7 +869,7 @@ static int batadv_tp_send(void *arg)
 				   "Meter: %s() cannot send packets (%d)\n",
 				   __func__, err);
 			/* ensure nobody else tries to stop the thread now */
-			if (atomic_dec_and_test(&tp_vars->sending))
+			if (atomic_xchg(&tp_vars->sending, 0) == 1)
 				tp_vars->reason = err;
 			break;
 		}


