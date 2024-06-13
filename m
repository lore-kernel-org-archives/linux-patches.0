Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687473209;
	Thu, 13 Jun 2024 12:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281671; cv=none; b=nzewSbR+6U055bEQzENJCFxnCO4u3AdwoBwNIcP0/tfzyWI1yCFE8C7ghle+sOVOmVdutGMEzW6tch1/gea6b8whI6Onyi+I1JDZeShOmMa9r/jSiscjKKgm9AHkhOMxFZrf9VoBqXz+uoPiR1aT157RRdSYZBW+pXuhaWcc/Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281671; c=relaxed/simple;
	bh=xhRkYyLSF2q5Cly00cBqLBIam8GGrhVFt30KLupcgW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDCTaY+TrnU/tJ2zZ9qUvRzKEVZv9hYlnYOIBglM+1H7bHj3g3nBT02YqlGCcCI9+cNe4OZeLh/Zu7n/6nEzIlTkac6XH/HJId+fp1vjISF9yPgpYNEGUFJ9klGlyCtC2CwrkaYX6eRSdS9pX67onDTkuOdjku9QlwTKZW0vXok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esWBNgnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esWBNgnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7340C2BBFC;
	Thu, 13 Jun 2024 12:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281671;
	bh=xhRkYyLSF2q5Cly00cBqLBIam8GGrhVFt30KLupcgW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esWBNgnk4a9USjxXAd5LE7muoDcjwcUZAk2Cvb/MSzG6qqzAJPZij/j1xCaEQu9vb
	 s2sWvztI6dEDtNVAbraLzN/K60KTjh1mbliSOCV5O9HZCFB8DY3TAHS77RLbHTD4PZ
	 VDqrDsPav039GtLnb+Xgf7EYFcxem0NqlgLhRIPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Milmore <ken.milmore@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 006/402] Revert "r8169: dont try to disable interrupts if NAPI is, scheduled already"
Date: Thu, 13 Jun 2024 13:29:23 +0200
Message-ID: <20240613113302.374681310@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit eabb8a9be1e4a12f3bf37ceb7411083e3775672d upstream.

This reverts commit 7274c4147afbf46f45b8501edbdad6da8cd013b9.

Ken reported that RTL8125b can lock up if gro_flush_timeout has the
default value of 20000 and napi_defer_hard_irqs is set to 0.
In this scenario device interrupts aren't disabled, what seems to
trigger some silicon bug under heavy load. I was able to reproduce this
behavior on RTL8168h. Fix this by reverting 7274c4147afb.

Fixes: 7274c4147afb ("r8169: don't try to disable interrupts if NAPI is scheduled already")
Cc: stable@vger.kernel.org
Reported-by: Ken Milmore <ken.milmore@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/9b5b6f4c-4f54-4b90-b0b3-8d8023c2e780@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4617,10 +4617,8 @@ static irqreturn_t rtl8169_interrupt(int
 		rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 	}
 
-	if (napi_schedule_prep(&tp->napi)) {
-		rtl_irq_disable(tp);
-		__napi_schedule(&tp->napi);
-	}
+	rtl_irq_disable(tp);
+	napi_schedule(&tp->napi);
 out:
 	rtl_ack_events(tp, status);
 


