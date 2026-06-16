Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B443E9C6;
	Tue, 16 Jun 2026 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624326; cv=none; b=PmyPE/wsaK+1YmjCNRd+B9fYWlETVpvCSu1ZoHSCKu8bEgUo+36+u+KOe+IRA6Dky65IWfJYQ5s2+pvQejJYGIl1wsv0L+2+O3zKOO5FdeyoOaUi8a9H3u9tVUAlwwb+EyvqR5NeYjxTkCXrC1kbqYiSkoTgt3XvYYWoRX/d+uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624326; c=relaxed/simple;
	bh=Cm+yZdDJPC173KtlY2gTO7uCBqFMY+pWQ9LMgUv1DFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSZlBgwjRbsxEylpWB8PpFAYnUxbztROxYWjx8YYzaKavXMDqZSkaB2HaWr4nVx/Zp37/ZaroebLvGd7hfiNyAk0jn92srKMRmLzDkEspUsFr4QcvVkxnibPbzT9cydjhMJUVIkDpOem7AyJvzbZoaaEkfQKxKl9sRpFy4yZJtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFI4nwzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFI4nwzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4931F000E9;
	Tue, 16 Jun 2026 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624325;
	bh=+vBnkFD8GHabmx3bYsXGUtbXXTjLwOF7mohYkXffauw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFI4nwzKHcuE3V+PRjoJ8QAvtVL58ajLbooJRLZ1Ej5ezxmZ6JJmphDpbvWKn/N44
	 qpIcy4RX/QBPsWpM6uu+07AFvnZXUJ1JZmP82C6vk4AhCS1jRq0nDxjCIbNo/3VeHT
	 tWG8PSWVs1C41KDvEGI/JwqG3lUQuovZb16sZaSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 315/378] rtase: Avoid sleeping in get_stats64()
Date: Tue, 16 Jun 2026 20:29:06 +0530
Message-ID: <20260616145126.837134732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

commit 9fc237f8d49f06d05f0f8e80361047b718894e81 upstream.

The .ndo_get_stats64 callback must not sleep because it can be
called when reading /proc/net/dev.

rtase_get_stats64() calls rtase_dump_tally_counter(), which polls
the tally counter dump bit with read_poll_timeout(). This may
sleep while waiting for the hardware counter dump to complete.

Use read_poll_timeout_atomic() instead to avoid sleeping in the
get_stats64() path.

Fixes: 079600489960 ("rtase: Implement net_device_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Link: https://patch.msgid.link/20260603061816.31356-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1563,8 +1563,9 @@ static void rtase_dump_tally_counter(con
 	rtase_w32(tp, RTASE_DTCCR0, cmd);
 	rtase_w32(tp, RTASE_DTCCR0, cmd | RTASE_COUNTER_DUMP);
 
-	err = read_poll_timeout(rtase_r32, val, !(val & RTASE_COUNTER_DUMP),
-				10, 250, false, tp, RTASE_DTCCR0);
+	err = read_poll_timeout_atomic(rtase_r32, val,
+				       !(val & RTASE_COUNTER_DUMP),
+				       10, 250, false, tp, RTASE_DTCCR0);
 
 	if (err == -ETIMEDOUT)
 		netdev_err(tp->dev, "error occurred in dump tally counter\n");


