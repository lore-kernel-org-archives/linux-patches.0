Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F8168C4;
	Mon, 27 May 2024 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837443; cv=none; b=C4IOcb4APIYtDHIrm3xhxTWXE0jRqaW4XpeGgO86aHLqu6QdgIG0YWSE+81D4V5BMmVgTDE9WaCrbgnCRyCGB3NNLRrOPgQuCMYT0lP6H7q5xUyg7l09wTPwsAw3tSyI0uyik3Vyhs5R0OQ09erETVvN/YAcBstXp9giz1sH3d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837443; c=relaxed/simple;
	bh=sgQ8UsqysqQEo2J+r9IarMKKEM9oydtktE4yqO4B65k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcoEuQpJ49oNqfMNjbir4xRUduN6G9Jbk1542wXf80EtfOri05c6OdaUBPhdD6EA+5L6sGOzBb+H8gKcJjhu7zFFgouQDvW8nIkwYJbe1PIDIMegQ/zaU8tILSRU1LUXcCIkSEail6jPxj35rwEdBL5U4m9aAnOvcxv8Tso4O6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9T0HTY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9T0HTY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DADC2BBFC;
	Mon, 27 May 2024 19:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837443;
	bh=sgQ8UsqysqQEo2J+r9IarMKKEM9oydtktE4yqO4B65k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9T0HTY1Uagl/lRQZqZLqri9DbyktOa1pOUawvnbblp/TMqT5+GoeIO5byYxdw78D
	 wjw3NZu6QaKZ/SZItnti3fDk7dJvmkMWKJKub5KsfD7tQ0tolroWX2+AR8d1UvhJow
	 vezyirjXDsGjYt+0HDFawoeEoy5tdWJseplP6+VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Milmore <ken.milmore@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.8 016/493] Revert "r8169: dont try to disable interrupts if NAPI is, scheduled already"
Date: Mon, 27 May 2024 20:50:18 +0200
Message-ID: <20240527185628.105436261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4541,10 +4541,8 @@ static irqreturn_t rtl8169_interrupt(int
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
 


