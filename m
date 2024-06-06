Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D2E196C7D;
	Thu,  6 Jun 2024 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683096; cv=none; b=ktmXPpIT43Co2nzfIbu0SGYWfdWRDlbcEFrz13hDaTQG8ETcz1uxbPaMOsNpyfIncgOllyXWqwnG5DD/8BRm2UMnZmwE5W79TlfaD5mlcM5eVwvJjE0wW2RVoevqGW2+3XalWmAaY1oroE9ACuI6c90jkKc2EvNq9uij+Cy2jnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683096; c=relaxed/simple;
	bh=FsRi/jgoSyTPmc1gT1jCXLC8DSyKkKXm+3s6xBM+LeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah3AuJyqoU/xjnyWEPKUjAm+eYGS0JEA4K43/bVPxy8rqoJA9Nk/95zAu4uaBqvqxy6HRq8JpdZjO54uxeNog1/g9Qbz96moHkLPAfLAAvEzG8s305M3o6CdRGOHdffjhy2653OpkJcSJeWN+3kwY0a4pDkIaBAWox5wcZtHGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vs7VD1QS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vs7VD1QS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE06AC2BD10;
	Thu,  6 Jun 2024 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683096;
	bh=FsRi/jgoSyTPmc1gT1jCXLC8DSyKkKXm+3s6xBM+LeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vs7VD1QSJbepZeiNvegQW6mM/A93xOGq84ny8Jjt0gS2SXoCUzY6tibjMKo8ESSgY
	 jhv8lAQjJyyrp679DuQsbBKFfbbFM5kbpXzdk+SMm6b8LZtu7NTff5wJEf5l521QLA
	 9dl3DiXCY7xFUmP04gixVHFZXEitAZBJ61lhalxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Milmore <ken.milmore@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 011/744] Revert "r8169: dont try to disable interrupts if NAPI is, scheduled already"
Date: Thu,  6 Jun 2024 15:54:43 +0200
Message-ID: <20240606131732.809467263@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4566,10 +4566,8 @@ static irqreturn_t rtl8169_interrupt(int
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
 


